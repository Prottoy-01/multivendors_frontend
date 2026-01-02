import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/admin_service.dart';
import '../../../data/models/vendor_model.dart';

class AdminVendorsScreen extends StatefulWidget {
  const AdminVendorsScreen({Key? key}) : super(key: key);

  @override
  State<AdminVendorsScreen> createState() => _AdminVendorsScreenState();
}

class _AdminVendorsScreenState extends State<AdminVendorsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<VendorModel> _allVendors = [];
  List<VendorModel> _pendingVendors = [];
  List<VendorModel> _approvedVendors = [];
  List<VendorModel> _rejectedVendors = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadVendors();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadVendors() async {
    setState(() => _isLoading = true);

    try {
      final result = await AdminService.getVendors();

      if (result['success']) {
        final data = result['data']['data'] as List;
        final vendors = data.map((v) => VendorModel.fromJson(v)).toList();

        setState(() {
          _allVendors = vendors;
          _pendingVendors = vendors.where((v) => v.isPending).toList();
          _approvedVendors = vendors.where((v) => v.isApproved).toList();
          _rejectedVendors = vendors.where((v) => v.isRejected).toList();
        });
      } else {
        _showError(result['message'] ?? 'Failed to load vendors');
      }
    } catch (e) {
      _showError('Error loading vendors: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateVendorStatus(VendorModel vendor, String status) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('${status == 'approved' ? 'Approve' : 'Reject'} Vendor?'),
        content: Text(
          'Are you sure you want to ${status} ${vendor.shopName}?\n\n'
          'Owner: ${vendor.user?.name ?? 'Unknown'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'approved'
                  ? AppColors.success
                  : AppColors.error,
            ),
            child: Text(status == 'approved' ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await AdminService.approveVendor(
        vendorId: vendor.id,
        status: status,
      );

      Navigator.pop(context); // Close loading dialog

      if (result['success']) {
        _showSuccess(
          'Vendor ${status == 'approved' ? 'approved' : 'rejected'} successfully!',
        );
        _loadVendors(); // Reload the list
      } else {
        _showError(result['message'] ?? 'Failed to update vendor status');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showError('Error updating vendor: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Management'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadVendors),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'All (${_allVendors.length})'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pending '),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_pendingVendors.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(text: 'Approved (${_approvedVendors.length})'),
            Tab(text: 'Rejected (${_rejectedVendors.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildVendorList(_allVendors),
                _buildVendorList(_pendingVendors),
                _buildVendorList(_approvedVendors),
                _buildVendorList(_rejectedVendors),
              ],
            ),
    );
  }

  Widget _buildVendorList(List<VendorModel> vendors) {
    if (vendors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No vendors found',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVendors,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return _VendorCard(
            vendor: vendor,
            onApprove: () => _updateVendorStatus(vendor, 'approved'),
            onReject: () => _updateVendorStatus(vendor, 'rejected'),
          );
        },
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _VendorCard({
    required this.vendor,
    required this.onApprove,
    required this.onReject,
  });

  Color _getStatusColor() {
    switch (vendor.status) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  IconData _getStatusIcon() {
    switch (vendor.status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.store, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.shopName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: #${vendor.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(),
                        size: 16,
                        color: _getStatusColor(),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        vendor.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Vendor Details
            _InfoRow(
              icon: Icons.person_outline,
              label: 'Owner',
              value: vendor.user?.name ?? 'Unknown',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: vendor.user?.email ?? 'N/A',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.percent,
              label: 'Commission',
              value: '${vendor.commissionPercentage}%',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Registered',
              value: _formatDate(vendor.createdAt),
            ),

            // Action Buttons (only show for pending vendors)
            if (vendor.isPending) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
