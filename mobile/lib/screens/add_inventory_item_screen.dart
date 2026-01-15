import "dart:async";

import "package:flutter/material.dart";

import "../environment/env.dart";
import "../backend/catalog_api.dart";
import "../backend/inventory_api.dart";

class AddInventoryItemScreen extends StatefulWidget {
  const AddInventoryItemScreen({super.key});

  @override
  State<AddInventoryItemScreen> createState() =>
      _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends State<AddInventoryItemScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final CatalogApi _catalogApi = CatalogApi();
  final InventoryApi _inventoryApi = InventoryApi();

  Timer? _debounceTimer;
  int _requestId = 0;
  bool _isSearching = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String _selectedUnit = "";
  CatalogItem? _selectedItem;
  List<CatalogItem> _suggestions = [];
  bool _hasLoggedSearchUrl = false;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _ingredientController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _selectedItem = null;
      _selectedUnit = "";
      _errorMessage = null;
    });

    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      _requestId++;
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    if (!_hasLoggedSearchUrl) {
      final uri = Uri.parse("${Env.baseUrl}/api/v1/catalog/search")
          .replace(queryParameters: {"q": trimmed});
      print("Catalog search URL: $uri");
      _hasLoggedSearchUrl = true;
    }

    setState(() {
      _isSearching = true;
    });
    final currentRequestId = ++_requestId;
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        final results = await _catalogApi.search(trimmed);
        if (!mounted || currentRequestId != _requestId) {
          return;
        }
        setState(() {
          _suggestions = results.take(10).toList();
          _isSearching = false;
        });
      } catch (_) {
        if (!mounted || currentRequestId != _requestId) {
          return;
        }
        setState(() {
          _suggestions = [];
          _isSearching = false;
        });
      }
    });
  }

  void _selectSuggestion(CatalogItem item) {
    setState(() {
      _selectedItem = item;
      _selectedUnit = item.defaultUnit;
      _ingredientController.text = item.name;
      _suggestions = [];
      _errorMessage = null;
    });
  }

  bool get _canSubmit {
    final quantity = double.tryParse(_quantityController.text.trim());
    return _selectedItem != null && quantity != null && quantity > 0;
  }

  String _formatQuantitySuffix() {
    final trimmedUnit = _selectedUnit.trim();
    if (trimmedUnit.isEmpty) {
      return "";
    }
    return trimmedUnit;
  }

  Future<void> _submit() async {
    if (_selectedItem == null) {
      setState(() {
        _errorMessage = "Please select an ingredient from the list.";
      });
      return;
    }

    if (!_canSubmit) {
      setState(() {
        _errorMessage = "Please enter a valid quantity.";
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final quantity = double.parse(_quantityController.text.trim());
      final unit = _selectedItem!.defaultUnit;
      print(
        "AddInventoryItem payload: ingredient_catalog_id=${_selectedItem!.id} quantity=$quantity unit=$unit",
      );
      await _inventoryApi.addInventoryItem(
        ingredientCatalogId: _selectedItem!.id,
        name: _selectedItem!.name,
        quantity: quantity,
        unit: unit,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = "Something went wrong. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Ingredient"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _ingredientController,
                decoration: const InputDecoration(
                  labelText: "Ingredient name",
                  border: OutlineInputBorder(),
                ),
                onChanged: _onQueryChanged,
              ),
              const SizedBox(height: 12),
              if (_isSearching)
                const SizedBox(
                  height: 20,
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              if (_suggestions.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final item = _suggestions[index];
                      return ListTile(
                        title: Text(item.name),
                        onTap: () => _selectSuggestion(item),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  border: const OutlineInputBorder(),
                  suffixText: _formatQuantitySuffix(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _canSubmit && !_isSubmitting ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9DB67B),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
