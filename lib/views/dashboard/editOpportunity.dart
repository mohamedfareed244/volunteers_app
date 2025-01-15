import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volunteers_app/controllers/my_app_method.dart';
import 'package:volunteers_app/models/opp_model.dart';
import 'package:volunteers_app/views/inner_screens/loading_manager.dart';

class EditOpp extends StatefulWidget {
  final OppModel oppModel;

  const EditOpp({Key? key, required this.oppModel}) : super(key: key);

  @override
  _EditOppState createState() => _EditOppState();
}

class _EditOppState extends State<EditOpp> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _imageUrl;
  XFile? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.oppModel.OppTitle);
    _descriptionController = TextEditingController(text: widget.oppModel.OppDescription);
    _imageUrl = widget.oppModel.OppImage;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateOpp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = _imageUrl!;
      if (_pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('OppImages')
            .child('${_titleController.text.trim()}.jpg');

        await ref.putFile(File(_pickedImage!.path));
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('opportunitites')
          .doc(widget.oppModel.OppId)
          .update({
        'oppTitle': _titleController.text.trim(),
        'oppDescription': _descriptionController.text.trim(),
        'oppImage': imageUrl,
      });

     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opportunity updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
      Navigator.of(context).pop();
    } catch (error) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: 'Error updating opportunity: $error',
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Opportunity'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: _pickedImage == null && _imageUrl != null
                        ? Image.network(_imageUrl!, height: 200, fit: BoxFit.cover)
                        : _pickedImage != null
                            ? Image.file(File(_pickedImage!.path), height: 200, fit: BoxFit.cover)
                            : Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(child: Text('Tap to select an image')),
                              ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateOpp,
                    child: const Text('Update Opportunity'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
