import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String badgeText;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const OnboardingModel({
    required this.title,
    required this.badgeText,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });

  static const List<OnboardingModel> pages = [
    OnboardingModel(
      title: 'Organize Tasks Effortlessly',
      badgeText: 'Smart Management',
      description:
          'Streamline your daily workflow with intuitive task tracking, automated priority tagging, and customized deadlines.',
      icon: Icons.assignment_turned_in_rounded,
      gradientColors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    ),
    OnboardingModel(
      title: 'Collaborate & Sync Real-time',
      badgeText: 'Seamless Teamwork',
      description:
          'Work together with your team seamlessly. Share projects, assign tasks, and track team progress in one single hub.',
      icon: Icons.groups_rounded,
      gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    ),
    OnboardingModel(
      title: 'Smart Analytics & Insights',
      badgeText: 'Boost Productivity',
      description:
          'Gain deep insights into your productivity with interactive charts, streak tracking, and personalized efficiency reports.',
      icon: Icons.insights_rounded,
      gradientColors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
    ),
  ];
}
