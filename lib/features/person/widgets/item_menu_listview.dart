import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_streams_app/common/helpers/constants.dart';
import 'package:live_streams_app/common/helpers/utils.dart';

class ItemMenu {
  final int id;
  final String title;
  final String icon;

  ItemMenu(this.id, this.title, this.icon);
}

class ItemMenuListView extends StatefulWidget {
  final int index;
  final bool isSelected;
  final ItemMenu item;
  final VoidCallback onSelect;

  const ItemMenuListView({
    Key? key,
    required this.index,
    required this.isSelected,
    required this.item,
    required this.onSelect,
  }) : super(key: key);

  @override
  _ItemMenuListViewState createState() => _ItemMenuListViewState();
}

class _ItemMenuListViewState extends State<ItemMenuListView> {
  @override
  Widget build(BuildContext context) {
    final titleColor =
        widget.isSelected ? Colors.white : ColorConstants.neutralColor1;
    final bgColor =
        widget.isSelected ? ColorConstants.brandColor : Colors.white;
    return GestureDetector(
      key: UniqueKey(),
      onTap: widget.onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: [
            SvgPicture.asset(
              widget.item.icon,
              height: 28,
              color: widget.isSelected
                  ? Colors.white
                  : ColorConstants.neutralColor1,
            ),
            const SizedBox(width: 24),
            Text(widget.item.title, style: Utils.setStyle(color: titleColor)),
            const Spacer(),
            SvgPicture.asset(
              'assets/icons/ic_arrow_right.svg',
              color: titleColor,
            )
          ],
        ),
      ),
    );
  }
}
