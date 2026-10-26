import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_state.dart';
import '../app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/fade_slide.dart';
import '../widgets/gradient_button.dart';
import '../widgets/option_sheet.dart';
import 'success_screen.dart';

class ScheduleGameScreen extends StatefulWidget {
  const ScheduleGameScreen({super.key});

  @override
  State<ScheduleGameScreen> createState() => _ScheduleGameScreenState();
}

class _ScheduleGameScreenState extends State<ScheduleGameScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _category = TextEditingController();
  final _price = TextEditingController();
  final _desc = TextEditingController();

  late DateTime _fromDate;
  late DateTime _toDate;
  TimeOfDay _fromTime = const TimeOfDay(hour: 12, minute: 30);
  TimeOfDay _toTime = const TimeOfDay(hour: 14, minute: 0);
  bool _reminder = true;
  bool _loading = false;

  static const _categories = ['Action', 'Sports', 'Puzzle', 'Strategy', 'Racing'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, now.day);
    _toDate = _fromDate;
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _price.dispose();
    _desc.dispose();
    super.dispose();
  }

  DateTime _combine(DateTime d, TimeOfDay t) =>
      DateTime(d.year, d.month, d.day, t.hour, t.minute);

  Future<void> _pickDate(bool from) async {
    final initial = from ? _fromDate : _toDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked == null) return;
    setState(() {
      if (from) {
        _fromDate = picked;
        if (_toDate.isBefore(picked)) _toDate = picked;
      } else {
        _toDate = picked;
      }
    });
  }

  Future<void> _pickTime(bool from) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: from ? _fromTime : _toTime,
    );
    if (picked == null) return;
    setState(() {
      if (from) {
        _fromTime = picked;
      } else {
        _toTime = picked;
      }
    });
  }

  Future<void> _pickCategory() async {
    final v = await showOptionSheet(
      context,
      title: 'Category',
      options: _categories,
      selected: _category.text.isEmpty ? null : _category.text,
    );
    if (v != null) setState(() => _category.text = v);
  }

  Future<void> _publish() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    final from = _combine(_fromDate, _fromTime);
    final to = _combine(_toDate, _toTime);
    if (!to.isAfter(from)) {
      toast(context, 'Время окончания должно быть позже начала');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    AppState.addGame(
      ScheduledGame(
        name: _name.text.trim(),
        category: _category.text,
        price: _price.text.trim(),
        description: _desc.text.trim(),
        from: from,
        to: to,
        reminder: _reminder,
      ),
    );
    final result = await Navigator.of(context).push<String>(successRoute());
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  Widget _picker(String text, VoidCallback onTap, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.fieldBorder)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(text, style: ps(10, w: FontWeight.w500)),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _range(String label, DateTime d, TimeOfDay t, bool from) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ps(8.5, color: AppColors.primary, w: FontWeight.w600)),
        Row(
          children: [
            _picker(formatDate(d), () => _pickDate(from), flex: 3),
            const SizedBox(width: 18),
            _picker(formatTime(t), () => _pickTime(from), flex: 2),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                ),
                FadeSlide(
                  child: Text(
                    'Schedule Game',
                    style: ps(18, w: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                FadeSlide(
                  delay: const Duration(milliseconds: 100),
                  child: CustomTextField(
                    label: 'Game Name',
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Введите название игры' : null,
                  ),
                ),
                const SizedBox(height: 10),
                FadeSlide(
                  delay: const Duration(milliseconds: 170),
                  child: CustomTextField(
                    label: 'Category',
                    controller: _category,
                    readOnly: true,
                    onTap: _pickCategory,
                    suffix: const Icon(Icons.keyboard_arrow_down,
                        size: 18, color: AppColors.primary),
                    validator: (v) =>
                        (v ?? '').isEmpty ? 'Выберите категорию' : null,
                  ),
                ),
                const SizedBox(height: 10),
                FadeSlide(
                  delay: const Duration(milliseconds: 240),
                  child: CustomTextField(
                    label: 'Winning Price',
                    controller: _price,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Укажите приз' : null,
                  ),
                ),
                const SizedBox(height: 22),
                FadeSlide(
                  delay: const Duration(milliseconds: 310),
                  child: _range('From', _fromDate, _fromTime, true),
                ),
                const SizedBox(height: 14),
                FadeSlide(
                  delay: const Duration(milliseconds: 380),
                  child: _range('To', _toDate, _toTime, false),
                ),
                const SizedBox(height: 28),
                FadeSlide(
                  delay: const Duration(milliseconds: 450),
                  child: CustomTextField(
                    label: 'Description',
                    controller: _desc,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 18),
                FadeSlide(
                  delay: const Duration(milliseconds: 520),
                  child: Row(
                    children: [
                      Text(
                        'REMINDERS',
                        style: ps(8.5, w: FontWeight.w600, color: AppColors.primary),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: _reminder,
                          activeColor: AppColors.primary,
                          visualDensity: VisualDensity.compact,
                          onChanged: (v) => setState(() => _reminder = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Notification', style: ps(9)),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                FadeSlide(
                  delay: const Duration(milliseconds: 600),
                  child: Center(
                    child: GradientButton(
                      label: 'Publish',
                      width: 190,
                      loading: _loading,
                      onTap: _publish,
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
