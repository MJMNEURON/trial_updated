#include <stdio.h>
#include "hocdec.h"
extern int nrnmpi_myid;
extern int nrn_nobanner_;
modl_reg(){
  if (!nrn_nobanner_) if (nrnmpi_myid < 1) {
    fprintf(stderr, "Additional mechanisms from files\n");

    fprintf(stderr," ITGHK.mod");
    fprintf(stderr," Ican.mod");
    fprintf(stderr," ampa.mod");
    fprintf(stderr," cadmerged.mod");
    fprintf(stderr," hh2.mod");
    fprintf(stderr," iahp.mod");
    fprintf(stderr," iar.mod");
    fprintf(stderr," ical.mod");
    fprintf(stderr, "\n");
  }
  _ITGHK_reg();
  _Ican_reg();
  _ampa_reg();
  _cadmerged_reg();
  _hh2_reg();
  _iahp_reg();
  _iar_reg();
  _ical_reg();
}
