# rfid_opcua_docker
Docker Container with OPC UA server to drive a Jadak ThingMagic(R) M6e Nano UHR RFID Reader on Raspberry Pi and netPi

## Usage 

1. Open the Docker user interface
2. Edit the parameters under **Containers > Add Container**
	* **Image**: `ibloe/ua-server-docker:latest`
	* **Network > Network**: `host`
	* **Restart policy** : `always`
3. Press the button **Actions > Start container**
