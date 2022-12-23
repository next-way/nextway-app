import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:nextway/app.dart';
import 'package:nextway/repository.dart';
import 'package:nextway_api/src/models/order.dart';
import 'package:provider/provider.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

enum ActionIntent { collectPayment, confirmCancellation, viewSingleOrder }

class SingleOrderActionWidget extends StatefulWidget {
  const SingleOrderActionWidget({
    Key? key,
    required this.order,
    required this.intent,
    this.dropOffDT,
    this.displayState,
  }) : super(key: key);

  final Order order;
  final ActionIntent intent;
  final DateTime? dropOffDT;
  final String? displayState;

  @override
  _SingleOrderActionWidgetState createState() =>
      _SingleOrderActionWidgetState();
}

class _SingleOrderActionWidgetState extends State<SingleOrderActionWidget> {
  TextEditingController? notesFieldController;
  TextEditingController? recipientNameFieldController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool cancelInProgress = false;
  Repository repository = Repository(FlavorConfig.instance.variables);

  String get mainCtaButtonText {
    switch (widget.intent) {
      case ActionIntent.collectPayment:
        return 'Collect';
      case ActionIntent.confirmCancellation:
        return 'Confirm job cancellation';
      case ActionIntent.viewSingleOrder:
      default:
        return '';
    }
  }

  String get secondaryCtaButtonText {
    switch (widget.intent) {
      case ActionIntent.confirmCancellation:
        return 'Back';
      case ActionIntent.collectPayment:
      case ActionIntent.viewSingleOrder:
      default:
        return '';
    }
  }

  bool get isRecipientEditable {
    switch (widget.intent) {
      case ActionIntent.collectPayment:
      case ActionIntent.confirmCancellation:
        return true;
      case ActionIntent.viewSingleOrder:
      default:
        return false;
    }
  }

  bool get isNotesEditable {
    switch (widget.intent) {
      case ActionIntent.collectPayment:
      case ActionIntent.confirmCancellation:
        return true;
      case ActionIntent.viewSingleOrder:
      default:
        return false;
    }
  }

  bool get isNotesVisible {
    if (widget.order.state == 'done') {
      return false;
    }
    return true;
  }

  bool get isCancelling {
    return widget.intent == ActionIntent.confirmCancellation &&
        cancelInProgress;
  }

  @override
  void initState() {
    super.initState();
    notesFieldController = TextEditingController();
    recipientNameFieldController = TextEditingController();
    if (widget.order.deliveryAddress.name?.isNotEmpty ?? false) {
      recipientNameFieldController!.text = widget.order.deliveryAddress.name!;
    } else if (widget.order.deliveryAddress.displayName.isNotEmpty) {
      recipientNameFieldController!.text =
          widget.order.deliveryAddress.displayName;
    }
  }

