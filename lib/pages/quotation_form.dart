import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quote.dart';
import 'package:ccm/models/response.dart';
import 'package:ccm/pages/comments.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/quotation/client_invoice.dart';
import 'package:ccm/widgets/quotation/client_quotation.dart';
import 'package:ccm/widgets/quotation/contractor_quotation.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuotationForm extends StatefulWidget {
  QuotationForm({Key? key, this.quotation}) : super(key: key);

  final Quotation? quotation;

  @override
  State<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  @override
  void initState() {
    Get.put(ClientController());
    if (widget.quotation != null) {
      controller = QuotationFormController.fromQuotation(widget.quotation!);
    } else {
      controller = QuotationFormController();
    }
    super.initState();
  }

  late QuotationFormController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3A5F85),
          title: Text('In a world of gray, CCM provides clarity to all construction & facility projects'),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return CommentsList(comments: controller.comments);
                  },
                );
              },
              icon: Icon(Icons.chat_bubble),
            ),
          ],
        ),
        floatingActionButton: ElevatedButton(
            onPressed: () async {
              if (controller.quoteFormKey.currentState!.validate()) {
                var quotation = controller.object;
                var text = "updated";
                if (widget.quotation == null) {
                  quotation.id = await getNextQuotationId();
                  text = "added";
                }
                var future = quotations.doc(quotation.id).set(quotation.toJson()).then((value) {
                  // return databaseRef
                  //     .child(session.country!.code)
                  //     .child(quotation.id!)
                  //     .set(quotation.toRTDBJson())
                  //     .then((value) => Result.success("Quotation $text successfully"))
                  //     .catchError((error) {
                  //   print(
                  //     error.toString(),
                  //   );
                  //   return Result.error(error.toString());
                  // });
                  return Result.success("Quotation $text successfully");
                }).then(((value) => value));

                showFutureDialog(context: context, future: future);
              }
            },
            child: Text("Submit")),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.0,
              ),
              ClientQuotation(controller: controller),
              ClientInvoiceForm(controller: controller),
              ContractorPoForm(controller: controller),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
