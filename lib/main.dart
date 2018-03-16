import 'package:flutter/material.dart';

void main() {
  runApp(new ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title : "Chat App",
      home : new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}


class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _message = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  @override
  void dispose() {
    for (ChatMessage message in _message)
      message.animationController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title : new Text("Chat App")
      ),
      body : new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(0.0),
              reverse: true,
              itemBuilder: (_, int index) => _message[index],
              itemCount: _message.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color : Theme.of(context).cardColor
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data:  new  IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child : new Row(children: <Widget>[
          new Flexible(
                child: new TextField(
                controller:  _textController,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                hintText: "Send a message"
              ),
            ),
          ),
            new Container(
              margin : new EdgeInsets.symmetric(horizontal: 4.0),
              child : new IconButton(
                icon : new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text)),
          ),
        ],
      ),
    ),
  );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message  = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      )
    );
    setState(() {
      _message.insert(0, message);
    });
    message.animationController.forward();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final AnimationController animationController;
  final String text;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController, curve: Curves.easeOut
      ),
      axisAlignment: 0.0,
      child: new Container(
      margin : const EdgeInsets.symmetric(vertical: 10.0),
      child : new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin : const EdgeInsets.only(right : 16.0),
            child : new CircleAvatar(child: new Text(_name[0])),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin : const EdgeInsets.only(top : 5.0),
                child: new Text(text),
              )
            ],
          )
        ],
      )
    )
    );
  }
}

const String _name = "Sidharth";