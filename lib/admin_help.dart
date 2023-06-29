import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admin_Help extends StatefulWidget {
  @override
  _Admin_HelpState createState() => _Admin_HelpState();
}

class _Admin_HelpState extends State<Admin_Help> {
  CollectionReference _faqCollection = FirebaseFirestore.instance.collection('FAQ');
  CollectionReference _faqAnsCollection = FirebaseFirestore.instance.collection('faq_ans');
  List<QuestionAnswer> _questionAnswers = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  void _fetchQuestions() async {
    QuerySnapshot snapshot = await _faqCollection.get();
    List<QuestionAnswer> questionAnswers = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
      String question = data['query'] as String; // Cast to String
      return QuestionAnswer(question: question);
    }).toList();
    setState(() {
      _questionAnswers = questionAnswers;
    });
  }

  void _fetchAnswers() async {
    QuerySnapshot snapshot = await _faqAnsCollection.get();
    List<QuestionAnswer> updatedQuestionAnswers = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
      String question = data['query'] as String; // Cast to String
      String? answer = data['answer'] as String?; // Cast to nullable String
      return QuestionAnswer(question: question, answer: answer);
    }).toList();
    setState(() {
      _questionAnswers = updatedQuestionAnswers;
    });
  }

  void _storeAnswer(QuestionAnswer questionAnswer, String answer) async {
    await _faqAnsCollection.add({
      'query': questionAnswer.question,
      'answer': answer,
    });

    await _faqCollection
        .where('query', isEqualTo: questionAnswer.question)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.first.reference.delete();
    });

    setState(() {
      questionAnswer.answer = answer;
      _questionAnswers.remove(questionAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView.builder(
        itemCount: _questionAnswers.length,
        itemBuilder: (context, index) {
          QuestionAnswer questionAnswer = _questionAnswers[index];
          return Card(
            child: ListTile(
              title: Text(
                questionAnswer.question,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Answer:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the answer',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (answer) {
                      setState(() {
                        questionAnswer.answer = answer;
                      });
                    },
                    onSubmitted: (answer) {
                      _storeAnswer(questionAnswer, answer);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuestionAnswer {
  final String question;
  String? answer;

  QuestionAnswer({required this.question, this.answer});
}
