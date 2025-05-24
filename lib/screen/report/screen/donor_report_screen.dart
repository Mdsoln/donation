import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/donor_report_model.dart';
import '../models/report_request_model.dart';
import '../service/generate_report_service.dart';
import '../service/export_report_service.dart';

class DonorReportScreen extends StatefulWidget {
  const DonorReportScreen({super.key});

  @override
  _DonorReportScreenState createState() => _DonorReportScreenState();
}

class _DonorReportScreenState extends State<DonorReportScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  // Form values
  String _reportType = 'QUARTERLY';
  String _reportFormat = 'JSON';
  int _year = DateTime.now().year;
  int _quarter = (DateTime.now().month - 1) ~/ 3 + 1;
  int _yearOnly = DateTime.now().year;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _includeAppointmentStats = true;
  bool _includeRequestStats = true;
  bool _includeHospitalBreakdown = true;

  // Available options
  final List<int> _years = List.generate(
      6, (index) => DateTime.now().year - index);
  final List<int> _quarters = [1, 2, 3, 4];

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
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Generate Donation Report',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Report Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Report Type',
                  border: OutlineInputBorder(),
                ),
                value: _reportType,
                items: const [
                  DropdownMenuItem(value: 'QUARTERLY', child: Text('Quarterly')),
                  DropdownMenuItem(value: 'YEARLY', child: Text('Yearly')),
                  DropdownMenuItem(value: 'CUSTOM', child: Text('Custom Date Range')),
                  DropdownMenuItem(value: 'ALL_TIME', child: Text('All Time')),
                ],
                onChanged: (value) {
                  setState(() {
                    _reportType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Report Format
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Report Format',
                  border: OutlineInputBorder(),
                ),
                value: _reportFormat,
                items: const [
                  DropdownMenuItem(value: 'JSON', child: Text('JSON (View Online)')),
                  DropdownMenuItem(value: 'PDF', child: Text('PDF')),
                  DropdownMenuItem(value: 'EXCEL', child: Text('Excel')),
                ],
                onChanged: (value) {
                  setState(() {
                    _reportFormat = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Quarterly Options
              if (_reportType == 'QUARTERLY') ...[
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(),
                        ),
                        value: _year,
                        items: _years.map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _year = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Quarter',
                          border: OutlineInputBorder(),
                        ),
                        value: _quarter,
                        items: _quarters.map((quarter) => DropdownMenuItem(
                          value: quarter,
                          child: Text('Q$quarter'),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _quarter = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Yearly Options
              if (_reportType == 'YEARLY') ...[
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  value: _yearOnly,
                  items: _years.map((year) => DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _yearOnly = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Custom Date Range Options
              if (_reportType == 'CUSTOM') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: _startDate != null
                              ? DateFormat('yyyy-MM-dd').format(_startDate!)
                              : '',
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _startDate = date;
                            });
                          }
                        },
                        validator: (value) {
                          if (_reportType == 'CUSTOM' && _startDate == null) {
                            return 'Please select a start date';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: _endDate != null
                              ? DateFormat('yyyy-MM-dd').format(_endDate!)
                              : '',
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _endDate = date;
                            });
                          }
                        },
                        validator: (value) {
                          if (_reportType == 'CUSTOM' && _endDate == null) {
                            return 'Please select an end date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Additional Options
              CheckboxListTile(
                title: const Text('Include Appointment Statistics'),
                value: _includeAppointmentStats,
                onChanged: (value) {
                  setState(() {
                    _includeAppointmentStats = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: const Text('Include Request Statistics'),
                value: _includeRequestStats,
                onChanged: (value) {
                  setState(() {
                    _includeRequestStats = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: const Text('Include Hospital Breakdown'),
                value: _includeHospitalBreakdown,
                onChanged: (value) {
                  setState(() {
                    _includeHospitalBreakdown = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 16),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _generateReport,
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Text('Generate Report'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _exportReport('PDF'),
                    child: const Text('PDF'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _exportReport('EXCEL'),
                    child: const Text('Excel'),
                  ),
                ],
              ),
            ],
          ),
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

  Widget _buildReportResults() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report for ${_report!.donorName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Period: ${_report!.reportPeriod}'),
            const SizedBox(height: 16),

            // Donation Summary
            const Text(
              'Donation Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Total Donations', '${_report!.totalDonations}'),
            _buildInfoRow('Total Volume', '${_report!.totalVolumeMl.toStringAsFixed(2)} ml'),
            if (_report!.firstDonationDate != null)
              _buildInfoRow('First Donation', _report!.formatDate(_report!.firstDonationDate!)),
            if (_report!.lastDonationDate != null)
              _buildInfoRow('Last Donation', _report!.formatDate(_report!.lastDonationDate!)),
            const SizedBox(height: 16),

            // Appointment Statistics
            if (_includeAppointmentStats) ...[
              const Text(
                'Appointment Statistics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow('Total Appointments', '${_report!.totalAppointments}'),
              _buildInfoRow('Completed', '${_report!.completedAppointments}'),
              _buildInfoRow('Scheduled', '${_report!.scheduledAppointments}'),
              _buildInfoRow('Expired', '${_report!.expiredAppointments}'),
              _buildInfoRow('Cancelled', '${_report!.cancelledAppointments}'),
              const SizedBox(height: 16),
            ],

            // Hospital Breakdown
            if (_includeHospitalBreakdown && _report!.hospitalData.isNotEmpty) ...[
              const Text(
                'Hospital Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Hospital')),
                  DataColumn(label: Text('Donations')),
                  DataColumn(label: Text('Volume (ml)')),
                ],
                rows: _report!.hospitalData.map<DataRow>((hospital) {
                  return DataRow(
                    cells: [
                      DataCell(Text(hospital.hospitalName)),
                      DataCell(Text('${hospital.donations}')),
                      DataCell(Text(hospital.volumeMl.toStringAsFixed(2))),
                    ],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Service instances
  final GenerateReportService _generateReportService = GenerateReportService();
  final ExportReportService _exportReportService = ExportReportService();

  // DonorReport model instance
  DonorReport? _report;

  Future<void> _generateReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Create a ReportRequest object
      final request = _createReportRequest();

      // Call the service
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
      // Create a ReportRequest object
      final request = _createReportRequest();

      // Call the service
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
