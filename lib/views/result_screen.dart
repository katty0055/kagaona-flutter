import 'package:flutter/material.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/theme/colors.dart';
import 'package:kgaona/views/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScoreGame;
  final int totalQuestions;
  const ResultScreen({
    super.key,
    required this.finalScoreGame,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String scoreText =
        '${PreguntasConstantes.puntuacion} $finalScoreGame/$totalQuestions';
    final String feedbackMessage;
    final IconData feedbackIcon;
    final Color feedbackColor;
    final double percentage = finalScoreGame / totalQuestions;
    if (percentage >= 0.8) {
      feedbackMessage = PreguntasConstantes.excellent;
      feedbackIcon = Icons.emoji_events;
      feedbackColor = AppColors.success;
    } else if (percentage >= 0.6) {
      feedbackMessage = PreguntasConstantes.wellDone;
      feedbackIcon = Icons.thumb_up;
      feedbackColor = AppColors.primaryDarkBlue;
    } else if (percentage >= 0.4) {
      feedbackMessage = PreguntasConstantes.goodJob;
      feedbackIcon = Icons.sentiment_satisfied;
      feedbackColor = AppColors.primaryLightBlue;
    } else {
      feedbackMessage = PreguntasConstantes.keepTrying;
      feedbackIcon = Icons.sentiment_dissatisfied;
      feedbackColor = AppColors.warning;
    }
    return Scaffold(
      appBar: AppBar(title: const Text(PreguntasConstantes.results)),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(feedbackIcon, size: 72, color: feedbackColor),
                    const SizedBox(height: 24),
                    Text(
                      PreguntasConstantes.gameEnded,
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withAlpha(77),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            scoreText,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: finalScoreGame / totalQuestions,
                            backgroundColor: theme.colorScheme.primary
                                .withAlpha(27),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percentage >= 0.6
                                  ? AppColors.success
                                  : percentage >= 0.4
                                  ? AppColors.primaryLightBlue
                                  : AppColors.warning,
                            ),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      feedbackMessage,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: feedbackColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                  (route) => false,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(
                PreguntasConstantes.playAgain,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
