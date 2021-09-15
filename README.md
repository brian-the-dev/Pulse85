# Pulse85
![](https://user-images.githubusercontent.com/40331046/133422289-e5d28d87-3777-4d0c-80c4-3bacbda1379d.png)

## Features
- Lightweight (~4 grams)
- No batteries required
- Very affordable
- Android app (Linux and Windows are on the roadmap)

## How To Make Your Own Pulse85
You'll need a PulseSensor, a Digispark, some jumper wires, and soldering tools.

1. If your PulseSensor comes with the jumper wires soldered, cut them about 2 cm from the PulseSensor. Otherwise, solder three wires (about 2 cm each) for each pin (+, -, and S).
2. Solder the wires to the Digispark according to the [schematic](https://github.com/brian-the-dev/Pulse85/blob/main/hardware/schematic.png).
3. Make a sleeve out of leather to protect your Pulse85. (Optional)
4. Follow the instructions on Digistump's [wiki](http://digistump.com/wiki/digispark/tutorials/connecting) to set up your Arduino IDE.
5. Upload the code (`hardware/sketch.ino`) to your Digispark.
6. Install the Pulse85 app on your phone. You can find the APK on the releases page.

## Roadmap
- [X] Basic functionality (heart rate and PPG graph)
- [ ] App settings (set threshold, graph settings, etc)
- [ ] Get a unique USB VID/PID
- [ ] Cross-platform support (Linux and Windows are prioritized)
- [ ] Design a PCB to further reduce size

## License
All source code (both software and hardware) is licensed under MIT license. The documentation, schematic, and images are licensed under Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0).
