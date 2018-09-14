# Pulsar

Pulsar is a service to provide realtime detection of the BPM of an audio input and generate a MIDI tick. It's designed for use on a Raspberry Pi to be used with QLC+.

It uses JACK audio connection kit, Aubio's aubiotrack example program, and a2jmidid to send MIDI data to the MIDI through device.
