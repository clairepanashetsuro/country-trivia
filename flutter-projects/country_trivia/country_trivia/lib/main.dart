import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'app.dart';
import 'data/services/api_service.dart';
import 'data/services/game_state_repository.dart';
import 'viewmodels/game_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // HTTP client
        Provider<Dio>(
          create: (_) => Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          ),
        ),

        // Country API service
        Provider<CountryApiService>(
          create: (context) => CountryApiServiceImpl(context.read<Dio>()),
        ),

        // Game state repository
        Provider<GameStateRepository>(
          create: (_) => GameStateRepositoryImpl(),
        ),

        // ViewModel
        ChangeNotifierProvider<GameViewModel>(
          create: (context) => GameViewModel(
            countryApi: context.read<CountryApiService>(),
            gameStateRepo: context.read<GameStateRepository>(),
          )..initialize(),
        ),
      ],
      child: const CountryTriviaApp(),
    ),
  );
}
