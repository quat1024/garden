# Search

```{=html}  
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>
<div id="loading">Loading...</div>
<div id="searchbar"></div>
<script>
window.addEventListener('DOMContentLoaded', (event) => {
  new PagefindUI({ element: "#searchbar", showSubResults: true });
  document.getElementById("loading").remove();
});
</script>
```

Powered by [pagefind](https://pagefind.app/). You can go [here](how-i-put-pagefind-on-the-site) to read about how the integration works.