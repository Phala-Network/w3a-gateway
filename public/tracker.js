(function() {
  'use strict';

  let queue = window.fathom.q || [];
  let config = {
    siteId: '',
    spa: false,
    trackerUrl: ''
  };

  const commands = {
    set: set,
    trackPageview: function (e) {
      trackPageview({}, "pageview");
    },
    trackGoal: function (e, t) {
      trackPageview({ gcode: e, gval: t }, "goal");
    },
    setTrackerUrl: function (e) {
      set("trackerUrl", "http://0.0.0.0:3000");
      return "http://0.0.0.0:3000";
    },
  };

  function set(key, value) {
    config[key] = value;

    if (key === "spa") {
      if (value === "pushstate" && history !== void(0)) {
        var n = history.pushState;
        history.pushState = function () { n.apply(history, arguments), fathom("trackPageview") }
      }
      else {
        value === "hash" && window.addEventListener("hashchange", function () { fathom("trackPageview") })
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

  function trackPageview(e, o) {
    e = e || {};

    if ("visibilityState" in document && "prerender" === document.visibilityState) {
      return;
    }
    if (/bot|google|baidu|bing|msn|duckduckbot|teoma|slurp|yandex/i.test(navigator.userAgent)) {
      return;
    }
    if (null === document.body) {
      document.addEventListener("DOMContentLoaded", () => { r(e, o) });
      return;
    }

    let n = window.location;
    if ("" === n.host) {
      return;
    }

    let i = document.querySelector('link[rel="canonical"][href]');
    if (i) {
      let e = document.createElement("a");
      e.href = i.href;
      n = e
    }

    let c = e.path || n.pathname + n.search;
    c = c || "/";
    if (config.spa == "hash" && "" !== window.location.hash.substr(1)) {
      c = "/" + window.location.hash;
    }

    let s = e.hostname || n.protocol + "//" + n.hostname, l = e.referrer || "";
    document.referrer.indexOf(s) < 0 && (l = document.referrer);
    const d = { p: c, h: s, r: l, sid: config.siteId, tz: Intl.DateTimeFormat().resolvedOptions().timeZone };
    if ("goal" == o)
      d.gcode = e.gcode, d.gval = e.gval, navigator.sendBeacon(config.trackerUrl + "/collector/event" + stringifyObject(d));
    else {
      let e = document.getElementById("fathom-script");
      e && (d.dash = e.src.replace("/tracker.js", ""), d.dash.indexOf("cdn.usefathom.com") > -1 && (d.dash = null));
      let o = config.trackerUrl + "/pageview", n = document.createElement("img");
      n.setAttribute("alt", ""), n.setAttribute("aria-hidden", "true"), n.style.position = "absolute", n.src = o + stringifyObject(d), n.addEventListener("load", function () { n.parentNode.removeChild(n) }), document.body.appendChild(n)
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
})()
