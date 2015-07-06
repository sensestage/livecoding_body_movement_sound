// simple sonification:
s.boot; // boot server
s.latency_(0.001);

// a simple three-tone sine oscillator
Ndef( \sines, { SinOsc.ar( \freq.kr( [1,1,1], 0.1 ) * 300, 0, \amp.kr([0,0,0], 0.1) ).sum } );

// play the sound:
Ndef( \sines ).play;

// map data to it:
(
OSCdef( \minibeeData3, { |msg|
	var id = msg[1];
	var data = msg.copyToEnd(2);
	if ( id == 1 ){
		Ndef( \sines ).setn( \freq, data * 2 * [1,2,3] );
		Ndef( \sines ).setn( \amp, (data - 0.5).abs * 5 );
	};
});
);

// show the sound on the scope
Ndef( \sines ).scope

// stop the sound
Ndef( \sines ).stop;


// alternative sound & mapping:
// single sinetone
Ndef( \sines, { SinOsc.ar( \freq.kr( 300, 0.1 ), 0, \amp.kr(0.1, 0.1) ) } );
(
OSCdef( \minibeeData3, { |msg|
	var id = msg[1];
	var data = msg.copyToEnd(2);
	if ( id == 1 ){
		Ndef( \sines ).set( \freq, ([300, 5000, \exp].asSpec.map( data[0] )) );
		Ndef( \sines ).set( \amp, (data[2] - 0.5).abs * 5 );
	};
}, "/minibee/data");
);
Ndef( \sines ).play;

// specs for mapping:
~accMap = [0.44,0.56].asSpec; // range of accelerometer
~freqMap = [300, 5000, \exp].asSpec; // range of frequency
(
OSCdef( \minibeeData3, { |msg|
	var id = msg[1];
	var data = msg.copyToEnd(2);
	if ( id == 1 ){
		Ndef( \sines ).set( \freq, data[0].specMap( ~accMap, ~freqMap ) ); // specMap from SenseWorld quark
		Ndef( \sines ).set( \amp, (data[2] - 0.5).abs * 5 );
	};
}, "/minibee/data");
);

// stop the sound
Ndef( \sines ).stop;
