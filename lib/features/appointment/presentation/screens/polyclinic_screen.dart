import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../providers/polyclinic_provider.dart';
import '../../providers/appointment_provider.dart';

class PolyclinicScreen extends ConsumerWidget {
  const PolyclinicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polyclinicsAsync = ref.watch(polyclinicsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.primary,
                  expandedHeight: 120,
                  pinned: true,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: AppColors.textWhite),
                  title: const Text(
                    'Jadwal Poli',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  flexibleSpace: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                    child: FlexibleSpaceBar(
                      background: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Opacity(
                              opacity: 0.4,
                              child: Image.asset(
                                'assets/header_logo.png',
                                width: 220,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: polyclinicsAsync.when(
                    data: (polys) {
                      if (polys.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              'Belum ada jadwal poli',
                              style: TextStyle(color: AppColors.textDark),
                            ),
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final poly = polys[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowColor.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Material(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                    ),
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                      title: Text(
                                        poly.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          poly.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textGrey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          color: AppColors.primaryLight
                                              .withValues(alpha: 0.5),
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Jadwal Praktik:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textDark,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              if (poly.schedules.isEmpty)
                                                const Text(
                                                  'Jadwal belum tersedia',
                                                  style: TextStyle(
                                                    color: AppColors.textGrey,
                                                    fontSize: 13,
                                                  ),
                                                )
                                              else
                                                ...poly.schedules.map(
                                                  (s) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 12,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                          child: const Icon(
                                                            Icons.schedule,
                                                            color: AppColors
                                                                .primary,
                                                            size: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            s.dayOfWeek,
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .textDark,
                                                                  fontSize: 13,
                                                                ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${s.startTime} - ${s.endTime}',
                                                          style:
                                                              const TextStyle(
                                                                color: AppColors
                                                                    .textDark,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    final spec = poly.name
                                                        .replaceAll(
                                                          'Poli ',
                                                          'Spesialis ',
                                                        );
                                                    ref
                                                            .read(
                                                              selectedSpecializationProvider
                                                                  .notifier,
                                                            )
                                                            .state =
                                                        spec;
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 14,
                                                        ),
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.person_search,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Lihat Dokter di Poli Ini',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }, childCount: polys.length),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: CardSkeletonLoader(count: 6),
                    ),
                    error: (err, stack) => SliverToBoxAdapter(
                      child: Center(child: Text(ErrorHandler.getMessage(err))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
