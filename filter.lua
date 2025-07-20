-- about pandoc filters: https://pandoc.org/lua-filters.html

-- modified a bit from stackoverflow https://stackoverflow.com/a/76048743

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

-- allow intra-garden links to be "lazy" and omit the full path or proper extension
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
  internalLinkMangler
}



-- -- grab the title of the first visited header and save to a local variable...
-- local title
-- function Header(el)
--   if title then return end
--   title = pandoc.utils.stringify(el)
-- end

-- -- then when it's time for document metadata, return the name of that header
-- function Meta(m)
--   if not m.pagetitle then
--     m.pagetitle = title or "Untitled"
--     return m
--   end
-- end

-- mangle internal links ("lazy" links without full path or proper extension)
-- function Link(el)
--   if el.target then
--     local t = el.target

--     if t:find("//") == nil then --no "http://"
--       local fst = t:sub(1, 1)
      
--       --string doesn't have any extension - relative link, needs ".html" appended
--       --either there is no dot, or the only dot in the string is the first character (as part of "./")
--       if t:find("%.") == nil or (fst == "." and t:reverse():find("%.") == t:len()) then
--         t = t .. ".html"
--       end
      
--       --if there is not already a leading slash, and there isn't a "./", absolutize the link ("hey.html" -> "/hey.html")
--       if fst ~= "/" and fst ~= "." then
--         t = "/" .. t
--       end

--       if el.target ~= t then
--         --print("rewrote link from " .. el.target .. " to " .. t)
--         el.target = t
--         return el
--       end
--     end
--   end
-- end