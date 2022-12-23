import 'package:flutter/material.dart';
import 'package:nextway/flutter_flow/flutter_flow_theme.dart';
import 'package:nextway/helpers.dart';
import 'package:nextway/index.dart';
import 'package:order_repository/order_repository.dart';

import '../single_order/single_order_details.dart';

final List<String> assignedStates = <String>[
  'assigned',
  'confirmed',
  'done',
  'cancelled',
];

class OrderListItem extends StatelessWidget {
  final Order order;

  const OrderListItem({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () async {
        if (order.state.toLowerCase() == 'done') {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleOrderActionWidget(
                order: order,
                intent: ActionIntent.viewSingleOrder,
              ),
            ),
          );
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleOrderDetailsWidget(
                displayName: order.displayName,
                customerName: order.deliveryAddress.name,
                companyName: order.deliveryAddress.companyName,
                totalAmount: order.amountInPesos,
                address: getAddress(order),
                assigned: isAssigned(order),
                lat: order.deliveryAddress.partnerLatitude,
                long: order.deliveryAddress.partnerLongitude,
                order: order,
              ),
            ),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.displayName,
                    style: FlutterFlowTheme.of(context).subtitle2.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          order.amountInPesos,
                          style: FlutterFlowTheme.of(context)
                              .subtitle2
                              .override(
                                fontFamily: 'Noto Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryColor,
                                fontSize: 20,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    getAddress(order),
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.scheduleVerbose,
                  textAlign: TextAlign.end,
                  style: FlutterFlowTheme.of(context).bodyText1,
                ),
                Text(
                  order.state.toUpperCase(),
                  textAlign: TextAlign.end,
                  style: FlutterFlowTheme.of(context).bodyText1,
                ),
                Text(
                  '',
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Outfit',
                        color: Color(0x00FFFFFF),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  bool isAssigned(Order order) {
    return assignedStates.contains(order.state);
  }
}
