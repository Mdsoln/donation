import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/donor_report_model.dart';
import '../models/report_request_model.dart';
import '../service/export_report_service.dart';
import '../service/generate_report_service.dart';



class DonorReportScreen extends StatefulWidget {
  const DonorReportScreen({super.key});

  @override
  State<DonorReportScreen> createState() => _DonorReportScreenState();
}

class _DonorReportScreenState extends State<DonorReportScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  // Form values
  final String _reportType = 'QUARTERLY';
  final String _reportFormat = 'JSON';
  final int _year = DateTime.now().year;
  final int _quarter = (DateTime.now().month - 1) ~/ 3 + 1;
  final int _yearOnly = DateTime.now().year;
  DateTime? _startDate;
  DateTime? _endDate;
  final bool _includeAppointmentStats = true;
  final bool _includeRequestStats = true;
  final bool _includeHospitalBreakdown = true;

  // Available options
  final List<int> _years = List.generate(6, (index) => DateTime.now().year - index);
  final List<int> _quarters = [1, 2, 3, 4];

  // DonorReport model instance
  DonorReport? _report;

  // Service instances (replace with your actual services)
  final GenerateReportService _generateReportService = GenerateReportService();
  final ExportReportService _exportReportService = ExportReportService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildReportForm(),
            if (_error != null) _buildErrorMessage(),
            if (_report != null) _buildReportResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _isLoading ? null : _generateReport,
            child: _isLoading ? const CircularProgressIndicator() : const Text('Generate Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportResults() {
    final report = _report!;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This report is a comprehensive summary of your actions\nin serving lives for the past 3 months',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _exportReport(_reportFormat),
                icon: const Icon(Icons.download),
                label: const Text("Export as"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
            const Divider(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Donor: ${report.donorName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Blood Group: ${report.bloodGroup}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Location: ${report.location}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Optional: to match design
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Donation Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildKeyValue("Total Donation", report.totalDonations.toString()),
                  _buildKeyValue("Last Donation", _formatDate(report.lastDonationDate)),
                  _buildKeyValue("Eligible Date", _formatDate(report.eligibleDate)),
                ],
              ),
            ),
            const Divider(),
            _buildSectionTitle("Donation Summary"),
            _buildKeyValue("Total Donation", report.totalDonations.toString()),
            _buildKeyValue("Last Donation", _formatDate(report.lastDonationDate)),
            _buildKeyValue("Eligible Date", _formatDate(report.eligibleDate)),
            const Divider(),
            _buildSectionTitle("Appointments"),
            _buildKeyValue("Appointments Booked", report.scheduledAppointments.toString()),
            _buildKeyValue("Appointments Attended", report.completedAppointments.toString()),
            _buildKeyValue("Appointments Missed", report.expiredAppointments.toString()),
            const Divider(),
            _buildSectionTitle("Top Donation Center"),
            _buildKeyValue("Center", report.topDonationCenter ?? "N/A"),
            const Divider(),
            _buildSectionTitle("Most Active Month"),
            _buildKeyValue("Month", report.mostActiveMonth ?? "N/A"),
            const Divider(),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "All copyrights are reserved",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        color: Colors.red[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _error!,
            style: TextStyle(color: Colors.red[900]),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
      ),
    );
  }

  Widget _buildKeyValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$key:",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return "N/A";
    }
  }

  Future<void> _generateReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final request = _createReportRequest();
      final result = await _generateReportService.generateReport(request);

      if (result['success']) {
        setState(() {
          _report = result['data'];
        });
      } else {
        setState(() {
          _error = result['error'];
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error generating report: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _exportReport(String format) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final request = _createReportRequest();
      final result = await _exportReportService.exportReport(request, format);

      if (!result['success']) {
        setState(() {
          _error = result['error'];
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error exporting report: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  ReportRequest _createReportRequest() {
    return ReportRequest(
      reportType: _reportType,
      reportFormat: _reportFormat,
      year: _reportType == 'QUARTERLY' ? _year : null,
      quarter: _reportType == 'QUARTERLY' ? _quarter : null,
      yearOnly: _reportType == 'YEARLY' ? _yearOnly : null,
      startDate: _reportType == 'CUSTOM' ? _startDate : null,
      endDate: _reportType == 'CUSTOM' ? _endDate : null,
      includeAppointmentStats: _includeAppointmentStats,
      includeRequestStats: _includeRequestStats,
      includeHospitalBreakdown: _includeHospitalBreakdown,
    );
  }
}