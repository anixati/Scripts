<#
Description: Creates zip file of vs sln folder excluding bin,obj and other files 
Author: Anil Kornepati
#>

#-- Variables
$crDir = Split-Path $myInvocation.MyCommand.Path

#-- Create Temp directory
$pkDir = Join-Path $Env:Temp $(New-Guid)
New-Item -Type Directory -Path $pkDir | Out-Null
Write-Host "Created $($pkDir) folder ..."

#-- Delete prev zip files
Get-ChildItem -Path $crDir -Include "*.zip" -Recurse  -Force -ea 0 |
ForEach-Object { 
   Write-Host "Deleting $( $_.FullName) .. "
   $_ | del -Recurse -Force
}

#-- Copy files recursivly 
Write-Host "Copying files...."
Copy-Item -Path $crDir -Destination $pkDir -recurse -Force
Write-Host "Done"

#-- Delete excluded content
Get-ChildItem -Path $pkDir -Recurse -Directory -Force -ea 0 |
?{ $_.FullName.ToLower() -match '\\.git$' -or  $_.FullName.ToLower() -match '\\.vs$' -or  $_.FullName.ToLower() -match '\\obj$' -or  $_.FullName.ToLower() -match '\\bin$' } |
ForEach-Object { 
   Write-Host "Deleting $( $_.FullName) .. "
   $_ | del -Recurse -Force
}
# explorer  $pkDir

#-- Compress the folder 
$zpPath = "$($crDir)\$(New-Guid).zip"
Write-Host "Compressing to $($zpPath) .. "
Compress-Archive -Path $pkDir -DestinationPath $zpPath

Write-Host "Done!"
