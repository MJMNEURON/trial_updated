NEURON {
        POINT_PROCESS AMPA
	POINTER pre          
        RANGE R, gmax, g, ina     
        USEION na WRITE ina   
        NONSPECIFIC_CURRENT  iglu             : i
        GLOBAL Cdur, Alpha, Beta, Erev, Rinf, Rtau
}
UNITS {
        (nA) = (nanoamp)
        (mV) = (millivolt)
        (umho) = (micromho)
        (mM) = (milli/liter)
}

PARAMETER {
        Cmax        = 1        (mM)                : max transmitter concentration
:        Cdur        = 0.3        (ms)                : transmitter duration (rising phase)
        Cdur        = 1.1        (ms)                : transmitter duration (rising phase)
:        Alpha        = 0.94        (/ms)        : forward (binding) rate
        Alpha        = 10        (/ms)        : forward (binding) rate
:        Beta        = 0.18        (/ms)                : backward (unbinding) rate
        Beta        = 0.5        (/ms)                : backward (unbinding) rate
        Erev        = 0        (mV)                :0 reversal potential
}


ASSIGNED {
        v                (mV)                : postsynaptic voltage
        iglu                 (nA)                : current = g*(v - Erev)     :i
        g                 (umho)                : conductance
        Rinf                                : steady state channels open
        Rtau                (ms)                : time constant of channel binding
        synon
        gmax
	pre
        ina
        ica
}

STATE {Ron Roff}

INITIAL {
        Rinf = Cmax*Alpha / (Cmax*Alpha + Beta)
               Rtau = 1 / ((Alpha * Cmax) + Beta)
        synon = 0
}

BREAKPOINT {
        SOLVE release METHOD cnexp
        g = (Ron + Roff)*1(umho)
        iglu = g*(v - Erev)  :i
        ina = 0.9*iglu
        iglu = 0.1*iglu

}

DERIVATIVE release {
        Ron' = (synon*Rinf - Ron)/Rtau
        Roff' = -Beta*Roff
}


: following supports both saturation from single input and
: summation from multiple inputs
: if spike occurs during CDur then new off time is t + CDur
: ie. transmitter concatenates but does not summate
: Note: automatic initialization of all reference args to 0 except first

NET_RECEIVE(weight, on, nspike, r0, t0 (ms)) {
        : flag is an implicit argument of NET_RECEIVE and  normally 0
        if (flag == 0) { : a spike, so turn on if not already in a Cdur pulse
                nspike = nspike + 1
                if (!on) {
                        r0 = r0*exp(-Beta*(t - t0))
                        t0 = t
                        on = 1
                        synon = synon + weight
                        state_discontinuity(Ron, Ron + r0)
                        state_discontinuity(Roff, Roff - r0)
                }
                : come again in Cdur with flag = current value of nspike
                net_send(Cdur, nspike)
        }
        if (flag == nspike) { : if this associated with last spike then turn off
                r0 = weight*Rinf + (r0 - weight*Rinf)*exp(-(t - t0)/Rtau)
                t0 = t
                synon = synon - weight
                state_discontinuity(Ron, Ron - r0)
                state_discontinuity(Roff, Roff + r0)
                on = 0
        }
gmax=weight
}
