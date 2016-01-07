-- function source: http://stackoverflow.com/a/326677/105282
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

-- output (tested)
-- OSX - Darwin
-- Linux (Raspbian/PI2) - Linux

unix_test = os.capture("uname")
os_name = ""
if unix_test == "" then
    os_name = "Windows"
else 
    os_name = unix_test
end

print(os_name) -- debugging purposes

return os_name
