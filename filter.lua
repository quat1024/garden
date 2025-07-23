-- about pandoc filters: https://pandoc.org/lua-filters.html

--modified a bit from stackoverflow https://stackoverflow.com/a/76048743
--set the "title" metadata variable to the first header on the page
local first_header
local firstTitleGrabber = {
  Header = function(el)
    if first_header then return end
    first_header = pandoc.utils.stringify(el)
  end,
  
  Meta = function(m)
    if not m.title then
      m.title = first_header or "Untitled"
      return m
    end
  end
}

--splice the date underneath the first header, if the item is dated
--needs two phases due to https://pandoc.org/lua-filters.html#typewise-traversal
--(it's sort of the opposite of the previous filter, too)
local the_date
local added_date = false
local dateUnderHeaderPhs1 = {
  Meta = function(m)
    the_date = pandoc.utils.stringify(m.date)
  end
}
local dateUnderHeaderPhs2 = {
  Header = function(el)
    if the_date and (not added_date) then
      added_date = true
      return {
        el,
        pandoc.RawBlock("html", "<time class=\"publish_date\">" .. the_date .. "</time>")
      }
    end
  end
}

--allow intra-garden links to be "lazy" and omit the full path or proper extension
local internalLinkMangler = {
  Link = function (el)
    if el.target then
      local t = el.target
      
      if t:find("//") == nil then --no "http://"
       local fst = t:sub(1, 1)
       local rev = t:reverse()
       local lst = rev:sub(1, 1)
       
        --string doesn't have trailng slash, and no other file extension - relative link, needs ".html" appended
        --either there is no dot, or the only dot in the string is the first character (as part of "./")
        if lst ~= "/" and (t:find("%.") == nil or (fst == "." and rev:find("%.") == rev:len())) then
          t = t .. ".html"
        end
        
        --if there is not already a leading slash, and there isn't a "./", absolutize the link ("hey.html" -> "/hey.html")
        --just allows you to write [foo](foo) to link to "/foo.html"
        if fst ~= "/" and fst ~= "." then
         t = "/" .. t
        end
        
        if el.target ~= t then
          --print("rewrote link from " .. el.target .. " to " .. t)
          el.target = t
          return el
        end
      end
    end
  end
}

return {
  firstTitleGrabber,
  dateUnderHeaderPhs1,
  dateUnderHeaderPhs2,
  internalLinkMangler
}
