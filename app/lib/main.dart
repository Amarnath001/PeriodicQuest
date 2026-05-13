import 'package:flutter/material.dart';

import 'app.dart';
import 'core/audio/element_audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ElementAudioService.instance.init();
  runApp(const PeriodicQuestApp());
}
