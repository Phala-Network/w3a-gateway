W3Analytics
====

```html
<!-- W3A -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/fingerprintjs2/2.1.0/fingerprint2.min.js"></script>
<script>
(function(t){
  window.w3a=window.w3a||function(){
    (window.w3a.q=window.w3a.q||[]).push(arguments)
  };
  o=document.createElement('script');
  m=document.getElementsByTagName('script')[0];
  o.async=1; o.src=t; o.id='w3a-script';
  m.parentNode.insertBefore(o,m)
})("TRACKER_JS_URL");
w3a('set', 'siteId', 'YOUR_SITE_ID');
w3a('set', 'trackerUrl', "TRACKER_BASE_URL");
w3a('set', 'uid', "PUBLIC_KEY");
w3a('generateClientId');
setTimeout(function () {
  w3a('trackPageview');
}, 500);
</script>
<!-- / W3A -->
```

