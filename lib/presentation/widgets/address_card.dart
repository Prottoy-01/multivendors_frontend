import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/user_address_model.dart';

class AddressCard extends StatelessWidget {
  final UserAddressModel address;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;
  final bool showActions;

  const AddressCard({
    Key? key,
    required this.address,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      address.recipientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (address.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Default',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    address.phone,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address.fullAddress,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              if (showActions) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (!address.isDefault && onSetDefault != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onSetDefault,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
                          label: const Text('Set Default'),
                        ),
                      ),
                    if (!address.isDefault && onSetDefault != null)
                      const SizedBox(width: 8),
                    if (onEdit != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit'),
                        ),
                      ),
                    if (onEdit != null) const SizedBox(width: 8),
                    if (onDelete != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
