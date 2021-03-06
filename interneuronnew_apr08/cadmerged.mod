TITLE decay of internal calcium concentration
:
: Simple extrusion mechanism for internal calium dynamics
:
: Written by Alain Destexhe, Salk Institute, Nov 12, 1992
: Modified by Geir Halnes, Norwegian Life Science University of Life Sciences, June 2011


INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

NEURON {
	SUFFIX cad
	USEION ca READ ica, cai WRITE cai
	RANGE depth, kt, kd, cainf,taur
}

UNITS {
	(molar) = (1/liter)			: moles do not appear in units
	(mM)	= (millimolar)
	(um)	= (micron)
	(mA)	= (milliamp)
	(msM)	= (ms mM)
}

CONSTANT {
	FARADAY = 96489		(coul)		: moles do not appear in units
:	FARADAY = 96.489	(k-coul)	: moles do not appear in units
}

PARAMETER {
	depth	= .1(um)		: depth of shell
	taur	= 5	(ms)		: Zhu et al. used 2 decay terms w/ taus 80ms and 150ms. 1 term 50 ms gives similar decay. 
	cainf	= 2e-4	(mM)  : Basal Ca-level
:	Cainit  = 5e-5 (mM)	: Initial Ca-level
:      k       = 0.0155458135   (mmol/C cm)  : Phenomenological constant, estimated to give reasonable intracellular calcium concentration
	kt	= 0	(mM/ms)		: dummy
	kd	= 0	(mM)		: dummy
}


STATE {
	cai		(mM) <1e-8> : to have tolerance of .01nM
}


INITIAL {
	cai = cainf
}


ASSIGNED {
	ica		(mA/cm2)
	drive_channel	(mM/ms)
:	drive_pump	(mM/ms)
}

	
BREAKPOINT {
	SOLVE state METHOD euler
}

DERIVATIVE state { 
	:drive_channel =  - k * iCa
	drive_channel =- (10000) * ica / (2 * FARADAY * depth)
	if (drive_channel<=0.) { drive_channel = 0. }: cannot pump inward
	cai' = drive_channel +(cainf-cai)/taur
}