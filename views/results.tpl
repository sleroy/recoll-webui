%include('header', title=": " + query['query']+" ("+str(nres)+")")
%include('search', query=query, dirs=dirs, sorts=sorts, config=config, types=types)
<div id="layout" data-query="{{query_string}}">
<main id="resultcol">
<div id="status">
    <div id="found">
        <b>{{nres}}</b> result{{'' if nres == 1 else 's'}} for <b class="qs">{{query['query'] if query['view'] == 'files' else qs}}</b>{{" in file names" if query['view'] == 'files' else ""}}
        <small class="muted">· {{'%.2f' % (time.total_seconds())}}s</small>
    </div>
    %if len(res) > 0 and not config['rclc_nojsoncsv']:
        <div id="downloads">
            <a href="./json?{{query_string}}&amp;page=0">JSON</a>
            <a href="./csv?{{query_string}}&amp;page=0">CSV</a>
        </div>
    %end
</div>
%if len(res) == 0:
<div class="empty">
    <h2>No results</h2>
    <p>Check the spelling, remove a file-type or date filter, or try fewer words.
    Wildcards work: <code>migr*</code>. Use <code>OR</code> between alternatives.</p>
</div>
%end
%include('pages', query=query, config=config, nres=nres)
<div id="results" class="{{'files' if query['view'] == 'files' else ''}}">
%for i in range(0, len(res)):
    %include('result_file' if query['view'] == 'files' else 'result', d=res[i], i=i, query=query, config=config, query_string=query_string)
%end
</div>
%include('pages', query=query, config=config, nres=nres)
</main>
<aside id="preview" hidden>
    <div class="pv-bar">
        <strong id="pv-title"></strong>
        <span class="pv-actions">
            <button type="button" id="pv-open" title="Open on this computer">Open</button>
            <button type="button" id="pv-folder" title="Show folder">Folder</button>
            <a id="pv-dl" href="#" title="Download">Download</a>
            <button type="button" id="pv-close" title="Close (Esc)" aria-label="Close">✕</button>
        </span>
    </div>
    <iframe id="pv-frame" title="Preview" sandbox="allow-same-origin"></iframe>
</aside>
</div>
%include('footer')
