%number = (query['page'] - 1)*config['perpage'] + i + 1
%tl = config['title_link'] if 'title_link' in config else 'download'
<article class="card filerow" id="r{{d['sha']}}" tabindex="0" data-n="{{number-1}}" data-path="{{d['path']}}"
         data-group="{{d['group']}}" data-title="{{d['label']}}">
    <div class="ficon g-{{d['group']}}" aria-hidden="true">{{d['ext']}}</div>
    <div class="body">
        <h3><a class="title" href="download/{{number-1}}?{{query_string}}" data-preview="preview/{{number-1}}?{{query_string}}">{{!d['label_html']}}</a>
        %if len(d['ipath']) > 0:
            <span class="tag">in archive: {{d['ipath']}}</span>
        %end
        </h3>
        <div class="fpath" title="{{d['path']}}">{{d['dir']}}</div>
    </div>
    <div class="fmeta">
        <span>{{d['hsize']}}</span>
        <span>{{d['time']}}</span>
    </div>
    <div class="actions">
        <button type="button" data-act="preview">Preview</button>
        <button type="button" data-act="open">Open</button>
        <button type="button" data-act="folder">Folder</button>
        <button type="button" data-act="copy">Copy path</button>
    </div>
</article>
