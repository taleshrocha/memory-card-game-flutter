import 'package:flutter/material.dart';
import 'package:memory_card_game/utils/Game.dart';
import 'package:memory_card_game/widgets/ScoreBoard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.initGame();
  }

  int tries = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Memory Game",
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              scoreBoard("Tries", "$tries"),
              scoreBoard("Score", "$score"),
            ],
          ),
          SizedBox(
            height: screenWidth,
            width: screenWidth,
            child: GridView.builder(
              itemCount: game.gameImg!.length,
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print(game.cardsList[index]);
                    setState(() {
                      tries++;
                      game.gameImg![index] = game.cardsList[index];
                      game.matchCheck.add({index: game.cardsList[index]});
                    });
                    if (game.matchCheck.length == 2) {
                      if (game.matchCheck[0].values.first ==
                          game.matchCheck[1].values.first) {
                        score += 100;
                        game.matchCheck.clear();
                      } else {
                        Future.delayed(Duration(milliseconds: 500), () {
                          setState(() {
                            game.gameImg![game.matchCheck[0].keys.first] =
                                game.gameImg![game.matchCheck[0].keys.first] =
                                    game.hiddenCardPath;
                            game.matchCheck.clear();
                          });
                        });
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(game.gameImg![index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
