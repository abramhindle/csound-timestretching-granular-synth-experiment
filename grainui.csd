<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
;-odac           -iadc     -d     ;;;RT audio I/O
;
;-odac           -iadc     -d  -+rtaudio=jack -+jack_client=csoundGrain  -b 441 -B 2048
;-odac           -iadc     -d  -+rtaudio=jack -+jack_client=csoundGrain  -b 441 -B 8192
; -odac           -iadc     -d    ;;;RT audio I/O
 -odac           -iadc     -d  -+rtaudio=jack -+jack_client=csoundGrain  -b 441 -B 2048   ;;;RT audio I/O
;-odac
; For Non-realtime ouput leave only the line below:
; -o grain3.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
/* FROM CSOUND MANUAL 

Author: Istvan Varga

New in version 4.15

Updated April 2002 by Istvan Varga

*/

sr	=  44100
kr	=  100
ksmps   =  441
nchnls	=  1

/* f#  time  size  1  filcod  skiptime  format  channel */
giImpulse     ftgen   666, 0, 65536, 1,   "chicken.wav", 0, 0, 0	;mono file, duration 0.750
giImpulse     ftgen   777, 0, 2097152, 1, "hurricane.wav", 0, 0, 0	;mono file, duration 40 seconds
;;; giImpulse     ftgen   888, 0, 16777216, 1, "videogames.wav", 0, 0, 0	;mono file, duration 40 seconds
giImpulse     ftgen   999, 0, 16777216, 1, "goldberg-aria-da-capo.wav", 0, 0, 0	;mono file, duration 40 seconds
;giImpulse     ftgen   555, 0, 16777216, 1, "yaocave-1-xanadu-wurlitzer-jujube.wav", 0, 0, 0	;mono file
; giImpulse     ftgen   444, 0, 16777216, 1, "ma-vlast.wav", 0, 0, 0	;mono file

gkFreq init 1
gkFreqRand init 0.001
gkAmp init 1000
gkDens init 498
gkDur init 0.2
gkPhase init 0
gkPhaseMix init 1


FLcolor	180,200,199
FLpanel 	"Granular",250,300
    istarttim = 0
    idropi = 666
    idur = 1
    ibox0  FLbox  "Grain", 1, 6, 12, 300, 20, 0, 0
    ;FLsetFont   7, ibox0
                
    gkFreq,    iknob1 FLknob  "Freq", 0.00001, 2, -1,1, -1, 50, 0,0
    gkFreqRand,    iknob2 FLknob  "FreqRand", 0.0001, 0.2, -1,1, -1, 50, 50,0
    gkAmp,    iknob3 FLknob  "Amp", 0.0001, 10000, -1,1, -1, 50, 100,0
    gkDens,    iknob4 FLknob  "Dens", 1, 600, -1,1, -1, 50, 150,0
    gkDur,    iknob5 FLknob  "Dur", 0.01, 1.0, -1,1, -1, 50, 200,0
    ;kout, ihandle FLslider "label", imin, imax, iexp, itype, idisp, iwidth, \
    ;  iheight, ix, iy
    gkPhase, islider1 FLslider "Phase", 0, 1, 0, 1, -1, 250, 50, 0, 100
    ;kout, ihandle FLknob "label", imin, imax, iexp, itype, idisp, iwidth, \
    ;  ix, iy [, icursorsize]
    gkPhaseMix,    iknob6 FLknob  "PhaseMix", 0, 1.0, 0,1, -1, 50, 200,150
    FLsetVal_i   1.0, iknob1
    FLsetVal_i   0.001, iknob2
    FLsetVal_i   1000, iknob3
    FLsetVal_i   498, iknob4
    FLsetVal_i   0.2, iknob5
    FLsetVal_i   0.0, islider1
    FLsetVal_i   1.0, iknob6
    
    
    
FLpanel_end	;***** end of container

FLrun		;***** runs the widget thread 






/* Bartlett window */
itmp	ftgen 1, 0, 16384, 20, 3, 1
/* sawtooth wave */
itmp	ftgen 2, 0, 16384, 7, 1, 16384, -1
/* sine */
itmp	ftgen 4, 0, 1024, 10, 1

	instr 666
kdur	= k(p3)
idur    = p3
kamp	= k(p4)
kfrq	= k(p5)
;kfmd	=  kfrq * 0.001		; random variation in frequency
kfmd	=  kfrq * 0.001		; random variation in frequency
kgdur	=  0.1			; grain duration
;kdens	=  200			; density
kdens	=  500			; density
iseed	=  1			; random seed
;;; kphs	oscili 0.5, 1, 4	; phase
kphs	linen 1, idur, idur, 0
kfnum     = k(p6)

