ALSA Request Device
===================

A small utility that reserves an audio-device on a modern GNU/Linux desktop.

Motivation
----------

The tool is intended to be used with ALSA applications that are not in a
position to send dbus request by themselves.

Description
-----------

This tool sends a request to the session message bus to reserve an audio-device:
Other applications which may currently use the device are asked to release it
(which may or may not succeed depending on the given priority -p).

If the device can be acquired, `alsa_request_device` keeps running and answers
requests pertaining to the device. It terminates if either STDIN is closed, a
SIGINT or SIGTERM is sent or some other application requests the device with
a higher priority.

If a PID is given `alsa_request_device` watches the process and also terminates
when the process with the given PID exits.

The device remains reserved as long as `alsa_request_device` runs.

For further information please see the included man page.
