import '../../../utils/exported_path.dart';

class ComplaintFilter extends StatefulWidget {
  const ComplaintFilter({super.key});

  @override
  State<ComplaintFilter> createState() => _ComplaintFilterState();
}

class _ComplaintFilterState extends State<ComplaintFilter> {
  final controller = getIt<ComplaintController>();

  @override
  void initState() {
    controller.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        // height: Get.height * 0.8.h,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: controller.mainLoader.isTrue
              ? LoadingWidget(color: primaryColor)
              : SingleChildScrollView(
                  child: Column(
                    spacing: 16.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Date Range
                      _buildDateRange(),

                      /// Complaint Status
                      _buildStatus(),

                      /// Complaint Type
                      _buildComplaintType(),

                      /// Complaint Source
                      _buildSource(),

                      /// Apply / Reset
                      _buildButtons(),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildDateRange() {
    return AppDropdownField(
      title: 'Date Range',
      value: controller.selectedDateRange.value,
      items: [
        "Today",
        "Yesterday",
        "This Week",
        "This Month",
        "Custom",
        if (controller.selectedDateRange.value != null &&
            ![
              "Today",
              "Yesterday",
              "This Week",
              "This Month",
              "Custom",
            ].contains(controller.selectedDateRange.value))
          controller.selectedDateRange.value!,
      ],
      hintText: 'Select Date Range',
      validator: (value) => value == null ? 'Please select Date Range' : null,
      onChanged: (val) async {
        controller.selectedDateRange.value = val;
        // if (val == "Custom") controller.pickCustomDateRange();
        if (val == "Custom") {
          controller.pickCustomDateRange();
        } else {
          controller.setDateRange(val!);
        }
      },
    );
  }

  Widget _buildStatus() {
    return AppDropdownField(
      isDynamic: true,
      title: 'Status',
      value: controller.selectedFilterStatus.value,
      items: controller.statusList,
      hintText: 'Select Status',
      validator: (value) => value == null ? 'Please select Status' : null,
      onChanged: (val) => controller.selectedFilterStatus.value = val,
    );
  }

  Widget _buildComplaintType() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 6),
            child: buildLabel('Complaint Type', isRequired: false),
          ),
          ButtonTheme(
            alignedDropdown: true,
            buttonColor: Colors.grey[700],
            splashColor: Colors.transparent,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(12.r),
              initialValue: controller.selectedType.value,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.w),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                focusedBorder: buildOutlineInputBorder(),
                enabledBorder: buildOutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                disabledBorder: buildOutlineInputBorder(),
                border: buildOutlineInputBorder(),
                hintText: 'Select Complaint Type',
                errorStyle: TextStyle(fontSize: 12.sp),
                errorMaxLines: 1,
              ),
              validator: (value) =>
                  value == null ? 'Please select Complaint Type' : null,
              dropdownColor: Colors.white,
              hint: Text(
                'Select Complaint Type',
                style: TextStyle(fontSize: 14.sp, color: primaryGrey),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              isExpanded: true,
              elevation: 4,
              items: controller.complaintType.map((value) {
                return DropdownMenuItem(
                  value: value['id'].toString(),
                  child: CustomText(
                    textAlign: TextAlign.start,
                    title: getIt<TranslateController>().lang.value == 'en'
                        ? value['name']
                        : value['name_mr'],
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                );
              }).toList(),
              onChanged: (val) => controller.selectedType.value = val!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSource() {
    return AppDropdownField(
      isDynamic: true,
      title: 'Source',
      value: controller.selectedSource.value,
      items: controller.sourceList,
      hintText: 'Select Source',
      validator: (value) => value == null ? 'Please select Source' : null,
      onChanged: (val) => controller.selectedSource.value = val!,
    );
  }

  Widget _buildButtons() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Reset -> OutlinedButton
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                side: BorderSide(color: primaryColor), // outline color
              ),
              onPressed: () => controller.resetFilters(false),
              child: Text("Reset", style: TextStyle(color: primaryColor)),
            ),
          ),
          SizedBox(width: 12.w), // space between buttons
          // Apply -> ElevatedButton
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: controller.applyFilters,
              child: Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }
}
