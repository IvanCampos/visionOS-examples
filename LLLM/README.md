# LLLM
**Local Large Language Model (LLLM):** Call your LM Studio models from your Apple Vision Pro   
![GIF](https://github.com/IvanCampos/visionOS-examples/assets/872137/a691758a-4e3a-4b58-9c72-06d9ed655ae8)

## Requirements
* Install [LM Studio](https://lmstudio.ai/) on your Apple Silicon (M-Series) Mac
  * Click on Local Server in Left Menu
    * Download your model of choice (e.g. TheBloke/*)
    * Load your desired local Model
    * Click "Start Server" button for Port 1234
* Xcode 15.2+

# Instructions
## Simulator
* Open in Project in Xcode
* Set your run destination to a Vision Pro Simulator
* Play

## Apple Vision Pro
* Open in Project in Xcode
* Set your run destination to a Vision Pro Simulator
* Open APIResponseService.swift
  * Get your IP address
    * In Terminal, run: ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'
  * Replace the text "ENTER THE IP ADDRESS OF THE MACHINE RUNNING LM STUDIO HERE" with your IP address
* Play
* When sending your prompt for the first time, Allow Network Access
