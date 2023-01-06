class Calc {
  static double getTotalNetComputedLoad(double floorArea, int bcSAL, int bcLL, int bcBL) {
    double glrcl = floorArea * 24;
    int tSAL = bcSAL * 1500;
    int tLL = bcLL * 1500;
    int tBL = bcBL * 1500;
    double tot = glrcl + tSAL + tLL + tBL;
    double ntl;
    double tncl;

    if (tot >= 3000) {
      ntl = 3000 + (tot - 3000) * 0.35;
    } else {
      ntl = 3000 + (120000 - 3000) * 0.35 + (tot - 120000) * 0.25;
    }

    ntl = ntl.roundToDouble();

    if (floorArea > 150) {
      double others = (tLL+ tSAL + tBL)*0.40;
      tncl = glrcl + others;
    } else {
      tncl = ntl;
    }

    return tncl;
  }

  static double getIFLC(double tncl, int v) => tncl / v;

  static double getAdjustedIFLC(double iflc, double sFactor) => iflc*sFactor;
}