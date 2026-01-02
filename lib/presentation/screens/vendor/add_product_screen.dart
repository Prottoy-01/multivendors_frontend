// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/api_constants.dart';
// import '../../../data/services/product_service.dart';

// class AddProductScreen extends StatefulWidget {
//   const AddProductScreen({Key? key}) : super(key: key);

//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _stockController = TextEditingController();

//   int? _selectedCategoryId;
//   List<Map<String, dynamic>> _categories = [];
//   List<File> _images = [];
//   bool _isLoading = false;
//   bool _loadingCategories = true;

//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _priceController.dispose();
//     _stockController.dispose();
//     super.dispose();
//   }

//   // ✅ UPDATED METHOD WITH DEBUG LOGGING
//   Future<void> _loadCategories() async {
//     setState(() => _loadingCategories = true);

//     print('🔍 [AddProduct] Starting to load categories...');
//     print('🔍 [AddProduct] Base URL: ${ApiConstants.baseUrl}');

//     try {
//       final result = await ProductService.getCategories();

//       print('📦 [AddProduct] Result success: ${result['success']}');
//       print('📦 [AddProduct] Full result: $result');

//       if (result['success']) {
//         final cats = result['categories'];
//         print('✅ [AddProduct] Categories type: ${cats.runtimeType}');
//         print('✅ [AddProduct] Categories count: ${cats.length}');
//         print('✅ [AddProduct] Categories data: $cats');

//         setState(() {
//           _categories = List<Map<String, dynamic>>.from(cats);
//         });

//         print(
//           '📋 [AddProduct] State updated with ${_categories.length} categories',
//         );

//         if (_categories.isEmpty) {
//           _showError(
//             'No categories found. Please ask admin to create categories.',
//           );
//         }
//       } else {
//         print('❌ [AddProduct] Failed to load categories');
//         print('❌ [AddProduct] Error message: ${result['message']}');
//         _showError(result['message'] ?? 'Failed to load categories');
//       }
//     } catch (e, stackTrace) {
//       print('💥 [AddProduct] Exception caught: $e');
//       print('💥 [AddProduct] Stack trace: $stackTrace');
//       _showError('Error loading categories: $e');
//     } finally {
//       setState(() => _loadingCategories = false);
//       print('🏁 [AddProduct] Loading complete. Categories: $_categories');
//     }
//   }

//   Future<void> _pickImage() async {
//     if (_images.length >= 5) {
//       _showError('Maximum 5 images allowed');
//       return;
//     }

//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         setState(() {
//           _images.add(File(image.path));
//         });
//         print('📷 [AddProduct] Image added: ${image.path}');
//       }
//     } catch (e) {
//       print('❌ [AddProduct] Error picking image: $e');
//       _showError('Error picking image: $e');
//     }
//   }

//   Future<void> _takePhoto() async {
//     if (_images.length >= 5) {
//       _showError('Maximum 5 images allowed');
//       return;
//     }

//     try {
//       final XFile? photo = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (photo != null) {
//         setState(() {
//           _images.add(File(photo.path));
//         });
//         print('📸 [AddProduct] Photo taken: ${photo.path}');
//       }
//     } catch (e) {
//       print('❌ [AddProduct] Error taking photo: $e');
//       _showError('Error taking photo: $e');
//     }
//   }

//   void _removeImage(int index) {
//     setState(() {
//       _images.removeAt(index);
//     });
//     print('🗑️ [AddProduct] Image removed at index: $index');
//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Add Product Image',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: const Icon(
//                 Icons.photo_library,
//                 color: AppColors.primary,
//               ),
//               title: const Text('Choose from Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: AppColors.secondary),
//               title: const Text('Take a Photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _takePhoto();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _submitProduct() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (_selectedCategoryId == null) {
//       _showError('Please select a category');
//       return;
//     }

//     if (_images.isEmpty) {
//       _showError('Please add at least one product image');
//       return;
//     }

//     setState(() => _isLoading = true);

