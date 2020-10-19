import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

/*
I renamed the class to pokemon and added a few parameters
related to pokemon, like stats and types
*/

class Pokemon {
  String name;
  int id;

  List<dynamic> types;
  String firstType;
  String secondType;

  int hp;
  int attack;
  int defense;
  int specialAttack;
  int specialDefense;
  int speed;

  String speciesUrl;

  String technicalName;
  String imageUrl;

  int rating = 5;
  bool correct = true;
  bool loaded = false;

  int evolutions;
  String firstEvolutionName;
  String secondEvolutionName;
  String thirdEvolutionName;
  String firstEvolutionImageUrl = "N/A";
  String secondEvolutionImageUrl = "N/A";
  String thirdEvolutionImageUrl = "N/A";

  /*
  The constructor no longer uses location or description
  as these are irrelevant and the API can provide alternative and
  more relevant data
  Also it only requires the name because it is the only data
  needed to connect with the API 
  */
  Pokemon(this.name);

  //Returns the same string but with the first char in capitals
  String capitalize(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  /*
  Because some Pokemon have various forms that makes their API name quite long
  and break the design so i decided to make a method to shorten their names
  */
  String shorten(String name) {
    bool exit = false;
    //Some Pokemon have their API name correct and short, so i avoid changing them
    if (name != "ho-oh" && name != "porygon-z" && name != "jangmo-o" && name != "hakamo-o" && name != "kommo-o") {
      for (int i = 0; i < name.length && !exit; i++) {
        if (name[i] == "-") {
          exit = true;
          name = name.substring(0, i);
        }
      }
    }
    return name;    
  }

  //This method gets the info from the json provided by the API
  Future fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = capitalize(shorten(json["name"]));
    
    types = json["types"];
    firstType = types[0]["type"]["name"];
    secondType = types.length == 2 ? types[1]["type"]["name"] : "N/A";

    hp = json["stats"][0]["base_stat"];
    attack = json["stats"][1]["base_stat"];
    defense = json["stats"][2]["base_stat"];
    specialAttack = json["stats"][3]["base_stat"];
    specialDefense = json["stats"][4]["base_stat"];
    speed = json["stats"][5]["base_stat"];

    speciesUrl = json["species"]["url"];
  }

  /*
  load() gets the data from the API first and then
  it gets the image for said pokemon
  */
  Future load() async {
    if (imageUrl != null) return;
    try {
      dynamic response = await fetchPokemon(name);
      if (correct) await fromJson(response);
      imageUrl = getImage(id);
      /*
      Because the API doesn't have the evolutions of the Pokemons
      from id 810 i just don't get them
      Then i set loaded to true to indicate that all data has been loaded
      */
      if (id < 810) await getEvolutionChain();
      loaded = true;
    }
    catch (exception) {
      print(exception);
    }
  }

  /*
  fetchPokemon() gets a json from the API with information about
  the pokemon we are looking for and stores in bool
  "correct" if the response was OK, indicating if such pokemon
  exists or not. In case it exists we use the additional data
  provided by the API to display, else we use some default data
  */
  Future fetchPokemon(String name) async {
    technicalName = name.toLowerCase();
    final response = await http.get("https://pokeapi.co/api/v2/pokemon/$technicalName");
    if (response.statusCode != 200) {
      correct = false;
      throw Exception('Failed to load $name');
    }
    return json.decode(response.body);
  }

  String getImage(int pokeId) {
    String imageId = "";
    if (pokeId < 10) imageId = "00$pokeId";
    else if (pokeId < 100) imageId = "0$pokeId";
    else imageId = "$pokeId";
    //return "https://www.pkparaiso.com/imagenes/xy/sprites/animados/${name.toLowerCase()}.gif"; GIFS
    return "https://assets.pokemon.com/assets/cms2/img/pokedex/full/$imageId.png";
  }

  /*
  The following method gets the names and imageURLs from the evolutions of the Pokemon 
  */
  Future getEvolutionChain() async {
    //First we get the Pokemon evolution chain
    final speciesResponse = await http.get(speciesUrl);
    String evolutionChain = json.decode(speciesResponse.body)["evolution_chain"]["url"];
    final evolutionResponse = await http.get(evolutionChain);

    /*
    As this specific json structure is quite messy i have to grab elements, transform
    them into lists, read their length and repeat
    */
    var evolution1 = json.decode(evolutionResponse.body)["chain"];
    List<dynamic> evolution2 = evolution1["evolves_to"];
    /*
    In case the evolution2's length is 2 it menas it has no content
    otherwise it means there's at least one evolution more
    */
    bool second = evolution2.toString().length > 2;
    bool third = false;

    if (second) {
      List<dynamic> evolution3 = evolution1["evolves_to"][0]["evolves_to"];
      third = evolution3.toString().length > 2;
    }

    //Here i store the number of evolutions    
    if (!second) evolutions = 1;
    else if (!third) evolutions = 2;
    else evolutions = 3;

    //Here i get every evolution name
    firstEvolutionName = evolution1["species"]["name"];
    secondEvolutionName = second ? evolution2[0]["species"]["name"] : "N/A";
    thirdEvolutionName = third ? evolution2[0]["evolves_to"][0]["species"]["name"] : "N/A";

    /*
    Now i set the matching evolution to grab the imageUrl from the
    same Pokemon to avoid unnecessary http requests
    */
    if (firstEvolutionName == name.toLowerCase()) firstEvolutionImageUrl = imageUrl;
    if (secondEvolutionName == name.toLowerCase()) secondEvolutionImageUrl = imageUrl;
    if (thirdEvolutionName == name.toLowerCase()) thirdEvolutionImageUrl = imageUrl;
    
    //Now i grab the pokemons images
    if (firstEvolutionImageUrl == "N/A") {
      final firstResponse = await http.get("https://pokeapi.co/api/v2/pokemon/$firstEvolutionName");
      int firstId = await json.decode(firstResponse.body)["id"];
      firstEvolutionImageUrl = getImage(firstId);
    }

    if (secondEvolutionImageUrl == "N/A" && evolutions > 1) {
      final secondResponse = await http.get("https://pokeapi.co/api/v2/pokemon/$secondEvolutionName");
      int secondId = await json.decode(secondResponse.body)["id"];
      secondEvolutionImageUrl = getImage(secondId);
    }

    if (thirdEvolutionImageUrl == "N/A" && evolutions > 2) {
      final thirdResponse = await http.get("https://pokeapi.co/api/v2/pokemon/$thirdEvolutionName");
      int thirdId = await json.decode(thirdResponse.body)["id"];
      thirdEvolutionImageUrl = getImage(thirdId);
    }
    return;
  }
}