import 'package:talker_flutter/talker_flutter.dart';

/// Global logger instance (Talker).
///
/// Usable anywhere: `talker.info('...')`, `talker.error(e)`.
/// Talker automatically logs Dio traffic in debug builds via
/// [TalkerDioLogger] registered in [ApiClient].
final Talker talker = TalkerFlutter.init();
