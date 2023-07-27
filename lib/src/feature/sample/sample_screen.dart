import 'package:flutter/material.dart';
import 'package:gravity_group_techquest/src/core/utils/extensions/context_extension.dart';
import 'package:gravity_group_techquest/src/feature/counter/controller/counting_controller.dart';
import 'package:gravity_group_techquest/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:gravity_group_techquest/src/feature/settings/widget/settings_scope.dart';
import 'package:gravity_group_techquest/src/feature/weather/controller/weather_controller.dart';
import 'package:gravity_group_techquest/src/shared/state/operation_state.dart';
import 'package:gravity_group_techquest/src/shared/widget/size_explicit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final $counter = CounterController();
  late final $weather = WeatherController(
    weatherRepository: DependenciesScope.of(context).weatherRepository,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(context.localized.appTitle),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListenableBuilder(
                    listenable: $weather,
                    builder: (context, _) => switch ($weather.state) {
                      OperationState$Successful(:final data) =>
                        Text(data.toString()),
                      OperationState$Error(:final error) =>
                        Text('Error: $error'),
                      OperationState$Processing() =>
                        const CircularProgressIndicator(),
                      _ => const Text('Press the icon to get the weather')
                    },
                  ),
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  ListenableBuilder(
                    listenable: $counter,
                    builder: (context, _) => Text(
                      '${$counter.state}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: $weather.updateWeather,
                          tooltip: 'Update weather',
                          child: const Icon(Icons.cloud),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () => SettingsScope.toggleTheme(context),
                          tooltip: 'Change theme',
                          child: const Icon(Icons.brush),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ListenableBuilder(
                      listenable: $counter,
                      builder: (context, c) => Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ScaleExplicitTransition(
                            isExpanded: !$counter.isMaximum,
                            child: FloatingActionButton(
                              onPressed: $counter.increment,
                              tooltip: 'Increment',
                              child: const Icon(Icons.add),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ScaleExplicitTransition(
                            isExpanded: !$counter.isMinimum,
                            child: FloatingActionButton(
                              onPressed: $counter.decrement,
                              tooltip: 'Decrement',
                              child: const Icon(Icons.remove),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