//     print('📤 [AddProduct] Submitting product...');
//     print('   Name: ${_nameController.text}');
//     print('   Category ID: $_selectedCategoryId');
//     print('   Price: ${_priceController.text}');
//     print('   Stock: ${_stockController.text}');
//     print('   Images: ${_images.length}');

//     try {
//       final result = await ProductService.createProduct(
//         name: _nameController.text.trim(),
//         description: _descriptionController.text.trim(),
//         price: double.parse(_priceController.text),
//         stock: int.parse(_stockController.text),
//         categoryId: _selectedCategoryId!,
//         images: _images,
//       );

//       print('📥 [AddProduct] Result: $result');

//       if (result['success']) {
//         print('✅ [AddProduct] Product created successfully!');
//         if (mounted) {
//           Navigator.pop(context, true); // Return true to indicate success
//         }
//       } else {
//         print('❌ [AddProduct] Failed: ${result['message']}');
//         _showError(result['message'] ?? 'Failed to add product');
//       }
//     } catch (e, stackTrace) {
//       print('💥 [AddProduct] Exception: $e');
//       print('💥 [AddProduct] Stack trace: $stackTrace');
//       _showError('Error adding product: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.error,
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add New Product'),
//         actions: [
//           if (_isLoading)
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: _loadingCategories
//           ? const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Loading categories...'),
//                 ],
//               ),
//             )
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // ✅ ADDED: Category status indicator
//                     if (_categories.isEmpty)
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         margin: const EdgeInsets.only(bottom: 20),
//                         decoration: BoxDecoration(
//                           color: AppColors.warning.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: AppColors.warning,
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.warning_amber_rounded,
//                               color: AppColors.warning,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'No Categories Found',
//                                     style: TextStyle(
//                                       color: AppColors.warning,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Please ask the admin to create product categories first.',
//                                     style: TextStyle(
//                                       color: AppColors.textSecondary,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                     // Product Images Section
//                     const Text(
//                       'Product Images',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Add up to 5 images (First image will be main)',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Image Grid
//                     SizedBox(
//                       height: 120,
//                       child: ListView(
//                         scrollDirection: Axis.horizontal,
//                         children: [
//                           // Add Image Button
//                           if (_images.length < 5)
//                             InkWell(
//                               onTap: _showImageSourceDialog,
//                               child: Container(
//                                 width: 120,
//                                 margin: const EdgeInsets.only(right: 12),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: AppColors.primary,
//                                     width: 2,
//                                     style: BorderStyle.solid,
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.add_photo_alternate,
//                                       size: 40,
//                                       color: AppColors.primary,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'Add Image',
//                                       style: TextStyle(
//                                         color: AppColors.primary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                           // Display selected images
//                           ..._images.asMap().entries.map((entry) {
//                             int index = entry.key;
//                             File image = entry.value;
//                             return Container(
//                               width: 120,
//                               margin: const EdgeInsets.only(right: 12),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 image: DecorationImage(
//                                   image: FileImage(image),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               child: Stack(
//                                 children: [
//                                   // Main badge
//                                   if (index == 0)
//                                     Positioned(
//                                       top: 8,
//                                       left: 8,
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: AppColors.success,
//                                           borderRadius: BorderRadius.circular(
//                                             6,
//                                           ),
//                                         ),
//                                         child: const Text(
//                                           'MAIN',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   // Remove button
//                                   Positioned(
//                                     top: 8,
//                                     right: 8,
//                                     child: InkWell(
//                                       onTap: () => _removeImage(index),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(4),
//                                         decoration: BoxDecoration(
//                                           color: AppColors.error,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: const Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                           size: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 32),

