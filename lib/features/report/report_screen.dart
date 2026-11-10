import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/imigongo.dart';
import '../today/cycle_controller.dart';

/// Report for the nurse (screen 11). Built from logged cycles only; no
/// analytics event carries any of its content.
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cycles = context.watch<CycleController>();
    final data = cycles.buildReport();
    final theme = Theme.of(context);
    final first = data.cycles.isEmpty ? null : data.cycles.first.start;
    final today = dayOnly(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(l.reportTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 6, color: AppColors.terracotta),
                    const SizedBox(height: AppSpace.md),
                    Text(l.reportSummary, style: theme.textTheme.titleLarge),
                    if (first != null)
                      Text(
                        '${l.dayMonthYear(first)} – ${l.dayMonthYear(today)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    const SizedBox(height: AppSpace.md),
                    Row(
                      children: [
                        Expanded(
                          child: _Box(
                            label: l.reportCycleCol,
                            value: '${data.averageCycle}',
                          ),
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(
                          child: _Box(
                            label: l.reportPeriodCol,
                            value: '${data.averagePeriod}',
                          ),
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(
                          child: _Box(
                            label: l.reportLast,
                            value: data.lastStart == null
                                ? '–'
                                : shortDate(data.lastStart!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.lg),
                    if (data.cycles.isEmpty)
                      Text(l.reportNoData)
                    else
                      _CyclesTable(data: data),
                    const SizedBox(height: AppSpace.lg),
                    Text(l.reportSymptoms, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpace.sm),
                    Wrap(
                      spacing: AppSpace.sm,
                      runSpacing: AppSpace.sm,
                      children: [
                        for (final s in data.topSymptoms)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.blush,
                              borderRadius: BorderRadius.circular(AppRadius.chip),
                            ),
                            child: Text(
                              '${l.symptomLabel(s.key)} · ${l.daysCount(s.value)}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.lg),
                    Text(l.reportFooter, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            FilledButton.icon(
              onPressed: () => _sharePdf(context, data),
              icon: const Icon(Icons.upload_outlined),
              label: Text(l.sharePdf),
            ),
            const SizedBox(height: AppSpace.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => _LargeReportView(data: data)),
              ),
              child: Text(l.showOnPhone),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sharePdf(BuildContext context, ReportData data) async {
    final l = AppLocalizations.of(context);
    final cycles = context.read<CycleController>();
    final bytes = await buildReportPdf(l, data);
    // Printing.sharePdf hands the bytes straight to the share sheet; nothing
    // is written to the phone's storage.
    await Printing.sharePdf(bytes: bytes, filename: 'donzela-report.pdf');
    cycles.trackReportShared();
  }
}

/// Builds the nurse PDF in memory. Plain ASCII-safe text keeps the built-in
/// PDF fonts working for every language.
Future<Uint8List> buildReportPdf(AppLocalizations l, ReportData data) async {
  final doc = pw.Document();
  final today = dayOnly(DateTime.now());
  final first = data.cycles.isEmpty ? today : data.cycles.first.start;

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(l.reportTitle,
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.Text('${l.dayMonthYear(first)} - ${l.dayMonthYear(today)}'),
          pw.SizedBox(height: 16),
          pw.Text('${l.reportCycleCol}: ${data.averageCycle}'),
          pw.Text('${l.reportPeriodCol}: ${data.averagePeriod}'),
          pw.Text('${l.reportLast}: ${data.lastStart == null ? '-' : shortDate(data.lastStart!)}'),
          pw.SizedBox(height: 16),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  for (final h in [l.reportStartCol, l.reportLengthCol, l.reportPeriodLenCol])
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(h, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                ],
              ),
              for (final c in data.cycles)
                pw.TableRow(children: [
                  for (final v in [
                    l.dayMonthYear(c.start),
                    c.cycleLength == null ? '-' : l.daysCount(c.cycleLength!),
                    l.daysCount(c.periodLength),
                  ])
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(v)),
                ]),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Text(l.reportSymptoms, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          for (final s in data.topSymptoms)
            pw.Text('${l.symptomLabel(s.key)} - ${l.daysCount(s.value)}'),
          pw.Spacer(),
          pw.Text(l.reportFooter, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    ),
  );
  return doc.save();
}

class _Box extends StatelessWidget {
  const _Box({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _CyclesTable extends StatelessWidget {
  const _CyclesTable({required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(children: [
          Text(l.reportStartCol, style: style),
          Text(l.reportLengthCol, style: style),
          Text(l.reportPeriodLenCol, style: style),
        ]),
        for (final c in data.cycles.reversed)
          TableRow(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.sand)),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l.dayMonthYear(c.start)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(c.cycleLength == null ? '–' : l.daysCount(c.cycleLength!)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l.daysCount(c.periodLength)),
              ),
            ],
          ),
      ],
    );
  }
}

/// "Erekana kuri telefoni": full-screen view with large text.
class _LargeReportView extends StatelessWidget {
  const _LargeReportView({required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const big = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink);
    return Scaffold(
      appBar: AppBar(title: Text(l.reportTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.xl),
        children: [
          Text('${l.reportCycleCol}: ${data.averageCycle}', style: big),
          const SizedBox(height: AppSpace.md),
          Text('${l.reportPeriodCol}: ${data.averagePeriod}', style: big),
          const SizedBox(height: AppSpace.md),
          Text('${l.reportLast}: ${data.lastStart == null ? '–' : shortDate(data.lastStart!)}', style: big),
          const SizedBox(height: AppSpace.xl),
          for (final c in data.cycles.reversed) ...[
            Text(
              '${l.dayMonthYear(c.start)}\n'
              '${c.cycleLength == null ? '–' : l.daysCount(c.cycleLength!)} · '
              '${l.daysCount(c.periodLength)}',
              style: big,
            ),
            const SizedBox(height: AppSpace.md),
          ],
          const SizedBox(height: AppSpace.lg),
          const ZigzagBand(height: 12, color: AppColors.gold),
          const SizedBox(height: AppSpace.md),
          Text(l.reportFooter, style: const TextStyle(fontSize: 18, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}
