import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'storage_service.dart';

enum GameSound {
  tap('sfx/tap.wav'),
  correct('sfx/correct.wav'),
  wrong('sfx/wrong.wav'),
  levelComplete('sfx/level.wav'),
  hint('sfx/hint.wav'),
  navigate('sfx/navigate.wav');

  const GameSound(this.asset);
  final String asset;
}

class SoundService extends ChangeNotifier {
  SoundService._();
  static final SoundService instance = SoundService._();

  static const _enabledKey = 'unp_sound_enabled';

  bool _enabled = true;
  bool _ready = false;
  final List<AudioPlayer> _pool = [];
  int _next = 0;

  bool get enabled => _enabled;
  bool get isReady => _ready;

  Future<void> init() async {
    if (_ready) return;
    _enabled = await StorageService.instance.getBool(_enabledKey) ?? true;
    for (var i = 0; i < 4; i++) {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release);
      await player.setPlayerMode(PlayerMode.lowLatency);
      _pool.add(player);
    }
    _ready = true;
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;
    _enabled = value;
    await StorageService.instance.saveBool(_enabledKey, value);
    notifyListeners();
  }

  Future<void> toggle() => setEnabled(!_enabled);

  Future<void> play(GameSound sound) async {
    if (!_enabled || !_ready || _pool.isEmpty) return;
    final player = _pool[_next % _pool.length];
    _next++;
    try {
      await player.stop();
      await player.play(AssetSource(sound.asset));
    } catch (e) {
      debugPrint('Sound play failed (${sound.name}): $e');
    }
  }

  void tap() => play(GameSound.tap);
  void correct() => play(GameSound.correct);
  void wrong() => play(GameSound.wrong);
  void levelComplete() => play(GameSound.levelComplete);
  void hint() => play(GameSound.hint);
  void navigate() => play(GameSound.navigate);

  @override
  void dispose() {
    for (final player in _pool) {
      player.dispose();
    }
    super.dispose();
  }
}
