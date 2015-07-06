s.boot;
s.latency_(0.001);

MFunc.openHelpFile;

m = MFunc.new();

m.add( \test, { |v| v.postln; } );

(
OSCdef( \minibeeDataMFunc, { |msg|
	var id = msg[1];
	var data = msg.copyToEnd(2);
	// data.postln;
	if ( id == 1 ){
		m.value( data );
	};
}, "/minibee/data");
);

m.disable( \test );
m.enable( \test );

~accSpec = [0.44,0.56].asSpec;
Ndef(\a, { |freq = 200| LFPulse.ar(freq * [1, 0.1, 0.01]).product * 0.1 }).play;
m.add(\set_a, { |v| Ndef(\a).set(\freq, \freq.asSpec.map( ~accSpec.unmap( v[0] ) ) ) });

// use setUni:
Ndef(\a ).addSpec( \freq, [200, 6000, \exp] );
m.add(\set_a, { |v| Ndef(\a).setUni(\freq, ~accSpec.unmap( v[0] ) ) });


// data also sets Ndef(\b)
Ndef(\b, { |freq = 200| SinOsc.ar(freq * [1, 0.1, 0.01]).product * 0.3 }).play(1);
// use setUni to let Ndef(\b) decide on mapping
m.add(\set_b, { |v| Ndef(\b).setUni(\freq, ~accSpec.unmap( v[0] ) ) });

// change Ndef(\b)'s spec for freq - this requires JITLibExtensions
Ndef(\b).addSpec(\freq, [200, 2000, \exp]);


m.disable( \set_a );
m.disable( \set_b );

m.enable( \set_a );
m.enable( \set_b );


// data now also sets Ndef(\c)
Ndef(\c, { |freq = 200| LFSaw.ar(freq * [1, 0.1, 0.01]).product * 0.1 }).play(0);
m.addFirst(\set_c, { |v| Ndef(\c).setUni(\freq, ~accSpec.unmap( v[0] ) ) });

// range is reversed here
Ndef(\c).addSpec(\freq, [2000, 20, \exp]);


// define the three set functions as a modeList.
// this can be used for mutually turning the others off,
m.modeLists.put(\abc, [\set_a, \set_b, \set_c]);

// like this:
m.modes.put(\a_only, (on: \set_a, off: \abc));
m.modes.put(\b_only, (on: \set_b, off: \abc));
m.modes.put(\c_only, (on: \set_c, off: \abc));

// prepare a polyphonic mode too, where a b and c are controlled
m.modes.put(\abc, (on: [\set_a, \set_b, \set_c]));

// now switch betwee single control destinations ...
m.mode_(\a_only);
m.mode_(\b_only);
m.mode_(\c_only);

// ... and polyphonic control for all three
m.mode_(\abc);
