Set objFso 		= CreateObject("Scripting.FileSystemObject")
unifiedHosts 	= ""
whitelist		= ""
blacklist		= ""
whitelistPath 	= "D:\GitRepo\hosts\whitelist"
blacklistPath	= "D:\GitRepo\hosts\blacklist"
webHostpath 	= "D:\GitRepo\hosts\hosts"
const overWrite = 2
const forRead 	= 1
const forAppend	= 8
Url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"
dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP")
dim bStrm: Set bStrm = createobject("Adodb.Stream")
xHttp.Open "GET", Url, False
xHttp.Send

with bStrm
    .type = 1 '//binary
    .open
    .write xHttp.responseBody
    .savetofile webHostpath, overWrite '//overwrite
end with
'msgbox "1"
whitelist = readFile(whitelistPath)
'msgbox "2"
blacklist = readFile(blacklistPath)
'msgbox "3"
Set mainHostFile = objFso.OpenTextFile( webHostpath, forRead )
unifiedHosts = editList(blacklist) & vbCrlf & ClearWhiteList(mainHostFile.ReadAll,whitelist)
mainHostFile.Close
Set mainHostFile = objFso.OpenTextFile( webHostpath, overWrite )
mainHostFile.write(unifiedHosts)
mainHostFile.Close
'msgbox "Your Hosts have been Downloaded"
wscript.quit (1)

function readFile (filePath)
'msgbox "Read Start"
fileData = ""
Set hostFile = objFso.OpenTextFile( filePath, forRead )
do While Not hostFile.AtEndOfStream
	line = hostFile.readLine
	if line<>"" and InStr(line,"#")=0 then
		fileData = fileData & line & vbCrlf
	end if
loop
hostFile.Close
readFile = fileData
'msgbox "read End"
End function

function ClearWhiteList(allHosts,white)
if white <>"" then
'msgbox "5"
returnList = ""
lists = split(white,vbCrlf)
for each list in lists
'msgbox list
		allHosts = replace(allHosts,list,"")
next
' msgbox allHosts
lists = split(allHosts,vbCrlf)
for each list in lists
	If InStr(list,"!@#$%^")=0 then
		returnList = returnList & list & vbCrlf
	end if
Next
end if
' msgbox returnList

ClearWhiteList = returnList
end function

function editList(black)
'msgbox "4"
returnList="# Black LIST" & vbCrlf
lists=split(black,vbCrlf)
for each list in lists
	if list <>"" then
	returnList = returnList & "0.0.0.0 " & list & vbCrlf
	end if
next
editList = returnList
end function