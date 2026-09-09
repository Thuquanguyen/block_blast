import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'storage_service.dart';

/// Plays short sound effects from `assets/sounds/`. Real .wav/.mp3 assets
/// still need to be dropped into that folder (see assets/sounds/README.md);
/// until then every call below simply no-ops after logging.
class AudioService {
  AudioService(this._storageService);

  final StorageService _storageService;
  final AudioPlayer _player = AudioPlayer();

  Future<void> _play(String fileName) async {
    if (!_storageService.getSoundEnabled()) return;
    try {
      await _player.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint('AudioService: could not play $fileName ($e)');
    }
  }

  Future<void> playButton() => _play('button.wav');

  Future<void> playBlockDrop() => _play('block_drop.wav');

  Future<void> playLineClear() => _play('line_clear.wav');

  Future<void> playCombo() => _play('combo.wav');

  Future<void> playPerfect() => _play('perfect.wav');

  Future<void> playGameOver() => _play('game_over.wav');
}
