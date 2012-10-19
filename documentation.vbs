'
' Ross XPression script for generating project documentation
' 
' Requires:
' A project with some scenes and objects, a lazy developer or designer who hates documentation writing
'
' System requirements:
' Ross XPression, FSO available
'
' Note: this is just an example code, still a lot to do ...
'
' contact:
' @en_erikusaj
'
  Dim sLocation = "c:\documentation.html"
  Dim Scene As xpScene
  Dim ScObj As xpBaseObject
  Dim i, j
  Dim tab = chr(9)

  ' if file exists delete it
  Dim fso, file, fs As Object
  fso = Createobject("scripting.FileSystemObject")
  If fso.Fileexists(sLocation) Then fso.DeleteFile(sLocation)

  fso.CreateTextFile(sLocation)
  file = fso.GetFile(sLocation)
  ' open text file
  fs = file.OpenAsTextStream(2, -2)

  fs.WriteLine("<!DOCTYPE html><html lang=en><meta charset=utf-8><title> Ross XPression project documentation </title>")
  fs.WriteLine("<style>{margin:0;padding:0}html,code{font:15px/22px arial,sans-serif}html{background:#fff;color:#222;padding:15px}body{max-width:800px;}</style>")
  fs.WriteLine("</head><body>")
  fs.WriteLine("<h1>Project: " &Engine.ActiveProject.FileName &"</h1>")
  fs.WriteLine("total scenes:" & Engine.SceneCount)
  ' loop over all scenes
  For i = 0 To Engine.SceneCount - 1
    Engine.GetScene(i, Scene)
    fs.WriteLine("<h2>Scene: &quot;" &Scene.Name &"&quot;<br> ID:" &Scene.ID &"</h2>")
    fs.WriteLine(tab &"dimensions:" &Scene.Width &"x" &Scene.Height &"<br>")
    fs.WriteLine(tab &"description:" &Scene.description &"<br>")
    fs.WriteLine(tab &"objects:" &Scene.ObjectCount &"<br>")
    for j = 0 to Scene.ObjectCount - 1
		Scene.GetObject(j, ScObj)
        fs.WriteLine(tab &tab &"<h4>" &ScObj.TypeName &": " &ScObj.Name &"</h4>")
        fs.WriteLine(tab &tab &"<ul>")
        fs.WriteLine(tab &tab &"<li>published: " &ScObj.IsPublished &"</li>")
        fs.WriteLine(tab &tab &"<li>alpha: " &ScObj.Alpha &"</li>")
        fs.WriteLine(tab &tab &"<li>visible:" &ScObj.Visible &"</li>")
        fs.WriteLine(tab &tab &"<li>position: " &ScObj.PosX &"," &ScObj.PosY &"," &ScObj.PosZ &"</li>")
        fs.WriteLine(tab &tab &"<li>rotation: " &ScObj.RotX &"," &ScObj.RotY &"," &ScObj.RotZ &"</li>")
        fs.WriteLine(tab &tab &"<li>scale: " &ScObj.ScaleX &"," &ScObj.ScaleY &"," &ScObj.ScaleZ &"</li>")
        fs.WriteLine(tab &tab &"</ul>")
	next j
	fs.WriteLine()
  next i
  fs.WriteLine("</body></html>")
  ' Close the file and clean up
  fs.Close
  fs = Nothing
  file = Nothing
  fso = Nothing
