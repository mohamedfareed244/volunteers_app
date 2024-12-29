import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteers_app/controllers/my_app_method.dart';
import 'package:volunteers_app/models/opp_model.dart';
import 'package:volunteers_app/views/services/my_validators.dart';

import 'dart:io';

import '../widgets/title_text.dart';

class UploadOpp extends StatefulWidget {
  static const routeName = '/UploadOpp';

  const UploadOpp({
    super.key,
    this.oppModel,
  });
  final OppModel? oppModel;
  @override
  State<UploadOpp> createState() => _UploadOppState();
}

class _UploadOppState extends State<UploadOpp> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isEditing = false;
  String? oppNetworkImage;
  late TextEditingController _titleController, _descriptionController;

  bool _isLoading = false;
  String? oppImageUrl;

  @override
  void initState() {
    if (widget.oppModel != null) {
      isEditing = true;
      oppNetworkImage = widget.oppModel!.OppImage;
    }
    _titleController =
        TextEditingController(text: widget.oppModel?.OppTitle);

    _descriptionController =
        TextEditingController(text: widget.oppModel?.OppDescription);

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void clearForm() {
    _titleController.clear();

    _descriptionController.clear();
    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      oppNetworkImage = null;
    });
  }

  Future<void> _uploadOpp() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Make sure to pick up an image",
        fct: () {},
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child("OppImages")
            .child('${_titleController.text.trim()}.jpg');
        await ref.putFile(File(_pickedImage!.path));
        oppImageUrl = await ref.getDownloadURL();

        final oppID = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("opportunitites")
            .doc(oppID)
            .set({
          'oppId': oppID,
          'oppTitle': _titleController.text,
          'oppImage': oppImageUrl,
          'oppDescription': _descriptionController.text,
          'createdAt': Timestamp.now(),
        });
        Fluttertoast.showToast(
          msg: "Opportunity has been added",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
          clearForm();


        ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Opportunity uploaded successfully!', style: TextStyle(color: Colors.amber,  fontSize: 16,
              fontWeight: FontWeight.w500, ),),
    
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () async {
        setState(() {
          _isLoading = true;
          
        }
        );

        try {
          if (oppImageUrl != null) {
            final storageRef = FirebaseStorage.instance
                .refFromURL(oppImageUrl!);
            await storageRef.delete();
          }

          await FirebaseFirestore.instance
              .collection("opportunitites")
              .doc(oppID)
              .delete();

          clearForm();
          setState(() {
            _pickedImage = null;
            oppNetworkImage = null;
          });

          Fluttertoast.showToast(
            msg: "Opportunity upload undone",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white,
          );
        } catch (error) {
          await MyAppMethods.showErrorORWarningDialog(
            context: context,
            subtitle: "Error undoing upload: $error",
            fct: () {},
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      },
    ),
  ),
);
       
      } on FirebaseException catch (error) {
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occured ${error.message}",
          fct: () {},
        );
      } catch (error) {
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occured $error",
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editOpp() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && oppNetworkImage == null) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Please pick up an image",
        fct: () {},
      );
      return;
    }
    if (isValid) {}
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomSheet: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.clear),
                  label: const Text(
                    "Clear",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    // backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.upload),
                  label: Text(
                    isEditing ? "Edit Opportunity" : "Upload Opportunity",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    if (isEditing) {
                      _editOpp();
                    } else {
                      _uploadOpp();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (isEditing && oppNetworkImage != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      oppNetworkImage!,
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  ),
                ] else if (_pickedImage == null) ...[
                  SizedBox(
                    width: size.width * 0.4 + 10,
                    height: size.width * 0.4,
                    child: DottedBorder(
                        color: Colors.amber,
                        radius: const Radius.circular(12),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.amber,
                              ),
                              TextButton(
                                onPressed: () {
                                  localImagePicker();
                                },
                                child: const Text("Pick image"),
                              ),
                            ],
                          ),
                        )),
                  ),
                ] else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(
                        _pickedImage!.path,
                      ),
                      // width: size.width * 0.7,
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
                if (_pickedImage != null || oppNetworkImage != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          localImagePicker();
                        },
                        child: const Text("Pick another image"),
                      ),
                      TextButton(
                        onPressed: () {
                          removePickedImage();
                        },
                        child: const Text(
                          "Remove image",
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    ],
                  )
                ],
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          key: const ValueKey('Title'),
                          maxLength: 80,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: 'Opportunity Title',
                          ),
                          validator: (value) {
                            return MyValidators.uploadOppTexts(
                              value: value,
                              toBeReturnedString: "Please enter a valid title",
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          key: const ValueKey('Description'),
                          controller: _descriptionController,
                          minLines: 5,
                          maxLines: 8,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Opportunity description',
                          ),
                          validator: (value) {
                            return MyValidators.uploadOppTexts(
                              value: value,
                              toBeReturnedString: "Description is missed",
                            );
                          },
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: kBottomNavigationBarHeight + 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
