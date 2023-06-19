import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hypha_wallet/core/network/models/user_profile_data.dart';
import 'package:hypha_wallet/ui/send/components/send_view.dart';
import 'package:hypha_wallet/ui/send/interactor/send_bloc.dart';

class SendPage extends StatelessWidget {
  final UserProfileData receiverUser;

  const SendPage({super.key, required this.receiverUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<SendBloc>(param1: receiverUser)..add(const SendEvent.initial()),
      child: BlocListener<SendBloc, SendState>(
        listenWhen: (previous, current) => previous.command != current.command,
        listener: (context, state) {
          context.read<SendBloc>().add(const SendEvent.clearPageCommand());
        },
        child: const SendView(),
      ),
    );
  }
}
