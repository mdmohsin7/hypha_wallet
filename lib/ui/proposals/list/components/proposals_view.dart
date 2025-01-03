import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as GetX;
import 'package:get_it/get_it.dart';
import 'package:hypha_wallet/core/extension/proposals_filter_extension.dart';
import 'package:hypha_wallet/core/network/models/proposal_model.dart';
import 'package:hypha_wallet/design/avatar_image/hypha_avatar_image.dart';
import 'package:hypha_wallet/design/background/hypha_page_background.dart';
import 'package:hypha_wallet/design/hypha_colors.dart';
import 'package:hypha_wallet/design/themes/extensions/theme_extension_provider.dart';
import 'package:hypha_wallet/ui/blocs/authentication/authentication_bloc.dart';
import 'package:hypha_wallet/ui/profile/profile_page.dart';
import 'package:hypha_wallet/ui/proposals/components/proposals_list.dart';
import 'package:hypha_wallet/ui/proposals/creation/proposal_creation_page.dart';
import 'package:hypha_wallet/ui/proposals/filter/filter_proposals_page.dart';
import 'package:hypha_wallet/ui/proposals/filter/interactor/filter_proposals_bloc.dart';
import 'package:hypha_wallet/ui/proposals/filter/interactor/filter_status.dart';
import 'package:hypha_wallet/ui/proposals/list/interactor/proposals_bloc.dart';
import 'package:hypha_wallet/ui/shared/hypha_body_widget.dart';

class ProposalsView extends StatelessWidget {
  const ProposalsView({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterStatus filterStatus =
        context.watch<ProposalsBloc>().filterStatus;
    final ProposalsBloc proposalBloc = context.read<ProposalsBloc>();
    return BlocBuilder<ProposalsBloc, ProposalsState>(
        builder: (context, state) {
      return HyphaPageBackground(
          backgroundTexture: 'assets/images/graphics/wallet_background.png',
          withOpacity: false,
          child: Scaffold(
            backgroundColor: HyphaColors.transparent,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                const _NewProposalButton(),
                const SizedBox(
                  width: 20,
                )
              ],
              title: Row(
                children: [
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      return HyphaAvatarImage(
                        onTap: () {
                          GetX.Get.to(
                            const ProfilePage(),
                            transition: GetX.Transition.leftToRight,
                          );
                        },
                        imageRadius: 19,
                        imageFromUrl: state.userProfileData?.userImage,
                        name: state.userProfileData?.userName,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Proposals',
                    style: context.hyphaTextTheme.bigTitles
                        .copyWith(color: HyphaColors.white),
                  ),
                ],
              ),
              titleSpacing: 20,
            ),
            body: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ProposalsBloc>()
                      .add(const ProposalsEvent.initial(refresh: true));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? null : HyphaColors.offWhite,
                    gradient:
                        context.isDarkMode ? HyphaColors.gradientBlack : null,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: context.isDarkMode
                        ? HyphaColors.darkModeCardShadow
                        : HyphaColors.lightModeCardShadow,
                  ),
                  child: HyphaBodyWidget(
                    pageState: state.pageState,
                    success: (context) {
                      final List<int>? daoIds = GetIt.I.get<FilterProposalsBloc>().selectedDaoIds;
                      final List<ProposalModel> proposals = daoIds != null
                          ? state.proposals.filterByDao(daoIds)
                          : state.proposals;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                '${proposals.length} ${filterStatus.string} Proposal${proposals.length == 1 ? '' : 's'}',
                                style: context.hyphaTextTheme.ralMediumBody.copyWith(color: HyphaColors.midGrey),
                              ),
                            ),
                            Expanded(
                              child: ProposalsList(
                                proposals,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
            floatingActionButton: proposalBloc.daos.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      GetX.Get.to(() => ProposalCreationPage(proposalBloc.daos),
                          transition: GetX.Transition.leftToRight);
                    },
                    icon: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            'assets/images/graphics/wallet_background.png'),
                        child: Icon(Icons.add, color: HyphaColors.white))),
          ));
    });
  }
}

class _NewProposalButton extends StatelessWidget {
  const _NewProposalButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            GetX.Get.to(() => const FilterProposalsPage(),
                transition: GetX.Transition.leftToRight);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 38,
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? HyphaColors.darkBlack
                  : HyphaColors.offWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Filter',
                  style: context.hyphaTextTheme.regular.copyWith(
                      color: context.isDarkMode
                          ? Colors.white
                          : HyphaColors.darkBlack,
                      fontSize: 13),
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(Icons.filter_list_rounded,
                    size: 25,
                    color: context.isDarkMode
                        ? HyphaColors.white
                        : HyphaColors.darkBlack),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
