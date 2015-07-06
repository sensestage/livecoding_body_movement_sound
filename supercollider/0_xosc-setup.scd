/*
// start xosc:
"xoscmain 57300".runInTerminal;
*/

// xosc is running on the localhost (127.0.0.1) and on port 57300
~xosc = NetAddr.new( "127.0.0.1", 57300 );
~xosc.sendMsg( "/XOSC/subscribe/tag", "/minibee/data" );

OSCdef( \xoscConfirmSubscribe, { |msg| msg.postln; }, "/XOSC/subscribe" );

// optional:
~xosc.sendMsg( "/XOSC/subscribe/tag", "/minibee/status" );
~xosc.sendMsg( "/XOSC/subscribe/tag", "/minibee/info" );
