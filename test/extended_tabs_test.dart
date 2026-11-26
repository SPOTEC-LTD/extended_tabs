import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('Material controller keeps tab taps and page swipes in sync', (
    tester,
  ) async {
    final controller = TabController(length: 2, vsync: tester);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ExtendedTabBar(
                controller: controller,
                tabs: const [
                  ExtendedTab(text: 'One'),
                  ExtendedTab(text: 'Two'),
                ],
              ),
              Expanded(
                child: ExtendedTabBarView(
                  controller: controller,
                  children: const [
                    Center(child: Text('First page')),
                    Center(child: Text('Second page')),
                  ],
                ),
              ),
              CarouselIndicator(controller: controller),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();
    expect(controller.index, 1);
    expect(find.text('Second page').hitTestable(), findsOneWidget);

    await tester.fling(
      find.byType(ExtendedTabBarView),
      const Offset(500, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(controller.index, 0);
    expect(find.text('First page').hitTestable(), findsOneWidget);
  });
}
