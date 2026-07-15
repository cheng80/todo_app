import 'package:flutter/material.dart';

import 'todo.dart';
import 'todo_repository.dart';

/// Todo를 새로 만들거나 기존 Todo를 수정하는 입력 화면 컴포넌트입니다.
class TodoEditorPage extends StatefulWidget {
  const TodoEditorPage({super.key, required this.repository, this.todo});

  /// 저장 요청을 처리할 Todo 저장소입니다.
  final TodoRepository repository;

  /// 수정 모드에서는 기존 Todo를 전달하고, 추가 모드에서는 비워 둡니다.
  final Todo? todo;

  @override
  State<TodoEditorPage> createState() => _TodoEditorPageState();
}

class _TodoEditorPageState extends State<TodoEditorPage> {
  /// 제목 입력 검증을 실행하는 폼 키입니다.
  final _formKey = GlobalKey<FormState>();

  /// 제목과 본문 입력값을 유지하는 컨트롤러입니다.
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  /// 저장 중에는 중복 저장을 막기 위한 상태입니다.
  var _isSaving = false;

  /// 기존 Todo 값으로 입력 필드를 초기화합니다.
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title);
    _contentController = TextEditingController(text: widget.todo?.content);
  }

  /// 입력 컨트롤러를 해제해 메모리 누수를 막습니다.
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 제목을 검증한 뒤 Todo를 생성하거나 수정하고 목록 화면으로 돌아갑니다.
  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();
      final todo = widget.todo;
      if (todo == null) {
        await widget.repository.create(title: title, content: content);
      } else {
        await widget.repository.update(
          todo.copyWith(title: title, content: content),
        );
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Todo를 저장하지 못했습니다.')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Todo 수정' : 'Todo 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('todoTitle'),
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '제목을 입력해 주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '본문 (선택)'),
                maxLines: 4,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: Text(_isSaving ? '저장 중...' : '저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
