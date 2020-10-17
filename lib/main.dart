import 'package:flutter/material.dart';
import 'package:messenger/app/messenger.dart';
import 'package:messenger/config/EnvConfig.dart';
import 'package:messenger/config/flavor_config.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.purple,
      values: FlavorValues(
          //https://medium.com/flutter-community/flutter-ready-to-go-e59873f9d7de#c38c
          mapApiKey: EnvConfig.MAP_API_KEY));
  runApp(Messenger());
}
