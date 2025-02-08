/* This class will handle calculations for shooting percentages*/
class ShootingPercentage {
  static double calculateShootingPercentage(int fgm, int fga) {
    double? percentage;
    // If the divider is not 0, divide, but if equal to 0, set
    // percentage equal to 0 to prevent NaN
    if (fga > 0){
      percentage = fgm.toDouble() / fga;
    }
    else {
      percentage = 0.0;
    }
    return percentage;
  }
}