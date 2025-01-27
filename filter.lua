-- pandoc filter
-- modified a bit from stackoverflow https://stackoverflow.com/a/76048743
-- grab the title of the first visited header and save to a local variable...
local title
function Header(el)
  if title then return end
  title = pandoc.utils.stringify(el)
end

-- then when it's time for document metadata, return the name of that header
function Meta(el)
  if not el.pagetitle then
    el.pagetitle = title or "Untitled"
    return el
  end
end

-- mangle intra-doc URLs ("lazy" links without full path or proper extension)
function Link(el)
  if el.target then
    local t = el.target

    if string.find(t, "//") == nil then
      if string.sub(t, 1, 1) ~= "/" then t = "/" .. t end --append leading slash
      if string.find(t, "%.") == nil then t = t .. ".html" end --default to .html
      if el.target ~= t then
        print("rewrote link from " .. el.target .. " to " .. t)
        el.target = t
        return el
      end
    end
  end
end