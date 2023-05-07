fx_version 'bodacious'
games { 'rdr3', 'gta5' }



client_script {
  "cl_main.lua",
  'config.lua',
}
server_scripts {
  'sv_main.lua',
  '@oxmysql/lib/MySQL.lua',
}