'
' Ross XPression script to fade a crawler on Layer
'
' Requires:
' A crawler scene on layer 3 of the first framebuffer
' 
' Fades and pauses a crawler scene
' Unfades and resumes a faded crawler on same layer
'
' System requirements:
' Ross XPression
'
  dim fb as xpOutputFrameBuffer
  dim scene as xpScene
  if Engine.GetOutputFrameBuffer(0, fb) then
    if fb.getSceneOnLayer(3, scene) then
      if scene.Alpha = 0 then
        scene.FadeTo(100, 40)
        scene.SoftStart = False
        scene.start()
      else
        scene.FadeTo(0, 40)
        scene.stop()
      end if
    end if
  end if
  Self.SetOffline()


