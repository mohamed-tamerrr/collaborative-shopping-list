import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/add_people_container.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/cancel_button.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_button.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_text_form_field.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_type_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddListViewBody extends StatefulWidget {
  const AddListViewBody({super.key});

  @override
  State<AddListViewBody> createState() => _AddListViewBodyState();
}

class _AddListViewBodyState extends State<AddListViewBody> {
  bool isSharedList = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: context.read<ListCubit>().listKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 20),
                  const CancelButton(),
                  const SizedBox(height: 6),
                  const Text(
                    'New List',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 28),

                  // ListName Title And TextField
                  CustomTextFormFieldWithTitle(
                    isRequired: true,
                    title: 'List Name:',
                    hintText: 'Enter List Name',
                    controller: BlocProvider.of<ListCubit>(
                      context,
                    ).listNameController,
                  ),

                  const SizedBox(height: 20),

                  // Notes Title And TextField
                  CustomTextFormFieldWithTitle(
                    title: 'Notes:',
                    hintText:
                        'Add any additional information or reminders for your list here.',
                    maxLines: 3,
                    controller: BlocProvider.of<ListCubit>(
                      context,
                    ).listNoteController,
                  ),

                  // List Type row
                  const SizedBox(height: 20),
                  ListTypeRow(
                    value: isSharedList,
                    onChange: (value) {
                      setState(() {
                        isSharedList = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // to show or hide the list of people you wanna share the list with
                  Visibility(
                    visible: isSharedList,
                    child: const AddPeopleContainer(),
                  ),
                  // Add items button
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Create List',
              onPressed: () async {
                await BlocProvider.of<ListCubit>(context).createList(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
