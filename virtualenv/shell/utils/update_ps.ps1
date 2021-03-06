$scriptpath = $MyInvocation.MyCommand.Path
$path_to_utils = Split-Path $scriptpath

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

Get-Date > "$path_to_utils\last-check.txt"
echo "Downloading latest version of pip modules"
$url = Get-Content "$path_to_utils\pip-install-list.url"
echo "URL: $url"
(New-Object System.Net.WebClient).DownloadFile($url,"$path_to_utils\pip-install-list-new.txt");

$old_list="$path_to_utils\pip-install-list.txt"
$new_list="$path_to_utils\pip-install-list-new.txt"

if ((Get-FileHash $old_list).hash -ne (Get-FileHash $new_list).hash) {
  echo "New updates found, updating pip packages"
  Remove-Item "$path_to_utils\pip-install-list.txt"
  Rename-Item "$path_to_utils\pip-install-list-new.txt" "pip-install-list.txt"
  pip install -r .\pip-install-list.txt
} else {
  echo "No new updates found"
  Remove-Item "$path_to_utils\pip-install-list-new.txt"
}
