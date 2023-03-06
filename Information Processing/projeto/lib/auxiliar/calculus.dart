import 'dart:math';

import 'package:projeto/auxiliar/person.dart';

class Calculus {
  static var rng = Random();

  static int meditation() {
    return (rng.nextDouble() < 3648 / 15972 ? 0 : 1);
  }

  static double sleepHours() {
    double p, p1, p2;
    do {
      p1 = -1 + 2 * rng.nextDouble();
      p2 = -1 + 2 * rng.nextDouble();
      p = (p1 * p1) + (p2 * p2);
    } while (p >= 1);
    return (7.04 + 1.2 * p1 * sqrt(-2 * log(p) / p));
  }

  static double inverseRayleigh(double a, double b) {
    return (a + (b * sqrt(-1 * log(rng.nextDouble()))));
  }

  static double coreCircle() {
    return inverseRayleigh(0, 5);
  }

  static double flowState() {
    return inverseRayleigh(0, 113 / 50);
  }

  static inverseExponential(double k) {
    return (-k * log(rng.nextDouble()));
  }

  static double timeForPassion() {
    return inverseExponential(10 / 3);
  }

  static double socialNetwork() {
    return inverseExponential(162 / 25);
  }

  static int classOfAge() {
    double rand = rng.nextDouble();
    if (rand < 1 / 8) {
      return 1;
    } else if (rand < 1 / 2) {
      return 2;
    } else if (rand < 39 / 58) {
      return 3;
    } else {
      return 4;
    }
  }

  static int classOfSteps() {
    double rand = rng.nextDouble();
    if (rand < 0.08) {
      return 1;
    } else if (rand < 0.17) {
      return 2;
    } else if (rand < 0.27) {
      return 3;
    } else if (rand < 0.37) {
      return 4;
    } else if (rand < 0.5) {
      return 5;
    } else if (rand < 0.6) {
      return 6;
    } else if (rand < 0.69) {
      return 7;
    } else if (rand < 0.79) {
      return 8;
    } else if (rand < 0.83) {
      return 9;
    } else {
      return 10;
    }
  }

  static double groupProductivityAverage(List<Person> lp) {
    double p = 0;
    for (Person prs in lp) {
      prs.setFactors();
      p += prs.personProductivity();
    }
    return p / lp.length;
  }

  static double weibullVariation(double x, double b, double c) {
    return 1 * x * exp(-pow(x / b, c));
  }

  static double normalizedWeibullVariation(double x, double b, double c) {
    return weibullVariation(x, b, c) /
        weibullVariation(b / pow(c, 1 / c), b, c);
  }

  static double auxLn(double x) {
    //CONFIRMAR NAS FORMULAS
    return 17 * log((x / 3) + exp(-4 / 17)) + 4;
  }

  static double auxExpVariation(double x) {
    return 15 - exp(-0.9 * x - 2.708);
  }

  static getAgeOfClass(int classOfAge) {
    int? clss;
    if (classOfAge == 1) {
      clss = 16 + rng.nextInt(5);
    } else if (classOfAge == 2) {
      clss = 21 + rng.nextInt(15);
    } else if (classOfAge == 2) {
      clss = 36 + rng.nextInt(15);
    } else {
      clss = 50 + rng.nextInt(21);
    }
    return clss;
  }
}