/* Syntax

ares grain3 kcps, kphs, kfmd, kpmd, kgdur, kdens, imaxovr, kfn, iwfn, \
      kfrpow, kprpow [, iseed] [, imode]
 kcps -- grain frequency in Hz. 
 kphs -- grain phase. This is the location in the grain waveform table, expressed as a fraction (between 0 to 1) of the table length. 
 kfmd -- random variation (bipolar) in grain frequency in Hz.  
 kpmd -- random variation (bipolar) in start phase.
 kgdur -- grain duration in seconds. kgdur also controls the duration of already active grains (actually the speed at which the window function is read). This behavior does not depend on the imode flags.  
 kdens -- number of grains per second. 
 kfrpow -- this value controls the distribution of grain frequency variation. If kfrpow is positive, the random distribution (x is in the range -1 to 1) is 
 kprpow -- distribution of random phase variation (see kfrpow). Setting kphs and kpmd to 0.5, and kprpow to 0 will emulate grain2. 
 kfn -- function table containing grain waveform. Table number can be changed at k-rate (this is useful to select from a set of band-limited tables generated by GEN30, to avoid aliasing). 
*/
;;;a1	grain3	kfrq, kphs, kfmd, 0.02, kgdur, kdens, 100,		\
a1	grain3	kfrq, kphs, kfmd, kfmd, kgdur, kdens, 100,		\
		kfnum, 1, -0.5, 0, iseed, 2

	out kamp * a1
	endin

	instr 777
kdur	= k(p3)
idur    = p3
kamp	= gkAmp
kfrq	= gkFreq
kfmd	=  kfrq * gkFreqRand		; random variation in frequency
kgdur	=  gkDur		; grain duration
kdens	=  gkDens		; density
iseed	=  1			; random seed
kfnum     = k(p6)
;kphs1	linen 1, idur, idur, 0
kphsL	linen 1, idur, idur, 0
kphs1	oscili 0.001, 1/30, 4	; phase
akPhase butterlp  a(gkPhase), 10
kkPhase downsamp akPhase
kphs = gkPhaseMix*(kkPhase +  kphs1) + (1 - gkPhaseMix)*(kphsL)
kphs limit kphs, 0, 1
printks "gkAmp = %f, gkFreq = %f, gkFreqRand = %f, gkDens = %f, gkDur = %f, gkPhase = %f, gkPhaseMix = %f\\n", 1, gkAmp, gkFreq, gkFreqRand, gkDens, gkDur, gkPhase, gkPhaseMix
/* Syntax

ares grain3 kcps, kphs, kfmd, kpmd, kgdur, kdens, imaxovr, kfn, iwfn, \
      kfrpow, kprpow [, iseed] [, imode]
 kcps -- grain frequency in Hz. 
 kphs -- grain phase. This is the location in the grain waveform table, expressed as a fraction (between 0 to 1) of the table length. 
 kfmd -- random variation (bipolar) in grain frequency in Hz.  
 kpmd -- random variation (bipolar) in start phase.
 kgdur -- grain duration in seconds. kgdur also controls the duration of already active grains (actually the speed at which the window function is read). This behavior does not depend on the imode flags.  
 kdens -- number of grains per second. 
 kfrpow -- this value controls the distribution of grain frequency variation. If kfrpow is positive, the random distribution (x is in the range -1 to 1) is 
 kprpow -- distribution of random phase variation (see kfrpow). Setting kphs and kpmd to 0.5, and kprpow to 0 will emulate grain2. 
 kfn -- function table containing grain waveform. Table number can be changed at k-rate (this is useful to select from a set of band-limited tables generated by GEN30, to avoid aliasing). 
*/
;;;a1	grain3	kfrq, kphs, kfmd, 0.02, kgdur, kdens, 100,		\
a1	grain3	kfrq, kphs, kfmd, kfmd, kgdur, kdens, 601,		\
		kfnum, 1, -0.5, 0, iseed, 2

	out kamp * a1
	endin



</CsInstruments>
<CsScore>

t 0 60
;i 777 0 3600  1000   0.00236570835113525390 888
;i 777 0 3600  1000   0.00236570835113525390 999
;i 777 0 3600  1000   0.00236570835113525390 555
;i 777 0 3600  1000   0.00236570835113525390 444
;i 777 0 3600  1000   0.00236570835113525390 555

;i 777 0 3600  1000   0.00236570835113525390 555
;i 777 0 3600  1000   0.00236570835113525390 888

;i 777 0 3600  1000   0.00236570835113525390 777

i 777 0 3600  1000   0.00236570835113525390 999

;i 1 0 3
;i 2 4 3
;i 3 8 3
; yes 2018 seconds
;i 666 0 2018 1000   0.002628564834  888
;i 666 0 2018 1000   0.001314282417  888
; achieved by 1/(tablelength/sr) * 9/10
;i 666 0 2018  700   0.00206570835113525390 888
;i 666 0 2018  800   0.00216570835113525390 888
;i 666 0 2018  900   0.00226570835113525390 888
;i 666 0 2018  900   0.00246570835113525390 888
;i 666 0 2018  800   0.00256570835113525390 888
;i 666 0 2018  700   0.00266570835113525390 888
;i 666 0 2018  600   0.00276570835113525390 888
;i 666 0 2018  500   0.00286570835113525390 888
;i 666 0 2018  400   0.00296570835113525390 888
;i 666 0 4096  1000   0.00236570835113525390 888
;i 666 0 8192  1000   0.00236570835113525390 888
; too slow..
;i 666 0 2018  1000  0.002102851867  888
;i 666 0 2018 1000   0.001752376556  888
;i 666 0 2018 10000   0.125 888

;i 666 0 3   10000  0.5 777
;i 666 4 6   10000  0.5 777
;i 666 11 9  10000  0.5 777
;i 666 20 18 10000  0.5 777
;i 666 39 80 10000  0.5 777
;i 666 121 160 10000  0.5 777

;e


</CsScore>
</CsoundSynthesizer>
