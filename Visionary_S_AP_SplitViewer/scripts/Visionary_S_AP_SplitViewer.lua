--[[----------------------------------------------------------------------------

  Application Name: Visionary_S_AP_SplitViewer

  Summary:
  Show the distance image, statemap and color that the camera acquired

  Description:
  Set up the camera to take live images continuously. React to the "OnNewImage"
  event and display the distance (local-Z), statemap and color image in a 2D and
  3D viewer, using the addDepthMap function.

  How to run:
  Start by running the app (F5) or debugging (F7+F10).
  Set a breakpoint on the first row inside the main function to debug step-by-step.
  See the results in the different image viewer on the DevicePage.

  More Information:
  If you want to run this app on an emulator some changes are needed to get images.
  The statemap should be used as an error map for overlaying.

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------
-- Variables, constants, serves etc. should be declared here.

--setup the camera, set the configuration to default and get the camera model
local camera = Image.Provider.Camera.create()
Image.Provider.Camera.stop(camera)
local config = Image.Provider.Camera.getDefaultConfig(camera)
Image.Provider.Camera.setConfig(camera, config)
local cameraModel = Image.Provider.Camera.getInitialCameraModel(camera)

--setup the  views
local viewer2D = View.create("viewer2D")
local viewer3D = View.create("viewer3D")

local decoLocalZ = View.ImageDecoration.create()
decoLocalZ:setRange(0, 6500)

local decoStatemap = View.ImageDecoration.create()
decoStatemap:setRange(0, 100)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------
local function main()
  Image.Provider.Camera.start(camera)
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register("Engine.OnStarted", main)

---@param image Image
---@param sensordata SensorData
local function handleOnNewImage(images)
  -- Views, adds the distance image as default, second one is StateMap and third is RGB
  View.addDepthmap(viewer2D, images, cameraModel, {decoLocalZ, decoStatemap}, {"Local Z", "StateMap", "Color"})
  View.addDepthmap(viewer3D, images, cameraModel, {decoLocalZ, decoStatemap}, {"Local Z", "StateMap", "Color"})

  --Show in the viewer using present
  View.present(viewer2D)
  View.present(viewer3D)
end
Image.Provider.Camera.register(camera, "OnNewImage", handleOnNewImage)
--End of Function and Event Scope-----------------------------------------------