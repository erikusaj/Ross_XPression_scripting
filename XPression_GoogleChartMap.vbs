'
' Ross XPression script to generate a Geo-political map texture by using GoogleChart API
' 
' Requires:
' Text1 object on scene as input 
'		to enter an ISO 3166-1 alpha-2 country code: such as US, CA, GB... or multiple codes
' 		list of codes: http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
' Quad1 object on scene to apply the texture
' Sphere1 object on scene to apply the texture on something you can use as a spinning globe
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
	Dim Text1 As xpTextObject
	Self.GetObjectByName("Text1", Text1)
	Dim url="http://chart.apis.google.com/chart?cht=t&chs=440x220&chd=s:_&chtm=world&chld=" & Text1.Text &"&chco=CCCCCC|0000BB&chf=bg,s,e0f2ffB"
	' make sure the folder exists before running this script 
	Dim sFolder = "d:\texture_downloads\"
	Dim sName = Right(url, Len(url)-InStrRev(url,"/") )
	Dim sLocation
	Dim objHTTP As Object
	
	On Error Resume Next
	objHTTP = CreateObject("MSXML2.XMLHTTP")
	If err.number <> 0 Then Text1.Text = err.number & " " & err.description
	
	objHTTP.Open("GET", url, false)
	objHTTP.Send()
	
	If (objHTTP.Status = 200) Then
		' file extension
		Dim sExt = objHTTP.getResponseHeader("Content-Type")
		sExt = Right(sExt, Len(sExt)-InStrRev(sExt,"/"))
		sLocation = sFolder & "map" &  Text1.Text & "." & sExt
		'create binary stream object
		Dim objADOStream As Object
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
	Dim material as xpMaterial
	Dim shader As xpBaseShader
	
	If engine.GetMaterialByName("dynamic", material) Then
		material.GetShaderByName("dynamic", shader)
	Else
		material = engine.CreateMaterial()
		material.Name = "dynamic"
		material.AddShader("Texture2D", 0, shader)
		shader.Name = "dynamic"
	End If
	
	shader.SetFileName(sLocation)
	material.UpdateThumbnail
	
	'apply material to scene objects
	Dim quad As xpQuadObject
	Self.GetObjectByName("Quad1", quad)
	quad.SetMaterial(0, material)
	
	Dim sphere As xpSphereObject
	Self.GetObjectByName("Sphere1", sphere)
	sphere.SetMaterial(0, material)