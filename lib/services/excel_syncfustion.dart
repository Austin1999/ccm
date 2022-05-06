import 'dart:math';

import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'dart:convert';

class ExcelService {
  static createExcel(List<Quotation> quotes) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('QUOTE NUMBER');
    sheet.getRangeByName('B1').setText('DATE ISSUED');
    sheet.getRangeByName('C1').setText('CLIENT');
    sheet.getRangeByName('D1').setText('DESCRIPTION');
    sheet.getRangeByName('E1').setText('QUOTE AMOUNT');
    sheet.getRangeByName('F1').setText('CLIENT PO');
    sheet.getRangeByName('G1').setText('APPROVAL STATUS');
    sheet.getRangeByName('H1').setText('MARGIN');
    sheet.getRangeByName('I1').setText('CCM TICKET NUMBER');
    sheet.getRangeByName('J1').setText('COMPLETION DATE');
    sheet.getRangeByName('K1').setText('OVERALL STATUS');
    sheet.getRangeByName('L1').setText('INVOICE NUMBER');
    sheet.getRangeByName('M1').setText('AMOUNT');
    sheet.getRangeByName('N1').setText('ISSUED DATE');
    sheet.getRangeByName('O1').setText('LAST RECEIVED DATE');
    sheet.getRangeByName('P1').setText('RECEIVED AMOUNT');
    sheet.getRangeByName('Q1').setText('CREDITS');

    for (int i = 0; i < quotes.length; i++) {
      var quote = quotes[i];
      var invoice = quote.clientInvoices.length != 0 ? quote.clientInvoices.first : null;
      sheet.getRangeByName('A${i + 2}').setText(quote.number);
      sheet.getRangeByName('B${i + 2}').setDateTime(quote.issuedDate);
      sheet.getRangeByName('C${i + 2}').setText(clientController.getName(quote.client));
      sheet.getRangeByName('D${i + 2}').setText(quote.description);
      sheet.getRangeByName('E${i + 2}').setNumber(quote.amount);
      sheet.getRangeByName('F${i + 2}').setText(quote.clientApproval);
      sheet.getRangeByName('G${i + 2}').setText(quote.approvalStatus.toString().split('.').last.toUpperCase());
      sheet.getRangeByName('H${i + 2}').setNumber(quote.margin);
      sheet.getRangeByName('I${i + 2}').setText(quote.ccmTicketNumber);
      sheet.getRangeByName('J${i + 2}').setDateTime(quote.completionDate);
      sheet.getRangeByName('K${i + 2}').setText(quote.overallStatus.toString().split('.').last.toUpperCase());
      if (invoice != null) {
        sheet.getRangeByName('L${i + 2}').setText(invoice.number);
        sheet.getRangeByName('M${i + 2}').setNumber(invoice.amount);
        sheet.getRangeByName('N${i + 2}').setDateTime(invoice.issuedDate);
        sheet.getRangeByName('O${i + 2}').setDateTime(invoice.lastReceivedDate);
        sheet.getRangeByName('P${i + 2}').setNumber(invoice.closedAmount);
        sheet.getRangeByName('Q${i + 2}').setNumber(invoice.creditAmount);
      }
    }

