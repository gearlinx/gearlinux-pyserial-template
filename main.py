#!/usr/bin/env python

import os
import sys
import time
import signal
import serial

def quit(signo, stack):
    print('Terminating')
    sys.exit(0)

# Bind the host system's serial port to this path inside the container
tty = '/dev/tty0';

baudrate = 115200
msg = b'Hello world'

# Handle terminating from "docker stop"
signal.signal(signal.SIGTERM, quit)

print('Starting pySerial example program on tty {} at {} baud'.format(tty, baudrate))

# See https://pyserial.readthedocs.io for more information
with serial.Serial(tty, baudrate, timeout=1) as ser:
    while True:
        print('Sending message on serial port...');
        ser.write(msg)

        read = ser.read(len(msg))
        print('Read bytes: {}'.format(read));
        time.sleep(10)

print('Exiting')
