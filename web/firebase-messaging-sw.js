importScripts('https://www.gstatic.com/firebasejs/10.13.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyCuBpUd7f0Xeop8F6OpeApLwYc2Rdgzk4s",
  authDomain: "interngrow-fooddelivery.firebaseapp.com",
  projectId: "interngrow-fooddelivery",
  storageBucket: "interngrow-fooddelivery.firebasestorage.app",
  messagingSenderId: "825634770003",
  appId: "1:825634770003:web:0f061fc955bdbdde450aa6",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Background message received:', payload);
});