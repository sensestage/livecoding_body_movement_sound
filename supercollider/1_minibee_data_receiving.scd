/*
~path = "../minibee2osc/".resolveRelative;
~serial = "/dev/ttyACM4";
("cd" + ~path ++ ";minibee2osc -s" + ~serial + "-p 57300 -c minibees_configuration.xml").runInTerminal;
*/

// posting the data"
OSCdef( \minibeeData, { |msg| msg.postln; }, "/minibee/data" );

// storing all the data in a dictionary:
~acceleroData = IdentityDictionary.new;
OSCdef( \minibeeData2, { |msg| ~acceleroData.put( msg[1], msg.copyToEnd( 2 ) ); }, "/minibee/data" );

// plotting the data (uses SenseWorld quark)
~plotter = SWPlotterMonitor.new( { ~acceleroData.at(1) }, 100, 3, 0.025, 8 );
~plotter.start;


// resolution of the sensors is +/- 16 g over 13 bits:
32 / (2**13); // = g/bit
1/32;         // = 1g

// the sensor is sensitive to the gravity acceleration, so it can be used as a tilt sensor.
