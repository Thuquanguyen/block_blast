import '../../../core/constants/app_constants.dart';

class ScoreCalculator {
  ScoreCalculator._();

  /// Base score for clearing [lines] rows/columns in one placement.
  static int calculateLineScore(int lines) {
    if (lines <= 0) return 0;
    final table = AppConstants.lineClearScores;
    if (lines <= table.length) return table[lines - 1];
    final extraLines = lines - table.length;
    return table.last + extraLines * AppConstants.extraLineBonus;
  }

  /// Combo multiplier for the current consecutive-clear streak.
  static double comboMultiplier(int combo) {
    if (combo <= 0) return 1.0;
    final table = AppConstants.comboMultipliers;
    final index = combo - 1;
    return index < table.length ? table[index] : table.last;
  }

  /// Final score gained for a placement that cleared [lines] lines while on
  /// combo streak [combo] (already incremented for this placement).
  static int calculateScore(int lines, int combo) {
    final base = calculateLineScore(lines);
    if (base == 0) return 0;
    return (base * comboMultiplier(combo)).round();
  }
}
