<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
; -L stdin -odac           -iadc     -dm6    ;;;RT audio I/O
 -odac           -iadc     -dm6  -+rtaudio=jack -+jack_client=csoundGrain  -b 1024 -B 2048   ;;;RT audio I/O
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
;kr      =  100
ksmps   =  1
nchnls	=  1

maxalloc 556, 100; Limit to three instances.

/* f#  time  size  1  filcod  skiptime  format  channel */
giImpulse01     ftgen   101, 0, 16777216, 1, "palette/01.wav", 0, 0, 0	
giImpulse02     ftgen   102, 0, 16777216, 1, "palette/02.wav", 0, 0, 0	
giImpulse03     ftgen   103, 0, 16777216, 1, "palette/03.wav", 0, 0, 0	
giImpulse04     ftgen   104, 0, 16777216, 1, "palette/04.wav", 0, 0, 0	
giImpulse05     ftgen   105, 0, 16777216, 1, "palette/05.wav", 0, 0, 0	
giImpulse06     ftgen   106, 0, 16777216, 1, "palette/06.wav", 0, 0, 0	
giImpulse07     ftgen   107, 0, 16777216, 1, "palette/07.wav", 0, 0, 0	
giImpulse08     ftgen   108, 0, 16777216, 1, "palette/08.wav", 0, 0, 0	
giImpulse09     ftgen   109, 0, 16777216, 1, "palette/09.wav", 0, 0, 0	
giImpulse10     ftgen   110, 0, 16777216, 1, "palette/10.wav", 0, 0, 0	
; csound has some memory leak so having a final junk table prevents a crash
; it is sorta pathetic :(
giImpulse11     ftgen   111, 0, 16777216, 1, "palette/10.wav", 0, 0, 0	


gkFreq init 1
gkFreqRand init 0.001
gkAmp init 1000
gkDens init 20
gkDur init 0.1
gkPhase init 0
gkPhaseMix init 1

giEXP = -1
giLINEAR = 0

FLcolor	180,200,199
FLpanel 	"Granular",505,310
    istarttim = 0
    idropi = 666
    idur = 1
    ibox0  FLbox  "Grain", 1, 6, 12, 300, 20, 0, 0
    ;FLsetFont   7, ibox0
                
;    gkFreq,    iknob1 FLknob  "Freq", 0.00001, 2, -1,1, -1, 50, 0,0
    gkFreq,    iknob1 FLknob  "Freq", 0.01, 5, giLINEAR ,1, -1, 50, 0,0
    gkFreqRand,    iknob2 FLknob  "FreqRand", 0.00001, 0.1, -1,1, -1, 50, 50,0
    gkAmp,    iknob3 FLknob  "Amp", 0.0001, 10000, -1,1, -1, 50, 100,0
    gkDens,    iknob4 FLknob  "Dens", 1, 300, -1,1, -1, 50, 150,0
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
    FLsetVal_i   20, iknob4
    FLsetVal_i   0.1, iknob5
    FLsetVal_i   0.0, islider1
    FLsetVal_i   1.0, iknob6

    gkIComp01,     gicompslider01 FLslider "01", 0, 1, 0, 1, -1, 250, 30, 255, (0)
    gkIComp02,     gicompslider02 FLslider "02", 0, 1, 0, 1, -1, 250, 30, 255, (30)
    gkIComp03,     gicompslider03 FLslider "03", 0, 1, 0, 1, -1, 250, 30, 255, (60)
    gkIComp04,     gicompslider04 FLslider "04", 0, 1, 0, 1, -1, 250, 30, 255, (90)
    gkIComp05,     gicompslider05 FLslider "05", 0, 1, 0, 1, -1, 250, 30, 255, (120)
    gkIComp06,     gicompslider06 FLslider "06", 0, 1, 0, 1, -1, 250, 30, 255, (150)
    gkIComp07,     gicompslider07 FLslider "07", 0, 1, 0, 1, -1, 250, 30, 255, (180)
    gkIComp08,     gicompslider08 FLslider "08", 0, 1, 0, 1, -1, 250, 30, 255, (210)
    gkIComp09,     gicompslider09 FLslider "09", 0, 1, 0, 1, -1, 250, 30, 255, (240)
    gkIComp10,     gicompslider10 FLslider "10", 0, 1, 0, 1, -1, 250, 30, 255, (270)
    ion = 0
    ioff = 0
    ix = 0
    iy = 150
    iopcode = 0 ; i 
    gkrandbutton,  ibutton FLbutton "Randomize", ion, ioff, 1, 50, 50, ix, iy, iopcode, 400, 0, 1


    
FLpanel_end	;***** end of container

FLrun		;***** runs the widget thread 





/* Bartlett window */
itmp	ftgen 1, 0, 16384, 20, 3, 1
/* sawtooth wave */
itmp	ftgen 2, 0, 16384, 7, 1, 16384, -1
/* sine */
itmp	ftgen 4, 0, 1024, 10, 1

; randomize the sliders and thus change the distribution
instr 400
      FLsetVal_i  rnd(1.0),gicompslider01
      FLsetVal_i  rnd(1.0),gicompslider02
      FLsetVal_i  rnd(1.0),gicompslider03
      FLsetVal_i  rnd(1.0),gicompslider04
      FLsetVal_i  rnd(1.0),gicompslider05
      FLsetVal_i  rnd(1.0),gicompslider06
      FLsetVal_i  rnd(1.0),gicompslider07
      FLsetVal_i  rnd(1.0),gicompslider08
      FLsetVal_i  rnd(1.0),gicompslider09
      FLsetVal_i  rnd(1.0),gicompslider10
      turnoff
endin



; the generator part II
        instr 550
        idur = p3
;         kRate  = gkDens
; kTrig   metro  kRate      ; a trigger to generate grains
;         kDur = gkDur
; kfrnd   rand gkFreqRand
; kForm   limit (gkFreq + gkFreq * kfrnd), 0, 100
; 
;         ; work out the     phase and mixing time
; kphsL	linen 1, idur, idur, 0
; kphs1	oscili 0.001, 1/30, 4	; phase
; akPhase butterlp  a(gkPhase), 10
; kkPhase downsamp akPhase
;         kphs = gkPhaseMix*(kkPhase +  kphs1) + (1 - gkPhaseMix)*(kphsL)
; kphs    limit kphs, 0, 1
; 
  kdur	= k(p3)
  idur    = p3
  kamp	= gkAmp
  kfrq  = (gkFreq / (16777216 / 44100))       
  kfmd	=  kfrq * gkFreqRand		; random variation in frequency
  kgdur	=  gkDur		; grain duration
  kdens	=  gkDens		; density
  iseed	=  1			; random seed

;kphs1	linen 1, idur, idur, 0
kphsL	linen 1, idur, idur, 0
kphs1	oscili 0.001, 1/30, 4	; phase
akPhase butterlp  a(gkPhase), 10
kkPhase downsamp akPhase
kphs = gkPhaseMix*(kkPhase +  kphs1) + (1 - gkPhaseMix)*(kphsL)
kphs limit kphs, 0, 1


     ; now I know this looks complicated but really it is just 
     ; choosing which table to play from 
     ; given a random value
      kfnum = 101
      ksum = gkIComp01 + gkIComp02 + gkIComp03 + gkIComp04 + gkIComp05 + gkIComp06 + gkIComp07 + gkIComp08 + gkIComp09 + gkIComp10 
      krnd = rnd(ksum)
      kacc = gkIComp01
      if (krnd > kacc) then
         kfnum = 102
      endif
      kacc = kacc + gkIComp02        
      if (krnd > kacc) then
         kfnum = 103
      endif
      kacc = kacc + gkIComp03       
      if (krnd > kacc) then
         kfnum = 104
      endif
      kacc = kacc + gkIComp04        
      if (krnd > kacc) then
         kfnum = 105
      endif
      kacc = kacc + gkIComp05        
      if (krnd > kacc) then
         kfnum = 106
      endif
      kacc = kacc + gkIComp07        
      if (krnd > kacc) then
         kfnum = 107
      endif
      kacc = kacc + gkIComp07        
      if (krnd > kacc) then
         kfnum = 108
      endif
      kacc = kacc + gkIComp08
      if (krnd > kacc) then
         kfnum = 109
      endif
      kacc = kacc + gkIComp09
      if (krnd > kacc) then
         kfnum = 110
      endif


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

printks "%5.1f Rate:%5.2F  Dur:%5.2F  Formant:%5.5F%n", 0.5, kfnum, kdens , kgdur, kfrq


a1	grain3	kfrq, kphs, kfmd, kfmd, kgdur, kdens, 601,		\
		kfnum, 1, -0.5, 0, iseed, 2

	out kamp * a1

endin






  





; the generator
        instr 555
        idur = p3
        ;  kRate  expon  p4,p3,p5   ; rate of grain generation
  ; fuzz?
  kRate  = gkDens
  kTrig  metro  kRate      ; a trigger to generate grains
  ;  kDur   expon  p6,p3,p7   ; grain duration
  ; fuzz?
  kDur = gkDur
  ;  kForm  expon  p8,p3,p9   ; formant (spectral centroid)
  ; fuzz?
  kfrnd rand gkFreqRand
  kForm limit (gkFreq + gkFreq * kfrnd), 0, 100
  ;trigger a note(grain) in instr 556
  ;                       p1, p2,   p3,          p4,    p5,  p6,p7,p8,p9,p10,
  ;  kphs	linen 1, idur, idur, 0

  ; copied phase..
  kphsL	linen 1, idur, idur, 0
  kphs1	oscili 0.001, 1/30, 4	; phase
  akPhase butterlp  a(gkPhase), 10
  kkPhase downsamp akPhase
  kphs = gkPhaseMix*(kkPhase +  kphs1) + (1 - gkPhaseMix)*(kphsL)
  kphs limit kphs, 0, 1
  

;  schedkwhen    kTrig,0,0,556, 0, kDur,gkAmp/kRate, kForm,kphs, 0, 0, 0,  0,gkIComp01,gkIComp02,gkIComp03,gkIComp04,gkIComp05,gkIComp06,gkIComp07,gkIComp08,gkIComp09,gkIComp10  
  schedkwhen    kTrig,0,0,556, 0, kDur,       gkAmp, kForm,kphs + kfrnd, 0, 0, 0,  0,gkIComp01,gkIComp02,gkIComp03,gkIComp04,gkIComp05,gkIComp06,gkIComp07,gkIComp08,gkIComp09,gkIComp10  
  ;print data to terminal every 1/2 second
  printks "Rate:%5.2F  Dur:%5.2F  Formant:%5.5F%n", 0.5, kRate , kDur, kForm
        endin


; the grain
        instr 556
        idur = p3
        iamp = p4
        ipitch = (p5 / (16777216 / 44100)) ; 16 1.352e-12 ; 2 is 2X 0.5 is 1/2
        iphase = p6
        ;;; padding 
        iother2 = p7
        iother3 = p8
        iother4 = p9
        iother5 = p10
        ;;;; component stuff
        iamp01 =  p11
        iamp02 =  p12
        iamp03 =  p13
        iamp04 =  p14
        iamp05 =  p15
        iamp06 =  p16
        iamp07 =  p17
        iamp08 =  p18
        iamp09 =  p19
        iamp10 =  p20
aenv    oscili iamp, 1/idur, 1        
aa01     poscil iamp01, ipitch, 101, iphase
aa02     poscil iamp02, ipitch, 102, iphase
aa03     poscil iamp03, ipitch, 103, iphase
aa04     poscil iamp04, ipitch, 104, iphase
aa05     poscil iamp05, ipitch, 105, iphase
aa06     poscil iamp06, ipitch, 106, iphase
aa07     poscil iamp07, ipitch, 107, iphase
aa08     poscil iamp08, ipitch, 108, iphase
aa09     poscil iamp09, ipitch, 109, iphase
aa10     poscil iamp10, ipitch, 110, iphase
        out aenv*(aa01+aa02+aa03+aa04+aa05+aa06+aa07+aa08+aa09+aa10)
;         out aenv*(aa01+aa02+aa03+aa04+aa05)
;         out aenv*aa10

        endin



        instr 557
        idur = p3
        iamp = p4
        ipitch = p5 * (1.0 / (16777216 / 44100)) ; 16 1.352e-12 ; 2 is 2X 0.5 is 1/2
        iphase = p6
aa      oscili iamp, ipitch, 101, iphase
        out aa
        endin

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
; i 777 0 3600  1000   0.00236570835113525390 888 
f 0 3600

i 555 0 3600

;i 550 0 3600  1000   0.00236570835113525390 888 



; i556 0 1 1000 1.0 0.5 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
; i556 0 6 10000 1.0 0.5 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
; i556 0 6 1000 1.0 0.5 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
; 
; i556 0 6 10000 1.0 0.5 0.0 0.0 0.0 0.0 1.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0 0.0 0.0
; 
; i557 0 6 1000 1.0 0.5
;e


</CsScore>
</CsoundSynthesizer>