  @override
  void dispose() {
    notesFieldController?.dispose();
    recipientNameFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: false,
            floating: false,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24,
              ),
            ),
            actions: [],
            centerTitle: false,
            elevation: 0,
            title: Text(
              "Order ${widget.order.displayName}",
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
          )
        ],
        body: Builder(
          builder: (context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        color: Color(0x230E151B),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 8, 16, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Items',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .subtitle2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 16),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: widget
                                                    .order.orderLines.length,
                                                itemBuilder:
                                                    (BuildContext bldContext,
                                                        int index) {
                                                  OrderLine line = widget
                                                      .order.orderLines[index];
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${line.quantityVerbose} ${line.unitOfMeasureVerbose}",
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8, 0, 0, 0),
                                                        child: Text(
                                                          line.name,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1,
                                                        ),
                                                      ),
                                                      Text(
                                                        line.priceSubtotalVerbose,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 16, 16, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Total cash to collect',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .subtitle2
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                ),
                                              ),
                                              Text(
                                                widget.order.amountInPesos,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyText1
                                                    .override(
                                                      fontFamily: 'Noto Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        color: Color(0x230E151B),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 8, 16, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recipient\n*Change here when received by someone else other than the customer',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                        ),
                                        TextFormField(
                                          controller:
                                              recipientNameFieldController,
                                          autofocus:
                                              recipientNameFieldController
                                                      ?.text.isEmpty ??
                                                  false,
                                          readOnly: !isRecipientEditable ||
                                              isCancelling,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: '[Enter recipient name]',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyText2,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isNotesVisible
                            ? Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 5,
                                              color: Color(0x230E151B),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 8, 16, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Notes',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                        ),
                                              ),
                                              TextFormField(
                                                controller:
                                                    notesFieldController,
                                                readOnly: !isNotesEditable ||
                                                    isCancelling,
                                                autofocus: notesFieldController
                                                        ?.text.isEmpty ??
                                                    false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText: '[Enter notes]',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyText2,
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4.0),
                                                      topRight:
                                                          Radius.circular(4.0),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4.0),
                                                      topRight:
                                                          Radius.circular(4.0),
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4.0),
                                                      topRight:
                                                          Radius.circular(4.0),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4.0),
                                                      topRight:
                                                          Radius.circular(4.0),
                                                    ),
                                                  ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Spacer(),
                        displayReadOnlyStatus()
                            ? Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 16, 0, 0),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(),
                                          child: Text(
                                            (widget.displayState ??
                                                    widget.order.state)
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .title3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Spacer(),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 16, 0, 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    hasSecondaryCta()
                                        ? FFButtonWidget(
                                            onPressed: () {
                                              if (secondaryCtaButtonText
                                                      .toLowerCase() ==
                                                  'back') {
                                                Navigator.pop(context);
                                              }
                                              print('Button pressed ...');
                                            },
                                            text: secondaryCtaButtonText,
                                            options: FFButtonOptions(
                                              width: 130,
                                              height: 40,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .subtitle2
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryColor,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          )
                                        : Spacer(),
                                    hasCta()
                                        ? FFButtonWidget(
                                            onPressed: () async {
                                              switch (widget.intent) {
                                                case ActionIntent
                                                    .confirmCancellation:
                                                  {
                                                    var confirmDialogResponse =
                                                        await showDialog<bool>(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Cancel Job Order'),
                                                                  content: Text(
                                                                      'Are you sure you want to cancel this job order?\n\nThis will only unassign the order from you.\nThis does NOT CANCEL AN ORDER'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          alertDialogContext,
                                                                          false),
                                                                      child: Text(
                                                                          'Cancel'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          alertDialogContext,
                                                                          true),
                                                                      child: Text(
                                                                          'Confirm'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ) ??
                                                            false;
                                                    if (confirmDialogResponse) {
                                                      setState(() {
                                                        cancelInProgress = true;
                                                      });
                                                      // Request cancellation of job
                                                      bool
                                                          cancelRequestSuccess =
                                                          false;
                                                      const snackbarSuccess =
                                                          SnackBar(
                                                              content: Text(
                                                                  "Order job is now cancelled and unassigned"));
                                                      const snackbarFail = SnackBar(
                                                          content: Text(
                                                              "Order job cannot be cancelled. Try again later."));
                                                      var snackbarController;

                                                      await Future.delayed(
                                                          const Duration(
                                                              seconds: 2),
                                                          () async {
                                                        cancelRequestSuccess =
                                                            await repository
                                                                .orderApiRepository
                                                                .cancelJobOrder(
                                                                    widget.order
                                                                        .id,
                                                                    notesFieldController
                                                                            ?.text ??
                                                                        '');
                                                        setState(() {
                                                          cancelInProgress =
                                                              false;
                                                        });
                                                        if (cancelRequestSuccess) {
                                                          snackbarController =
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackbarSuccess);
                                                          // Navigate back to list view
                                                          await Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NavBarPage(
                                                                      initialPage:
                                                                          'myTasks'),
                                                            ),
                                                          );
                                                        } else {
                                                          snackbarController =
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackbarFail);
                                                        }
                                                        await snackbarController
                                                            .closed;
                                                        Navigator.pop(context);
                                                      });
                                                    }
                                                    break;
                                                  }
                                                case ActionIntent
                                                    .collectPayment:
                                                  {
                                                    DateTime collectionDT =
                                                        DateTime.now();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1),
                                                        () async {
                                                      const snackbarSuccess =
                                                          SnackBar(
                                                              content: Text(
                                                                  "Order collection successful"));
                                                      const snackbarFail = SnackBar(
                                                          content: Text(
                                                              "Order job cannot be confirmed. Try again later."));
                                                      var snackbarController;
                                                      bool requestSuccess =
                                                          await repository
                                                              .orderApiRepository
                                                              .dropOffOrder(
                                                        widget.order.id,
                                                        widget.dropOffDT,
                                                        collectionDT,
                                                        notesFieldController
                                                            ?.text,
                                                      );
                                                      if (requestSuccess) {
                                                        snackbarController =
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackbarSuccess);
                                                        await snackbarController
                                                            .closed;

                                                        /// Replace with view only
                                                        await Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SingleOrderActionWidget(
                                                              order:
                                                                  widget.order,
                                                              intent: ActionIntent
                                                                  .viewSingleOrder,
                                                              displayState:
                                                                  'Done',
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        snackbarController =
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackbarFail);
                                                        await snackbarController
                                                            .closed;
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                    break;
                                                  }
                                                default:
                                                  print('Button pressed ...');
                                              }
                                            },
                                            text: mainCtaButtonText,
                                            options: FFButtonOptions(
                                              width: 130,
                                              height: 40,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryColor,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .subtitle2
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color: Colors.white,
                                                      ),
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          )
                                        : Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool hasCta() => mainCtaButtonText.isNotEmpty;
  bool hasSecondaryCta() => secondaryCtaButtonText.isNotEmpty;

  bool displayReadOnlyStatus() {
    switch (widget.intent) {
      case ActionIntent.viewSingleOrder:
        return true;
      case ActionIntent.collectPayment:
      case ActionIntent.confirmCancellation:
      default:
        return false;
    }
  }
}
