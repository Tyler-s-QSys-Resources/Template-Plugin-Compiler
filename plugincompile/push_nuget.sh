infoLua=$(printf "$1\\%s" "01-info.lua")
# echo "infoLua is $infoLua"

build_version=$(grep 'BuildVersion' $infoLua | sed -E 's/.*"([^"]+)".*/\1/')

nupkg=$(printf "%s.%s.%s" $2 $build_version "nupkg") 

$1/.vscode/plugincompile/nuget.exe push $nupkg -Source http://nuget.tailb0a24.ts.net:8080/aligned-vision-group-plugins/ -ApiKey $3