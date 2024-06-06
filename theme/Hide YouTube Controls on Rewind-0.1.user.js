// ==UserScript==
// @name         Hide YouTube Controls on Rewind
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Hide YouTube player controls when rewinding the video, and toggle controls visibility based on mouse events
// @author       Your Name
// @match           https://www.youtube.com/watch
// @match           https://*.youtube.com/*
// @grant        none
// @run-at       document-start
// ==/UserScript==


(function() {
    'use strict';
    console.log("Hide YouTube Controls on Rewind")
     const TARGET = "video";

    function waitForElement(selector) {
        return new Promise(resolve => {
            if (document.querySelector(selector)) {
                return resolve(document.querySelector(selector));
            }
            const observer = new MutationObserver(mutations => {
                if (document.querySelector(selector)) {
                    resolve(document.querySelector(selector));
                    observer.disconnect();
                }
            });
            observer.observe(document.body, { childList: true, subtree: true });
        });
    }

    function handleRewind(){
        waitForElement(TARGET).then((player) => {
            player.addEventListener('seeking', function() {
                const controls = document.querySelector('.ytp-chrome-bottom');
                const caption = document.querySelector('.caption-window.ytp-caption-window-bottom');

                if (controls) {
                    controls.style.display = 'none';
                }
                if (caption) {
                    caption.style.marginBottom = null
                }
            });

            // Add event listeners for mouse events to toggle controls visibility
           player.addEventListener('mouseover', function() {
                const controls = document.querySelector('.ytp-chrome-bottom');
                if (controls) {
                    controls.style.display = null;
                }
            });

        });
    }

    window.onload = handleRewind;
})();