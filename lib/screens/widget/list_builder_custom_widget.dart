import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/color_manger.dart';
import '../../constants/constants.dart';
import '../../constants/font_manager.dart';
import '../../constants/style_manager.dart';
import '../../constants/values_manger.dart';

class ListBuilderCustomWidget extends HookWidget {
  const ListBuilderCustomWidget({
    Key? key,
    required this.index,
    required this.name,
    required this.code,
    required this.baseUnit,
    required this.scannedUnit,
    required this.scannedQty,
    required this.qty,
    required this.barcode,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final String name;
  final String code;
  final String baseUnit;
  final String scannedUnit;
  final String? scannedQty;
  final String? qty;
  final String? barcode;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
      child: InkWell(
        onDoubleTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xffD7E4F4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text("#$index", style: getSemiBoldStyle(color: ColorManager.black, fontSize: FontSize.s16)),
              ),
              _buildRichText("Name", name),
              _buildRichText("Code", code),
              _buildRichText("Base Unit", baseUnit),
              _buildRichText("Scanned Unit", scannedUnit),
              _buildRichText("Qty", qty ?? ""),
              _buildRichText("Scanned Qty", scannedQty ?? ""),
              _buildRichText("Barcode", barcode ?? ""),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: onTap,
                    child: Icon(Icons.edit_rounded)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RichText _buildRichText(String label, String value) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: getSemiBoldStyle(color: ColorManager.grey, fontSize: FontSize.s12),
          ),
          TextSpan(
            text: value,
            style: getSemiBoldStyle(color: ColorManager.black, fontSize: FontSize.s14),
          ),
        ],
      ),
    );
  }
}

