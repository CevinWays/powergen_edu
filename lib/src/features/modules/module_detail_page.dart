import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:powergen_edu/src/features/modules/bloc/module_bloc.dart';
import 'package:powergen_edu/src/features/modules/bloc/module_state.dart';
import 'package:powergen_edu/src/features/modules/preview_image.dart';
import 'package:powergen_edu/src/features/post_test/post_test_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ModuleDetailPage extends StatefulWidget {
  final int? id;
  final String? title;
  final String? desc;
  final bool isFinish;
  final int? pointPostTest;

  const ModuleDetailPage({
    super.key,
    this.id,
    this.title,
    this.isFinish = false,
    this.pointPostTest,
    this.desc,
  });

  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  final bool _muted = false;
  final bool _isPlayerReady = false;
  ModuleBloc moduleBloc = ModuleBloc();

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
    moduleBloc.fetchModule(widget.id);
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
    return BlocProvider(
      create: (context) => moduleBloc,
      child: BlocBuilder(
        bloc: moduleBloc,
        builder: (context, state) {
          if (state is LoadingModuleState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrange,
                ),
              ),
            );
          } else if (state is LoadedModuleState) {
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
                        '${widget.title} : ${widget.desc}',
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
                                'https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg',
                            // Sesuaikan dengan path image yang tersedia
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) =>
                                Container(
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
                        children: state.contents.map((content) {
                          if (content.type == 'text') {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: HtmlWidget(content.content),
                            );
                          } else if (content.type == 'image') {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreviewImage(
                                    image: content.content,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    content.content,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          } else if (content.type == 'video') {
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle next navigation
                        if (widget.isFinish) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Oke'),
                                  ),
                                ],
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                        'Kamu sudah menyelesaikan post test, point kamu adalah'),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: Text(
                                        '${widget.pointPostTest}',
                                        style: const TextStyle(
                                            fontSize: 54,
                                            color: Colors.deepOrange),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostTestPage(
                                      moduleId: (widget.id ?? 0).toString(),
                                    )),
                          );
                        }
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
          } else {
            return const Scaffold(
              body: SizedBox.shrink(),
            );
          }
        },
      ),
    );
  }
}
