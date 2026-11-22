%include("header",title="")
<main class="home">
%include("search", query=query, dirs=dirs, sorts=sorts, config=config, types=types, home=True)
<p class="hint">Search names, contents, PDFs, Office files, mail. Try <code>"exact phrase"</code>,
<code>invoice OR facture</code>, <code>filename:contrat*</code>, <code>-draft</code>,
<code>date:2025/2026</code>. Press <kbd>/</kbd> to focus the search box, <kbd>?</kbd> for all shortcuts.</p>
</main>
%include("footer")
