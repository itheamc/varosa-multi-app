import '../flavor/configuration/development_configuration.dart';
import '../flavor/configuration/production_configuration.dart';
import '../flavor/configuration/staging_configuration.dart';

import 'flavor.dart';

abstract class Configuration {
  /// The max allowed age duration for the http cache
  final Duration maxCacheAge;

  /// Key used in dio options to indicate whether
  /// cache should be force refreshed
  final String dioCacheForceRefreshKey;

  /// HIVE's box name
  final String hiveBoxName;

  /// Base Url
  ///
  final String baseUrl;

  /// Privacy Policy Url
  ///
  final String privacyPolicyUrl;

  /// Api Versions
  final String apiV1 = 'api/v1/';
  final String apiV2 = 'api/v2/';
  final String apiV3 = 'api/v3/';

  /// Getters for api base url
  ///
  String get apiBaseUrlV1 => "$baseUrl$apiV1";

  String get apiBaseUrlV2 => "$baseUrl$apiV2";

  String get apiBaseUrlV3 => "$baseUrl$apiV3";

  String get apiBaseUrl;

  /// Getter for flavor
  ///
  Flavor get flavor;

  /// Constructor
  ///
  const Configuration({
    required this.maxCacheAge,
    required this.dioCacheForceRefreshKey,
    required this.hiveBoxName,
    required this.baseUrl,
    required this.privacyPolicyUrl,
  });

  /// Method to get configuration for different flavour
  ///
  static Configuration of([Flavor? flavor]) {
    flavor ??= Flavor.fromEnvironment;

    return flavor == Flavor.dev
        ? DevelopmentConfiguration.instance
        : flavor == Flavor.staging
            ? StagingConfiguration.instance
            : ProductionConfiguration.instance;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Configuration &&
          runtimeType == other.runtimeType &&
          maxCacheAge == other.maxCacheAge &&
          dioCacheForceRefreshKey == other.dioCacheForceRefreshKey &&
          hiveBoxName == other.hiveBoxName &&
          baseUrl == other.baseUrl &&
          privacyPolicyUrl == other.privacyPolicyUrl;

  @override
  int get hashCode =>
      maxCacheAge.hashCode ^
      dioCacheForceRefreshKey.hashCode ^
      hiveBoxName.hashCode ^
      baseUrl.hashCode ^
      privacyPolicyUrl.hashCode;
}
