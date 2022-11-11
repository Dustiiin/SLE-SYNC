server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'
}

client_scripts {
  'client/main.lua'
}

ui_page 'html/ui.html'

files {
  'html/ui.html',
  'html/ui.css', 
  'html/*.js',
  'html/*.png',
  'html/items/*.png'
}

