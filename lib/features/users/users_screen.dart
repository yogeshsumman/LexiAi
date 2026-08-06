import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_view.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/users_model.dart';
import '../../../shared/widgets/build_info_row.dart';
import 'users_controller.dart';

/// Reference implementation of a real remote API flow
/// (Retrofit + repository + BaseController/BaseView).
///
/// This is also a live test of the `dummyjson.com` users endpoint.
class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersController controller = Get.put(UsersController());

    return Scaffold(
      appBar: AppBar(title: const Text('Remote Users (Demo)')),
      body: BaseView<UsersController>(
        controller: controller,
        builder: (c) => RefreshIndicator(
          onRefresh: () => c.fetchUsers(),
          child: ListView.separated(
            padding: AppDimensions.screenPadding,
            itemCount: c.users.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final User user = c.users[i];
              return _UserCard(user: user, index: i);
            },
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.index});

  final User user;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> gradient = [
      dark ? const Color(0xFF1C2740) : const Color(0xFFEFEAE0),
      dark ? const Color(0xFF131C2E) : const Color(0xFFE4DED2),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              user.initials,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: dark ? const Color(0xFFEDF0F7) : const Color(0xFF1B2230),
              ),
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Text(
          '@${user.username} · ${user.company.name}',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                BuildInfoRow(label: 'Email', value: user.email),
                BuildInfoRow(label: 'Phone', value: user.phone),
                BuildInfoRow(label: 'Address', value: user.address.fullAddress),
                BuildInfoRow(label: 'Website', value: user.website),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
