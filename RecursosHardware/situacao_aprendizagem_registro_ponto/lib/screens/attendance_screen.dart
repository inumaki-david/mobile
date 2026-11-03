import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../config/app_config.dart';
import '../models/api_exception.dart';
import '../models/attendance_record.dart';
import '../models/employee.dart';
import '../models/workplace.dart';
import '../services/attendance_api.dart';
import '../services/location_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({
    super.key,
    required this.employee,
    required this.onSignOut,
  });

  final Employee employee;
  final VoidCallback onSignOut;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _api = AttendanceApi();
  final _locationService = LocationService();
  Workplace? _workplace;
  List<AttendanceRecord> _records = [];
  bool _isLoading = true;
  bool _isRegistering = false;
  bool _hasLoadedRecords = false;
  String? _errorMessage;
  double? _lastDistance;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _api.close();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await Future.wait<Object>([
        _api.loadWorkplace(),
        _api.loadTodayRecords(widget.employee.id),
      ]);
      if (!mounted) return;
      setState(() {
        _workplace = results[0] as Workplace;
        _records = results[1] as List<AttendanceRecord>;
        _hasLoadedRecords = true;
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _registerAttendance() async {
    final workplace = _workplace;
    if (workplace == null || _isRegistering) return;
    setState(() {
      _isRegistering = true;
      _errorMessage = null;
      _lastDistance = null;
    });

    try {
      final position = await _locationService.currentPosition();
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        workplace.latitude,
        workplace.longitude,
      );
      if (!mounted) return;
      setState(() => _lastDistance = distance);

      if (!AppConfig.isWithinAttendanceRadius(distance)) {
        setState(() {
          _errorMessage =
              'Você está a ${distance.round()} m do local. O limite permitido é 100 m.';
        });
        return;
      }

      final record = await _api.createAttendance(
        employee: widget.employee,
        type: attendanceTypeForIndex(_records.length),
        timestamp: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
        distanceMeters: distance,
      );
      if (!mounted) return;
      setState(() {
        _records = [..._records, record];
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ponto registrado com sucesso!')),
      );
    } on LocationException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } on ApiException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } on PlatformException catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage = 'Falha ao obter localização: ${error.message}',
        );
      }
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  Future<void> _signOut() async {
    widget.onSignOut();
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    return '${dateTime.day} de ${months[dateTime.month - 1]} de ${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final nextType = attendanceTypeForIndex(_records.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ponto Certo',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: _signOut,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Text(
              'Olá, ${widget.employee.name.split(' ').first}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF15233F),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatDate(DateTime.now()),
              style: const TextStyle(color: Color(0xFF667085), fontSize: 15),
            ),
            const SizedBox(height: 24),
            _AttendanceActionCard(
              isLoading: _isLoading,
              isRegistering: _isRegistering,
              workplace: _workplace,
              nextType: nextType,
              radiusMeters: AppConfig.attendanceRadiusMeters,
              onRegister: _registerAttendance,
              onRetry: _loadData,
            ),
            if (_lastDistance != null) ...[
              const SizedBox(height: 14),
              _DistanceCard(distance: _lastDistance!),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 14),
              _InlineError(message: _errorMessage!),
            ],
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Registros de hoje',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF15233F),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${_records.length} ${_records.length == 1 ? 'ponto' : 'pontos'}',
                  style: const TextStyle(color: Color(0xFF667085)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoading && _records.isEmpty)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_hasLoadedRecords && _records.isEmpty)
              const _EmptyRecordsCard()
            else
              ..._records.asMap().entries.map(
                (entry) => _RecordTile(
                  record: entry.value,
                  index: entry.key,
                  time: _formatTime(entry.value.timestamp),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceActionCard extends StatelessWidget {
  const _AttendanceActionCard({
    required this.isLoading,
    required this.isRegistering,
    required this.workplace,
    required this.nextType,
    required this.radiusMeters,
    required this.onRegister,
    required this.onRetry,
  });

  final bool isLoading;
  final bool isRegistering;
  final Workplace? workplace;
  final String nextType;
  final double radiusMeters;
  final VoidCallback onRegister;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF15233F), Color(0xFF24436A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.my_location_rounded,
            color: Color(0xFF7CDED3),
            size: 28,
          ),
          const SizedBox(height: 16),
          Text(
            workplace?.name ?? 'Local de trabalho',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Registre até ${radiusMeters.round()} m deste local',
            style: const TextStyle(color: Color(0xFFD4DCE7), fontSize: 14),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading || workplace == null || isRegistering
                  ? null
                  : onRegister,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7CDED3),
                foregroundColor: const Color(0xFF15233F),
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: isRegistering
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.fingerprint_rounded),
              label: Text(
                isRegistering
                    ? 'Verificando localização...'
                    : 'Registrar $nextType',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          if (!isLoading && workplace == null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onRetry,
                child: const Text(
                  'Tentar novamente',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DistanceCard extends StatelessWidget {
  const _DistanceCard({required this.distance});

  final double distance;

  @override
  Widget build(BuildContext context) {
    final insideRadius = distance <= AppConfig.attendanceRadiusMeters;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insideRadius ? const Color(0xFFE8F5F1) : const Color(0xFFFFF3E4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            insideRadius ? Icons.check_circle_outline : Icons.near_me_disabled,
            color: insideRadius
                ? const Color(0xFF168B83)
                : const Color(0xFFB76A12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Distância do trabalho: ${distance.round()} m',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.record,
    required this.index,
    required this.time,
  });

  final AttendanceRecord record;
  final int index;
  final String time;

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFE9EDF2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE3F3F1),
          foregroundColor: const Color(0xFF168B83),
          child: Icon(
            isFirst ? Icons.login_rounded : Icons.access_time_rounded,
          ),
        ),
        title: Text(
          record.type,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Distância: ${record.distanceMeters.round()} m'),
        trailing: Text(
          time,
          style: const TextStyle(
            color: Color(0xFF15233F),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EmptyRecordsCard extends StatelessWidget {
  const _EmptyRecordsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE9EDF2)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            color: Color(0xFF98A2B3),
            size: 30,
          ),
          SizedBox(height: 10),
          Text(
            'Nenhum ponto registrado hoje',
            style: TextStyle(color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFB42318), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFB42318)),
            ),
          ),
        ],
      ),
    );
  }
}
