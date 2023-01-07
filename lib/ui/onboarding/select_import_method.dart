import 'package:flutter/material.dart';
import 'package:hypha_wallet/design/hypha_colors.dart';
import 'package:hypha_wallet/design/themes/extensions/theme_extension_provider.dart';
import 'package:hypha_wallet/ui/onboarding/components/onboarding_appbar.dart';
import 'package:hypha_wallet/ui/onboarding/components/onboarding_page_background.dart';

class SelectImportMethod extends StatelessWidget {
  const SelectImportMethod();

  @override
  Widget build(BuildContext context) {
    return OnboardingPageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: OnboardingAppbar(title: 'Import your', subTitle: 'Hypha Account'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Select your preferred method to import your account',
                style: context.hyphaTextTheme.regular.copyWith(color: HyphaColors.primaryBlu),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 120),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SquareButton(icon: Icons.key_rounded, text: 'Private key'),
                  _SquareButton(icon: Icons.format_list_bulleted, text: '12 Words'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SquareButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: EdgeInsets.all(44),
            decoration: BoxDecoration(
              color: HyphaColors.lightBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 50),
          ),
        ),
        SizedBox(height: 20),
        Text(text, style: context.hyphaTextTheme.ralMediumBody),
      ],
    );
  }
}
