import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Day24Page extends StatefulWidget {
  const Day24Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day24PageState();
}

class _Day24PageState extends State<Day24Page> with TickerProviderStateMixin {
  late final TabController _tabController;
  int currentTabIndex = 0;

  final player = AudioPlayer();

  List<String> musicList = ['thunder.mp3', 'tiger.mp3'];
  String? playingMusic;
  List<String> favoriteList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    loadFavorite();

    player.onPlayerComplete.listen((event) {
      setState(() {
        playingMusic = null;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteList = prefs.getStringList('favorite') ?? [];
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    currentTabIndex = _tabController.index;
  }

  Future<void> _handleAudio(String music) async {
    if (playingMusic == music) {
      await player.stop();
      setState(() {
        playingMusic = null;
      });
    } else {
      await player.stop();
      await player.play(AssetSource('audios/$music'));
      setState(() {
        playingMusic = music;
      });
    }
  }

  Future<void> _handleFavorite(String music) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteList.contains(music)) {
        favoriteList.remove(music);
      } else {
        favoriteList.add(music);
      }
      prefs.setStringList('favorite', favoriteList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("음악 플레이어"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "전체 곡"),
            Tab(text: "즐겨찾기 곡"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(2, (tabIndex) {
          final filteredList = tabIndex == 0
              ? musicList
              : musicList.where((e) => favoriteList.contains(e)).toList();

          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final music = filteredList[index];
              final isThisPlaying = (playingMusic == music);

              return ListTile(
                title: Text(music),
                leading: GestureDetector(
                  onTap: () {
                    _handleAudio(music);
                  },
                  child: Icon(isThisPlaying ? Icons.stop : Icons.play_arrow),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    _handleFavorite(music);
                  },
                  child: Icon(
                    Icons.star,
                    color: favoriteList.contains(music)
                        ? Colors.amber
                        : Colors.black,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
