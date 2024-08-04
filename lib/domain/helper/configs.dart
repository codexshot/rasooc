import 'package:rasooc/domain/helper/config.dart';
import 'package:rasooc/domain/helper/constants.dart';

Config devConfig() => Config(
      appName: 'Rasooc [DEV]',
      apiBaseUrl: Constants.devBaseUrl,
      appToken: '',
      apiLogging: true,
      diagnostic: true,
      dummyData: true,
    );
Config stableConfig() => Config(
      appName: 'Rasooc [Stable]',
      apiBaseUrl: Constants.stableBaseUrl,
      appToken: '',
      apiLogging: true,
      diagnostic: true,
    );

Config releaseConfig() => Config(
      appName: 'Rasooc [Release]',
      apiBaseUrl: Constants.prodBaseUrl,
      appToken: '',
    );