    for (int i = 1; i <= 30; i++) {
      sheet.autoFitColumn(i);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64, ${base64.encode(bytes)}')
        ..setAttribute('download', 'output.xlsx')
        ..click();
    }
  }

  static createExcelForquote(List<Quotation> quotes) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('QUOTE NUMBER');
    sheet.getRangeByName('B1').setText('DATE ISSUED');
    sheet.getRangeByName('C1').setText('CLIENT');
    sheet.getRangeByName('D1').setText('DESCRIPTION');
    sheet.getRangeByName('E1').setText('QUOTE AMOUNT');
    sheet.getRangeByName('F1').setText('CLIENT PO');
    sheet.getRangeByName('G1').setText('APPROVAL STATUS');
    sheet.getRangeByName('H1').setText('MARGIN');
    sheet.getRangeByName('I1').setText('CCM TICKET NUMBER');
    sheet.getRangeByName('J1').setText('COMPLETION DATE');
    sheet.getRangeByName('K1').setText('OVERALL STATUS');

    sheet.getRangeByName('L1').setText('INVOICE NUMBER');
    sheet.getRangeByName('M1').setText('AMOUNT');
    sheet.getRangeByName('N1').setText('ISSUED DATE');
    sheet.getRangeByName('O1').setText('LAST RECEIVED DATE');
    sheet.getRangeByName('P1').setText('RECEIVED AMOUNT');
    sheet.getRangeByName('Q1').setText('CREDITS');

    sheet.getRangeByName('R1').setText('CONTRACTOR');
    sheet.getRangeByName('S1').setText('PO NUMBER');
    sheet.getRangeByName('T1').setText('ISSUED AMOUNT');
    sheet.getRangeByName('U1').setText('ISSUED DATE');
    sheet.getRangeByName('V1').setText('QUOTE NUMBER');
    sheet.getRangeByName('W1').setText('QUOTE AMOUNT');
    sheet.getRangeByName('X1').setText('WORK COMMENCE');
    sheet.getRangeByName('Y1').setText('WORK COMPLETE');

    sheet.getRangeByName('Z1').setText('INVOICE NUMBER');
    sheet.getRangeByName('AA1').setText('AMOUNT');
    sheet.getRangeByName('AB1').setText('ISSUED DATE');
    sheet.getRangeByName('AC1').setText('LAST RECEIVED DATE');
    sheet.getRangeByName('AD1').setText('RECEIVED AMOUNT');
    sheet.getRangeByName('AE1').setText('CREDITS');

    int sheetRow = 2;
    // sheet.getRangeByName('A2:A5').merge();
    Style oddStyle = workbook.styles.add('oddStyle');
    Style evenStyle = workbook.styles.add('evenStyle');
    oddStyle.vAlign = VAlignType.center;
    oddStyle.hAlign = HAlignType.center;
    evenStyle.vAlign = VAlignType.center;
    evenStyle.hAlign = HAlignType.center;
    oddStyle.backColor = '#F5F9FD';
    evenStyle.backColor = '#FEF5F0';
    oddStyle.borders.all.lineStyle = LineStyle.medium;
    evenStyle.borders.all.lineStyle = LineStyle.medium;

    for (int i = 0; i < quotes.length; i++) {
      var quote = quotes[i];

      var style = (i % 2 == 0) ? oddStyle : evenStyle;

      int quoteLength = 1;
      int clientInvoicesLength = quote.clientInvoices.length;
      int contractorPoLength = quote.contractorPo.length;
      int contractorInvoicesLength =
          quote.contractorPo.fold(0, (previousValue, element) => previousValue + (element.invoices.isEmpty ? 1 : element.invoices.length));

      int length = [quoteLength, clientInvoicesLength, contractorPoLength, contractorInvoicesLength].reduce(
        (value, element) => max(value, element),
      );

      int invoiceIncrementer = (length) ~/ (clientInvoicesLength == 0 ? 1 : clientInvoicesLength);

      sheet.getRangeByName('A$sheetRow').setText(quote.number);
      sheet.getRangeByName('B$sheetRow').setDateTime(quote.issuedDate);
      sheet.getRangeByName('C$sheetRow').setText(clientController.getName(quote.client));
      sheet.getRangeByName('D$sheetRow').setText(quote.description);
      sheet.getRangeByName('E$sheetRow').setNumber(quote.amount);
      sheet.getRangeByName('F$sheetRow').setText(quote.clientApproval);
      sheet.getRangeByName('G$sheetRow').setText(quote.approvalStatus.toString().split('.').last.toUpperCase());
      sheet.getRangeByName('H$sheetRow').setNumber(quote.margin);
      sheet.getRangeByName('I$sheetRow').setText(quote.ccmTicketNumber);
      sheet.getRangeByName('J$sheetRow').setDateTime(quote.completionDate);
      sheet.getRangeByName('K$sheetRow').setText(quote.overallStatus.toString().split('.').last.toUpperCase());

      sheet.getRangeByName('A$sheetRow:A${sheetRow + length - 1}').merge();
      sheet.getRangeByName('B$sheetRow:B${sheetRow + length - 1}').merge();
      sheet.getRangeByName('C$sheetRow:C${sheetRow + length - 1}').merge();
      sheet.getRangeByName('D$sheetRow:D${sheetRow + length - 1}').merge();
      sheet.getRangeByName('E$sheetRow:E${sheetRow + length - 1}').merge();
      sheet.getRangeByName('F$sheetRow:F${sheetRow + length - 1}').merge();
      sheet.getRangeByName('G$sheetRow:G${sheetRow + length - 1}').merge();
      sheet.getRangeByName('H$sheetRow:H${sheetRow + length - 1}').merge();
      sheet.getRangeByName('I$sheetRow:I${sheetRow + length - 1}').merge();
      sheet.getRangeByName('J$sheetRow:J${sheetRow + length - 1}').merge();
      sheet.getRangeByName('K$sheetRow:K${sheetRow + length - 1}').merge();

      sheet.getRangeByName('A$sheetRow:A${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('B$sheetRow:B${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('C$sheetRow:C${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('D$sheetRow:D${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('E$sheetRow:E${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('F$sheetRow:F${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('G$sheetRow:G${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('H$sheetRow:H${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('I$sheetRow:I${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('J$sheetRow:J${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('K$sheetRow:K${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('L$sheetRow:L${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('M$sheetRow:M${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('N$sheetRow:N${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('O$sheetRow:O${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('P$sheetRow:P${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('Q$sheetRow:Q${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('R$sheetRow:R${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('S$sheetRow:S${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('T$sheetRow:T${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('U$sheetRow:U${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('V$sheetRow:V${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('W$sheetRow:W${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('X$sheetRow:X${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('Y$sheetRow:Y${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('Z$sheetRow:Z${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('AA$sheetRow:AA${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('AB$sheetRow:AB${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('AC$sheetRow:AC${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('AD$sheetRow:AD${sheetRow + length - 1}').cellStyle = style;
      sheet.getRangeByName('AE$sheetRow:AE${sheetRow + length - 1}').cellStyle = style;

      for (int j = 0 + sheetRow, index = 0; index < quote.clientInvoices.length; j = j + invoiceIncrementer) {
        var invoice = quote.clientInvoices[index++];

        sheet.getRangeByName('L$j:L${j + invoiceIncrementer - 1}').merge();
        sheet.getRangeByName('M$j:M${j + invoiceIncrementer - 1}').merge();
        sheet.getRangeByName('N$j:N${j + invoiceIncrementer - 1}').merge();
        sheet.getRangeByName('O$j:O${j + invoiceIncrementer - 1}').merge();
        sheet.getRangeByName('P$j:P${j + invoiceIncrementer - 1}').merge();
        sheet.getRangeByName('Q$j:Q${j + invoiceIncrementer - 1}').merge();

        sheet.getRangeByName('L$j:L${j + invoiceIncrementer - 1}').setText(invoice.number);
        sheet.getRangeByName('M$j:M${j + invoiceIncrementer - 1}').setNumber(invoice.amount);
        sheet.getRangeByName('N$j:N${j + invoiceIncrementer - 1}').setDateTime(invoice.issuedDate);
        sheet.getRangeByName('O$j:O${j + invoiceIncrementer - 1}').setDateTime(invoice.lastReceivedDate);
        sheet.getRangeByName('P$j:P${j + invoiceIncrementer - 1}').setNumber(invoice.closedAmount);
        sheet.getRangeByName('Q$j:Q${j + invoiceIncrementer - 1}').setNumber(invoice.creditAmount);
      }

      for (int j = 0 + sheetRow, index = 0; index < quote.contractorPo.length; j++) {
        var po = quote.contractorPo[index++];
        sheet.getRangeByName('R$j').setText(po.contractor);
        sheet.getRangeByName('S$j').setText(po.number);
        sheet.getRangeByName('T$j').setNumber(po.amount);
        sheet.getRangeByName('U$j').setDateTime(po.issuedDate);
        sheet.getRangeByName('V$j').setText(po.quoteNumber);
        sheet.getRangeByName('W$j').setNumber(po.quoteAmount);
        sheet.getRangeByName('X$j').setDateTime(po.workCommence);
        sheet.getRangeByName('Y$j').setDateTime(po.workComplete);

        for (int k = 0 + j, index = 0; index < po.invoices.length; k++) {
          var invoice = po.invoices[index++];
          sheet.getRangeByName('Z$k').setText(invoice.number);
          sheet.getRangeByName('AA$k').setNumber(invoice.amount);
          sheet.getRangeByName('AB$k').setDateTime(invoice.issuedDate);
          sheet.getRangeByName('AC$k').setDateTime(invoice.lastReceivedDate);
          sheet.getRangeByName('AD$k').setNumber(invoice.closedAmount);
          sheet.getRangeByName('AE$k').setNumber(invoice.creditAmount);
        }

        style.borders.all.lineStyle = LineStyle.medium;
        style.vAlign = VAlignType.center;
        style.hAlign = HAlignType.center;

        sheet.getRangeByName('R$j:R${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').cellStyle = style;
        sheet.getRangeByName('S$j:S${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').cellStyle = style;
        sheet.getRangeByName('T$j:T${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').cellStyle = style;
        sheet.getRangeByName('U$j:U${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').cellStyle = style;
        sheet.getRangeByName('V$j:V${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').cellStyle = style;
        sheet.getRangeByName('W$j:W${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').cellStyle = style;
        sheet.getRangeByName('X$j:X${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').cellStyle = style;
        sheet.getRangeByName('Y$j:Y${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').cellStyle = style;
        sheet.getRangeByName('R$j:R${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').merge();
        sheet.getRangeByName('S$j:S${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').merge();
        sheet.getRangeByName('T$j:T${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').merge();
        sheet.getRangeByName('U$j:U${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').merge();
        sheet.getRangeByName('V$j:V${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').merge();
        sheet.getRangeByName('W$j:W${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').merge();
        sheet.getRangeByName('X$j:X${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').merge();
        sheet.getRangeByName('Y$j:Y${j + (po.invoices.isEmpty ? 0 : po.invoices.length - 1)}').merge();

        j += (po.invoices.length - 1);
      }

      sheetRow += length;
    }
    for (int column = 1; column <= 30; column++) {
      sheet.autoFitColumn(column);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64, ${base64.encode(bytes)}')
        ..setAttribute('download', 'output.xlsx')
        ..click();
    }
  }
}
