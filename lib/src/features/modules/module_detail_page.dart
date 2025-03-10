import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ModuleDetailPage extends StatefulWidget {
  final int id;
  final String title;

  const ModuleDetailPage({super.key, required this.id, required this.title});

  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'eygUTjQlOKI',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        showLiveFullscreenButton: false,
      ),
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Contoh data konten (nantinya bisa dari API)
    final List<Map<String, dynamic>> contents = [
      {
        'type': 'video',
        'content': 'Video Pembelajaran',
        'isTitle': true,
      },
      {
        'type': 'text',
        'content':
            'Basic concepts of electrical machinery, types of electrical machinery used in power generation, and basic working principles. An in-depth discussion of the components of power plant machinery, their functions, and how each component interacts. An in-depth discussion of the components of power plant machinery, their functions, and how each component interacts.',
        'isTitle': false,
      },
      {
        'type': 'image',
        'content':
            'https://images.pexels.com/photos/3573351/pexels-photo-3573351.png', // Sesuaikan path image
      },
      {
        'type': 'text',
        'content':
            'An in-depth discussion of the components of power plant machinery, their functions, and how each component interacts.',
        'isTitle': false,
      },
      {
        'type': 'image',
        'content':
            'https://images.pexels.com/photos/3573351/pexels-photo-3573351.png', // Sesuaikan path image
      },
      {
        'type': 'text',
        'content':
            'Multiple-choice and open-ended questions to test students\' basic understanding.',
        'isTitle': false,
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Bab ${widget.id} ${widget.title}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg', // Sesuaikan dengan path image yang tersedia
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) => Container(
                      color: Colors.deepOrange,
                    ),
                  ),
                  // Gradient overlay untuk memastikan text tetap terbaca
                  // Container(
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //       colors: [
                  //         Colors.transparent,
                  //         Colors.black.withOpacity(0.7),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contents.map((content) {
                  if (content['type'] == 'text') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        content['content'],
                        style: content['isTitle'] == true
                            ? Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )
                            : Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  } else if (content['type'] == 'image') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: content['content'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) =>
                              const Icon(
                            Icons.image_not_supported,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      ),
                    );
                  } else if (content['type'] == 'video') {
                    return YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.amber,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.amber,
                        handleColor: Colors.amberAccent,
                      ),
                      onReady: () {
                        _controller.addListener(listener);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle previous navigation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
              ),
              child: const Icon(Icons.arrow_back),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle next navigation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
