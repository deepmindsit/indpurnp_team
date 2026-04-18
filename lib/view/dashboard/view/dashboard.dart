import 'package:indapur_team/utils/exported_path.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = getIt<DashboardController>();
  final langController = getIt<TranslateController>();
  final navController = getIt<NavigationController>();
  final complaintController = getIt<ComplaintController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getDashboard();
    });
    getIt<FirebaseTokenController>().updateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return _infoGridShimmer();
        }

        return RefreshIndicator(
          color: primaryColor,
          onRefresh: () => controller.getDashboard(load: false),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              spacing: 16.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statsGrid(),
                if (controller.countFromKey('total_complaints') > 0)
                  _complaintSummary(),
                _monthlyComplaintChart(),
                _complaintTypeChart(),
                _recentComplaints(),
                _deadComplaints(),
              ],
            ),
          ),
        );
      }),
    );
  }

  /////////////////////////////////////////////////////////////
  /// APP BAR
  /////////////////////////////////////////////////////////////

  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      title: Image.asset(Images.logo, width: 0.5.sw),
      centerTitle: true,
      actions: [
        _buildLanguageButton(),
        Tooltip(
          message: 'Notifications',
          child: IconButton(
            onPressed: () => Get.toNamed(Routes.notificationList),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.withValues(alpha: 0.15),
            ),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification02,
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 12.w),
      ],
    );
  }

  Widget _buildLanguageButton() {
    return Obx(
      () => Tooltip(
        message: langController.lang.value == 'en'
            ? 'Switch to Marathi'
            : 'Switch to English',
        child: IconButton(
          onPressed: () async {
            langController.toggleLang();
            await controller.getDashboard(load: false);
          },
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.withValues(alpha: 0.15),
          ),
          icon: Image.asset(
            langController.lang.value == 'en'
                ? 'assets/images/translation_english_marathi.png'
                : 'assets/images/translation_marathi_english.png',
            width: 0.05.sw,
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// STATS GRID
  /////////////////////////////////////////////////////////////

  Widget _statsGrid() {
    final items = [
      DashboardCard(
        icon: HugeIcons.strokeRoundedComplaint,
        title: "Total Complaints",
        value: controller.countFromKey('total_complaints').toString(),
        onTap: () => _openComplaintsTab(''),
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedTickDouble01,
        title: "Completed Complaints",
        value: controller.countFromKey('complete_complaint').toString(),
        onTap: () => _openComplaintsTab('3'),
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedProgress,
        title: "Inprogress Complaints",
        value: controller.countFromKey('in_progress_complaints').toString(),
        onTap: () => _openComplaintsTab('2'),
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedLoading01,
        title: "Pending Complaints",
        value: controller.countFromKey('pending_complaints').toString(),
        onTap: () => _openComplaintsTab('1'),
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedCancelCircleHalfDot,
        title: "Rejected Complaints",
        value: controller.countFromKey('rejected_complaint').toString(),
        onTap: () => _openComplaintsTab('4'),
      ),
    ];

    return LiveGrid.options(
      options: LiveOptions(
        delay: Duration(milliseconds: 100),
        showItemInterval: Duration(milliseconds: 100),
        showItemDuration: Duration(milliseconds: 300),
        reAnimateOnVisibility: false,
      ),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: SizedBox(height: 50, child: items[index]),
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void _openComplaintsTab(String status) {
    if (status.isNotEmpty) {
      complaintController.selectedFilterStatus.value = status;
      getIt<NavigationController>().updateIndex(1, isFromDashboard: true);
    } else {
      getIt<NavigationController>().updateIndex(1, isFromDashboard: false);
    }
  }

  /////////////////////////////////////////////////////////////
  /// COMPLAINT SUMMARY PIE
  /////////////////////////////////////////////////////////////

  Widget _complaintSummary() {
    final int totalComplaints = controller.countFromKey('total_complaints');
    final int completed = controller.countFromKey('complete_complaint');
    final int inProgress = controller.countFromKey('in_progress_complaints');
    final int pending = controller.countFromKey('pending_complaints');
    final int rejected = controller.countFromKey('rejected_complaint');

    double percent(int value) =>
        totalComplaints == 0 ? 0 : (value / totalComplaints) * 100;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              TranslatedText(
                title: "All Summary",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.22.sh,
                  width: 0.22.sw,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          centerSpaceRadius: 50.r,
                          centerSpaceColor: Colors.white,
                          sectionsSpace: 2,
                          borderData: FlBorderData(show: false),
                          sections: [
                            PieChartSectionData(
                              value: completed.toDouble(),
                              radius: 28.r,
                              color: Colors.green,
                              title:
                                  "${percent(completed).toStringAsFixed(0)}%",
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: inProgress.toDouble(),
                              radius: 26.r,
                              color: Colors.blue,
                              title:
                                  "${percent(inProgress).toStringAsFixed(0)}%",
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: pending.toDouble(),
                              radius: 24.r,
                              color: Colors.orange,
                              title: "${percent(pending).toStringAsFixed(0)}%",
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: rejected.toDouble(),
                              radius: 22.r,
                              color: Colors.red,
                              title: "${percent(rejected).toStringAsFixed(0)}%",
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$totalComplaints",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(
                      "Completed",
                      completed,
                      Colors.green,
                      percent(completed),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "In Progress",
                      inProgress,
                      Colors.blue,
                      percent(inProgress),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Pending",
                      pending,
                      Colors.orange,
                      percent(pending),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Rejected",
                      rejected,
                      Colors.red,
                      percent(rejected),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, int count, Color color, double percent) {
    return Row(
      children: [
        Container(
          width: 14.w,
          height: 14.h,
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
        ),
        Expanded(
          child: TranslatedText(
            title: "$label ($count)",
            fontSize: 12.sp,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: TranslatedText(
            title: "${percent.toStringAsFixed(0)}%",
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////////
  /// MONTHLY CHART
  /////////////////////////////////////////////////////////////

  Widget _monthlyComplaintChart() {
    if (controller.chartData.isEmpty) return const SizedBox.shrink();
    bool isAllZero = controller.chartData.every((item) {
      return (item["pending"] == 0) &&
          (item["inProgress"] == 0) &&
          (item["completed"] == 0) &&
          (item["rejected"] == 0);
    });
    if (isAllZero) return const SizedBox.shrink();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Monthly Complaints", HugeIcons.strokeRoundedAnalytics02),
          SizedBox(height: 16.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  legend("Pending", const Color(0xffe83e8c)),
                  legend("In Progress", const Color(0xffffc105)),
                  legend("Completed", const Color(0xff58d8a3)),
                  legend("Rejected", const Color(0xffFB0404)),
                ],
              ),

              SizedBox(height: 8.w),

              SizedBox(
                height: 250.h,
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.h, right: 10.w),
                      width: controller.chartData.length * 60.w,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              tooltipBorderRadius: BorderRadius.circular(8.r),
                              tooltipPadding: EdgeInsets.all(8),
                              getTooltipItem: (group, _, __, ___) {
                                final item = controller.chartData[group.x];

                                return BarTooltipItem(
                                  "${item["month"]}\n"
                                  "Pending : ${item["pending"]}\n"
                                  "InProgress : ${item["inProgress"]}\n"
                                  "Completed : ${item["completed"]}\n"
                                  "Rejected : ${item["rejected"]}",
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          barGroups: buildBarGroups(),

                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false,
                            horizontalInterval: 2,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withValues(alpha: 0.2),
                                strokeWidth: 1,
                              );
                            },
                          ),

                          borderData: FlBorderData(show: false),
                          maxY: controller.getMaxComplaintCount().toDouble(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >=
                                      controller.chartData.length) {
                                    return const SizedBox();
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(top: 6.h),
                                    child: Text(
                                      controller.chartData[value
                                          .toInt()]["month"],
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> buildBarGroups() {
    return List.generate(controller.chartData.length, (index) {
      final item = controller.chartData[index];

      double pending = item["pending"].toDouble();
      double inProgress = item["inProgress"].toDouble();
      double completed = item["completed"].toDouble();
      double rejected = item["rejected"].toDouble();

      double total = pending + inProgress + completed + rejected;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            width: 10,

            rodStackItems: [
              /// Pending
              BarChartRodStackItem(0, pending, const Color(0xffe83e8c)),

              /// In Progress
              BarChartRodStackItem(
                pending,
                pending + inProgress,
                const Color(0xffffc105),
              ),

              /// Completed
              BarChartRodStackItem(
                pending + inProgress,
                pending + inProgress + completed,
                const Color(0xff58d8a3),
              ),

              /// Rejected
              BarChartRodStackItem(
                pending + inProgress + completed,
                total,
                const Color(0xffFB0404),
              ),
            ],
          ),
        ],
      );
    });
  }

  /////////////////////////////////////////////////////////////
  /// COMPLAINT TYPE
  /////////////////////////////////////////////////////////////

  Widget _complaintTypeChart() {
    if (controller.complaintTypeData.isEmpty ||
        controller.complaintTypeData.values.every((value) => value == 0)) {
      return const SizedBox(); // OR show "No Data"
    }
    final chartData = controller.complaintTypeData.entries.toList();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Complaint Type", HugeIcons.strokeRoundedAnalytics02),
          SizedBox(height: 14.h),

          /// Your existing pie chart code
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.2.sh,
                  width: 0.2.sw,
                  child: PieChart(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    PieChartData(
                      sections: chartData.map((entry) {
                        final color = getColor(entry.key);
                        return PieChartSectionData(
                          color: color,
                          value: entry.value.toDouble(),
                          title: "${entry.value.toInt()}%",
                          radius: 24.r,
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: chartData.map((entry) {
                    final color = getColor(entry.key);
                    return _legendItem(
                      entry.key,
                      entry.value.toInt(),
                      color,
                      entry.value.toDouble(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// RECENT COMPLAINTS
  /////////////////////////////////////////////////////////////

  Widget _recentComplaints() {
    if (controller.recentComplaint.isEmpty) return const SizedBox();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Recent Complaints", HugeIcons.strokeRoundedAnalytics02),
          SizedBox(height: 12.h),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(
                width: 0.5,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableCell('Complaint No', isHeader: true),
                    tableCell('Department', isHeader: true),
                    tableCell('Status', isHeader: true),
                    tableCell('Created On', isHeader: true),
                  ],
                ),
                // Data Rows
                ...controller.recentComplaint.asMap().entries.map((entry) {
                  // int index = entry.key + 1;
                  Map<String, dynamic> dept = entry.value;
                  return TableRow(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.complaintDetails,
                          arguments: {'id': dept['id'].toString()},
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              dept['code']?.toString() ?? '-',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      tableCell(dept['department'] ?? '-'),
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.only(left: 8.w),
                            decoration: BoxDecoration(
                              color: Color(int.parse(dept['status_color'])),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    int.parse(dept['status_color']),
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 4.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                dept['status'].toString(),
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),

                      tableCell(formatDate(dept['created_at'].toString())),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// DEAD COMPLAINTS
  /////////////////////////////////////////////////////////////

  Widget _deadComplaints() {
    if (controller.deadComplaints.isEmpty) return const SizedBox();
    return dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Dead Complaints", HugeIcons.strokeRoundedAnalytics02),
          SizedBox(height: 12.h),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(
                width: 0.5,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableCell('Complaint No', isHeader: true),
                    tableCell('Department', isHeader: true),
                    tableCell('Status', isHeader: true),
                    tableCell('Created On', isHeader: true),
                  ],
                ),
                // Data Rows
                ...controller.deadComplaints.asMap().entries.map((entry) {
                  Map<String, dynamic> dept = entry.value;
                  return TableRow(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.complaintDetails,
                          arguments: {'id': dept['id'].toString()},
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              dept['code']?.toString() ?? '-',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      tableCell(dept['department'] ?? '-'),
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.only(left: 8.w),
                            decoration: BoxDecoration(
                              color: Color(int.parse(dept['status_color'])),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    int.parse(dept['status_color']),
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 4.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                dept['status'].toString(),
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),

                      tableCell(formatDate(dept['created_at'].toString())),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// CARD WRAPPER (Reusable)
  /////////////////////////////////////////////////////////////

  Widget dashboardCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  /////////////////////////////////////////////////////////////
  /// HEADER
  /////////////////////////////////////////////////////////////
  Widget header(String title, dynamic icon) {
    return Row(
      spacing: 10.w,
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: HugeIcon(icon: icon, size: 18.sp, color: primaryColor),
        ),
        Expanded(
          child: TranslatedText(
            title: title,
            fontSize: 16.sp,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _infoGridShimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(6, (index) => const DashboardCardShimmer()),
      ),
    );
  }
}

class DashboardCardShimmer extends StatelessWidget {
  const DashboardCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon placeholder
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            // Title placeholder
            Container(width: 80, height: 12, color: Colors.grey[300]),
            const SizedBox(height: 8),
            // Value placeholder
            Container(width: 50, height: 20, color: Colors.grey[300]),
            const SizedBox(height: 8),
            // Percentage placeholder
            Container(width: 40, height: 12, color: Colors.grey[300]),
            const Spacer(),
            // Update date placeholder
            Container(width: 100, height: 10, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
