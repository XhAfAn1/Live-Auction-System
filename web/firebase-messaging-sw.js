// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.5.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDfDMfxcdAt44_r2gyYJ5pNGxSzD8mtYh8",
  authDomain: "live-auction-system-26b33.firebaseapp.com",
  projectId: "live-auction-system-26b33",
  storageBucket: "live-auction-system-26b33.firebasestorage.app",
  messagingSenderId: "443378336257",
  appId: "1:443378336257:web:e17b2b0b25099b58d3b600",
  measurementId: "G-0X852P6P15"
});

const messaging = firebase.messaging();
