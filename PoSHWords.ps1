###########################################################################
#
# NAME:		PoSHWords
#
# AUTHOR:	RichRoc
#
# COMMENT:	Powershell Script to spider a website and generate a unique
#			wordlist.
#
# VERSION HISTORY:
# 0.1 5/28/2014 - Initial release
#
###########################################################################

#Parameters#
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$False,Position=1)]
	[string]$Action,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$URL,
	[Parameter(Mandatory=$True,Position=3)]
	[int]$MinLength,
	[Parameter(Mandatory=$False,Position=4)]
	[int]$MaxLength
)

#Main#

#Initialize an array for PoSHWords
$WordListArray = @()
$Regex = "(\b(\w{$MinLength,$MaxLength})\b)"

#Get Web Page
$WebSite = Invoke-WebRequest -UseBasicParsing -Uri $URL

#Parse website content to word list array
$TempArray = $WebSite.RawContent.ToString() | Select-String -Pattern $Regex -AllMatches | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value}
$WordListArray = $WordListArray + $TempArray

foreach ($Link in $WebSite.Links)
{
	if ($Link.href.ToLower().Contains("$URL"))
		{ 
		#Write-Output $Link.href
		$SubLink = Invoke-WebRequest -UseBasicParsing -Uri ($link.href)
			if ($SubLink.StatusCode -eq 200)
				{
				$TempArray = $SubLink.RawContent.ToString() | Select-String -Pattern $Regex -AllMatches | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value}
				$WordListArray = $WordListArray + $TempArray
				}
		}
	elseif ($Link.href.ToLower().StartsWith("/"))
		{
		#Write-Output ("http://" + "$URL" + $Link.href)
		$SubLink = Invoke-WebRequest -UseBasicParsing -Uri ("http://" + "$URL" + $link.href)
			if ($SubLink.StatusCode -eq 200)
				{
				$TempArray = $SubLink.RawContent.ToString() | Select-String -Pattern $Regex -AllMatches | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value}
				$WordListArray = $WordListArray + $TempArray
				}
		}
}
#Write the WordListArray to a text file
$WordListArray | ForEach-Object {$_.ToLower()} | Select-Object -unique > wordlist_$URL.txt



<#--Invoke-WebRequest Object reference
$WebSite.StatusCode
$WebSite.StatusDescription
$WebSite.Content
$WebSite.RawContent
$WebSite.Forms
$WebSite.Headers
	$WebSite.Headers.Pragma
	$WebSite.Headers.Keep-Alive
	$Website.Headers.Transfer-Encoding
	$Website.Headers.Cache-Control
	$Website.Headers.Content-Type
	$Website.Headers.Date
	$Website.Headers.Server
$WebSite.Images
$WebSite.InputFields
$WebSite.Links
$WebSite.ParsedHTML
$WebSite.RawContentLength
--#>