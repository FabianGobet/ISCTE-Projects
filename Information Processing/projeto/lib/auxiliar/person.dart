import 'dart:math';

import 'package:projeto/auxiliar/calculus.dart';

class Person {
  late int meditation, classOfAge, classOfSteps, Age;
  late double sleepHours, timeForPassion, socialNetwork;
  late double coreCircleF,
      dailyStepsF,
      flowStateF,
      timeForPassionF,
      coreCircle,
      flowState; //timeForPassionF, flowStateF, stepsF, ageF;

  Person() {
    meditation = Calculus.meditation();
    sleepHours = Calculus.sleepHours();
    coreCircle = Calculus.coreCircle();
    flowState = Calculus.flowState();
    timeForPassion = Calculus.timeForPassion();
    socialNetwork = Calculus.socialNetwork();
    classOfAge = Calculus.classOfAge();
    Age = Calculus.getAgeOfClass(classOfAge);
    classOfSteps = Calculus.classOfSteps();
  }

  void setFactors() {
    coreCircleF = coreCircleFactor();
    dailyStepsF = stepsFactor();
    timeForPassionF = timeForPassionFactor();
    flowStateF = flowStateFactor();
  }

  double personProductivity() {
    return (sleepHoursFactor() * 0.114 +
            coreCircleF * 0.224 +
            meditation * 0.099 +
            timeForPassionF * 0.274 +
            flowStateFactor() * 0.301 +
            dailyStepsF * 0.2 +
            ageFactor() * 0.104 +
            socialNetworkFactor() * 0.204) *
        (100 / 1.52);
  }

  double coreCircleFactor() {
    double f = exp(-pow((coreCircle < 0 ? 0 : coreCircle) - 3, 2) / 3.5);
    //print("Core Circle: $coreCircle , f: $f");
    return f;
  }

  double sleepHoursFactor() {
    double f = exp(-0.3 * pow((sleepHours < 0 ? 0 : sleepHours) - 7.5, 2));
    //print("Sleep Hours: $sleepHours, f: $f");
    return (f + 0.088 * meditation) / 1.088;
  }

  double flowStateFactor() {
    double f = Calculus.auxLn(
            ((flowState < 0 ? 0 : (flowState > 10 ? 10 : flowState))) / 3) /
        Calculus.auxLn(10);
    double result = (f + 0.483 * timeForPassionF + 0.144 * dailyStepsF) / 1.627;
    //print("Flow State: $flowState , f: $result");
    return result;
  }

  double timeForPassionFactor() {
    double f =
        Calculus.auxExpVariation(timeForPassion < 0 ? 0 : timeForPassion) /
            Calculus.auxExpVariation(10);
    double result = (f + 0.228 * coreCircleF) / 1.228;
    //print("Time for Passion: $timeForPassion , f: $result");
    return result;
  }

  double socialNetworkFactor() {
    double f = Calculus.normalizedWeibullVariation(
        socialNetwork < 0 ? 0 : socialNetwork, 2, 2);
    double result =
        (f + 0.309 * coreCircleF + 0.245 * flowStateF + 0.216 * dailyStepsF) /
            1.77;
    //print("Social Network: $socialNetwork , f: $result");
    //print(
    //    "---------------------------------------------------------------------------");
    return result;
  }

  double ageFactor() {
    double f = Calculus.normalizedWeibullVariation(Age + 4, 35, 11 / 10);
    //print("Age: $classOfAge , $Age , f: $f");
    return f;
  }

  double stepsFactor() {
    double f = 1 / (1 + exp(-0.6 * (classOfSteps < 0 ? 0 : classOfSteps)));
    //print("Steps: $classOfSteps , f: $result");
    return f;
  }
}
