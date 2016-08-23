# avr_splmeter_arduino
Arduino port of avr_splmeter by Davide Gironi (https://davidegironi.blogspot.de/2014/02/a-simple-sound-pressure-level-meter-spl.html)

ported to arduino 1.6.5 by hjgode
using uart library by Peter Fleury

The code compiles for Atmega 328/168 and Atmega8 Optiboot in IDE 1.6.5.

= Tested with Arduino Nano, OK

+ See adc.h to configure the correct AREF source, I used "#define ADC_REF 1"
+ Signal was connected to A3.
+ see audioget.h to switch between fast and slow SPL sampling (#define AUGIOGET_TW...)
+ see audioget.h and setup your microphone sensivity and 'transfer factor' (see below)
+ Used processing with pde in "audioget_visualizer" to see spectrum.
+ Use processing with pde "audioget_plot" to see dbA
 
## Sensivity and 'transfer factor' (audioget.h)
//define voltage reference and spl db reference
AUDIOGET_VOLTREF 0.000315 
AUDIOGET_DBREF 30
from my understanding the above values can be taken from the electret microphone data sheet. Normally, only the sensivity is given. Go to http://www.sengpielaudio.com/calculator-transferfactor.htm to calculate the voltage reference (or transfer factor?). Ensure you are using the correct reference, normally this is 1V/Pa.

# Original README:
==================================================
avr splmeter
==================================================
= Copyright (c) Davide Gironi, 2012              =
= http://davidegironi.blogspot.it/               =
==================================================


A sound level meter or sound meter is an instrument which measures sound pressure
level, commonly used in noise pollution studies for the quantification
of different kinds of noise, especially for industrial, environmental and aircraft noise. 

avr splmeter is a spl meter implementeted on avr microcontroller.
It reads data from an ADC pin and returns the RMS value of the input using
rms avarage method.

Setup parameters are stored in file audioget.h


Devel Notes
-----------
This library was developed on Eclipse, built with avr-gcc on Atmega8 @ 16MHz.
If you include <math.h> add libm library to linker.


License
-------
Please refer to LICENSE file for licensing information.
