W3Analytics
====

```html
  <!-- Fathom - simple website analytics - https://github.com/usefathom/fathom -->
  <script>
    (function(f, a, t, h, o, m){
      a[h]=a[h]||function(){
        (a[h].q=a[h].q||[]).push(arguments)
      };
      o=f.createElement('script'),
        m=f.getElementsByTagName('script')[0];
      o.async=1; o.src=t; o.id='fathom-script';
      m.parentNode.insertBefore(o,m)
    })(document, window, '//cdn.usefathom.com/tracker.js', 'fathom');
    fathom('set', 'siteId', 'HNQOH');
    fathom('set', 'trackerUrl', "http://0.0.0.0:8080");
    fathom('trackPageview');
  </script>
  <!-- / Fathom -->
```
