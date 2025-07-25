import 'package:dartx/dartx.dart';
import 'package:phamarcy_system/cubits/app/app_cubit.dart';
import 'package:phamarcy_system/widgets/presentation/menu/app_menu.dart';
import 'package:phamarcy_system/widgets/presentation/resources/app_resources.dart';
import 'package:phamarcy_system/widgets/presentation/widgets/download_native_app_button.dart';
import 'package:phamarcy_system/urls.dart';
import 'package:phamarcy_system/widgets/util/app_helper.dart';
import 'package:phamarcy_system/widgets/util/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'chart_samples_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.showingChartType}) {
    _initMenuItems();
  }

  void _initMenuItems() {
    _menuItemsIndices = {};
    _menuItems = ChartType.values.mapIndexed((int index, ChartType type) {
      _menuItemsIndices[type] = index;
      return ChartMenuItem(type, type.displayName, type.assetIcon);
    }).toList();
  }

  final ChartType showingChartType;
  late final Map<ChartType, int> _menuItemsIndices;
  late final List<ChartMenuItem> _menuItems;

  @override
  Widget build(BuildContext context) {
    final selectedMenuIndex = _menuItemsIndices[showingChartType]!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final needsDrawer =
            constraints.maxWidth <=
            AppDimens.menuMaxNeededWidth + AppDimens.chartBoxMinWidth;
        final appMenuWidget = AppMenu(
          menuItems: _menuItems,
          currentSelectedIndex: selectedMenuIndex,
          onItemSelected: (newIndex, chartMenuItem) {
            context.go('/${chartMenuItem.chartType.name}');
            if (needsDrawer) {
              /// to close the drawer
              Navigator.of(context).pop();
            }
          },
          onBannerClicked: () => AppUtils().tryToLaunchUrl(Urls.flChartUrl),
        );
        final samplesSectionWidget = ChartSamplesPage(
          chartType: showingChartType,
        );
        final body = needsDrawer
            ? samplesSectionWidget
            : Row(
                children: [
                  SizedBox(
                    width: AppDimens.menuMaxNeededWidth,
                    child: appMenuWidget,
                  ),
                  Expanded(child: samplesSectionWidget),
                ],
              );

        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  body,
                  if (state.showDownloadNativeAppButton)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: DownloadNativeAppButton(
                          onClose: () => context
                              .read<AppCubit>()
                              .hideDownloadNativeAppButton(),
                          onDownload: () =>
                              AppUtils().tryToLaunchUrl(Urls.downloadUrl),
                        ),
                      ),
                    ),
                ],
              ),
              drawer: needsDrawer ? Drawer(child: appMenuWidget) : null,
              appBar: needsDrawer
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Text(showingChartType.displayName),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
