(function () {
  "use strict";

  let queue = window.fathom.q || []
  let config = {
    siteId: "",
    spa: false,
    trackerUrl: "",
    clientId: ""
  };
  const commands = {
    set: set,
    trackPageview: function (t) {
      i({}, "pageview")
    },
    trackGoal: function (t, e) {
      i({
        gcode: t,
        gval: e
      }, "goal")
    },
    setTrackerUrl: function (value) {
      set("trackerUrl", value);
      return value;
    },
    setClientId: function (value) {
      if (value) {
        set("clientId", value);
        return value;
      }

      if (window.Fingerprint2) {
        Fingerprint2.get(function (components) {
          var values = components.map(function (component) { return component.value });
          var murmur = Fingerprint2.x64hash128(values.join(''), 31);
          set("clientId", murmur);
          console.log(config);
        });
      }
    }
  };

  function set(key, value) {
    config[key] = value;
    if (key == "spa") {
      if ("pushstate" == value && history !== void(0)) {
        var o = history.pushState;
        history.pushState = function () {
          var t = o.apply(history, arguments);
          window.dispatchEvent(new Event("pushstate"));
          window.dispatchEvent(new Event("locationchange"));
          return t;
        };

        var a = history.replaceState;
        history.replaceState = function () {
          var t = a.apply(history, arguments);
          window.dispatchEvent(new Event("replacestate"));
          window.dispatchEvent(new Event("locationchange"));
          return t;
        };
        window.addEventListener("popstate", function () {
          window.dispatchEvent(new Event("locationchange"))
        });
        window.addEventListener("locationchange", function () {
          fathom("trackPageview")
        });
      } else if(value == "hash") {
        window.addEventListener("hashchange", function () {
          fathom("trackPageview")
        });
      }
    }
  }

  // convert object to query string
  function stringifyObject(obj) {
    var keys = Object.keys(obj);

    return '?' +
      keys.map(function(k) {
        return encodeURIComponent(k) + '=' + encodeURIComponent(obj[k]);
      }).join('&');
  }

  function i(t, n) {
    t = t || {};
    if ("visibilityState" in document && "prerender" === document.visibilityState) {
      return;
    }

    if (/bot|google|baidu|bing|msn|duckduckbot|teoma|slurp|yandex/i.test(navigator.userAgent)) {
      return;
    }

    if (null === document.body) {
      document.addEventListener("DOMContentLoaded", () => {
        i(t, n)
      });
      return;
    }

    let o = window.location;
    if (o.host === "") {
      return;
    }

    let r = document.querySelector('link[rel="canonical"][href]');
    if (r) {
      let t = document.createElement("a");
      t.href = r.href;
      o = t;
    }

    let c = t.path || o.pathname + o.search;
    c = c || "/";
    if (config.spa == "hash" && window.location.hash.substr(1) !== "") {
      c = "/" + window.location.hash;
    }

    let s = t.hostname || o.protocol + "//" + o.hostname
    let d = t.referrer || "";

    if (document.referrer.indexOf(s) < 0) {
      d = document.referrer;
    }

    const h = {
      p: c,
      h: s,
      r: d,
      sid: config.siteId,
      cid: config.clientId,
      tz: Intl.DateTimeFormat().resolvedOptions().timeZone,
      t: Date.now(),
    };
    if ("goal" == n) {
      h.gcode = t.gcode;
      h.gval = t.gval;
      navigator.sendBeacon(t.trackerUrl + "/event" + stringifyObject(h))
    } else {
      // let t = document.getElementById("fathom-script");
      // if (t) {
      //   h.dash = t.src.replace("/tracker.js", "")
      //   if (h.dash.indexOf("cdn.usefathom.com") > -1) {
      //     h.dash = null;
      //   }
      // }

      let n = config.trackerUrl + "/scooby";
      let o = document.createElement("img");
      o.setAttribute("alt", "");
      o.setAttribute("aria-hidden", "true");
      o.style.position = "absolute";
      o.src = n + stringifyObject(h);
      o.addEventListener("load", function () {
        o.parentNode.removeChild(o)
      });
      document.body.appendChild(o);
    }
  }

  // override global fathom object
  window.fathom = function() {
    var args = [].slice.call(arguments);
    var c = args.shift();
    commands[c].apply(this, args);
  };

  // process existing queue
  queue.forEach((i) => fathom.apply(this, i));
})();
