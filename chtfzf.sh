#!/usr/bin/env bash

# chtfzf.sh
# by iotku
# license: wtfpl
# Requirements: curl, fzf
# Docs: use -t flag to launch in a new tmux window
# - ``chtfzf sync`` to cache main list for faster access
# support cht.sh docker self-host: cht.sh is always tried first, the local
# server is only used when cht.sh fails
# - CHT_* settings below can be overridden with environment variables

set -euf -o pipefail

CACHE_DIR="${HOME}/.local/share/chtfzf"
CHT_PRIMARY="${CHT_PRIMARY:-https://cht.sh}"
CHT_FALLBACK="${CHT_FALLBACK:-http://localhost:8002}"
CHT_CONNECT_TIMEOUT="${CHT_CONNECT_TIMEOUT:-3}" # seconds to reach a server before marking it as down
CHT_MAX_TIME="${CHT_MAX_TIME:-10}"              # seconds for a full answer (uncached queries can be slow)
CHT_BREAKER_TTL="${CHT_BREAKER_TTL:-60}"        # seconds to skip cht.sh after it failed (0 = never skip)
CHT_BREAKER_FILE="${CHT_BREAKER_FILE:-/tmp/chtfzf_primary_down}"

openMode="bash"

# --- Circuit breaker ---
# Flag file lives in /tmp — no content needed, mtime IS the timestamp.
# /tmp clears on reboot so stale state never persists across sessions.
# Kept short: it only spares fzf previews from each waiting out the connect
# timeout while cht.sh is down, then cht.sh gets retried.

function _breaker_is_open {
    local tripped_at
    tripped_at=$(date -r "$CHT_BREAKER_FILE" +%s 2>/dev/null) || return 1
    (( $(date +%s) - tripped_at < CHT_BREAKER_TTL ))
}
function _breaker_trip  { touch "$CHT_BREAKER_FILE"; }
function _breaker_reset { rm -f "$CHT_BREAKER_FILE"; }

# --- Fetch helpers ---

# GET <base_url>/<path> from one server. If it answers 200 with non-empty plain
# text, print that followed by the status code on its own last line; otherwise
# print nothing and fail. cht.sh answers curl in plain text, so anything else is
# an error page (500, 429, captive portal...). Checked by Content-Type rather
# than grepping the body, since sheets themselves may contain "<html".
# `|| rc=$?` keeps `set -e` from exiting before the fallback gets a chance.
function _fetch_from {
    local out rc=0 meta
    out=$(curl -sg --connect-timeout "$CHT_CONNECT_TIMEOUT" --max-time "$CHT_MAX_TIME" \
        -w '\n%{http_code} %{content_type}' "$1/$2") || rc=$?
    meta=$(tail -n1 <<< "$out")
    out=$(sed '$d' <<< "$out")
    [[ $rc -eq 0 && "$meta" == "200 text/plain"* && -n "$out" ]] || return 1
    printf '%s\n200\n' "$out"
}

# Fetch from cht.sh, falling back to the local server only when cht.sh fails
# (or failed less than CHT_BREAKER_TTL seconds ago).
# Prints the HTTP status code as the last line
# (mirrors the original  curl -w "%{http_code}"  pattern used in cachePreview)
# Usage: cht_fetch_with_status <path>
function cht_fetch_with_status {
    local path="$1" out

    if ! _breaker_is_open; then
        if out=$(_fetch_from "$CHT_PRIMARY" "$path"); then
            _breaker_reset
            echo "$out"
            return 0
        fi
        _breaker_trip
    fi

    if out=$(_fetch_from "$CHT_FALLBACK" "$path"); then
        echo "$out"
    else
        printf 'Error: upstream server (%s) is down, and the local server (%s) failed too.\n500\n' \
            "$CHT_PRIMARY" "$CHT_FALLBACK"
    fi
}

# Like cht_fetch_with_status, without the status line
# Usage: cht_fetch <path>
function cht_fetch {
    cht_fetch_with_status "$1" | sed '$d'
}

