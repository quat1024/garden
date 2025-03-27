# Search powered by [pagefind](https://pagefind.app/)

Searching is done clientside.

```{=html}  
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>

<div id="loading">Loading giant block of JS...</div>

<div id="search"></div>
<script>
window.addEventListener('DOMContentLoaded', (event) => {
  new PagefindUI({ element: "#search", showSubResults: true });
  document.getElementById("loading").remove();
});
</script>
```
