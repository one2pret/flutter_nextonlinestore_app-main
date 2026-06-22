import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/variables.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/response/order_response_model.dart';
import '../../order/pages/order_detail_page.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;
  final Order order;
  const PaymentPage({
    super.key,
    required this.paymentUrl,
    required this.order,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: _onNavRequest,
        onPageStarted: (_) => setState(() => _isLoading = true),
        onProgress: (p) => setState(() => _loadingProgress = p),
        onPageFinished: (_) => setState(() => _isLoading = false),
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  NavigationDecision _onNavRequest(NavigationRequest request) {
    final redirectBase = '${Variables.baseUrl}/orders/';
    if (request.url.startsWith(redirectBase)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessPage(order: widget.order),
        ),
      );
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> _confirmExit() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tinggalkan Pembayaran?'),
        content: const Text(
            'Anda masih bisa bayar nanti dari detail pesanan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Lanjut Bayar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (shouldLeave == true && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailPage(orderId: widget.order.id!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran',
              style: TextStyle(color: AppColors.white)),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _confirmExit,
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              LinearProgressIndicator(
                value: _loadingProgress / 100,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
