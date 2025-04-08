import 'package:flutter/material.dart';
import 'package:road_guard/auth/auth.dart';
import 'package:road_guard/drivers_license/drivers_license.dart';
import 'package:road_guard/home/cubit/cubit.dart';
import 'package:road_guard/utils/utils.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
          ),
          children: [
            const SizedBox(height: 24),

            // --- Profile Section ---
            _buildProfileSection(context, user),
            const SizedBox(height: 24),

            // --- Driver's License Section ---
            _buildDriversLicenseSection(context),
            const SizedBox(height: 24),

            // --- Statistics Section ---
            _buildStatisticsSection(context),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildProfileSection(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatar ?? ''),
            radius: 32,
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'User',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriversLicenseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(4)),
          child: Text(
            "Driver's License",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.orange.shade50,
          elevation: 3,
          shadowColor: Colors.orange.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LicenseButton(
                  icon: Icons.add_card,
                  label: 'Add',
                  onTap: () {
                    Navigator.push(
                      context,
                      DriversLicensePage.route('Add'),
                    );
                  },
                ),
                _LicenseButton(
                  icon: Icons.remove_red_eye,
                  label: 'View',
                  onTap: () {
                    Navigator.push(
                      context,
                      DriversLicensePage.route('View'),
                    );
                  },
                ),
                _LicenseButton(
                  icon: Icons.edit,
                  label: 'Update',
                  onTap: () {
                    Navigator.push(
                      context,
                      DriversLicensePage.route('Update'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(4)),
          child: Text(
            'Statistics',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard(
              context,
              '695,740',
              'Active Vehicle Population',
              Colors.green,
            ),
            _buildStatCard(
              context,
              '772,570',
              'Licensed Drivers',
              Colors.blue,
            ),
            _buildStatCard(
              context,
              '80,310',
              'Traffic Violations',
              Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String number,
    String label,
    MaterialColor color,
  ) {
    return Expanded(
      child: SizedBox(
        height: getProportionateScreenHeight(120),
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          shadowColor: color.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.shade50,
                  Colors.white,
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: color.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(18),
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: getProportionateScreenWidth(11),
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

class _LicenseButton extends StatelessWidget {
  const _LicenseButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 28,
              color: Colors.orange.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