function main {
    # Read Command Line Arguments
    for i in "$@"; do
        case "$i" in
            -t) openMode="tmux"; shift;;
            sync) syncSheetList;;
            query) shift; query $*;;
            preview) shift; cachePreview "$*";;
            *) ;; # Do nothing if no matches
        esac
    done

    search="$(searchMain)"
    pushd -n "$search" > /dev/null 2>&1

    if [[ "${search: -1}" != "/" ]]; then
        openSheet "$search"
        exit
    fi

    while :; do # do while
        search=$(cht_fetch "$(getPath):list" |
            grep -v ":list" |
            fzf --bind "ctrl-d:print-query" --preview="${BASH_SOURCE[0]} preview \"$(getPath){}\"")

        if [[ "$search" == "" ]]; then # go up a level on ctrl-d
            popd -n > /dev/null 2>&1
            if [[ $? != 0 ]]; then
                break
            fi
            continue
        fi

        [[ "${search: -1}" == "/" ]] || break # exit condition
        pushd -n "$search" > /dev/null 2>&1
    done

    if [[ "$search" == "" ]]; then
        main
        exit
    fi

    echo "opening $(getPath)$search"
    openSheet "$(getPath)$search"
}

function getPath {
    echo "$(dirs -p | tail -n +2 | sed 's/.$//' | tac | tr '\n' '/')"
}

function openSheet {
    if [[ "$1" == "" ]]; then exit; fi # Exit if empty string

    case "$openMode" in
        tmux) tmux neww bash -c "cht_fetch \"$*\" | less -R";;
        bash) cht_fetch "$*" | less -R;;
        *) echo "Unknown openMode, set -t to use tmux, or no args to use bash directly"
    esac
}

function searchMain {
    if [ -f "$CACHE_DIR/main.list" ]; then
        # Use cached list if it exists
        echo "$(grep -v ":list" "$CACHE_DIR/main.list" | fzf --query="$*" --preview="${BASH_SOURCE[0]} preview '{}'")"
    else
        echo "$(cht_fetch ":list" | grep -v ":list" | fzf --query="$*" --preview="${BASH_SOURCE[0]} preview '{}'")"
    fi
}

function query {
    search="$(searchMain)"
    read -rp "query: " queryInput
    queryInput=$(tr ' ' '+' <<< "$queryInput")

    if [[ "$queryInput" == "" ]]; then
        openSheet "$(echo "$search")"
        exit
    fi

    if [[ "${search: -1}" != "/" ]]; then
        openSheet "$search/$queryInput"
    else
        openSheet "$search$queryInput"
    fi
    exit
}

function syncSheetList {
    [ ! -d "$CACHE_DIR" ] && mkdir -p "$CACHE_DIR"
    printf "Saving main.list to %s\nDon't forget to sync in the future :)\n" "$CACHE_DIR"
    cht_fetch ":list" > "$CACHE_DIR/main.list"
    printf "done.\n"
    exit
}

function cachePreview {
    # Hopefully avoid really bad situations
    if [[ "$*" == "" ]]; then exit; fi
    if [[ "$*" == "/" ]]; then exit; fi

    # Just fetch directly if we don't have a cache directory (haven't done sync yet)
    if [ ! -d "$CACHE_DIR" ]; then
        cht_fetch "$*"
        exit
    fi

    # Exists in cache
    if [ -f "$CACHE_DIR/$*.sheet" ]; then
        cat "$CACHE_DIR/$*.sheet"
        exit
    fi

    # Make subdirectory structure to match preview
    SUB_DIR="$(dirname "$CACHE_DIR/$*.sheet")"
    [ ! -d "$SUB_DIR" ] && mkdir -p "$SUB_DIR"

    # sheet with status code as last line
    sheet="$(cht_fetch_with_status "$*")"
    statusCode="$(tail -n1 <<< "$sheet")"
    sheet="$(sed '$d' <<< "$sheet")" # Remove status code from output

    if [[ "$statusCode" == "200" ]]; then
        tee "$CACHE_DIR/$*.sheet" <<< "$sheet"
    else
        # Don't cache error page
        printf "Sorry, cht.sh returned non 200 status code (error):\n%s" "$sheet"
    fi
    exit
}

main $@ # Pass CLI args to main
