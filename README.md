# rfid-opcua-docker
Docker Container with OPC UA server to drive a Jadak ThingMagic(R) M6e Nano UHR RFID Reader on Raspberry Pi and netPi

## Usage 

1. Open the Docker user interface
2. Edit the parameters under **Containers > Add Container**
	* **Image**: `ibloe/rfid-opcua-docker:latest`
	* **Network > Network**: `host`
	* **Restart policy** : `always`
	* **Runtime & Ressources > Priviliged mode** : true
	* **Runtime & Ressources > Devices > add device** : `/dev/ttyAMA0 -> /dev/ttyAMA0`
	* **Runtime & Ressources > Devices > add device** : `/dev/gpiomem -> /dev/gpiomem`
3. Press the button **Actions > Start container**
