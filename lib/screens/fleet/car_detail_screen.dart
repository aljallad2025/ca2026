import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme.dart';
import '../../models/car_model.dart';
import '../../services/car_service.dart';

/// TODO: غيّر هذا الرقم لرقم المبيعات/الشورووم الحقيقي (بصيغة دولية بدون +)
const String kSalesWhatsappNumber = '973XXXXXXXX';
const String kSalesPhoneNumber = '+973XXXXXXXX';

class CarDetailScreen extends StatefulWidget {
  final String carId;
  const CarDetailScreen({super.key, required this.carId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final CarService _carService = CarService();
  CarModel? _car;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final car = await _carService.getCarById(widget.carId);
    setState(() {
      _car = car;
      _loading = false;
    });
  }

  Future<void> _callSales() async {
    final uri = Uri(scheme: 'tel', path: kSalesPhoneNumber);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsappSales() async {
    final car = _car;
    final msg = car == null
        ? 'مرحباً، أنا مهتم بسيارة معروضة للبيع.'
        : 'مرحباً، أنا مهتم بسيارة ${car.displayName} المعروضة للبيع.';
    final uri = Uri.parse(
      'https://wa.me/$kSalesWhatsappNumber?text=${Uri.encodeComponent(msg)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _bookNow() {
    // TODO: تنقل لشاشة Booking الفعلية بعد بنائها
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('شاشة الحجز قيد البناء')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.speedRed),
        ),
      );
    }

    final car = _car;
    if (car == null) {
      return const Scaffold(body: Center(child: Text('السيارة غير موجودة')));
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.speedBlack,
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: car.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: car.images.first,
                      fit: BoxFit.cover,
                    )
                  : Container(color: AppColors.speedBlackSoft),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.displayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (car.category != null) _Tag(car.category!),
                      if (car.transmission != null) _Tag(car.transmission!),
                      if (car.fuelType != null) _Tag(car.fuelType!),
                      if (car.seats != null) _Tag('${car.seats} مقاعد'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (car.description != null) Text(car.description!),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildActionArea(car),
        ),
      ),
    );
  }

  Widget _buildActionArea(CarModel car) {
    // سيارة للإيجار فقط -> Book Now
    if (car.listingType == 'rent') {
      return ElevatedButton(
        onPressed: _bookNow,
        child: Text(
          car.dailyRate != null
              ? 'احجز الآن • BD ${car.dailyRate!.toStringAsFixed(0)}/يوم'
              : 'احجز الآن',
        ),
      );
    }

    // سيارة للبيع فقط -> اتصال + واتساب (بدون فلسفة، بسيط)
    if (car.listingType == 'sale') {
      return Column(
        children: [
          if (car.salePrice != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'BD ${car.salePrice!.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.speedBlack,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _callSales,
                  icon: const Icon(Icons.call),
                  label: const Text('اتصال'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _whatsappSales,
                  icon: const Icon(Icons.chat),
                  label: const Text('واتساب'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // 'both' -> الخيارين
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _callSales,
            icon: const Icon(Icons.call),
            label: const Text('اتصال للبيع'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _bookNow,
            child: const Text('احجز للإيجار'),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
