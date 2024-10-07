import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:hypha_wallet/design/hypha_colors.dart';
import 'package:hypha_wallet/design/themes/extensions/theme_extension_provider.dart';

class ProposalCreationView extends StatefulWidget {
  const ProposalCreationView({super.key});

  @override
  State<ProposalCreationView> createState() => _ProposalCreationViewState();
}

class _ProposalCreationViewState extends State<ProposalCreationView> {
  final TextEditingController _titleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _isEditingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      _isEditingNotifier.value = _focusNode.hasFocus;
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });

    _quillController.document.changes.listen((event) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        color: context.isDarkMode ? HyphaColors.darkBlack : HyphaColors.offWhite,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Proposal Content',
                style: context.hyphaTextTheme.smallTitles.copyWith(color: HyphaColors.primaryBlu),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Text(
                  'Add a title for your proposal, and use the big text field to include as many details as you need.',
                  style: context.hyphaTextTheme.ralMediumBody.copyWith(color: HyphaColors.midGrey),
                ),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.isDarkMode ? HyphaColors.lightBlack : HyphaColors.white,
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: _titleController.text.isEmpty
                        ? (context.isDarkMode ? HyphaColors.midGrey : HyphaColors.black)
                        : HyphaColors.primaryBlu,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.isDarkMode ? HyphaColors.lightBlack : HyphaColors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.isDarkMode ? HyphaColors.lightBlack : HyphaColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                  valueListenable: _isEditingNotifier,
                  builder: (BuildContext context, bool isEditing, Widget? child) {
                    return Visibility(
                      visible: isEditing,
                      child: QuillSimpleToolbar(
                        controller: _quillController,
                        configurations: const QuillSimpleToolbarConfigurations(),
                      ),
                    );
                  }
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? HyphaColors.lightBlack : HyphaColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 150.0,
                      ),
                      child: IntrinsicHeight(
                        child: QuillEditor.basic(
                          controller: _quillController,
                          focusNode: _focusNode,
                          configurations: QuillEditorConfigurations(
                            keyboardAppearance: context.isDarkMode
                                ? Brightness.dark
                                : Brightness.light,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: -6,
                    child: Text(
                      'Details',
                      style: context.hyphaTextTheme.ralMediumLabel.copyWith(
                        color: _quillController.document.isEmpty()
                            ? (context.isDarkMode
                            ? HyphaColors.midGrey
                            : HyphaColors.black)
                            : HyphaColors.primaryBlu,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewPadding.bottom + 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}