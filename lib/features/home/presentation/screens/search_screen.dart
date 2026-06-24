import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/search_all_results.dart';
import '../widgets/search_doctor_results.dart';
import '../widgets/search_agenda_results.dart';
import '../widgets/search_service_results.dart';

final globalSearchQueryProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.text = ref.read(globalSearchQueryProvider);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(globalSearchQueryProvider).toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.extHasilpencarian,
          style: TextStyle(
            color: AppColors.backgroundWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: AppColors.backgroundWhite, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Cari Dokter, Layanan, Agenda...',
                      hintStyle: TextStyle(color: AppColors.textWhite70, fontSize: 13),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textWhite70,
                        size: 18,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onChanged: (val) {
                      ref.read(globalSearchQueryProvider.notifier).state = val;
                    },
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.backgroundWhite,
                labelColor: AppColors.backgroundWhite,
                unselectedLabelColor: AppColors.textWhite70,
                isScrollable: false,
                labelPadding: EdgeInsets.zero,
                dividerColor: AppColors.transparent,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 13),
                tabs: const [
                  Tab(text: 'Semua'),
                  Tab(text: 'Dokter'),
                  Tab(text: 'Agenda'),
                  Tab(text: 'Layanan'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SearchAllResults(query: query),
          SearchDoctorResults(query: query),
          SearchAgendaResults(query: query),
          SearchServiceResults(query: query),
        ],
      ),
    );
  }
}
