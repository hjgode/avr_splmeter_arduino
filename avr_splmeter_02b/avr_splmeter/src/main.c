/*
avr SPL meter 02

copyright (c) Davide Gironi, 2013

Released under GPLv3.
Please refer to LICENSE file for licensing information.
*/

#include <avr/io.h>
#include <stdlib.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#include "adc/adc.h"

#include "audioget/audioget.h"

#define UART_BAUD_RATE 9600
#include "uart/uart.h"

int main(void) {
	//init uart
	uart_init( UART_BAUD_SELECT(UART_BAUD_RATE,F_CPU) );

	//init interrupt
	sei();

	//get current reference voltage
	double refv = acd_getrealvref();

	audioget_init();

	int16_t audiorms = 0;
	int16_t audiospl = 0;
	double spectrum[AUDIOGET_SAMPLES/2+1] = {0};

	for (;;) {
		uint16_t i = 0;

		//get samples
		audioget_getsamples();
		//compute fft
		audioget_computefft();
		//apply weighting
		audioget_doweighting();
		//get spectrum
		audioget_getmagnitude(&spectrum[0]);

		//get rms and spl
		audiorms = audioget_getrmsval();
		float rmsvolt = 0;
		if(audiorms <= 0)
			rmsvolt = AUDIOGET_VOLTREF;
		else
			rmsvolt = adc_getvoltage(audiorms, refv);
		audiospl = audioget_getspl(rmsvolt, AUDIOGET_VOLTREF, AUDIOGET_DBREF);

		//output spectrum
		for(i=0; i<AUDIOGET_SAMPLES/2+1; i++) {
			spectrum[i] = spectrum[i]*100; //send it multiplied, as integer
			uart_putc((uint16_t)spectrum[i]);
			uart_putc((uint16_t)spectrum[i]>>8);
		}

		//output rms
		uart_putc(audiorms);
		uart_putc(audiorms>>8);
		//output spl
		uart_putc(audiospl);
		uart_putc(audiospl>>8);

		uart_putc('\n');
	}

}
