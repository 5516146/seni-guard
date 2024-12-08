import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const WalkingRoutesScreen());

class WalkingRoutesScreen extends StatefulWidget {
  const WalkingRoutesScreen({super.key});

  @override
  _WalkingRoutesScreenState createState() => _WalkingRoutesScreenState();
}

class _WalkingRoutesScreenState extends State<WalkingRoutesScreen> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  List<RouteInfo> _routes = [];
  int _selectedRouteIndex = 0;

  final List<Map<String, dynamic>> walkingTrails = [
    {
      "구간시점위도": "35.85545507671219",  // 계명대 동문
      "구간시점경도": "128.4925301902473",
      "구간종점위도": "35.8510",
      "구간종점경도": "128.5080",
      "위치명": "달구벌대로 코스",
      "구간난이도": "하",
      "산책로구간거리": "2000.0",
      "구간시점위치": "계명대학교 동문",
      "구간종점위치": "이곡역",
      "산책로설명": "달구벌대로를 따라 걷는 가장 빠른 경로",
    },
    {
      "구간시점위도": "35.85545507671219",  // 계명대 동문
      "구간시점경도": "128.4925301902473",
      "구간종점위도": "35.8510",
      "구간종점경도": "128.5080",
      "위치명": "주택가 코스",
      "구간난이도": "중",
      "산책로구간거리": "2200.0",
      "구간시점위치": "계명대학교 동문",
      "구간종점위치": "이곡역",
      "산책로설명": "조용한 주택가를 통과하는 여유로운 경로",
    },
    {
      "구간시점위도": "35.85545507671219",  // 계명대 동문
      "구간시점경도": "128.4925301902473",
      "구간종점위도": "35.8510",
      "구간종점경도": "128.5080",
      "위치명": "공원 코스",
      "구간난이도": "중상",
      "산책로구간거리": "2300.0",
      "구간시점위치": "계명대학교 동문",
      "구간종점위치": "이곡역",
      "산책로설명": "근처 공원을 경유하는 자연친화적인 경로",
    },
  ];

  Future<void> _loadWalkingTrails() async {
    setState(() {
      _routes.clear();
      _polylines.clear();
      _markers.clear();

      // 시작점 마커 추가
      _markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(35.85545507671219, 128.4925301902473),
        infoWindow: const InfoWindow(title: '계명대학교 동문'),
      ));

      // 각 산책로에 대한 경로 생성
      for (int i = 0; i < walkingTrails.length; i++) {
        final trail = walkingTrails[i];
        
        final startLat = double.parse(trail['구간시점위도']);
        final startLng = double.parse(trail['구간시점경도']);
        final endLat = double.parse(trail['구간종점위도']);
        final endLng = double.parse(trail['구간종점경도']);

        List<LatLng> points = _createDetailedRoute(
          LatLng(startLat, startLng),
          LatLng(endLat, endLng),
          i,
        );

        final distance = double.parse(trail['산책로구간거리']);
        final distanceStr = distance >= 1000 
            ? '${(distance/1000).toStringAsFixed(1)}km' 
            : '${distance.toStringAsFixed(0)}m';

        _routes.add(RouteInfo(
          points: points,
          distance: distanceStr,
          duration: '예상 소요시간: ${(distance/80).round()}분',
          routeName: '${trail['위치명']} (${trail['구간난이도']})',
          index: i,
        ));

        _polylines.add(Polyline(
          polylineId: PolylineId('route_$i'),
          visible: true,
          points: points,
          color: _getRouteColor(i),
          width: 4,
        ));

        // 시작점과 끝점에 마커 추가
        _markers.add(Marker(
          markerId: MarkerId('trail_start_$i'),
          position: LatLng(startLat, startLng),
          infoWindow: InfoWindow(
            title: '${trail['위치명']} 시작점',
            snippet: trail['구간시점위치'],
          ),
        ));

        _markers.add(Marker(
          markerId: MarkerId('trail_end_$i'),
          position: LatLng(endLat, endLng),
          infoWindow: InfoWindow(
            title: '${trail['위치명']} 종점',
            snippet: '거리: $distanceStr, 난이도: ${trail['구간난이도']}\n${trail['산책로설명']}',
          ),
        ));
      }
    });
  }

  // 상세 경로 생성 함수 수정
  List<LatLng> _createDetailedRoute(LatLng start, LatLng end, int routeIndex) {
    List<LatLng> points = [];
    
    switch(routeIndex) {
      case 0:  // 달구벌대로 직진 코스
        points = [
          start,  // 동문
          LatLng(35.8545, 128.4940),  // 달구벌대로 진입
          LatLng(35.8535, 128.4960),  // 달구벌대로 1
          LatLng(35.8525, 128.4980),  // 달구벌대로 2
          LatLng(35.8515, 128.5020),  // 달구벌대로 3
          end,  // 이곡역
        ];
        break;
      
      case 1:  // 주택가 경유 코스
        points = [
          start,  // 동문
          LatLng(35.8540, 128.4930),  // 주택가 진입
          LatLng(35.8530, 128.4950),  // 주택가 1
          LatLng(35.8520, 128.4970),  // 주택가 2
          LatLng(35.8515, 128.5000),  // 주택가 3
          LatLng(35.8510, 128.5040),  // 달구벌대로 합류
          end,  // 이곡역
        ];
        break;
      
      case 2:  // 공원 경유 코스
        points = [
          start,  // 동문
          LatLng(35.8550, 128.4950),  // 공원 방향
          LatLng(35.8540, 128.4970),  // 공원 1
          LatLng(35.8530, 128.5000),  // 공원 2
          LatLng(35.8520, 128.5030),  // 공원 3
          LatLng(35.8515, 128.5060),  // 달구벌대로 합류
          end,  // 이곡역
        ];
        break;
    }
    
    return points;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadWalkingTrails();  // API 호출 대신 로컬 데이터 사용
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(35.85545507671219, 128.4925301902473),  // 계명대 동문
          infoWindow: const InfoWindow(title: '계명대학교 동문'),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    
    // 지도 초기 위치 설정
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(35.85545507671219, 128.4925301902473),  // 계명대 동문 위치
        15.0,
      ),
    );
  }

  Color _getRouteColor(int index) {
    final colors = [Colors.blue, Colors.red, Colors.green];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('산책 경로 추천'),
          backgroundColor: const Color.fromARGB(255, 114, 243, 232),
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(35.85545507671219, 128.4925301902473),
                zoom: 15.0,
              ),
              polylines: {
                if (_routes.isNotEmpty) _polylines.elementAt(_selectedRouteIndex)
              },
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => _selectedRouteIndex = 0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedRouteIndex == 0 ? Colors.blue : Colors.grey,
                      ),
                      child: Text('경로 1'),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => _selectedRouteIndex = 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedRouteIndex == 1 ? Colors.red : Colors.grey,
                      ),
                      child: Text('경로 2'),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => _selectedRouteIndex = 2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedRouteIndex == 2 ? Colors.green : Colors.grey,
                      ),
                      child: Text('경로 3'),
                    ),
                  ],
                ),
              ),
            ),
            if (_routes.isNotEmpty)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _routes[_selectedRouteIndex].routeName,  // 경로 이름 표시
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('거리: ${_routes[_selectedRouteIndex].distance}'),
                      Text('예상 시간: ${_routes[_selectedRouteIndex].duration}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RouteInfo {
  final List<LatLng> points;
  final String distance;
  final String duration;
  final String routeName;
  final int index;

  RouteInfo({
    required this.points,
    required this.distance,
    required this.duration,
    required this.routeName,
    required this.index,
  });
}
