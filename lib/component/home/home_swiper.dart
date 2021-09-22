import 'package:card_swiper/card_swiper.dart';
import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/api/transformer/banner.dart';
import 'package:demo09/model/banner.dart';
import 'package:demo09/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class HomeSwiper extends StatefulWidget {
  const HomeSwiper({Key? key}) : super(key: key);

  @override
  _HomeSwiperState createState() => _HomeSwiperState();
}

class _HomeSwiperState extends State<HomeSwiper> {
  List<BannerModel?> _banners = [];
  HttpClient? _dio;

  Future<void> getBanners() async {
    HttpResponse? res = await _dio?.get(
      '/banner?${DateTime.now().millisecondsSinceEpoch}',
      httpTransformer: BannerTransfromer.getInstance(),
    );
    if (res?.ok ?? false) {
      _banners.clear();
      res?.data.forEach((e) {
        _banners.add(BannerModel.fromMap(e));
      });
    } else {
      Future.delayed(Duration(seconds: 5), () {
        getBanners();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dio = context.read<HttpModel>().dio;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('Home 轮播图重构');
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey,
      ),
      height: 400 / (1080 / 330),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FutureBuilder(
          future: getBanners(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return SpinKitWave(
                  color: Theme.of(context).primaryColor,
                  size: 32,
                );
              case ConnectionState.done:
              default:
                return Swiper(
                  index: 0,
                  loop: true,
                  autoplay: true,
                  duration: 300,
                  itemCount: _banners.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      _banners[index]!.imageUrl + '?param=1080y400',
                      fit: BoxFit.cover,
                    );
                  },
                  pagination: SwiperPagination(
                    builder: RectSwiperPaginationBuilder(
                      activeColor: Colors.black,
                      color: Colors.white,
                      activeSize: Size(15, 7.5),
                      size: Size(15, 7.5),
                      space: 3,
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
