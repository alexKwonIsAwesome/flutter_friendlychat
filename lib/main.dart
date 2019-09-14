import 'package:flutter/material.dart';

void main() => runApp(FriendlychatApp());

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Friendlychat", home: ChatScreen());
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
        text: text,
        animationController: AnimationController(
            duration: Duration(milliseconds: 700), vsync: this));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(
            color: _isComposing
                ? Theme.of(context).accentColor
                : Theme.of(context).disabledColor),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: _handleSubmitted,
                    decoration:
                        InputDecoration.collapsed(hintText: "Send a message"),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => _isComposing
                          ? _handleSubmitted(_textController.text)
                          : null,
                    ))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Friendlychat'),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            )
          ],
        ));
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

const String _name = 'Your name';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(child: Text(_name[0]))),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_name, style: Theme.of(context).textTheme.subhead),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Text(text))
                    ],
                  ),
                )
              ],
            )));
  }
}
