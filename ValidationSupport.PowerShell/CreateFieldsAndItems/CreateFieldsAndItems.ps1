#
# Create a custom list / create many fields / create many items
#

Param(
    # 対象サイトURL
    [Parameter(Mandatory=$true, ParameterSetName="WebUrl")]
    [string]$webUrl,
	[Parameter(Mandatory=$true, ParameterSetName="ListName")]
    [string]$listName,
	[Parameter(Mandatory=$true, ParameterSetName="fieldNum")]
    [string]$fieldNum,
	[Parameter(Mandatory=$true, ParameterSetName="itemNum")]
    [string]$itemNum
)

$web = Get-SPWeb -Identity $webUrl

# Create New Custom List
$listCollection = $web.Lists
$list = $listCollection.TryGetList($listName)
if($list -ne $null) {
	Write-Host "Already exists in this web"
	# return?
}else{
	$listCollection.Add($listName,"Created by PowerShell",$listTemplate)
}

$web = Get-SPWeb -Identity $webUrl
$list = $web.Lists[$ListName]

#Add Fields
for($i=1; $i -le $fieldNum; $i++){
$columnXml = "<Field Type='Text' DisplayName='Column$i' Required='FALSE' MaxLength='255' StaticName='Column$i' Name='FirstName' />"
$list.Fields.AddFieldAsXml($columnXml,$true,[Microsoft.SharePoint.SPAddFieldOptions]::AddFieldToDefaultView)
$list.update()
}

#Add items
for($i=1; $i -le $itemNum; $i++){
 $item = $list.AddItem()
 $item["Title"] = "No.$i item"
  for($j=1; $j -le $fieldNum; $j++){
    $columnName = "Column" + $j
    $item[$columnName] = "$j"
  }
 $item.Update();
}
$web.dispose()
