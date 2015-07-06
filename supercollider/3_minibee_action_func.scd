s.boot; // boot server
s.latency_(0.001);


// thresholding
a = ActionFunc( \thresh, { |val, dir| [ val, dir ].postcs; }, 0.52 );

(
OSCdef( \minibeeDataAction, { |msg|
	var id = msg[1];
	var data = msg.copyToEnd(2);
	// data.postln;
	if ( id == 1 ){
		a.value( data[0] );
	};
}, "/minibee/data");
);

Ndef( \ting, { SinOsc.ar( \freq.kr(1000) ) * EnvGen.kr( Env.perc, \trig.tr(1), timeScale: \dur.kr(0.1) ) * 0.1 } );
Ndef( \ting ).play;

(
a = ActionFunc( \thresh, { |val, dir|
	[ val, dir ].postcs;
	if ( dir == 'up' )
	{ Ndef( \ting ).set( \freq, 2000, \trig, 1 ); }
	{ Ndef( \ting ).set( \freq, 1000, \trig, 1 ); }
}, 0.52 );
);


a = ActionFunc( \threshUp, { |val| [ val ].postcs; }, 0.52 );
a = ActionFunc( \threshDown, { |val| [ val ].postcs; }, 0.52 );

a = ActionFunc( \inRange, { |val| [ val ].postcs; }, [0.51, 0.52] );

// not so relevant for floating point values
// a = ActionFunc( \match, { |val, index| [ val, index ].postcs; }, [0.5, 0.52, 0.54] );

// only if value is going up
a = ActionFunc( \up, { |val| [ val ].postcs; } );

a = ActionFunc( \down, { |val| [ val ].postcs; } );


// change:
a = ActionFunc( \change, { |val| [ val ].postcs; } );

a = ActionFunc( \noChange, { |val| [ val ].postcs; } );

a = ActionFunc( \changeDirection, { |val, dir| [ val,dir ].postcs; } );

// speed
a = ActionFunc( \speed, { |val,speed| [ val, speed ].postcs; } );

a = ActionFunc( \speedAbove, { |val,speed| [ val, speed ].postcs; }, 0.1 );

a = ActionFunc( \speedBelow, { |val,speed| [ val, speed ].postcs; }, 0.1 );

// time based:
a = ActionFunc( \wait, { |val| [ val ].postcs; }, 0.1 );

a = ActionFunc( \delay, { |val| [ val ].postcs; }, 0.1 );

// speed limiting:
a = ActionFunc( \slew, { |val| [ val ].postcs; }, [0.1,0.01] );



// list:
(
a = ActionFuncList(
	[ \speedAbove, { |val, speed| [val, speed, \speedAbove].postln }, 2 ],
	[ \noChange, { |val| [val, \noChange].postln } ],
	[ \changeDirection, { |val, dir| [ val, dir ].postln } ]
);
);


(
// nested (upwards speed above)
a = ActionFunc(  \speedAbove,
	[ \up, { |val, up, speed| [val, speed, [\up,\speedAbove] ].postln } ],
	0.3
);
);

// add your own ActionFunc:
(
ActionFunc.typeDict.put(
	\meanTimed, { |node, val = 0 ...moreArgs| // mean timed
		var size, interval, current, windowVals;
		size = node.extra.asCollection[0] ? 10;
		interval = node.extra.asCollection[1] ? 0.01;
		windowVals = node.extra.asCollection[2] ? RingBuffer.new(size);

		if( node.task.isPlaying.not ) {
			node.task = Task({
				windowVals.overwrite( node.lastVal );
				node.action.value( windowVals.mean, *moreArgs );
				interval.wait;
			}).start;
		};
		nil;
	}
);
);


(
// mean Timed
a = ActionFunc(  \meanTimed, { |mean| [ mean ].postln }, [10, 0.01, RingBuffer.new(11)] );
)

// add your own ActionFunc:
(
ActionFunc.typeDict.put(
	\meanStdTimed, { |node, val = 0 ...moreArgs| // mean timed
		var size, interval, current, windowVals;
		size = node.extra.asCollection[0] ? 10;
		interval = node.extra.asCollection[1] ? 0.01;
		windowVals = node.extra.asCollection[2] ? RingBuffer.new(size);

		if( node.task.isPlaying.not ) {
			node.task = Task({
				var mean,std;
				windowVals.overwrite( node.lastVal );
				mean = windowVals.mean;
				std = windowVals.stdDev( mean );
				node.action.value( mean, std, *moreArgs );
				interval.wait;
			}).start;
		};
		nil;
	}
);
);


(
// mean + std Timed
a = ActionFunc(  \meanStdTimed, { |mean,std| [ mean,std ].postln }, [10, 0.01, RingBuffer.new(11)] );
)


// plot it:
~dataColl = IdentityDictionary.new;

a = ActionFunc(  \meanStdTimed, { |mean,std| ~dataColl.put( \mean,  mean ); ~dataColl.put( \std,  std ); }, [10, 0.01, RingBuffer.new(11)] );

~plotter = SWPlotterMonitor.new( { [ ~dataColl.at(\mean), ~dataColl.at(\std) ] }, 100, 3, 0.025, 8 );
~plotter.start;
