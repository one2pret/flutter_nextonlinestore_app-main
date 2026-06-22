import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep; // 1-based
  final int totalSteps;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final step = i + 1;
        final isActive = step <= currentStep;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.primary : AppColors.divider,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$step',
                  style: TextStyle(
                    color: isActive ? AppColors.white : AppColors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? AppColors.primary : AppColors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
