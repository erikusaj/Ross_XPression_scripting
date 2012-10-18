'
' Ross XPression script to retrieve a banner for a TV-show from www.thetvdb.com
' 
' Requires:
' Text1 object on scene as input for your location
' Quad1 object on scene to apply the texture
'
' System requirements:
' Ross XPression, connection to internet, MSXML2, ADODB and FSO available
'
' Note: this is just an example code, still a lot to do ...
'
' contact:
' @en_erikusaj
'
	Dim Text1 As xpTextObject
	Self.GetObjectByName("Text1", Text1)
	Dim url="http://www.thetvdb.com/api/GetSeries.php?seriesname=" & Text1.Text

	' make sure the folder exists before running this script 
	Dim sFolder = "d:\texture_downloads\"
	Dim sName = Right(url, Len(url)-InStrRev(url,"/") )
	Dim sLocation
	Dim objHTTP As Object

	objHTTP = CreateObject("MSXML2.XMLHTTP")
	objHTTP.Open("GET", url, false)
	objHTTP.Send()

	If (objHTTP.Status = 200) Then
	
		'xmlparsing
		Dim node = objHTTP.responseXML.documentElement.getElementsByTagName("banner").item(0)
		url="http://www.thetvdb.com/banners/" & node.text
		'get the graphics
		sName = Right(url, Len(url)-InStrRev(url,"/") )

		objHTTP.Open("GET", url, false)
		objHTTP.Send()

		If (objHTTP.Status = 200) Then
			' file extension
			dim sExt = objHTTP.getResponseHeader("Content-Type")
			sExt = Right(sExt, Len(sExt)-InStrRev(sExt,"/"))
			sLocation = sFolder & "banner." & sExt
			'create binary stream object
			Dim objADOStream As Object
			objADOStream = CreateObject("ADODB.Stream")
			objADOStream.Open
			objADOStream.Type = 1
			objADOStream.Write(objHTTP.ResponseBody)
			objADOStream.Position = 0
			' if file exists delete it
			Dim objFSO As Object
			objFSO = Createobject("Scripting.FileSystemObject")
			If objFSO.Fileexists(sLocation) Then objFSO.DeleteFile(sLocation)
			objFSO = Nothing
			'save the ado stream to a file
			objADOStream.SaveToFile(sLocation)
			objADOStream.Close
			objADOStream = Nothing
		End if

		'create a material shader
		Dim material As xpMaterial
		Dim shader As xpBaseShader

		If engine.GetMaterialByName("banner", material) Then
			material.GetShaderByName("banner", shader)
		Else
			material = engine.CreateMaterial()
			material.Name = "banner"
			material.AddShader("Texture2D", 0, shader)
			shader.Name = "banner"
		End If

		shader.SetFileName(sLocation)
		material.UpdateThumbnail

		'apply material to scene objects
		Dim quad As xpQuadObject
		Self.GetObjectByName("Quad1", quad)
		quad.SetMaterial(0, material)
	End if