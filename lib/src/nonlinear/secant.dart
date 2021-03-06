import 'package:equations/src/common/exceptions.dart';
import 'package:equations/src/common/results.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements the Secant method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is not guaranteed to converge to a root of _f(x)_.
///
///   - The secant method does not require the root to remain bracketed, like
///   the bisection method does for example, so it doesn't always converge.
class Secant extends NonLinear {
  /// The first guess
  final double firstGuess;

  /// The second guess
  final double secondGuess;

  /// Instantiates a new object to find the root of an equation by using the
  /// Secant method. Ideally, the two guesses should be close to the root.
  ///
  ///   - [function]: the function f(x)
  ///   - [firstGuess]: the first interval in which evaluate _f(a)_
  ///   - [secondGuess]: the second interval in which evaluate _f(b)_
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  Secant(String function, this.firstGuess, this.secondGuess,
      {double tolerance = 1.0e-10, int maxSteps = 15})
      : super(function, tolerance, maxSteps);

  @override
  Future<NonlinearResults> solve() async {
    var guesses = <double>[];
    var n = 1;

    var xold = firstGuess;
    var x0 = secondGuess;

    var fold = evaluateOn(xold);
    var fnew = evaluateOn(x0);
    var diff = tolerance + 1;

    while ((diff >= tolerance) && (n < maxSteps)) {
      final den = fnew - fold;
      if (den == 0) {
        throw NonlinearException("Denominator is zero");
      }

      diff = -(fnew * (x0 - xold)) / den;
      xold = x0;
      fold = fnew;
      x0 += diff;

      diff = diff.abs();
      ++n;

      guesses.add(x0);
      fnew = evaluateOn(x0);
    }

    return NonlinearResults(
        guesses, convergence(guesses, maxSteps), efficiency(guesses, maxSteps));
  }
}
