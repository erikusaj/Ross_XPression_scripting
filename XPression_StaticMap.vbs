'
' Ross XPression script to generate a Map of your location from Google static maps API
' 
' Requires:
' Text1 object on scene as input for your location
' Quad1 object on scene to apply the texture
'
' System requirements:
' Ross XPression, connection to internet, MSXML2, ADODB and FSO available
'
' contact:
' @en_erikusaj
'
	Dim Text1 As xpTextObject
	Self.GetObjectByName("Text1", Text1)
	Dim url="http://maps.googleapis.com/maps/api/staticmap?center=" & Text1.Text & "&zoom=13&size=600x600&sensor=false"

	Dim sFolder = "d:\texture_downloads"
	Dim sName = Right(url, Len(url)-InStrRev(url,"/") )
	Dim sLocation
	Dim objHTTP As object

	objHTTP = CreateObject("MSXML2.XMLHTTP")
	objHTTP.Open("GET", url, false)
	objHTTP.Send()

	If (objHTTP.Status = 200) Then
		' file extension
		Dim sExt = objHTTP.getResponseHeader("Content-Type")
		sExt = Right(sExt, Len(sExt)-InStrRev(sExt,"/"))
		sLocation = sFolder & "static_map_from_google." & sExt
		'create binary stream object
		Dim objADOStream As object
		objADOStream = CreateObject("ADODB.Stream")
		objADOStream.Open
		objADOStream.Type = 1
		objADOStream.Write(objHTTP.ResponseBody)
		objADOStream.Position = 0
		' if file exists delete it
		Dim objFSO As object
		objFSO = Createobject("Scripting.FileSystemObject")
		If objFSO.Fileexists(sLocation) Then objFSO.DeleteFile(sLocation)
		objFSO = Nothing
		'save the ado stream to a file
		objADOStream.SaveToFile(sLocation)
		objADOStream.Close
		objADOStream = Nothing
	End If

	'create a material shader
	Dim material As xpMaterial
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

	'apply material to your scene objects
	Dim quad As xpQuadObject
	Self.GetObjectByName("Quad1", quad)
	quad.SetMaterial(0, material)

