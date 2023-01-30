import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypha_wallet/design/avatar_image/hypha_editable_avatar_image.dart';
import 'package:hypha_wallet/design/background/hypha_half_background.dart';
import 'package:hypha_wallet/design/background/hypha_page_background.dart';
import 'package:hypha_wallet/design/cards/hypha_actionable_card.dart';
import 'package:hypha_wallet/design/hypha_colors.dart';
import 'package:hypha_wallet/design/themes/extensions/theme_extension_provider.dart';
import 'package:hypha_wallet/ui/profile/interactor/profile_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return HyphaPageBackground(
      withGradient: true,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: HyphaColors.transparent,
            body: Stack(
              children: [
                const HyphaHalfBackground(),
                Padding(
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      HyphaEditableAvatarImage(
                        imageRadius: 50,
                        name: state.profileData?.name,
                        imageFromUrl: state.profileData?.image,
                        // imageFromFile: _file?.path,
                        onImageRemoved: () {
                          // setState(() {
                          //   _file = null;
                          // });
                        },
                        onImageSelected: (image) async {
                          // setState(() {
                          //   _file = image;
                          // });
                        },
                      ),
                      const SizedBox(height: 14),
                      Text(state.profileData?.name ?? '', style: context.hyphaTextTheme.mediumTitles),
                      const SizedBox(height: 4),
                      Text('@${state.profileData?.account ?? ''}',
                          style: context.hyphaTextTheme.regular.copyWith(color: HyphaColors.lightBlue)),
                      const SizedBox(height: 24),
                      HyphaActionableCard(
                        trailer: const Icon(Icons.edit),
                        title: 'Short Bio',
                        subtitle: state.profileData?.bio ?? '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
