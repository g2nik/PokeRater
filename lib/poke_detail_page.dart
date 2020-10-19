import 'package:flutter/material.dart';
import 'poke_model.dart';
import 'dart:async';

class PokeDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  PokeDetailPage(this.pokemon);

  @override
  _PokeDetailPageState createState() => new _PokeDetailPageState();
}

class _PokeDetailPageState extends State<PokeDetailPage> {
  final double pokeAvarterSize = 150.0;
  double _sliderValue;
  var avatarImage;

  @override
  void initState() {
    super.initState();
    //_sliderValue gets its value from the Pokemon object
    _sliderValue = widget.pokemon.rating.toDouble();
    //avatarImage is a network image of the pokemon if it's correct, else it is a pokeball
    avatarImage = widget.pokemon.correct ? NetworkImage(widget.pokemon.imageUrl) : AssetImage("assets/pokeball.png");
  }
  
  /*
  As the widget updates the rating of the Pokemon without needing a button and a raitng
  is already being displayed, the text of the right side has been deleted
  */
  Widget get addYourRating {
    return Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: new Slider(
            activeColor: Colors.redAccent,
            min: 0.0,
            //Max rating has been updated to 10
            max: 10.0,
            value: _sliderValue,
            onChanged: (newRating) {
              setState(() {
                _sliderValue = newRating;
                //The following line updates the Pokemon rating when te slider has changed
                widget.pokemon.rating = _sliderValue.toInt();
              } );
            },
          ),
        ),
        submitRatingButton,
      ],
    );
  }

  /*
  The colors have been modified to match the Pokemon scheme and the purpose
  of the button is merely to check the creature's feelings
  The update process happens when the slider value is changed
  */
  Widget get submitRatingButton {
    return new RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      onPressed: () => _feelingsDialog(),
      child: new Text("Check feelings", style: TextStyle(fontSize: 20),),
      color: Colors.redAccent,
    );
  }

  /*
  I added 2 widget to display the emotions of the Pokemon based on their rating
  They can be very sad (0-2), sad (3-4), good (5-7) or excited (8-10)
  */
  Widget get pokeFeelingsTitle {
    if (_sliderValue < 3) return Text("Watchout!", style: TextStyle(color: Colors.white));
    else if (_sliderValue < 5) return Text(":C", style: TextStyle(color: Colors.white));
    else if (_sliderValue < 8) return Text("Yay!", style: TextStyle(color: Colors.white));
    else return Text("NIIICE!!!", style: TextStyle(color: Colors.white));
  }

  Widget get pokeFeelings {
    if (_sliderValue < 3) return Text("${widget.pokemon.name} is veeery sad :c", style: TextStyle(color: Colors.white));
    else if (_sliderValue < 5) return Text("${widget.pokemon.name} is sad...", style: TextStyle(color: Colors.white));
    else if (_sliderValue < 8) return Text("${widget.pokemon.name} is feeling good :3", style: TextStyle(color: Colors.white));
    else return Text("${widget.pokemon.name} is very happy UwU", style: TextStyle(color: Colors.white));
  }

  /*
  The updateRating() has been replaced totally by the feelingsDialog(), which is now red
  and uses the two widgets mentioned above as title and content
  */
  Future<Null> _feelingsDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Colors.red[600],
          title: pokeFeelingsTitle,
          content: pokeFeelings,
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK", style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
    );
  }

  //The background gradient has been removed
  Widget get pokeImage {
    return new Hero(
      tag: widget.pokemon,
      child: new Container(
        height: pokeAvarterSize,
        width: pokeAvarterSize,
        constraints: new BoxConstraints(),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: avatarImage,
          ),
        ),
      ),
    );
  }

  Widget get rating {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //The star is now orange
        new Icon(Icons.star, size: 30.0, color: Colors.amber),
        new Text(
          "${widget.pokemon.rating}/10",
          style: TextStyle(color: Colors.white, fontSize: 20)
        )
      ],
    );
  }

  /*
  This select which widgets to return
  If the pokemon doesn't exist it returns an unknown type
  If the pokemon has one type it returns its first type
  If the pokemon has two types it returns a row with both
  */
  Widget get pokeType {
    if (!widget.pokemon.correct) return PokeType("unknown");
    else if (widget.pokemon.types.length == 1) return PokeType(widget.pokemon.firstType);
    else return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PokeType(widget.pokemon.firstType),
        PokeType(widget.pokemon.secondType),
      ],
    );
  }

  /*
  The following widget returns two rows with Pokemon stats in case it's correct
  otherwise it doesn't return anything
  */
  Widget get pokeStats {
    if (!widget.pokemon.correct) return Container();
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PokeTextCard("HP: ${widget.pokemon.hp}"),
              PokeTextCard("Att: ${widget.pokemon.attack}"),
              PokeTextCard("Def: ${widget.pokemon.defense}"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PokeTextCard("S. Att: ${widget.pokemon.specialAttack}"),
              PokeTextCard("S. Def: ${widget.pokemon.specialDefense}"),
              PokeTextCard("Speed: ${widget.pokemon.speed}"),
            ],
          ),
        ],
      )
    );
  }

  Widget get pokeProfile {
    return new Container(
      padding: new EdgeInsets.symmetric(vertical: 16.0),
      //The gradient is replaced with a filtered image
      decoration: new BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/cave.jpg"),
          colorFilter: ColorFilter.mode(Colors.green, BlendMode.darken)
        ),
      ),

      //Now the location is replaced with type
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          pokeImage,
          new Text("${widget.pokemon.name}", style: TextStyle(fontSize: 40.0, color: Colors.white)),
          rating,
          SizedBox(height: 10),
          pokeType,
        ],
      ),
    );
  }

  /*
  pokeEvolutions returns an empty container in case the number of evolutions of a Pokemon is 1
  else it will show all evolutions separated by an arrow icon
  */
  Widget get pokeEvolutions {
    if (!widget.pokemon.correct || widget.pokemon.evolutions == 1 || widget.pokemon.id >= 810) return Container();
    else if (widget.pokemon.evolutions == 2) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Tooltip (
              verticalOffset: 50,
              message: widget.pokemon.firstEvolutionName.toUpperCase(),
              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Image.network(widget.pokemon.firstEvolutionImageUrl ?? "", width: 100),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: new BorderRadius.all(new Radius.circular(25))
              ),
            ),
            Icon(Icons.arrow_right, color: Colors.redAccent, size: 50),
            Tooltip(
              verticalOffset: 50,
              message: widget.pokemon.secondEvolutionName.toUpperCase(),
              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Image.network(widget.pokemon.secondEvolutionImageUrl ?? "", width: 100),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: new BorderRadius.all(new Radius.circular(25))
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Tooltip (
              verticalOffset: 50,
              message: widget.pokemon.firstEvolutionName.toUpperCase(),
              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Image.network(widget.pokemon.firstEvolutionImageUrl ?? "", width: 75),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: new BorderRadius.all(new Radius.circular(25))
              ),
            ),
            Icon(Icons.arrow_right, color: Colors.redAccent, size: 50),
            Tooltip (
              verticalOffset: 50,
              message: widget.pokemon.secondEvolutionName.toUpperCase(),
              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Image.network(widget.pokemon.secondEvolutionImageUrl ?? "", width: 75),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: new BorderRadius.all(new Radius.circular(25))
              ),
            ),
            Icon(Icons.arrow_right, color: Colors.redAccent, size: 50),
            Tooltip (
              verticalOffset: 50,
              message: widget.pokemon.thirdEvolutionName.toUpperCase(),
              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Image.network(widget.pokemon.thirdEvolutionImageUrl ?? "", width: 75),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: new BorderRadius.all(new Radius.circular(25))
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text("${widget.pokemon.name}", style: TextStyle(color: Colors.white)),
      ),
      body: new ListView(
        //The stats and evolutions have been added to the list of children
        children: <Widget>[pokeProfile, pokeStats, pokeEvolutions, addYourRating],
      ),
    );
  }
}

