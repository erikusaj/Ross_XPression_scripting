'
' Ross XPression script to generate a QR code by using Google chart API
' 
' Requires:
' Text1 object on scene as input for your URL
' Quad1 object on scene to apply the texture
'
' *IMPORTANT*: 
' This script uses some deprecated API! (operational until April 20, 2015):
' The Image Charts portion of Google Chart Tools has been officially deprecated as of April 20, 2012. 
' https://developers.google.com/chart/terms 
'
' System requirements:
' Ross XPression, connection to internet, MSXML2, ADODB and FSO available
'
' contact:
' @en_erikusaj
'
	dim Text1 as xpTextObject
	Self.GetObjectByName("Text1", Text1)
	dim url="https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl="& Text1.Text &"&choe=UTF-8"

	dim sFolder = "c:\"
	dim sName = Right(url, Len(url)-InStrRev(url,"/") )
	dim sLocation
	dim objHTTP as object

	on error resume next
	objHTTP = CreateObject("MSXML2.XMLHTTP")
	if err.number <> 0 then Text1.Text = err.number & " " & err.description

	objHTTP.Open("GET", url, false)
	objHTTP.Send()

	If (objHTTP.Status = 200) Then
		' file extension
		dim sExt = objHTTP.getResponseHeader("Content-Type")
		sExt = Right(sExt, Len(sExt)-InStrRev(sExt,"/"))
		sLocation = sFolder & "QR" & "." & sExt
		'create binary stream object
		dim objADOStream as object
		objADOStream = CreateObject("ADODB.Stream")
		objADOStream.Open
		objADOStream.Type = 1
		objADOStream.Write(objHTTP.ResponseBody)
		objADOStream.Position = 0
		' if file exists delete it
		dim objFSO as object
		objFSO = Createobject("Scripting.FileSystemObject")
		if objFSO.Fileexists(sLocation) then objFSO.DeleteFile(sLocation)
		objFSO = Nothing
		'save the ado stream to a file
		objADOStream.SaveToFile(sLocation)
		objADOStream.Close
		objADOStream = Nothing
	End if

	'create a material shader
	dim material as xpMaterial
	dim shader As xpBaseShader

	if engine.GetMaterialByName("QR", material) then
		material.GetShaderByName("QR", shader)
	else
		material = engine.CreateMaterial()
		material.Name = "QR"
		material.AddShader("Texture2D", 0, shader)
		shader.Name = "QR"
	end if

	shader.SetFileName(sLocation)
	material.UpdateThumbnail

	'apply material to scene objects
	Dim quad As xpQuadObject
	Self.GetObjectByName("Quad1", quad)
	quad.SetMaterial(0, material)
