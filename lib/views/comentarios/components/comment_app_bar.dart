import 'package:flutter/material.dart';

class CommentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommentAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        'Comentarios',
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
