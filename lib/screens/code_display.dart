import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';

class CodeDisplay extends StatefulWidget {
  final Map<String, dynamic> codeSnippet;
  CodeDisplay({
    Key? key,
    required this.codeSnippet,
  }) : super(key: key);

  @override
  State<CodeDisplay> createState() => _CodeDisplayState();
}

class _CodeDisplayState extends State<CodeDisplay> {
  @override
  Widget build(BuildContext context) {
    EditorModel modelMaker(widName, widLanguage, codeInput) {
      List<FileEditor> file_formed = [
        FileEditor(
          name: widName,
          language: widLanguage,
          code: codeInput,
        )
      ];
      return new EditorModel(
        files: file_formed,
        styleOptions: EditorModelStyleOptions(
          theme: {
            'root': TextStyle(
              backgroundColor: mobileDrawerColor,
              color: Color(0xffdddddd),
            ),
            'keyword': TextStyle(color: keywordColor),
            'params': TextStyle(color: Color(0xffde935f)),
            'selector-tag': TextStyle(color: attrColor),
            'selector-id': TextStyle(color: idColor),
            'selector-class': TextStyle(color: classColor),
            'regexp': TextStyle(color: Color(0xffcc6666)),
            'literal': TextStyle(color: Colors.white),
            'section': TextStyle(color: Colors.white),
            'link': TextStyle(color: Colors.white),
            'subst': TextStyle(color: Color(0xffdddddd)),
            'string': TextStyle(color: quoteColor),
            'title': TextStyle(color: titlesColor),
            'name': TextStyle(color: tagColor),
            'type': TextStyle(color: tagColor),
            'attribute': TextStyle(color: propertyColor),
            'symbol': TextStyle(color: tagColor),
            'bullet': TextStyle(color: tagColor),
            'built_in': TextStyle(color: methodsColor),
            'addition': TextStyle(color: tagColor),
            'variable': TextStyle(color: tagColor),
            'template-tag': TextStyle(color: tagColor),
            'template-variable': TextStyle(color: tagColor),
            'comment': TextStyle(color: Color(0xff777777)),
            'quote': TextStyle(color: Color(0xff777777)),
            'deletion': TextStyle(color: Color(0xff777777)),
            'meta': TextStyle(color: Color(0xff777777)),
            'emphasis': TextStyle(fontStyle: FontStyle.italic),
          },
          padding: EdgeInsets.all(
            3,
          ),
          tabSize: 4,
          fontSize: 13,
          editorColor: mobileDrawerColor,
          // editorBorderColor: mobileBackgroundColor,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          '코드 스니펫',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.codeSnippet.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CodeEditor(
                          edit: false,
                          model: modelMaker(
                            widget.codeSnippet.keys.elementAt(index),
                            widget.codeSnippet[
                                widget.codeSnippet.keys.elementAt(index)][0],
                            widget.codeSnippet[
                                widget.codeSnippet.keys.elementAt(index)][1],
                          ),
                          onSubmit: (String? language, String? value) {
                            widget.codeSnippet[widget.codeSnippet.keys
                                .elementAt(index)][1] = value!;
                          },
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: IconButton(
                            icon: Icon(
                              Icons.copy_all_outlined,
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: widget.codeSnippet[widget
                                      .codeSnippet.keys
                                      .elementAt(index)][1],
                                ),
                              );
                              showSnackBar(
                                context,
                                '${widget.codeSnippet.keys.elementAt(index)} 클립보드 복사되었습니다!',
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
