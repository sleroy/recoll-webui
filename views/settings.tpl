%include("header", title=" / settings")
<header class="topbar"><a class="brand" href="./"><img src="static/recoll.png" alt="" width="28" height="28"><span>recoll</span></a>
<h1 class="pagetitle">Settings</h1></header>
<main class="settings">
<form action="set" method="get">
  <fieldset><legend>Search</legend>
    <label>Find similar words <small>1 or 0, "squats" also finds "squatter"</small>
      <input name="stem" value="{{stem}}"></label>
    <label>Collapse duplicates <small>1 or 0, show one result per identical content</small>
      <input name="collapsedups" value="{{collapsedups}}"></label>
    <label>Max results <small>0 for unlimited</small>
      <input name="maxresults" value="{{maxresults}}"></label>
    <label>Folder depth <small>levels shown in the folder dropdown</small>
      <input name="dirdepth" value="{{dirdepth}}"></label>
  </fieldset>
  <fieldset><legend>Display</legend>
    <label>Results per page <small>0 for no pagination</small>
      <input name="perpage" value="{{perpage}}"></label>
    <label>Context words <small>words shown around each match</small>
      <input name="context" value="{{context}}"></label>
    <label>Snippet characters <small>max characters per snippet</small>
      <input name="maxchars" value="{{maxchars}}"></label>
    <label>Date format <small>strftime string</small>
      <input name="timefmt" value="{{timefmt}}"></label>
    <label>Title click action
      <select name="title_link">
        <option value="download" {{'selected' if title_link == 'download' else ''}}>Download</option>
        <option value="preview" {{'selected' if title_link == 'preview' else ''}}>Preview</option>
        <option value="open" {{'selected' if title_link == 'open' else ''}}>Open</option>
      </select></label>
  </fieldset>
  <fieldset><legend>Locations</legend>
    %for d in dirs:
    <label><small>{{d}}</small><input name="mount_{{d}}" value="{{mounts[d]}}"></label>
    %end
  </fieldset>
  <fieldset><legend>Export &amp; browser</legend>
    <label>CSV fields <small>{{fields}}</small>
      <input name="csvfields" value="{{csvfields}}"></label>
    <p><a href="#" id="opensearch">Register recoll as a browser search engine</a></p>
  </fieldset>
  <div class="formbar"><button class="primary" type="submit">Save</button>
  <a class="btn" href="./">Cancel</a></div>
</form>
</main>
%include("footer")
