import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../../../appointment/providers/polyclinic_provider.dart';

final globalSearchQueryProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Hasil Pencarian', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Cari Dokter, Layanan, Agenda...',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.white70, size: 18),
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
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                isScrollable: false,
                labelPadding: EdgeInsets.zero,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
          _buildAllResults(context, ref, query),
          _buildDoctorResults(context, ref, query),
          _buildAgendaResults(context, ref, query),
          _buildServiceResults(context, ref, query),
        ],
      ),
    );
  }

  Widget _buildAllResults(BuildContext context, WidgetRef ref, String query) {
    if (query.isEmpty) return _buildEmptyState('Ketik sesuatu untuk mencari');

    final doctorsAsync = ref.watch(doctorsProvider);
    final polyclinicsAsync = ref.watch(polyclinicsProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        _buildSectionHeader('Dokter'),
        doctorsAsync.when(
          data: (doctors) {
            final filtered = doctors.where((d) => d.name.toLowerCase().contains(query)).take(2).toList();
            if (filtered.isEmpty) return const Padding(padding: EdgeInsets.only(bottom: 16), child: Text('Tidak ditemukan'));
            return Column(
              children: filtered.map((d) => _buildItem(Icons.person, d.name, d.specialization, () => context.push('/appointment'))).toList(),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text('Error memuat dokter'),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('Layanan / Poliklinik'),
        polyclinicsAsync.when(
          data: (polys) {
            final filtered = polys.where((p) => p.name.toLowerCase().contains(query)).take(2).toList();
            if (filtered.isEmpty) return const Padding(padding: EdgeInsets.only(bottom: 16), child: Text('Tidak ditemukan'));
            return Column(
              children: filtered.map((p) => _buildItem(Icons.local_hospital, p.name, p.description, () => context.push('/appointment'))).toList(),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text('Error memuat layanan'),
        ),
      ],
    );
  }

  Widget _buildDoctorResults(BuildContext context, WidgetRef ref, String query) {
    if (query.isEmpty) return _buildEmptyState('Cari nama atau spesialisasi dokter...');
    
    final doctorsAsync = ref.watch(doctorsProvider);
    return doctorsAsync.when(
      data: (doctors) {
        final filtered = doctors.where((d) => 
          d.name.toLowerCase().contains(query) || d.specialization.toLowerCase().contains(query)
        ).toList();
        if (filtered.isEmpty) return _buildEmptyState('Dokter tidak ditemukan');
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, i) => _buildItem(Icons.person, filtered[i].name, filtered[i].specialization, () => context.push('/appointment')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Gagal memuat')),
    );
  }

  Widget _buildAgendaResults(BuildContext context, WidgetRef ref, String query) {
    if (query.isEmpty) return _buildEmptyState('Cari jadwal kontrol / janji temu Anda...');
    
    final apptsAsync = ref.watch(userAppointmentsProvider);
    return apptsAsync.when(
      data: (appts) {
        final filtered = appts.where((a) {
          final docName = a.doctor?.name ?? '';
          final docSpec = a.doctor?.specialization ?? '';
          return docName.toLowerCase().contains(query) || docSpec.toLowerCase().contains(query);
        }).toList();
        if (filtered.isEmpty) return _buildEmptyState('Agenda tidak ditemukan');
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final docName = filtered[i].doctor?.name ?? 'Dokter';
            final docSpec = filtered[i].doctor?.specialization ?? 'Spesialis';
            return _buildItem(Icons.calendar_today, 'Kontrol $docName', docSpec, () => context.push('/appointment'));
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Gagal memuat')),
    );
  }

  Widget _buildServiceResults(BuildContext context, WidgetRef ref, String query) {
    if (query.isEmpty) return _buildEmptyState('Cari layanan medis atau poliklinik...');
    
    final polyclinicsAsync = ref.watch(polyclinicsProvider);
    return polyclinicsAsync.when(
      data: (polys) {
        final filtered = polys.where((p) => 
          p.name.toLowerCase().contains(query) || p.description.toLowerCase().contains(query)
        ).toList();
        if (filtered.isEmpty) return _buildEmptyState('Layanan tidak ditemukan');
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, i) => _buildItem(Icons.local_hospital, filtered[i].name, filtered[i].description, () => context.push('/appointment')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Gagal memuat')),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textGrey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(msg, style: const TextStyle(color: AppColors.textGrey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 0,
      color: Colors.transparent, // Fix the ink splash issue by making card transparent
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Material(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            minLeadingWidth: 0,
            horizontalTitleGap: 12,
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryLight,
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 20),
          ),
        ),
      ),
    );
  }
}
