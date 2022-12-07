import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/database/database_model.dart';
import 'package:untitled/services/getData.dart';
import 'package:get/get.dart';
import 'package:untitled/services/themes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/services/textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Box<Mock> mockApiData;
  List<Map<String,dynamic>> mockData = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController numController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mockApiData = Hive.box('MockData');

  }


  Future<void> apiCall() async {
    getApi api = getApi();
    await api.getData();
    for (int i = 0; i < api.apiData.length; i++){
      mockData.add(api.apiData[i]);
    }
    for (int i = 0; i < mockData.length; i++){
      Map mockMap = mockData[i];
      int id = int.parse(mockMap['id']);
      String name = mockMap['name'];
      String job = mockMap['Profession'];
      String number = mockMap['number'];
      //debugPrint('$name, $id, $job, $number');
      mockApiData.put(id, Mock(name: name, job: job, number: number, id: id));
    }
    debugPrint('${mockApiData.toMap()}');

    setState(() {});
    //debugPrint(mockData.toString());
    //debugPrint('${mockData[1]}');
  }

  void _onRefresh() async{
    // monitor network fetch
    try{
      await apiCall();
      //if refresh completed
      _refreshController.refreshCompleted();
    }
    catch(e){
      debugPrint('$e');
      //if refresh failed
      _refreshController.refreshFailed();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF9896F0), Color(0xFFFBC8D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        backgroundColor: Colors.transparent,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _listView(context),
        )
      ),
    );
  }
  
  _appBar(){
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20)
        )
      ),
      title: const Text('SnellCart'),
      elevation: 2,
      centerTitle: true,
      flexibleSpace: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
        colors: [Color(0xFF4568DC), Color(0xFFB06AB3)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      stops: [0.1,0.7]
    ),
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20)
      )

    ),
      ),
    );
  }

  _listView(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: mockApiData.listenable(),
      builder: (context, Box<Mock> box, _){
        if(box.values.isEmpty){
          debugPrint('Box is empty');
        }
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullUp: false,
        header: const WaterDropMaterialHeader(
          backgroundColor: Colors.lightBlueAccent,
        ),
        child: ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index){
            Mock? m = box.getAt(index);
            //debugPrint(data['name']);
            return GestureDetector(
              onTap: (){_showBottomSheet(context, m);},
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 15,
                shadowColor: Colors.blueAccent,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(m?.name ?? 'name', style: headingStyle,),
                  subtitle: Text(m?.job ?? 'Job', style: subHeadingStyle,),
                  trailing: Text(m?.number ?? "number", style: trailingStyle,),
                ),
              ),
            );
          },),
      );}
    );
  }

  _bottomSheetButton({required String label, required Function()? onTap, required Color clr, required BuildContext context}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
            border: Border.all(
                color: clr,
                width: 2
            ),
            borderRadius: BorderRadius.circular(20),
            color: clr
        ),
        child: Center(child: Text(label,style: headingStyle,)),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Mock? m) async {
    await Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height*0.32,
          color: Colors.transparent.withOpacity(0.7),
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[400],
                ),
              ),
              const Spacer(),
              _bottomSheetButton(
                  label: 'Edit',
                  onTap: (){
                    if(m != null){
                      nameController.text = m.name;
                      jobController.text = m.job;
                      numController.text = m.number;
                    }
                    Get.back();
                    _editbottomSheet(m);

                  },
                  clr: Colors.white,
                  context: context),
              _bottomSheetButton(
                  label: 'Delete',
                  onTap: (){
                    mockApiData.delete(m?.id);
                    Get.back();
                  },
                  clr: Colors.white,
                  context: context),
              _bottomSheetButton(
                  label: 'Close',
                  onTap: (){Get.back();},
                  clr: const Color(0xFFFF2E2E),
                  context: context),
              const SizedBox(height: 10,)
            ],
          ),
        ),
      )
    );
  }

  _editbottomSheet(Mock? m) async {
    await Get.bottomSheet(
        isScrollControlled: true,
     ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height*0.44,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[400],
              ),
            ),
            Textfield(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                ), onChanged: (value) {  },
            ),
            Textfield(
                onChanged: (jb){},
                controller: jobController,
                decoration: InputDecoration(
                    hintText: 'Job',
                    labelText: 'Profession',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                )
            ),
            Textfield(
                onChanged: (nmb){},
                controller: numController,
                decoration: InputDecoration(
                    hintText: 'Number',
                    labelText: 'Phone no.',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                )
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      mockApiData.put(m?.id, Mock(name: nameController.text, job: jobController.text, number: numController.text, id: m?.id,));
                      Get.back();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF647DEE),Color(0xFF7F53AC)]
                      )
                    ),
                    child: const Center(child: Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),)),
                  ),
                ),
                const SizedBox(height: 40,)
              ],
            )
          ],
        ),
      ),
    )
    );
  }
}
