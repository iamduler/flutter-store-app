import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/controllers/auth.dart';
import 'package:store_app/provider/user_provider.dart';
import 'package:store_app/services/manage_http_response.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController localityController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    stateController = TextEditingController(text: user?.state ?? '');
    cityController = TextEditingController(text: user?.city ?? '');
    localityController = TextEditingController(text: user?.locality ?? '');
  }

  // Showing loading dialog
  _showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(
                  'Loading...',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white.withValues(alpha: 0.96),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.96),
        title: Text(
          'Shipping Address',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        elevation: 0, // Remove the shadow from the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Where will your order\n be shipped',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                  controller: stateController,
                  onChanged: (value) {
                    stateController.text = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'State is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'State'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: cityController,
                  onChanged: (value) {
                    cityController.text = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'City'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: localityController,
                  onChanged: (value) {
                    localityController.text = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Locality is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Locality'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              _showLoadingDialog();
              // Save address
              await _authController
                  .saveAddress(
                    context: context,
                    id: user!.id,
                    state: stateController.text,
                    city: cityController.text,
                    locality: localityController.text,
                    ref: ref,
                  )
                  .whenComplete(() {
                    if (!context.mounted) return;
                    Navigator.pop(context); // Close the loading dialog
                    Navigator.pop(context); // Navigate back to the checkout screen
                    showSnackBar(context, 'Address saved successfully');
                  })
                  .catchError((error) {
                    if (!context.mounted) return;
                    Navigator.pop(context); // Close the loading dialog
                    showSnackBar(context, 'Error saving address: $error');
                  });
            } else {
              showSnackBar(context, 'Please fill all the fields');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF1532F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Save Address',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
