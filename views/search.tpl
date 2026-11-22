%import re
%sel_types = [t for t in query['type'].split(',') if t]
%home = defined('home') and home
<header class="topbar {{'home-bar' if home else ''}}">
  <a class="brand" href="./"><img src="static/recoll.png" alt="" width="28" height="28"><span>recoll</span></a>
  <form id="searchform" action="results" method="get" role="search">
    <div class="searchrow">
      <input id="q" type="search" name="query" value="{{query['query']}}" placeholder="Search your documents…" autocomplete="off" list="history" autofocus>
      <datalist id="history"></datalist>
      <button type="submit" class="primary">Search</button>
    </div>
    <div class="filters">
      <div class="chips" role="group" aria-label="File types">
      %for key, label, _p in types:
        <label class="chip"><input type="checkbox" name="type" value="{{key}}" {{'checked' if key in sel_types else ''}}>
        <span>{{label}}<small class="count" data-type="{{key}}"></small></span></label>
      %end
      </div>
      <div class="selects">
        <label>Folder
        <select id="folders" name="dir">
        %for d in sorted(dirs, key=str.lower):
            %space = "\u2003" * d.count('/')
            <option {{'selected' if d in query['dir'] else ''}} value="{{d}}">{{space}}{{re.sub('.+/','', d)}}</option>
        %end
        </select></label>
        <label>From <input type="date" name="after" value="{{query['after']}}"></label>
        <label>To <input type="date" name="before" value="{{query['before']}}"></label>
        <label>Sort
        <select name="sort">
        %for s in sorts:
            <option value="{{s[0]}}" {{'selected' if query['sort'] == s[0] else ''}}>{{s[1]}}</option>
        %end
        </select></label>
        <label>Order
        <select name="ascending">
            <option value="0" {{'selected' if int(query['ascending']) != 1 else ''}}>Desc</option>
            <option value="1" {{'selected' if int(query['ascending']) == 1 else ''}}>Asc</option>
        </select></label>
      </div>
    </div>
    <input type="hidden" name="page" value="1">
  </form>
  <div class="tools">
    <button type="button" class="icon" id="theme-toggle" title="Toggle dark / light theme" aria-label="Toggle theme">◐</button>
    <button type="button" class="icon" id="help-toggle" title="Keyboard shortcuts (?)" aria-label="Shortcuts">?</button>
    %if not config['rclc_nosettings']:
    <a class="icon" href="settings" title="Settings" aria-label="Settings">⚙</a>
    %end
  </div>
</header>
<dialog id="help">
  <h3>Keyboard shortcuts</h3>
  <dl>
    <dt><kbd>/</kbd></dt><dd>Focus search</dd>
    <dt><kbd>j</kbd> / <kbd>k</kbd></dt><dd>Next / previous result</dd>
    <dt><kbd>Enter</kbd> or <kbd>p</kbd></dt><dd>Preview selected result</dd>
    <dt><kbd>o</kbd></dt><dd>Open file on this computer</dd>
    <dt><kbd>f</kbd></dt><dd>Show containing folder</dd>
    <dt><kbd>c</kbd></dt><dd>Copy file path</dd>
    <dt><kbd>←</kbd> <kbd>→</kbd></dt><dd>Previous / next page</dd>
    <dt><kbd>Esc</kbd></dt><dd>Close preview</dd>
  </dl>
  <form method="dialog"><button class="primary">Close</button></form>
</dialog>