//                     // Product Name
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         labelText: 'Product Name *',
//                         hintText: 'Enter product name',
//                         prefixIcon: Icon(
//                           Icons.shopping_bag_outlined,
//                           color: AppColors.primary,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter product name';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Category Dropdown
//                     DropdownButtonFormField<int>(
//                       value: _selectedCategoryId,
//                       decoration: InputDecoration(
//                         labelText: 'Category *',
//                         prefixIcon: Icon(
//                           Icons.category_outlined,
//                           color: AppColors.primary,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       hint: Text(
//                         _categories.isEmpty
//                             ? 'No categories available'
//                             : 'Select a category',
//                       ),
//                       items: _categories.map((category) {
//                         return DropdownMenuItem<int>(
//                           value: category['id'],
//                           child: Text(category['name']),
//                         );
//                       }).toList(),
//                       onChanged: _categories.isEmpty
//                           ? null
//                           : (value) {
//                               setState(() {
//                                 _selectedCategoryId = value;
//                               });
//                               print(
//                                 '📁 [AddProduct] Category selected: $value',
//                               );
//                             },
//                       validator: (value) {
//                         if (value == null) {
//                           return 'Please select a category';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Price
//                     TextFormField(
//                       controller: _priceController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'Price *',
//                         hintText: 'Enter price',
//                         prefixIcon: Icon(
//                           Icons.attach_money,
//                           color: AppColors.primary,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter price';
//                         }
//                         if (double.tryParse(value) == null) {
//                           return 'Please enter valid price';
//                         }
//                         if (double.parse(value) <= 0) {
//                           return 'Price must be greater than 0';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Stock
//                     TextFormField(
//                       controller: _stockController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'Stock Quantity *',
//                         hintText: 'Enter stock quantity',
//                         prefixIcon: Icon(
//                           Icons.inventory_2_outlined,
//                           color: AppColors.primary,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter stock quantity';
//                         }
//                         if (int.tryParse(value) == null) {
//                           return 'Please enter valid quantity';
//                         }
//                         if (int.parse(value) < 0) {
//                           return 'Stock cannot be negative';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Description
//                     TextFormField(
//                       controller: _descriptionController,
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                         labelText: 'Description *',
//                         hintText: 'Enter product description',
//                         alignLabelWithHint: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter product description';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 32),

