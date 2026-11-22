(function () {
  'use strict';
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };

  function toast(msg) {
    var t = $('#toast'); if (!t) return;
    t.textContent = msg; t.classList.add('show');
    clearTimeout(toast.h); toast.h = setTimeout(function () { t.classList.remove('show'); }, 1800);
  }

  /* theme */
  function toggleTheme() {
    var cur = document.documentElement.dataset.theme ||
      (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    var next = cur === 'dark' ? 'light' : 'dark';
    document.documentElement.dataset.theme = next; localStorage.setItem('theme', next); themeIcon();
  }

  function themeIcon() {
    var b = $('#theme-toggle'); if (!b) return;
    var d = (document.documentElement.dataset.theme ||
      (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')) === 'dark';
    b.textContent = d ? '☀' : '☾';
  }

  /* search history (stored locally in the browser only) */
  function loadHistory() {
    var dl = $('#history'); if (!dl) return;
    var h = []; try { h = JSON.parse(localStorage.getItem('history') || '[]'); } catch (e) {}
    dl.innerHTML = '';
    h.forEach(function (q) { var o = document.createElement('option'); o.value = q; dl.appendChild(o); });
  }
  function saveHistory(q) {
    q = (q || '').trim(); if (!q) return;
    var h = []; try { h = JSON.parse(localStorage.getItem('history') || '[]'); } catch (e) {}
    h = [q].concat(h.filter(function (x) { return x !== q; })).slice(0, 30);
    localStorage.setItem('history', JSON.stringify(h));
  }

  var cards = [], current = -1, layout = $('#layout');

  function post(url) {
    return fetch(url, { method: 'POST', credentials: 'same-origin' }).then(function (r) {
      if (!r.ok) throw new Error(r.status); return r;
    });
  }
  function qs() { return layout ? layout.dataset.query : ''; }

  function select(i, scroll) {
    if (!cards.length) return;
    current = Math.max(0, Math.min(cards.length - 1, i));
    cards.forEach(function (c, k) { c.classList.toggle('active', k === current); });
    if (scroll !== false) cards[current].scrollIntoView({ block: 'nearest' });
    cards[current].focus({ preventScroll: true });
  }

  function preview(card) {
    var pv = $('#preview'); if (!pv) return;
    var n = card.dataset.n, group = card.dataset.group;
    var viewer = (group === 'pdf' || group === 'image') ? 'raw/' + n + '?' + qs() : 'preview/' + n + '?' + qs();
    $('#pv-title').textContent = card.dataset.title;
    $('#pv-frame').src = viewer;
    $('#pv-dl').href = 'download/' + n + '?' + qs();
    pv.dataset.n = n; pv.hidden = false;
  }
  function closePreview() {
    var pv = $('#preview'); if (!pv || pv.hidden) return false;
    pv.hidden = true; $('#pv-frame').src = 'about:blank'; return true;
  }
  function localAction(kind, n) {
    post(kind + '/' + n + '?' + qs()).then(function () { toast(kind === 'open' ? 'Opening…' : 'Showing folder…'); })
      .catch(function () { toast('Not allowed (only works from the machine hosting the index)'); });
  }
  function copyPath(card) {
    var p = card.dataset.path;
    (navigator.clipboard ? navigator.clipboard.writeText(p) : Promise.reject()).then(
      function () { toast('Path copied'); },
      function () { window.prompt('Copy path:', p); });
  }
  function act(card, what) {
    var n = card.dataset.n;
    if (what === 'preview') preview(card);
    else if (what === 'open') localAction('open', n);
    else if (what === 'folder') localAction('reveal', n);
    else if (what === 'copy') copyPath(card);
  }

  function loadFacets() {
    if (!layout) return;
    fetch('facets?' + qs(), { credentials: 'same-origin' }).then(function (r) { return r.json(); }).then(function (c) {
      $$('.count').forEach(function (el) {
        var n = c[el.dataset.type]; el.textContent = n ? n.toLocaleString() : '0';
      });
    }).catch(function () {});
  }

  function pageNav(rel) { var a = $('.pages a[rel=' + rel + ']'); if (a) a.click(); }

  document.addEventListener('DOMContentLoaded', function () {
    cards = $$('.card');
    loadHistory();
    var form = $('#searchform');
    if (form) {
      form.addEventListener('submit', function () { saveHistory($('#q').value); });
      /* chips and selects re-run the search immediately when there is already a query */
      $$('.chip input, .view input, #folders, select[name=sort], select[name=ascending], input[type=date]', form)
        .forEach(function (el) { el.addEventListener('change', function () { if ($('#q').value.trim()) form.requestSubmit(); }); });
    }
    loadFacets(); themeIcon();

    var tt = $('#theme-toggle'), ht = $('#help-toggle');
    if (tt) tt.addEventListener('click', toggleTheme);
    if (ht) ht.addEventListener('click', function () { $('#help').showModal(); });
    var os = $('#opensearch');
    if (os) os.addEventListener('click', function (e) {
      e.preventDefault();
      if (window.external && 'AddSearchProvider' in window.external)
        window.external.AddSearchProvider(location.origin + '/osd.xml');
      else alert('Your browser does not support OpenSearch plugins. Add ' + location.origin + '/osd.xml manually.');
    });

    cards.forEach(function (c, i) {
      c.addEventListener('click', function (e) {
        var b = e.target.closest('[data-act]');
        select(i, false);
        if (b) { e.preventDefault(); act(c, b.dataset.act); }
      });
      var t = $('.title', c);
      t.addEventListener('click', function (e) {
        if (e.ctrlKey || e.metaKey || e.shiftKey) return;
        e.preventDefault(); preview(c);
      });
    });
    $('#pv-close') && $('#pv-close').addEventListener('click', closePreview);
    $('#pv-open') && $('#pv-open').addEventListener('click', function () { localAction('open', $('#preview').dataset.n); });
    $('#pv-folder') && $('#pv-folder').addEventListener('click', function () { localAction('reveal', $('#preview').dataset.n); });

    document.addEventListener('keydown', function (e) {
      var tag = (e.target.tagName || '').toLowerCase();
      var typing = tag === 'input' || tag === 'textarea' || tag === 'select';
      if (e.key === 'Escape') { if (closePreview()) e.preventDefault(); else if (typing) e.target.blur(); return; }
      if (e.ctrlKey || e.metaKey || e.altKey) return;
      if (typing) return;
      var c = cards[current];
      switch (e.key) {
        case '/': if ($('#q')) { e.preventDefault(); $('#q').focus(); $('#q').select(); } break;
        case '?': if ($('#help')) $('#help').showModal(); break;
        case 'j': select(current + 1); break;
        case 'k': select(current < 0 ? 0 : current - 1); break;
        case 'Enter': case 'p': if (c && !e.target.closest('a,button')) { e.preventDefault(); preview(c); } break;
        case 'o': if (c) act(c, 'open'); break;
        case 'f': if (c) act(c, 'folder'); break;
        case 'c': if (c) act(c, 'copy'); break;
        case 'ArrowRight': pageNav('next'); break;
        case 'ArrowLeft': pageNav('prev'); break;
      }
    });
  });
})();
