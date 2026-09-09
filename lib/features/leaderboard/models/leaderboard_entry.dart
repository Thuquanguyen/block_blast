/// A single row on the global leaderboard.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.uid,
    required this.nickname,
    required this.score,
  });

  final String uid;
  final String nickname;
  final int score;
}
