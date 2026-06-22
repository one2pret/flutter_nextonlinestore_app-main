import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/extensions/context_ext.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/models/response/product_response_model.dart';
import '../home/widgets/product_card_widget.dart';
import '../product/pages/product_detail_page.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback? onBack;
  const SearchPage({super.key, this.onBack});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _datasource = ProductRemoteDatasource();
  Timer? _debounce;

  String _query = '';
  bool _loading = false;
  String? _error;
  List<Product> _results = [];
  List<Product> _featured = [];

  @override
  void initState() {
    super.initState();
    _loadFeatured();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFeatured() async {
    final result = await _datasource.getProducts(featured: true, limit: 10);
    result.fold(
      (_) {},
      (data) {
        if (!mounted) return;
        setState(() => _featured = data.data ?? []);
      },
    );
  }

  void _onChanged(String value) {
    setState(() => _query = value);
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _results = [];
        _error = null;
        _loading = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result =
        await _datasource.getProducts(search: query.trim(), limit: 20);
    if (!mounted || _query.trim() != query.trim()) return;
    result.fold(
      (err) => setState(() {
        _loading = false;
        _error = err;
        _results = [];
      }),
      (data) => setState(() {
        _loading = false;
        _results = data.data ?? [];
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        titleSpacing: 0,
        title: Container(
          height: 38,
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCFDFDC)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'Cari produk...',
                    hintStyle: AppTextStyles.bodyMuted,
                  ),
                  style: AppTextStyles.body,
                  onChanged: _onChanged,
                  textInputAction: TextInputAction.search,
                ),
              ),
              if (_query.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    _onChanged('');
                  },
                  child: const Icon(Icons.close,
                      size: 18, color: AppColors.textMuted),
                ),
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_query.trim().isEmpty) return _buildFeatured();
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, color: AppColors.primary, size: 64),
            const SizedBox(height: 12),
            const Text('Tidak ada hasil', style: AppTextStyles.h2),
            const SizedBox(height: 4),
            Text('Tidak ada produk untuk "$_query".',
                style: AppTextStyles.bodyMuted),
          ],
        ),
      );
    }
    return _buildGrid(_results, headerText: '${_results.length} hasil');
  }

  Widget _buildFeatured() {
    if (_featured.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildGrid(_featured, headerText: 'Rekomendasi untukmu');
  }

  Widget _buildGrid(List<Product> products, {required String headerText}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(headerText, style: AppTextStyles.bodyMuted),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (_, i) {
              final p = products[i];
              return ProductCardWidget(
                product: p,
                onTap: () => context.push(ProductDetailPage(product: p)),
              );
            },
          ),
        ),
      ],
    );
  }
}
