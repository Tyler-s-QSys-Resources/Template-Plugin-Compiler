url=$(git config --get remote.origin.url | sed 's/\.git$//')
year=$(date +%Y)
infoLua=$(printf "$1\\%s" "01-info.lua")

extract_string() {
  grep "$1" "$infoLua" | sed -E 's/^[^=]+=\s*"([^"]*)".*/\1/'
}

extract_bool() {
  grep "$1" "$infoLua" | sed -E 's/^[^=]+=\s*(true|false).*/\1/'
}


name=$(extract_string 'Name')
version=$(extract_string 'Version')
build_version=$(extract_string 'BuildVersion')
id=$(extract_string 'Id')
author=$(extract_string 'Author')
description=$(extract_string 'Description')

LongDescription=$(extract_string 'LongDescription')
AssetType="QSC_PLUGIN"
CodeOwner="Manufacturer"
DevEmail=$(extract_string 'DevEmail')
DevName=$(extract_string 'Author')  # intentional reuse
DeviceType=$(extract_string 'DeviceType')
CustomDeviceType=$(extract_string 'CustomDeviceType')
IsDeprecated=$(extract_bool 'IsDeprecated')
IsReflectEnabled=$(extract_bool 'IsReflectEnabled')
License="MIT License"
Manufacturer="Aligned Vision Group"
PartnerIntegration="Open"
ReleaseNotes=$(extract_string 'ReleaseNotes')
SupportEmail="avsupport@alignedvisiongroup.com"
SupportName="Support Team"

nuspec=$(cat <<EOF
<?xml version="1.0"?>
<package >
  <metadata>
    <id>$2</id>
    <version>$build_version</version>
    <title>$2</title>
    <authors>$author</authors>
    <owners>Aligned Vision Group</owners>
    <license type="expression">GPL-3.0-or-later</license>
    <projectUrl>$url</projectUrl>
    <iconUrl>http://content/images/logo.png</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>$description</description>
    <copyright>Copyright $year</copyright>
    <tags>Q-Sys Plugins</tags>
    <summary>$LongDescription</summary>
    <readme>README.md</readme>
    <releaseNotes>{"AssetType":"$AssetType","CodeOwner":"$CodeOwner","DevEmail":"$DevEmail","DevName":"$DevName","DeviceType":"$DeviceType","CustomDeviceType":null,"IsDeprecated":$IsDeprecated,"IsReflectEnabled":$IsReflectEnabled,"License":"$License","Manufacturer":"Aligned Vision Group","PartnerIntegration":"$PartnerIntegration","ReleaseNotes":"$ReleaseNotes","SupportEmail":"$SupportEmail","SupportName":"$SupportName"}</releaseNotes>
  </metadata>
</package>
EOF
)
#echo $nuspec

echo "$nuspec" > "${1}/content/${2}.nuspec"
$1/.vscode/plugincompile/nuget.exe pack $2.nuspec -outputdirectory $1