part of 'order_tracking_timeline.dart';

class _TimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIndicator(),
        const SizedBox(width: 16),
        _buildDetails(),
      ],
    );
  }

  Widget _buildIndicator() {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.primary : AppColors.backgroundLightGrey,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? AppColors.primary : AppColors.borderGrey,
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 16, color: AppColors.textWhite)
              : null,
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 50,
            color: isCompleted ? AppColors.primary : AppColors.dividerGrey,
          ),
      ],
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted ? AppColors.textDark : AppColors.textGrey,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: isCompleted ? AppColors.textGrey : AppColors.textLightGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isCompleted ? AppColors.textGrey : AppColors.textLightGrey,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
