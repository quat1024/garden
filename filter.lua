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

-- mangle internal links ("lazy" links without full path or proper extension)
function Link(el)
  if el.target then
    local t = el.target

    if t:find("//") == nil then --no "http://"
      local fst = t:sub(1, 1)
      
      --string doesn't have any extension - relative link, needs ".html" appended
      --either there is no dot, or the only dot in the string is the first character (as part of "./")
      if t:find("%.") == nil or (fst == "." and t:reverse():find("%.") == t:len()) then
        t = t .. ".html"
      end
      
      --if there is not already a leading slash, and there isn't a "./", absolutize the link ("hey.html" -> "/hey.html")
      if fst ~= "/" and fst ~= "." then
        t = "/" .. t
      end

      if el.target ~= t then
        print("rewrote link from " .. el.target .. " to " .. t)
        el.target = t
        return el
      end
    end
  end
end