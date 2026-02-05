 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ridhoplaylist/lib/main.dart b/ridhoplaylist/lib/main.dart
new file mode 100644
index 0000000000000000000000000000000000000000..c2232b4eb7408136313d16497dc62ca2406afa83
--- /dev/null
+++ b/ridhoplaylist/lib/main.dart
@@ -0,0 +1,528 @@
+import 'dart:io';
+
+import 'package:file_picker/file_picker.dart';
+import 'package:flutter/material.dart';
+import 'package:just_audio/just_audio.dart';
+import 'package:path/path.dart' as path;
+import 'package:permission_handler/permission_handler.dart';
+
+void main() {
+  runApp(const RidhoPlaylistApp());
+}
+
+class RidhoPlaylistApp extends StatelessWidget {
+  const RidhoPlaylistApp({super.key});
+
+  @override
+  Widget build(BuildContext context) {
+    return MaterialApp(
+      title: 'RidhoPlaylist',
+      debugShowCheckedModeBanner: false,
+      theme: ThemeData(
+        brightness: Brightness.dark,
+        scaffoldBackgroundColor: const Color(0xFF121212),
+        colorScheme: const ColorScheme.dark(
+          primary: Color(0xFF1DB954),
+          secondary: Color(0xFF1ED760),
+          surface: Color(0xFF181818),
+        ),
+        appBarTheme: const AppBarTheme(
+          backgroundColor: Color(0xFF121212),
+          elevation: 0,
+        ),
+      ),
+      home: const HomeScreen(),
+    );
+  }
+}
+
+class HomeScreen extends StatefulWidget {
+  const HomeScreen({super.key});
+
+  @override
+  State<HomeScreen> createState() => _HomeScreenState();
+}
+
+class _HomeScreenState extends State<HomeScreen> {
+  int _currentIndex = 0;
+
+  final List<Widget> _pages = const [
+    PlaylistScreen(),
+    ScanScreen(),
+  ];
+
+  @override
+  Widget build(BuildContext context) {
+    return Scaffold(
+      body: _pages[_currentIndex],
+      bottomNavigationBar: BottomNavigationBar(
+        currentIndex: _currentIndex,
+        backgroundColor: const Color(0xFF181818),
+        selectedItemColor: const Color(0xFF1DB954),
+        unselectedItemColor: Colors.white70,
+        onTap: (index) => setState(() => _currentIndex = index),
+        items: const [
+          BottomNavigationBarItem(
+            icon: Icon(Icons.queue_music),
+            label: 'Playlists',
+          ),
+          BottomNavigationBarItem(
+            icon: Icon(Icons.library_music),
+            label: 'Songs',
+          ),
+        ],
+      ),
+    );
+  }
+}
+
+class PlaylistScreen extends StatelessWidget {
+  const PlaylistScreen({super.key});
+
+  @override
+  Widget build(BuildContext context) {
+    final playlists = [
+      _PlaylistCardData(
+        title: 'Daily Focus',
+        description: 'Beat lo-fi untuk fokus kerja',
+        icon: Icons.nightlife,
+      ),
+      _PlaylistCardData(
+        title: 'Indie Chill',
+        description: 'Gitar santai dan vokal hangat',
+        icon: Icons.waves,
+      ),
+      _PlaylistCardData(
+        title: 'Workout Mix',
+        description: 'Tempo cepat, semangat maksimal',
+        icon: Icons.fitness_center,
+      ),
+      _PlaylistCardData(
+        title: 'Top Hits 2024',
+        description: 'Lagu hits pilihan minggu ini',
+        icon: Icons.trending_up,
+      ),
+    ];
+
+    return SafeArea(
+      child: Column(
+        crossAxisAlignment: CrossAxisAlignment.start,
+        children: [
+          Padding(
+            padding: const EdgeInsets.all(20),
+            child: Text(
+              'RidhoPlaylist',
+              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
+                    fontWeight: FontWeight.bold,
+                  ),
+            ),
+          ),
+          Padding(
+            padding: const EdgeInsets.symmetric(horizontal: 20),
+            child: Text(
+              'Koleksi playlist untuk setiap mood.',
+              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
+                    color: Colors.white70,
+                  ),
+            ),
+          ),
+          const SizedBox(height: 16),
+          Expanded(
+            child: ListView.separated(
+              padding: const EdgeInsets.symmetric(horizontal: 20),
+              itemBuilder: (context, index) => _PlaylistCard(data: playlists[index]),
+              separatorBuilder: (_, __) => const SizedBox(height: 12),
+              itemCount: playlists.length,
+            ),
+          ),
+          const _MiniPlayer(),
+        ],
+      ),
+    );
+  }
+}
+
+class _PlaylistCardData {
+  const _PlaylistCardData({
+    required this.title,
+    required this.description,
+    required this.icon,
+  });
+
+  final String title;
+  final String description;
+  final IconData icon;
+}
+
+class _PlaylistCard extends StatelessWidget {
+  const _PlaylistCard({required this.data});
+
+  final _PlaylistCardData data;
+
+  @override
+  Widget build(BuildContext context) {
+    return Container(
+      padding: const EdgeInsets.all(16),
+      decoration: BoxDecoration(
+        color: const Color(0xFF181818),
+        borderRadius: BorderRadius.circular(16),
+      ),
+      child: Row(
+        children: [
+          CircleAvatar(
+            radius: 26,
+            backgroundColor: const Color(0xFF1DB954),
+            child: Icon(data.icon, color: Colors.black),
+          ),
+          const SizedBox(width: 16),
+          Expanded(
+            child: Column(
+              crossAxisAlignment: CrossAxisAlignment.start,
+              children: [
+                Text(
+                  data.title,
+                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
+                        fontWeight: FontWeight.bold,
+                      ),
+                ),
+                const SizedBox(height: 6),
+                Text(
+                  data.description,
+                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
+                        color: Colors.white60,
+                      ),
+                ),
+              ],
+            ),
+          ),
+          const Icon(Icons.chevron_right, color: Colors.white54),
+        ],
+      ),
+    );
+  }
+}
+
+class _MiniPlayer extends StatelessWidget {
+  const _MiniPlayer();
+
+  @override
+  Widget build(BuildContext context) {
+    return Container(
+      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
+      decoration: const BoxDecoration(
+        color: Color(0xFF1A1A1A),
+        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
+      ),
+      child: Row(
+        children: [
+          Container(
+            width: 48,
+            height: 48,
+            decoration: BoxDecoration(
+              color: const Color(0xFF1DB954),
+              borderRadius: BorderRadius.circular(12),
+            ),
+            child: const Icon(Icons.music_note, color: Colors.black),
+          ),
+          const SizedBox(width: 12),
+          Expanded(
+            child: Column(
+              crossAxisAlignment: CrossAxisAlignment.start,
+              children: [
+                Text(
+                  'Belum ada lagu diputar',
+                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
+                        fontWeight: FontWeight.bold,
+                      ),
+                ),
+                const SizedBox(height: 4),
+                Text(
+                  'Scan lagu MP3 lokal untuk mulai',
+                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
+                        color: Colors.white60,
+                      ),
+                ),
+              ],
+            ),
+          ),
+          IconButton(
+            onPressed: null,
+            icon: const Icon(Icons.play_arrow),
+            color: Colors.white38,
+          ),
+        ],
+      ),
+    );
+  }
+}
+
+class ScanScreen extends StatefulWidget {
+  const ScanScreen({super.key});
+
+  @override
+  State<ScanScreen> createState() => _ScanScreenState();
+}
+
+class _ScanScreenState extends State<ScanScreen> {
+  final AudioPlayer _player = AudioPlayer();
+  final List<FileSystemEntity> _songs = [];
+  int? _currentIndex;
+  bool _isScanning = false;
+
+  @override
+  void dispose() {
+    _player.dispose();
+    super.dispose();
+  }
+
+  Future<void> _requestStoragePermission() async {
+    if (!Platform.isAndroid) {
+      return;
+    }
+    final status = await Permission.storage.request();
+    if (!status.isGranted) {
+      await Permission.audio.request();
+    }
+  }
+
+  Future<void> _scanForSongs() async {
+    setState(() => _isScanning = true);
+    await _requestStoragePermission();
+
+    final directoryPath = await FilePicker.platform.getDirectoryPath(
+      dialogTitle: 'Pilih folder musik',
+    );
+
+    if (directoryPath == null) {
+      setState(() => _isScanning = false);
+      return;
+    }
+
+    final directory = Directory(directoryPath);
+    if (!await directory.exists()) {
+      setState(() => _isScanning = false);
+      return;
+    }
+
+    final mp3Files = <FileSystemEntity>[];
+    await for (final entity in directory.list(recursive: true, followLinks: false)) {
+      if (entity is File && entity.path.toLowerCase().endsWith('.mp3')) {
+        mp3Files.add(entity);
+      }
+    }
+
+    setState(() {
+      _songs
+        ..clear()
+        ..addAll(mp3Files);
+      _currentIndex = _songs.isNotEmpty ? 0 : null;
+      _isScanning = false;
+    });
+
+    if (_songs.isNotEmpty) {
+      await _loadSong(0);
+    } else {
+      await _player.stop();
+    }
+  }
+
+  Future<void> _loadSong(int index) async {
+    if (index < 0 || index >= _songs.length) {
+      return;
+    }
+    final file = _songs[index] as File;
+    await _player.setFilePath(file.path);
+    setState(() => _currentIndex = index);
+  }
+
+  Future<void> _togglePlayback() async {
+    if (_songs.isEmpty) {
+      return;
+    }
+    if (_player.playing) {
+      await _player.pause();
+    } else {
+      await _player.play();
+    }
+    setState(() {});
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    return SafeArea(
+      child: Column(
+        crossAxisAlignment: CrossAxisAlignment.start,
+        children: [
+          Padding(
+            padding: const EdgeInsets.all(20),
+            child: Row(
+              children: [
+                Expanded(
+                  child: Text(
+                    'Lagu Lokal',
+                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
+                          fontWeight: FontWeight.bold,
+                        ),
+                  ),
+                ),
+                ElevatedButton.icon(
+                  onPressed: _isScanning ? null : _scanForSongs,
+                  style: ElevatedButton.styleFrom(
+                    backgroundColor: const Color(0xFF1DB954),
+                    foregroundColor: Colors.black,
+                  ),
+                  icon: _isScanning
+                      ? const SizedBox(
+                          width: 16,
+                          height: 16,
+                          child: CircularProgressIndicator(strokeWidth: 2),
+                        )
+                      : const Icon(Icons.search),
+                  label: Text(_isScanning ? 'Scanning' : 'Scan MP3'),
+                ),
+              ],
+            ),
+          ),
+          if (_songs.isEmpty)
+            Padding(
+              padding: const EdgeInsets.symmetric(horizontal: 20),
+              child: Text(
+                'Belum ada MP3. Pilih folder musik untuk mulai memindai.',
+                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
+                      color: Colors.white70,
+                    ),
+              ),
+            )
+          else
+            Expanded(
+              child: ListView.separated(
+                padding: const EdgeInsets.symmetric(horizontal: 20),
+                itemBuilder: (context, index) {
+                  final file = _songs[index] as File;
+                  final isActive = index == _currentIndex;
+                  return ListTile(
+                    contentPadding: EdgeInsets.zero,
+                    leading: CircleAvatar(
+                      backgroundColor: isActive
+                          ? const Color(0xFF1DB954)
+                          : const Color(0xFF2A2A2A),
+                      child: Icon(
+                        isActive ? Icons.play_arrow : Icons.music_note,
+                        color: isActive ? Colors.black : Colors.white70,
+                      ),
+                    ),
+                    title: Text(
+                      path.basenameWithoutExtension(file.path),
+                      style: TextStyle(
+                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
+                      ),
+                    ),
+                    subtitle: Text(
+                      path.dirname(file.path),
+                      maxLines: 1,
+                      overflow: TextOverflow.ellipsis,
+                      style: const TextStyle(color: Colors.white54),
+                    ),
+                    trailing: IconButton(
+                      icon: Icon(
+                        isActive && _player.playing ? Icons.pause : Icons.play_arrow,
+                        color: const Color(0xFF1DB954),
+                      ),
+                      onPressed: () async {
+                        await _loadSong(index);
+                        await _togglePlayback();
+                      },
+                    ),
+                  );
+                },
+                separatorBuilder: (_, __) => const Divider(color: Colors.white10),
+                itemCount: _songs.length,
+              ),
+            ),
+          if (_songs.isNotEmpty)
+            _NowPlayingBar(
+              player: _player,
+              songTitle: _currentIndex != null
+                  ? path.basenameWithoutExtension((_songs[_currentIndex!] as File).path)
+                  : 'Tidak ada lagu',
+              onPlayPause: _togglePlayback,
+            ),
+        ],
+      ),
+    );
+  }
+}
+
+class _NowPlayingBar extends StatelessWidget {
+  const _NowPlayingBar({
+    required this.player,
+    required this.songTitle,
+    required this.onPlayPause,
+  });
+
+  final AudioPlayer player;
+  final String songTitle;
+  final VoidCallback onPlayPause;
+
+  @override
+  Widget build(BuildContext context) {
+    return StreamBuilder<Duration>(
+      stream: player.positionStream,
+      builder: (context, snapshot) {
+        final position = snapshot.data ?? Duration.zero;
+        final duration = player.duration ?? Duration.zero;
+        final maxSeconds = duration.inSeconds.toDouble().clamp(1, double.infinity);
+        final currentSeconds = position.inSeconds.toDouble().clamp(0, maxSeconds);
+
+        return Container(
+          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
+          decoration: const BoxDecoration(
+            color: Color(0xFF1A1A1A),
+            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
+          ),
+          child: Column(
+            crossAxisAlignment: CrossAxisAlignment.start,
+            children: [
+              Text(
+                'Now Playing',
+                style: Theme.of(context).textTheme.labelMedium?.copyWith(
+                      color: Colors.white60,
+                    ),
+              ),
+              const SizedBox(height: 6),
+              Row(
+                children: [
+                  Expanded(
+                    child: Text(
+                      songTitle,
+                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
+                            fontWeight: FontWeight.bold,
+                          ),
+                      maxLines: 1,
+                      overflow: TextOverflow.ellipsis,
+                    ),
+                  ),
+                  IconButton(
+                    onPressed: onPlayPause,
+                    icon: Icon(player.playing ? Icons.pause : Icons.play_arrow),
+                    color: const Color(0xFF1DB954),
+                  ),
+                ],
+              ),
+              Slider(
+                value: currentSeconds,
+                min: 0,
+                max: maxSeconds,
+                activeColor: const Color(0xFF1DB954),
+                inactiveColor: Colors.white24,
+                onChanged: (value) async {
+                  await player.seek(Duration(seconds: value.toInt()));
+                },
+              ),
+            ],
+          ),
+        );
+      },
+    );
+  }
+}
 
EOF
)