//This widget returns a card with the stat it's passed as a parameter
class PokeTextCard extends StatelessWidget {
  PokeTextCard(this.stat);
  final String stat;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(stat, style: TextStyle(fontSize: 15)),
      ),
    );
  }
}

/*
This widget gets the type of the Pokemon and displays an asset image (which name
is the same as the Pokemon's type) surrounded by a Tooltip widget which displays the
type name when long-pressed
*/
class PokeType extends StatelessWidget {
  PokeType(type) {
    this.type = type;

    switch (type) {
      case "normal": themeColor = Color(0xff9099a1); break;
      case "fire": themeColor = Color(0xffff9c54); break;
      case "fighting": themeColor = Color(0xffc03028); break;
      case "water": themeColor = Color(0xff4d90d5); break;
      case "flying": themeColor = Color(0xff8fa8dd);break;
      case "grass": themeColor = Color(0xff63bb5b); break;
      case "poison": themeColor = Color(0xffab6ac8); break;
      case "electric": themeColor = Color(0xfff8d030); break;
      case "ground": themeColor = Color(0xffd97746); break;
      case "psychic": themeColor = Color(0xfff97176); break;
      case "rock": themeColor = Color(0xffc7b78b); break;
      case "ice": themeColor = Color(0xff74cec0); break;
      case "bug": themeColor = Color(0xff90c12c); break;
      case "dragon": themeColor = Color(0xff0a6dc4); break;
      case "ghost": themeColor = Color(0xff5269ac); break;
      case "dark": themeColor = Color(0xff5a5366); break;
      case "steel": themeColor = Color(0xff5a8ea1); break;
      case "fairy": themeColor = Color(0xffec8fe6); break;
      case "unknown": themeColor = Color(0xff68a090); break;
      default: themeColor = Colors.redAccent; break;
    }
  }

  String type;
  Color themeColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip (
      verticalOffset: 40,
      message: type.toUpperCase(),
      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      child: Container(width: 75, child: Image.asset("assets/$type.png")),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: new BorderRadius.all(new Radius.circular(25))
      ),
    );
  }
}
