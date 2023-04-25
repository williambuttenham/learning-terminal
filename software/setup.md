## Raspberry Pi Setup

1. Image the SD card for the Raspberry Pi using the [Raspberry Pi Imager](https://www.raspberrypi.org/software/).
    1. Select `Choose OS`
    3. Select `Other specific-purpose OS`
    4. Select `FullPageOS`
2. On the newly flashed drive, edit `fullpageos-wpa-supplicant.txt` to include your WiFi credentials.
2. Insert the SD card into the Raspberry Pi and power it on.
3. Connect to the Raspberry Pi using SSH.
    1. The default hostname is `fullpageos`
    2. The default username is `pi`
    3. The default password is `raspberry`
4. Edit the default webpage in `/boot/fullpageos.txt` to point at your TLT server.
