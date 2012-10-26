'
' Ross XPression script to retrieve manipulate a barchart
' 
' lots TODO
'
  dim Text1 as xpTextObject
  dim Stolpec as xpBaseObject
  
  Self.GetObjectByName("Text1", Text1)

  Self.GetObjectByName("stolpec", Stolpec)

  ' 1 = 100%
  ' value / 100
  dim a = split(Text1.Text, ",")
  dim x
  
  for each x in a
    Stolpec.ScaleY = Int(x) * 0.01
    
  next x
  Stolpec.FadeRange(0, 100, 100)

