import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goldapi/controllers/PlayerController.dart';
import 'package:goldapi/utils/responsive.dart';
import 'package:goldapi/widgets/responsive_layout.dart';

class PlayerScreen extends StatelessWidget{
  final PlayerController controller= Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Players",
          style: TextStyle(
            fontSize: Responsive.textSize(context, 18, 22, 26),
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),

      body: Obx((){
        print("Rebuilding UI with ${controller.players.length} players");
        if(controller.players.isEmpty && controller.isLoading.value){
          return const Center(child: CircularProgressIndicator());
        }
        return ResponsiveLayout(
          mobile: _playerList(context, crossAxisCount:1),
          tablet: _playerList(context, crossAxisCount:2),
          desktop: _playerList(context, crossAxisCount:4),
        );
      }),

      bottomNavigationBar: Obx((){
        if(controller.progress.value>0 && controller.progress.value<1){
          return LinearProgressIndicator(value: controller.progress.value);
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _playerList(BuildContext context, {required int crossAxisCount}){
    return GridView.builder(

        shrinkWrap: true, // Grid shrink to avoid tiny overflow
        padding: EdgeInsets.only(
          left: Responsive.pagePadding(context).left,
          right: Responsive.pagePadding(context).right,
          top: Responsive.pagePadding(context).top,
          bottom: Responsive.pagePadding(context).bottom + 1, // add 1 px buffer
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3
        ),
        itemCount: controller.players.length,
        itemBuilder: (context,index){
          final p = controller.players[index];
          return ClipRect(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                  padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        p.name,
                        style: TextStyle(
                          fontSize: Responsive.textSize(context, 12, 14, 16),
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        '${p.position} * ${p.national_team}',
                        style: TextStyle(
                          fontSize: Responsive.textSize(context, 10, 12, 14),
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
  
  
}