import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/app_data.dart';
import '../services/api_service.dart';
import '../widgets/section_title.dart';


class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
 
  List<ApiFamilyMember> _members = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  
  Future<void> _fetchMembers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await ApiService.getFamilyMembers();
      if (!mounted) return;
      setState(() {
        _members = list;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Impossible de charger les membres. Vérifiez WampServer.';
        _isLoading = false;
      });
    }
  }

 
  Future<void> _confirmAndDelete(ApiFamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le membre'),
        content: Text('Supprimer ${member.fullName} (${member.parente}) ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ApiService.deleteFamilyMember(member.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre supprimé.')),
      );
      await _fetchMembers();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la suppression.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  
  Future<void> _openForm({ApiFamilyMember? member}) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF101B32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MemberFormModal(existing: member),
    );

    if (saved == true) {
      await _fetchMembers();
    }
  }

  String _initialsOf(ApiFamilyMember member) {
    final source = member.prenom.isNotEmpty
        ? member.prenom
        : (member.nom.isNotEmpty ? member.nom : '?');
    return source.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF38BDF8),
        foregroundColor: const Color(0xFF080B11),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text(
          'Ajouter',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchMembers,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 88),
          children: [
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF101B32),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.family_restroom,
                    color: Color(0xFF38BDF8),
                    size: 38,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ma famille',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Les personnes qui comptent pour moi.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SectionTitle(
              title: 'Membres de ma famille',
              subtitle: 'Données synchronisées avec la base via l\'API REST.',
              titleColor: Colors.white,
            ),
          
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _fetchMembers,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_members.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Aucun membre enregistré. Appuyez sur "Ajouter".',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              )
            else
              ..._members.map(
                (member) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        
                        CircleAvatar(
                          radius: 29,
                          backgroundColor: const Color(
                            0xFF38BDF8,
                          ).withValues(alpha: 0.15),
                          backgroundImage: (member.imageUrl != null &&
                                  member.imageUrl!.isNotEmpty)
                              ? NetworkImage(member.imageUrl!)
                              : null,
                          child: (member.imageUrl == null ||
                                  member.imageUrl!.isEmpty)
                              ? Text(
                                  _initialsOf(member),
                                  style: const TextStyle(
                                    color: Color(0xFF38BDF8),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        // INFORMATIONS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 246, 246, 247),
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                member.parente,
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Né(e) le ${member.dateNaissance} — ${member.lieuNaissance}',
                                style: TextStyle(
                                  color: Colors.blueGrey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        IconButton(
                          tooltip: 'Modifier',
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Color(0xFF38BDF8),
                          ),
                          onPressed: () => _openForm(member: member),
                        ),
                        IconButton(
                          tooltip: 'Supprimer',
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade300,
                          ),
                          onPressed: () => _confirmAndDelete(member),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class _MemberFormModal extends StatefulWidget {
  final ApiFamilyMember? existing;

  const _MemberFormModal({this.existing});

  @override
  State<_MemberFormModal> createState() => _MemberFormModalState();
}

class _MemberFormModalState extends State<_MemberFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _nomCtrl;
  late final TextEditingController _postnomCtrl;
  late final TextEditingController _prenomCtrl;
  late final TextEditingController _lieuCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _parenteCtrl;

  XFile? _imageFile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    _nomCtrl = TextEditingController(text: m?.nom ?? '');
    _postnomCtrl = TextEditingController(text: m?.postnom ?? '');
    _prenomCtrl = TextEditingController(text: m?.prenom ?? '');
    _lieuCtrl = TextEditingController(text: m?.lieuNaissance ?? '');
    _dateCtrl = TextEditingController(text: m?.dateNaissance ?? '');
    _parenteCtrl = TextEditingController(text: m?.parente ?? '');
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _postnomCtrl.dispose();
    _prenomCtrl.dispose();
    _lieuCtrl.dispose();
    _dateCtrl.dispose();
    _parenteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _imageFile = picked);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_dateCtrl.text) ?? DateTime(1995);
    final chosen = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (chosen != null) {
      final y = chosen.year.toString().padLeft(4, '0');
      final m = chosen.month.toString().padLeft(2, '0');
      final d = chosen.day.toString().padLeft(2, '0');
      _dateCtrl.text = '$y-$m-$d';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      if (widget.existing == null) {
        await ApiService.createFamilyMember(
          nom: _nomCtrl.text,
          postnom: _postnomCtrl.text,
          prenom: _prenomCtrl.text,
          lieuNaissance: _lieuCtrl.text,
          dateNaissance: _dateCtrl.text,
          parente: _parenteCtrl.text,
          imageFile: _imageFile,
        );
      } else {
        await ApiService.updateFamilyMember(
          id: widget.existing!.id,
          nom: _nomCtrl.text,
          postnom: _postnomCtrl.text,
          prenom: _prenomCtrl.text,
          lieuNaissance: _lieuCtrl.text,
          dateNaissance: _dateCtrl.text,
          parente: _parenteCtrl.text,
          newImageFile: _imageFile,
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'enregistrement.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + inset),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEdit ? 'Modifier un membre' : 'Ajouter un membre',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nomCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Nom *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _postnomCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Postnom *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _prenomCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Prénom *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lieuCtrl,
                style: const TextStyle(color: Colors.white),
                decoration:
                    const InputDecoration(labelText: 'Lieu de naissance *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _pickDate,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Date de naissance (AAAA-MM-JJ) *',
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.white70),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _parenteCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Lien de parenté (Père, Mère, Frère...) *',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _saving ? null : _pickImage,
                icon: const Icon(Icons.image_outlined, color: Color(0xFF38BDF8)),
                label: Text(
                  _imageFile != null
                      ? 'Image : ${_imageFile!.name}'
                      : (isEdit
                          ? 'Changer l\'image (facultatif)'
                          : 'Choisir une image (facultatif)'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _saving ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: const Color(0xFF080B11),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isEdit ? 'Enregistrer' : 'Ajouter',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
