import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/app_ui/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    const _OnboardingData(
      title: 'Privacy by Default, With Zero Ads or Hidden Tracking',
      subtitle: 'No ads. No trackers. No third-party analytics.',
    ),
    const _OnboardingData(
      title: 'Insights That Help You Spend Better Without Complexity',
      subtitle: 'See category-wise spending, recent activity.',
    ),
    const _OnboardingData(
      title: 'Control Your Money and Save More Every Day',
      subtitle: 'Set budgets and track your progress effortlessly.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(AppAssets.etOnboardBg, fit: BoxFit.cover),
          ),

          // Top Skip Button
          if (_currentPage < 2)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Page Content
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Indicators
                            Row(
                              children: List.generate(
                                _pages.length,
                                (dotIndex) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  height: 4,
                                  width: 100, // Based on screenshot width
                                  decoration: BoxDecoration(
                                    color: dotIndex == _currentPage
                                        ? colors.white
                                        : colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              _pages[index].title,
                              style: TextStyle(
                                color: colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _pages[index].subtitle,
                              style: TextStyle(
                                color: colors.white.withValues(alpha: 0.7),
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      if (_currentPage > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ETCircleButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      Expanded(
                        child: ETPrimaryButton(
                          label: _currentPage == _pages.length - 1
                              ? 'GET STARTED'
                              : 'NEXT',
                          onPressed: () {
                            if (_currentPage < _pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              context.go('/login');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
