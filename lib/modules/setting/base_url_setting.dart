import 'package:chickfit/app_config.dart';
import 'package:chickfit/data/source/local/local_storage.dart';
import 'package:chickfit/locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SettingsUrlPage extends StatefulWidget {
  const SettingsUrlPage({Key? key}) : super(key: key);

  @override
  State<SettingsUrlPage> createState() => _SettingsUrlPageState();
}

class _SettingsUrlPageState extends State<SettingsUrlPage> {
  String currentUrl = "";

  final _urlController =
      TextEditingController(text: locator<Dio>().options.baseUrl);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    currentUrl = locator<Dio>().options.baseUrl;
    super.initState();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _updateBaseUrl() {
    if (_formKey.currentState!.validate()) {
      locator<Dio>().options.baseUrl = _urlController.text.trim();
      locator<LocalDataSource>().persistBaseUrl(_urlController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Base URL berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _resetToDefault() {
    final defaultUrl = AppConfig().baseUrl;
    _urlController.text = defaultUrl;
    locator<LocalDataSource>().persistBaseUrl(defaultUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Base URL direset ke default!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan API'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Base URL API',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'URL saat ini: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(currentUrl)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                      labelText: 'Base URL Baru',
                      hintText: 'https://api.example.com',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                      fillColor: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'URL tidak boleh kosong';
                    }
                    final uri = Uri.tryParse(value.trim());

                    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
                      return 'Format URL tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _updateBaseUrl,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Perbarui URL'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetToDefault,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Reset Default'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Card(
                  color: Colors.amber[50],
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.amber),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Setelah mengubah Base URL, aplikasi akan menggunakan endpoint baru untuk semua request API.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