//                     // Submit Button
//                     Container(
//                       height: 56,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             AppColors.secondary,
//                             AppColors.secondary.withOpacity(0.8),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.secondary.withOpacity(0.3),
//                             blurRadius: 12,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _submitProduct,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? const SizedBox(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.5,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               )
//                             : const Text(
//                                 'Add Product',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/api_constants.dart';
import '../../../data/services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  int? _selectedCategoryId;
  List<Map<String, dynamic>> _categories = [];
  List<File> _images = [];
  bool _isLoading = false;
  bool _loadingCategories = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _loadingCategories = true);

    print('🔍 [AddProduct] Starting to load categories...');
    print('🔍 [AddProduct] Base URL: ${ApiConstants.baseUrl}');

    try {
      final result = await ProductService.getCategories();

      print('📦 [AddProduct] Result success: ${result['success']}');
      print('📦 [AddProduct] Full result: $result');

      if (result['success']) {
        final cats = result['categories'];
        print('✅ [AddProduct] Categories type: ${cats.runtimeType}');
        print('✅ [AddProduct] Categories count: ${cats.length}');
        print('✅ [AddProduct] Categories data: $cats');

        setState(() {
          _categories = List<Map<String, dynamic>>.from(cats);
        });

        print(
          '📋 [AddProduct] State updated with ${_categories.length} categories',
        );

        if (_categories.isEmpty) {
          _showError(
            'No categories found. Please ask admin to create categories.',
          );
        }
      } else {
        print('❌ [AddProduct] Failed to load categories');
        print('❌ [AddProduct] Error message: ${result['message']}');
        _showError(result['message'] ?? 'Failed to load categories');
      }
    } catch (e, stackTrace) {
      print('💥 [AddProduct] Exception caught: $e');
      print('💥 [AddProduct] Stack trace: $stackTrace');
      _showError('Error loading categories: $e');
    } finally {
      setState(() => _loadingCategories = false);
      print('🏁 [AddProduct] Loading complete. Categories: $_categories');
    }
  }

  Future<void> _pickImage() async {
    if (_images.length >= 5) {
      _showError('Maximum 5 images allowed');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _images.add(File(image.path));
        });
        print('📷 [AddProduct] Image added: ${image.path}');
      }
    } catch (e, stackTrace) {
      print('❌ [AddProduct] Error picking image: $e');
      print('❌ [AddProduct] Stack trace: $stackTrace');
      _showError('Error picking image: $e');
    }
  }

  Future<void> _takePhoto() async {
    if (_images.length >= 5) {
      _showError('Maximum 5 images allowed');
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _images.add(File(photo.path));
        });
        print('📸 [AddProduct] Photo taken: ${photo.path}');
      }
    } catch (e, stackTrace) {
      print('❌ [AddProduct] Error taking photo: $e');
      print('❌ [AddProduct] Stack trace: $stackTrace');
      _showError('Error taking photo: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    print('🗑️ [AddProduct] Image removed at index: $index');
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Product Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF6C63FF),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFF6584)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitProduct() async {
    print('🚀 [AddProduct] _submitProduct called!');

    if (!_formKey.currentState!.validate()) {
      print('❌ [AddProduct] Form validation failed');
      return;
    }

    if (_selectedCategoryId == null) {
      print('❌ [AddProduct] No category selected');
      _showError('Please select a category');
      return;
    }

    // if (_images.isEmpty) {
    //   print('❌ [AddProduct] No images added');
    //   _showError('Please add at least one product image');
    //   return;
    // }

    print('✅ [AddProduct] All validations passed');

    setState(() => _isLoading = true);

    print('📤 [AddProduct] Submitting product...');
    print('   Name: ${_nameController.text}');
    print('   Category ID: $_selectedCategoryId');
    print('   Price: ${_priceController.text}');
    print('   Stock: ${_stockController.text}');
    print('   Images: ${_images.length}');

    try {
      final result = await ProductService.createProduct(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        categoryId: _selectedCategoryId!,
        images: _images,
      );

      print('📥 [AddProduct] Result: $result');

      if (result['success']) {
        print('✅ [AddProduct] Product created successfully!');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        print('❌ [AddProduct] Failed: ${result['message']}');
        _showError(result['message'] ?? 'Failed to add product');
      }
    } catch (e, stackTrace) {
      print('💥 [AddProduct] Exception: $e');
      print('💥 [AddProduct] Stack trace: $stackTrace');
      _showError('Error adding product: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _loadingCategories
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading categories...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // No categories warning
                    if (_categories.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFFB74D),
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFFFB74D),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No Categories Found',
                                    style: TextStyle(
                                      color: Color(0xFFE65100),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Please ask the admin to create product categories first.',
                                    style: TextStyle(
                                      color: Color(0xFF757575),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Product Images Section
                    const Text(
                      'Product Images',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add up to 5 images (First image will be main)',
                      style: TextStyle(fontSize: 14, color: Color(0xFF636E72)),
                    ),
                    const SizedBox(height: 16),

                    // Image Grid
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Add Image Button
                          if (_images.length < 5)
                            InkWell(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF6C63FF),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 40,
                                      color: Color(0xFF6C63FF),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Add Image',
                                      style: TextStyle(
                                        color: Color(0xFF6C63FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Display selected images
                          ..._images.asMap().entries.map((entry) {
                            int index = entry.key;
                            File image = entry.value;
                            return Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Main badge
                                  if (index == 0)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00B894),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: const Text(
                                          'MAIN',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  // Remove button
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: InkWell(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFD63031),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Product Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name *',
                        hintText: 'Enter product name',
                        prefixIcon: Icon(Icons.shopping_bag_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      hint: Text(
                        _categories.isEmpty
                            ? 'No categories available'
                            : 'Select a category',
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category['id'],
                          child: Text(category['name']),
                        );
                      }).toList(),
                      onChanged: _categories.isEmpty
                          ? null
                          : (value) {
                              setState(() {
                                _selectedCategoryId = value;
                              });
                              print(
                                '📁 [AddProduct] Category selected: $value',
                              );
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Price
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price *',
                        hintText: 'Enter price',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Stock
                    TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock Quantity *',
                        hintText: 'Enter stock quantity',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter stock quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter valid quantity';
                        }
                        if (int.parse(value) < 0) {
                          return 'Stock cannot be negative';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Enter product description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              print('🔘 [AddProduct] Button pressed!');
                              _submitProduct();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6584),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Add Product',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
