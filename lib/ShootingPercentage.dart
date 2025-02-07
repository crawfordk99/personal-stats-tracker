class ShootingPercentage {
  static double calculateShootingPercentage(int fgm, int fga) {
    double percentage = fgm.toDouble() / fga;
    return percentage;
  }
}