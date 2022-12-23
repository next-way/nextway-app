import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:nextway/flutter_flow/flutter_flow_widgets.dart';
import 'package:nextway/helpers.dart';
import 'package:nextway/repository.dart';
import 'package:nextway_api/src/models/order.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_google_map.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'single_order_action.dart';

// This is the type used by the popup menu below.
enum Menu { itemCall, itemSMS, directWaze }

class SingleOrderDetailsWidget extends StatefulWidget {
  const SingleOrderDetailsWidget({
    Key? key,
    this.displayName,
    this.customerName,
    this.companyName,
    this.address,
    this.totalAmount,
    this.orderItems,
    required this.assigned,
    this.lat,
    this.long,
    required this.order,
  }) : super(key: key);

  final String? displayName;
  final String? customerName;
  final String? companyName;
  final String? address;
  final String? totalAmount;
  final bool assigned;
  final dynamic orderItems;
  final double? lat;
  final double? long;
  final Order order;

  @override
  _SingleOrderDetailsWidgetState createState() =>
      _SingleOrderDetailsWidgetState();
}

class _SingleOrderDetailsWidgetState extends State<SingleOrderDetailsWidget> {
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedMenu = '';
  Repository repository = Repository(FlavorConfig.instance.variables);
  // Location location = new Location();
  // bool _serviceEnabled = false;
  // PermissionStatus _permissionGranted = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    // asyncGetLocationData();
  }

  // void asyncGetLocationData() async {
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   location.enableBackgroundMode(enable: true);
  // }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: false,
            floating: false,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            title: Text(
              "Order ${widget.order.displayName}",
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
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
            actions: () {
              List<PopupMenuEntry<Menu>> menuItems = [
                PopupMenuItem<Menu>(
                  value: Menu.directWaze,
                  child: Text('Show directions (Waze)'),
                  enabled: _shouldShowWaze(),
                ),
              ];
              if (widget.assigned || widget.order.state == 'assigned') {
                menuItems.addAll([
                  PopupMenuItem<Menu>(
                    value: Menu.itemCall,
                    child: Text('Call customer'),
                    enabled: widget.order.contactNumber != null,
                  ),
                  PopupMenuItem<Menu>(
                    value: Menu.itemSMS,
                    child: Text('SMS customer'),
                    enabled: widget.order.deliveryAddress.mobile != null &&
                        widget.order.deliveryAddress.mobile!.isNotEmpty,
                  ),
                ]);
              }
              return [
                PopupMenuButton(
                  icon: Icon(Icons.more_vert,
                      color: FlutterFlowTheme.of(context).secondaryText),
                  // Callback that sets the selected popup menu item.
                  onSelected: (Menu item) {
                    setState(() {
                      _selectedMenu = item.name;
                    });
                    switch (item) {
                      case Menu.directWaze:
                        {
                          launchWaze(widget.lat!, widget.long!);
                          break;
                        }
                      case Menu.itemCall:
                        maybeLaunch('tel://${widget.order.contactNumber}');
                        break;
                      case Menu.itemSMS:
                        maybeLaunch(
                            'sms://${widget.order.deliveryAddress.mobile}');
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => menuItems,
                ),
              ];
            }(),
            centerTitle: false,
            elevation: 0,
          )
        ],
        body: Builder(
          builder: (context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  /// TODO If no partner location, should just show driver location?
                  Expanded(
                    child: FlutterFlowGoogleMap(
                      controller: googleMapsController,
                      onCameraIdle: (latLng) => googleMapsCenter = latLng,
                      initialLocation: googleMapsCenter ??= LatLng(
                          widget.lat ?? 10.3163708, widget.long ?? 123.8953598),
                      markerColor: GoogleMarkerColor.red,
                      mapType: MapType.normal,
                      style: GoogleMapStyle.standard,
                      initialZoom: 14,
                      allowInteraction: true,
                      allowZoom: true,
                      showZoomControls: true,
                      showLocation: true,
                      showCompass: true,
                      showMapToolbar: false,
                      showTraffic: true,
                      centerMapOnMarkerTap: true,
                      markers: [
                        FlutterFlowMarker(
                          widget.customerName ?? 'Customer',
                          LatLng(widget.lat ?? 10.3163708,
                              widget.long ?? 123.8953598),
                        ),
                      ],

                      /// Currently no free way
                      /// https://stackoverflow.com/a/69901672
                      /// TODO Maybe just use Waze?
                      // onMapCreated: (controller) async {
                      //   if (widget.lat == null || widget.long == null) {
                      //     return;
                      //   }
                      //   final LatLng startingPoint =
                      //       LatLng(widget.lat!, widget.long!);
                      //   // final LatLng endingPoint = LatLng(37.7749295, -122.4194155);
                      //   //
                      //   // controller.showDirections(startingPoint, endingPoint);
                      //   // controller.showDirections();
                      //   if (_serviceEnabled &&
                      //       _permissionGranted == PermissionStatus.granted) {
                      //     location = Location();
                      //
                      //     location.onLocationChanged
                      //         .listen((LocationData currentLocation) {
                      //       if (currentLocation.latitude == null ||
                      //           currentLocation.longitude == null) {
                      //         return;
                      //       }
                      //       final LatLng endPoint = LatLng(
                      //           currentLocation.latitude!,
                      //           currentLocation.longitude!);
                      //       controller.showDirections(
                      //         startingPoint,
                      //         endPoint,
                      //       );
                      //       // Use current location
                      //     });
                      //   }
                      // },
                    ),
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      // Customer detail
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
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
                                          valueOrDefault<String>(
                                            widget.displayName,
                                            '000000',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .subtitle2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          valueOrDefault<String>(
                                            widget.customerName,
                                            'Michael Scott',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .subtitle2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          valueOrDefault<String>(
                                            widget.companyName,
                                            widget.customerName ??
                                                'Individual company',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .title2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Address: ' + (widget.address ?? ''),
                                          style: FlutterFlowTheme.of(context)
                                              .subtitle1
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 24),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 0, 0),
                                        child: Text(
                                          'Amount: ' +
                                              (widget.totalAmount ?? ''),
                                          style: FlutterFlowTheme.of(context)
                                              .title2
                                              .override(
                                                fontFamily: 'Noto Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 4,
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  color: FlutterFlowTheme.of(context).lineColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Order details
                      OrderDetails(order: widget.order),
                      // Action based on status
                      widget.assigned
                          ? OrderActionDropOff(order: widget.order)
                          : OrderActionUnassigned(
                              order: widget.order, repository: repository),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void launchWaze(double lat, double lng) async {
    var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
    // possibly https://waze.com/ul?ll=37.785834,-122.406417&navigate=to:37.331982,-121.886329 ?
    var fallbackUrl =
        'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
    try {
      await launchURL(url);
    } catch (e) {
      await launchURL(fallbackUrl);
    }
  }

  _shouldShowWaze() {
    return widget.lat != null && widget.long != null;
  }

  void maybeLaunch(String s) async {
    if (await canLaunchUrlString(s)) {
      await launchURL(s);
    } else {
      log("Cannot launch ${s.split('://')[0]}. Make sure permissions and intents are set.");
    }
  }
}

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // boxShadow: [
            //   BoxShadow(
            //     blurRadius: 5,
            //     color: Color(0x230E151B),
            //     offset: Offset(0, 2),
            //   )
            // ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        'Order',
                        style: FlutterFlowTheme.of(context).subtitle2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 16, 16),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: order.orderLines.length,
                  itemBuilder: (BuildContext bldContext, int index) {
                    OrderLine line = order.orderLines[index];
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "${line.quantityVerbose} ${line.unitOfMeasureVerbose}",
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                          child: Text(
                            line.name,
                            style: FlutterFlowTheme.of(context).bodyText1,
                          ),
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
    );
  }
}

/// Action when the order is unassigned
class OrderActionUnassigned extends StatefulWidget {
  const OrderActionUnassigned({
    Key? key,
    required this.order,
    required this.repository,
  }) : super(key: key);

  final Order order;
  final Repository repository;

  @override
  State<OrderActionUnassigned> createState() => _OrderActionUnassignedState();
}

class _OrderActionUnassignedState extends State<OrderActionUnassigned> {
  bool acceptRequestOnProgress = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FFButtonWidget(
                      onPressed: acceptRequestOnProgress
                          ? () {}
                          : () {
                              Navigator.pop(context);
                            },
                      text: 'Ignore',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle: FlutterFlowTheme.of(context)
                            .subtitle2
                            .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        setState(() {
                          acceptRequestOnProgress = true;
                        });
                        // Request for assignment with delay of 5 seconds
                        const snackbarFailed = SnackBar(
                            content: Text("Order job cannot be assigned"));
                        const snackbarAwaiting = SnackBar(
                            content: Text("Please wait..."),
                            duration: const Duration(seconds: 1));
                        const snackbarAssignSuccess = SnackBar(
                          content: Text("Order job is now assigned"),
                          duration: const Duration(seconds: 1),
                        );
                        var snackbarController;
                        snackbarController = ScaffoldMessenger.of(context)
                            .showSnackBar(snackbarAwaiting);
                        await Future.delayed(const Duration(seconds: 5),
                            () async {
                          bool acceptRequestSuccess = await widget
                              .repository.orderApiRepository
                              .acceptJobOrder(widget.order.id);
                          setState(() {
                            acceptRequestOnProgress = false;
                          });
                          if (!acceptRequestSuccess) {
                            snackbarController = ScaffoldMessenger.of(context)
                                .showSnackBar(snackbarFailed);
                            await snackbarController.closed;
                          } else {
                            snackbarController = ScaffoldMessenger.of(context)
                                .showSnackBar(snackbarAssignSuccess);
                            await snackbarController.closed;
                            // Set new navigation to assigned
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleOrderDetailsWidget(
                                  displayName: widget.order.displayName,
                                  customerName:
                                      widget.order.deliveryAddress.name,
                                  companyName:
                                      widget.order.deliveryAddress.companyName,
                                  totalAmount: widget.order.amountInPesos,
                                  address: getAddress(widget.order),
                                  assigned: true, // Force true as assigned
                                  lat: widget
                                      .order.deliveryAddress.partnerLatitude,
                                  long: widget
                                      .order.deliveryAddress.partnerLongitude,
                                  order: widget.order,
                                ),
                              ),
                            );
                          }
                        });
                      },
                      text: 'Accept',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.of(context).primaryColor,
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Action when the order is assigned
class OrderActionDropOff extends StatelessWidget {
  const OrderActionDropOff({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FFButtonWidget(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleOrderActionWidget(
                              order: order,
                              intent: ActionIntent.confirmCancellation,
                            ),
                          ),
                        );
                      },
                      text: 'Cancel Job',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle: FlutterFlowTheme.of(context)
                            .subtitle2
                            .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        DateTime dropOffDT = DateTime.now();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleOrderActionWidget(
                              order: order,
                              intent: ActionIntent.collectPayment,
                              dropOffDT: dropOffDT,
                            ),
                          ),
                        );
                      },
                      text: 'Drop Off',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.of(context).primaryColor,
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
