class Calc {
  static double getTotalNetComputedLoad(double floorArea, int bcSAL, int bcLL, int bcBL) {
    double glrcl = getGLRCL(floorArea);
    double tSAL = getTotalSmallApplianceLoad(bcSAL);
    double tLL = getTotalLaundryLoad(bcLL);
    double tBL = getTotalBathroomLoad(bcBL);
    double tot = glrcl + tSAL + tLL + tBL;
    double ntl;
    double tncl;

    ntl = getTotalWithDemandFactor(tot);

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
  static double getGLRCL(double floorArea) => floorArea * 24;
  static double getTotalSmallApplianceLoad(int bcSAL) => bcSAL * 1500;
  static double getTotalLaundryLoad(int bcLL) => bcLL * 1500;
  static double getTotalBathroomLoad(int bcBL) => bcBL * 1500;
  static double getTotalWithDemandFactor(double tot) {
    double ntl;
    if (tot >= 3000) {
      ntl = 3000 + (tot - 3000) * 0.35;
    } else {
      ntl = 3000 + (120000 - 3000) * 0.35 + (tot - 120000) * 0.25;
    }
    return ntl.roundToDouble();
  }

}