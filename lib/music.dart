import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/piano.dart';
import 'package:flutter_midi/flutter_midi.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  late FlutterMidi flutterMidi;
  String? title = "PIANO";
  var tuneList = [
    "Piano",
    "Guitars",
    "Flute",
  ];
  String dropdownValue = 'Piano';

  @override
  void initState() {
    super.initState();
    flutterMidi = FlutterMidi();
    load("assets/sf2/$dropdownValue.SF2");
  }

  void load(String asset) async {
    try {
      ByteData byte = await rootBundle.load(asset);
      await flutterMidi.prepare(
          sf2: byte,
          name: 'assets/sf2/$dropdownValue.SF2'.replaceAll('assets/sf2/', ''));
    } catch (e) {
      print('Failed to load asset: $asset');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: InteractivePiano(
        highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
        naturalColor: Colors.white,
        accidentalColor: Colors.black,
        keyWidth: 50,
        noteRange: NoteRange.forClefs([
          Clef.Bass,
        ]),
        onNotePositionTapped: (position) {
          flutterMidi.playMidiNote(midi: position.pitch);
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xffff004f),
      title: Text("$title"),
      centerTitle: true,
      actions: [
        buildDropdownButton(),
      ],
      leading: InkWell(
        onTap: () {
          SystemNavigator.pop();
        },
        child: const Icon(Icons.exit_to_app_outlined),
      ),
    );
  }

  DropdownButton<String> buildDropdownButton() {
    return DropdownButton<String>(
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      dropdownColor: const Color(0xffff004f),
      value: dropdownValue,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      items: tuneList.map((String items) {
        return DropdownMenuItem<String>(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            dropdownValue = newValue;
            title = newValue.toUpperCase();
            load("assets/sf2/$dropdownValue.SF2");
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
