import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypha_wallet/core/network/models/transaction_model.dart';
import 'package:hypha_wallet/design/hypha_card.dart';
import 'package:hypha_wallet/design/hypha_colors.dart';
import 'package:hypha_wallet/design/progress_indicator/hypha_progress_indicator.dart';
import 'package:hypha_wallet/design/themes/extensions/theme_extension_provider.dart';
import 'package:hypha_wallet/ui/shared/listview_with_all_separators.dart';
import 'package:hypha_wallet/ui/wallet/components/wallet_transaction_tile.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final bool loadingTransaction;
  final List<TransactionModel> recentTransactions;

  const RecentTransactionsWidget({super.key, required this.loadingTransaction, required this.recentTransactions});

  @override
  Widget build(BuildContext context) {
    return loadingTransaction
        ? const Center(child: HyphaProgressIndicator())
        : recentTransactions.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ListViewWithAllSeparators(
                  shrinkWrap: true,
                  itemBuilder: (context, item, index) {
                    if (item is TransactionRedeem) {
                      return WalletTransactionTile(
                        name: item.account,
                        amount: item.amount,
                        isReceived: true,
                        time: item.timestamp,
                        tokenImage: 'token image',
                        tokenName: item.symbol,
                        userProfileImage: null,
                      );
                    } else if (item is TransactionTransfer) {
                      return WalletTransactionTile(
                        name: item.account,
                        amount: item.amount.toString(),
                        isReceived: true,
                        time: item.timestamp,
                        tokenImage: 'token image',
                        tokenName: item.symbol,
                        userProfileImage: null,
                      );
                    } else {
                      return WalletTransactionTile(
                        name: item.account,
                        amount: '???',
                        isReceived: true,
                        time: item.timestamp,
                        tokenImage: 'token image',
                        tokenName: '???',
                        userProfileImage: null,
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 26, top: 0, bottom: 16),
                        child: Text('Recent transactions',
                            style: context.hyphaTextTheme.ralMediumBody.copyWith(
                              color: HyphaColors.midGrey,
                            )),
                      );
                    }
                    return Container(
                      height: 16,
                      color: context.isDarkMode ? HyphaColors.transparent : HyphaColors.offWhite,
                    );
                  },
                  items: recentTransactions,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                child: HyphaCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child:
                        Text('You haven’t done any transaction yet', style: context.hyphaTextTheme.ralMediumSmallNote),
                  ),
                ),
              );
  }
}