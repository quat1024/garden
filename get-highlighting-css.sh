# https://github.com/jgm/pandoc/issues/7860#issuecomment-1018696254
# call like: ./get-highlighting-css.sh kate > kate.css"

# this requires some silliness because pandoc will only write highlighting css
# styles if there is something it needs to highlight in the input

style=${1:-kate}

echo "/* STYLE: $style */"

# template which contains the string "$highlighting-css$"
tmp=
trap 'rm -f "$tmp"' EXIT
tmp=$(mktemp)
echo '$highlighting-css$' >> "$tmp"

# call pandoc with some random "code" that makes it think highlighting is required
echo '`a`{.c}' | pandoc --highlight-style="$style" --template="$tmp"