import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dory/components/dory_constants.dart';
import 'package:dory/components/dory_page_route.dart';
import 'package:dory/components/dory_widgets.dart';
import 'package:dory/pages/add_medicine/add_alarm_page.dart';
import 'package:dory/pages/bottomsheet/pick_image_bottomsheet.dart';

import 'components/add_page_widget.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({Key? key}) : super(key: key);

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _nameController = TextEditingController();
  File? _medicineImage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
        ),
        body: SingleChildScrollView(
          child: AddPageBody(
            children: [
              Text(
                '어떤 약이에요?',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: largeSpace,
              ),
              Center(
                child: _MedicineImageButton(
                  changedImageFile: (File? value) {
                    _medicineImage = value;
                  },
                ),
              ),
              const SizedBox(
                height: largeSpace + smallSpace,
              ),
              Text(
                '약 이름',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextFormField(
                controller: _nameController,
                maxLength: 20,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  hintText: '복용할 약 이름을 기입해주세요.',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                  contentPadding: textFieldContentPadding,
                ),
                onChanged: (_) {
                  setState(() {});
                },
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomSubmitButton(
          onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage,
          text: '다음',
        ));
  }

  void _onAddAlarmPage() {
    Navigator.push(
      context,
      FadePageRoute(
        page: AddAlarmPage(
          medicineImage: _medicineImage,
          medicineName: _nameController.text,
        ),
      ),
    );
  }
}

class _MedicineImageButton extends StatefulWidget {
  const _MedicineImageButton({Key? key, required this.changedImageFile})
      : super(key: key);

  final ValueChanged<File?> changedImageFile;

  @override
  State<_MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<_MedicineImageButton> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
          padding: _pickedImage == null ? null : EdgeInsets.zero,
          onPressed: _showBottomSheet,
          child: _pickedImage == null
              ? const Icon(CupertinoIcons.photo_camera,
                  size: 30, color: Colors.white)
              : CircleAvatar(
                  foregroundImage: FileImage(_pickedImage!),
                  radius: 40,
                )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageBottomSheet(
              onPressedCamera: () => _onPressed(ImageSource.camera),
              onPressedGallery: () => _onPressed(ImageSource.gallery));
        });
  }

  void _onPressed(ImageSource source) {
    ImagePicker().pickImage(source: source).then((xfile) {
      if (xfile != null) {
        setState(() {
          _pickedImage = File(xfile.path);
          widget.changedImageFile(_pickedImage);
        });
      }
      Navigator.maybePop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showPermissionDenied(context, permission: '카메라 및 갤러리 접근');
    });
  }
}