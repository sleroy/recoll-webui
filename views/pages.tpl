%from urllib.parse import urlencode
%import math
%q = dict(query)
%def page_href(page):
	%q['page'] = page
	%return './results?%s' % urlencode(q)
%end
%if nres > 0:
	%npages = int(math.ceil(nres/float(config['perpage'])))
	%if npages > 1:
		%cur = query['page']
		<nav class="pages" aria-label="Pages">
		<a title="First" href="{{page_href(1)}}">«</a>
		<a title="Previous" rel="prev" href="{{page_href(max(1,cur-1))}}">‹</a>
		%lo = max(1, cur-4)
		%hi = min(npages, lo+8)
		%lo = max(1, hi-8)
		%for p in range(lo, hi+1):
			<a href="{{page_href(p)}}" class="{{'current' if p == cur else ''}}" {{!'aria-current="page"' if p == cur else ''}}>{{p}}</a>
		%end
		<a title="Next" rel="next" href="{{page_href(min(npages, cur+1))}}">›</a>
		<a title="Last" href="{{page_href(npages)}}">»</a>
		</nav>
	%end
%end
