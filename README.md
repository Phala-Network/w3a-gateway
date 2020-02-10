W3Analytics
====

```html
  <script src="https://cdnjs.cloudflare.com/ajax/libs/fingerprintjs2/2.1.0/fingerprint2.min.js"></script>
  <!-- Fathom - simple website analytics - https://github.com/usefathom/fathom -->
  <script>
    (function(f, a, t, h, o, m){
      a[h]=a[h]||function(){
        (a[h].q=a[h].q||[]).push(arguments)
      };
      o=f.createElement('script');
      m=f.getElementsByTagName('script')[0];
      o.async=1; o.src=t; o.id='fathom-script';
      m.parentNode.insertBefore(o,m)
    })(document, window, '//0.0.0.0:8080/tracker.js', 'fathom');
    fathom('set', 'siteId', 'HNQOH');
    fathom('set', 'trackerUrl', "http://0.0.0.0:8080");
    fathom('setClientId');
    setTimeout(function () {
      fathom('trackPageview');
    }, 500);
  </script>
  <!-- / Fathom -->
```
