/*
(
SynthDef.new(\default, {
arg dur, attack=0.01, release=1.0,
t_gate=1, out, freq=442, cutoff=5500,
rq=1, pan=0.0, amp=0.5;

var env = EnvGen.kr(
	Env.perc(attack, release),
	t_gate,
	timeScale: dur,
	doneAction: 2
);
var sig = DPW3Tri.ar(freq: freq, mul: env);
sig = RLPF.ar(sig, cutoff.clip(20.0, 20000.0), rq.clip(0.0,1.0));
sig = Pan2.ar(sig, pan);
Out.ar(out, sig * amp);
}).add;
)*/


x = OSCFunc( { | msg, time, addr, port |
	var pyFreqs = [];
    var pyFreq;
	var msg1 = msg[1].asString;
	msg1 = msg1.split($,);
	msg1.postln;
	for (2, 1 + msg1[0].asInteger, {
		arg i;
		pyFreqs = pyFreqs.add(msg1[i].asFloat;
		{SinOsc.ar(msg1[i].asFloat,0,Line.kr(0.1,0.0,1.0))}.play

	)});
	pyFreqs.postln;
	// p = Pbind(\freq, pyFreqs).play;
	// (freq: pyFreqs, dur: msg1[1].asFloat * 2.5).play;
	/*{SinOsc.ar(440,0,Line.kr(0.1,0.0,1.0))}.play*/

	// h.set( \freq, pyFreqs );
}, "/print" );



