<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
;-odac           -iadc     -d     ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
 -o grain3.wav -W ;;; for file output any platform
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
giImpulse     ftgen   888, 0, 16777216, 1, "videogames.wav", 0, 0, 0	;mono file, duration 40 seconds

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
kfmd	=  kfrq * 0.02		; random variation in frequency
kfmd	=  kfrq * 0.02		; random variation in frequency
kgdur	=  0.2			; grain duration
;kdens	=  200			; density
kdens	=  200			; density
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

/* instr 1: pulse width modulated grains */


</CsInstruments>
<CsScore>

t 0 60
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
i 666 0 2018  1000   0.00236570835113525390 888
i 666 0 2018  900   0.00246570835113525390 888
i 666 0 2018  800   0.00256570835113525390 888
i 666 0 2018  700   0.00266570835113525390 888
i 666 0 2018  600   0.00276570835113525390 888
i 666 0 2018  500   0.00286570835113525390 888
i 666 0 2018  400   0.00296570835113525390 888
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
e


</CsScore>
</CsoundSynthesizer>