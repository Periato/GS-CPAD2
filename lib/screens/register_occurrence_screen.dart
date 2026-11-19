
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/occurrence.dart';
import '../services/occurrence_service.dart';
import '../theme/app_theme.dart';

class RegisterOccurrenceScreen extends StatefulWidget {
  const RegisterOccurrenceScreen({super.key});

  @override
  State<RegisterOccurrenceScreen> createState() =>
      _RegisterOccurrenceScreenState();
}

class _RegisterOccurrenceScreenState
    extends State<RegisterOccurrenceScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedNeighborhood;
  String? _selectedType;
  String _description = '';
  String _referencePoint = '';

  bool _isSaving = false;

  final List<String> _neighborhoods = [
    'Bairro Central',
    'Jardim das Flores',
    'Vila Nova',
  ];

  final List<String> _types = [
    'Alagamento em via pública',
    'Inundação de residência',
    'Bueiro entupido',
    'Deslizamento de terra',
    'Outro',
  ];

  Future<void> _registerOccurrence() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final occurrence = Occurrence(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      neighborhood: _selectedNeighborhood!,
      type: _selectedType!,
      description: _description,
      referencePoint: _referencePoint,
      date: DateTime.now(),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      await Provider.of<OccurrenceService>(
        context,
        listen: false,
      ).addOccurrence(occurrence);

      if (!mounted) return;

      _formKey.currentState!.reset();

      setState(() {
        _selectedNeighborhood = null;
        _selectedType = null;
        _description = '';
        _referencePoint = '';
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Ocorrência registrada com sucesso!',
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível salvar a ocorrência. Tente novamente.',
          ),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar Ocorrência',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Novo registro',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Informe os detalhes da ocorrência para contribuir '
                'com o monitoramento territorial.',
                style: TextStyle(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              _buildLabel('Bairro'),

              DropdownButtonFormField<String>(
                initialValue: _selectedNeighborhood,
                decoration: _inputDecoration(
                  hint: 'Selecione o bairro',
                  icon: Icons.location_city,
                ),
                items: _neighborhoods.map((neighborhood) {
                  return DropdownMenuItem(
                    value: neighborhood,
                    child: Text(neighborhood),
                  );
                }).toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _selectedNeighborhood = value;
                        });
                      },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um bairro';
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedNeighborhood = value;
                },
              ),

              const SizedBox(height: 20),

              _buildLabel('Tipo de ocorrência'),

              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: _inputDecoration(
                  hint: 'Selecione o tipo',
                  icon: Icons.warning_amber_rounded,
                ),
                items: _types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione o tipo de ocorrência';
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedType = value;
                },
              ),

              const SizedBox(height: 20),

              _buildLabel('Descrição'),

              TextFormField(
                enabled: !_isSaving,
                maxLines: 4,
                maxLength: 300,
                decoration: _inputDecoration(
                  hint: 'Descreva o que aconteceu...',
                  icon: Icons.description_outlined,
                ),
                onSaved: (value) {
                  _description = value!.trim();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe uma descrição';
                  }
                  if (value.trim().length < 10) {
                    return 'A descrição deve ter pelo menos 10 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              _buildLabel('Ponto de referência (opcional)'),

              TextFormField(
                enabled: !_isSaving,
                maxLength: 100,
                decoration: _inputDecoration(
                  hint: 'Ex.: próximo à praça central',
                  icon: Icons.place_outlined,
                ),
                onSaved: (value) {
                  _referencePoint = value?.trim() ?? '';
                },
              ),

              const SizedBox(height: 8),

              const Text(
                'Evite informar nomes, telefones ou outros dados pessoais de moradores.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _registerOccurrence,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add_circle_outline),
                  label: Text(
                    _isSaving
                        ? 'Salvando...'
                        : 'Registrar ocorrência',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Os registros contribuem para o monitoramento '
                  'e a prevenção de alagamentos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.secondary),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppTheme.secondary,
          width: 1.5,
        ),
      ),
    );
  }
}
