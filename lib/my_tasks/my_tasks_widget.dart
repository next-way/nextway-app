// import '../auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nextway/my_tasks/paged_orders_list_view.dart';
import 'package:nextway/preferences/list_preferences.dart';
import 'package:nextway/repository.dart';
import 'package:provider/provider.dart';

import '../backend/backend.dart';
import '../components/create_task_new_widget.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

class MyTasksWidget extends StatefulWidget {
  const MyTasksWidget({Key? key}) : super(key: key);

  @override
  _MyTasksWidgetState createState() => _MyTasksWidgetState();
}

class _MyTasksWidgetState extends State<MyTasksWidget>
    with TickerProviderStateMixin {
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 70),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  PagingController<DocumentSnapshot?, ToDoListRecord>? _pagingController;
  Query? _pagingQuery;
  List<StreamSubscription?> _streamSubscriptions = [];
  // TODO Add a way to customize preferences
  ListPreferences _listPreferences = ListPreferences(
    filteredState: OrderGroupState.scheduled,
  );
  String selectedTab = 'scheduled';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Repository repository = Repository(FlavorConfig.instance.variables);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Map apiConfig = await getApiConfig();
      // setState(() {
      // });
      repository = Repository(FlavorConfig.instance.variables);
      // getApiConfig().then((apiConfig) {
      //   setState(() {
      //     repository = Repository(apiConfig);
      //   });
      //   // this.repository = Repository(apiConfig);
      // });
    });
    super.initState();
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach((s) => s?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await showModalBottomSheet(
      //       isScrollControlled: true,
      //       backgroundColor: Colors.transparent,
      //       barrierColor: Color(0x230E151B),
      //       context: context,
      //       builder: (context) {
      //         return Padding(
      //           padding: MediaQuery.of(context).viewInsets,
      //           child: Container(
      //             height: MediaQuery.of(context).size.height * 1,
      //             child: CreateTaskNewWidget(),
      //           ),
      //         );
      //       },
      //     ).then((value) => setState(() {}));
      //   },
      //   backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      //   elevation: 8,
      //   child: Icon(
      //     Icons.add_rounded,
      //     color: FlutterFlowTheme.of(context).white,
      //     size: 28,
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Orders',
          style: FlutterFlowTheme.of(context).title1.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).white,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
            //     Container(
            //       width: MediaQuery.of(context).size.width,
            //       height: 53,
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           fit: BoxFit.fitWidth,
            //           image: Image.asset(
            //             'assets/images/waves@2x.png',
            //           ).image,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 6, 8, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    onPressed: () {
                      _listPreferences.filteredState = OrderGroupState.all;
                      setState(() {
                        selectedTab = 'all';
                      });
                    },
                    child: Text(
                      'All',
                      style: selectedTab == 'all'
                          ? FlutterFlowTheme.of(context).subtitle2.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText)
                          : FlutterFlowTheme.of(context).subtitle2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _listPreferences.filteredState =
                          OrderGroupState.scheduled;
                      setState(() {
                        selectedTab = 'scheduled';
                      });
                    },
                    child: Text(
                      'Scheduled',
                      style: selectedTab == 'scheduled'
                          ? FlutterFlowTheme.of(context).subtitle2.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText)
                          : FlutterFlowTheme.of(context).subtitle2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _listPreferences.filteredState =
                          OrderGroupState.unassigned;
                      setState(() {
                        selectedTab = 'unassigned';
                      });
                    },
                    child: Text(
                      'Unassigned',
                      style: selectedTab == 'unassigned'
                          ? FlutterFlowTheme.of(context).subtitle2.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText)
                          : FlutterFlowTheme.of(context).subtitle2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: PagedOrdersListView(
                  repository: repository, // TODO Get this from provider
                  listPreferences: _listPreferences,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ensureRepositoryInit() {}
}
