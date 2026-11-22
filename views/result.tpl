%import os
%number = (query['page'] - 1)*config['perpage'] + i + 1
%url = d['url'].replace('file://', '')
%for dr, prefix in config['mounts'].items():
    %url = url.replace(dr, prefix)
%end
%urllabel = os.path.dirname(d['url'].replace('file://', ''))
%for r in config['dirs']:
    %urllabel = urllabel.replace(r.rsplit('/',1)[0] + '/' , '')
%end
%tl = config['title_link'] if 'title_link' in config else 'download'
%if tl == 'open':
    %href = url
%elif tl == 'preview':
    %href = 'preview/%d?%s' % (number-1, query_string)
%else:
    %href = 'download/%d?%s' % (number-1, query_string)
%end
<article class="card" id="r{{d['sha']}}" tabindex="0" data-n="{{number-1}}" data-path="{{d['path']}}"
         data-group="{{d['group']}}" data-title="{{d['label']}}">
    <div class="ficon g-{{d['group']}}" aria-hidden="true">{{d['ext']}}</div>
    <div class="body">
        <h3><a class="title" href="{{href}}" data-preview="preview/{{number-1}}?{{query_string}}">{{d['label']}}</a>
        %if len(d['ipath']) > 0:
            <span class="tag">in archive: {{d['ipath']}}</span>
        %end
        %if "collapsecount" in d and d["collapsecount"]:
            <span class="tag">{{d["collapsecount"]}} duplicates</span>
        %end
        </h3>
        <div class="meta">
            <span class="path" title="{{d['path']}}">{{urllabel}}</span>
            %if d['hsize']:
            <span>{{d['hsize']}}</span>
            %end
            <span>{{d['time']}}</span>
            %if 'author' in d and len(d['author']) > 0:
            <span>{{d['author']}}</span>
            %end
            <span class="muted">#{{number}}</span>
        </div>
        <p class="snippet">{{!d['snippet']}}</p>
        %if not "noresultlinks" in config or not config["noresultlinks"]:
        <div class="actions">
            <button type="button" data-act="preview">Preview</button>
            <button type="button" data-act="open" title="Open with the default application">Open</button>
            <button type="button" data-act="folder" title="Show in file manager">Folder</button>
            <a href="download/{{number-1}}?{{query_string}}">Download</a>
            <button type="button" data-act="copy" title="Copy full path">Copy path</button>
        </div>
        %end
    </div>
</article>
