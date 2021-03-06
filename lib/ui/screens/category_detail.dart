import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:zgadula/services/formatters.dart';
import 'package:zgadula/localizations.dart';
import 'package:zgadula/store/category.dart';
import 'package:zgadula/store/question.dart';
import 'package:zgadula/models/question.dart';
import 'package:zgadula/store/settings.dart';
import 'package:zgadula/ui/theme.dart';
import '../shared/widgets.dart';

class CategoryDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(
      builder: (context, child, model) {
        return Scaffold(
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Container(
                          width: ThemeConfig.categoryImageSize,
                          height: ThemeConfig.categoryImageSize,
                          child: Hero(
                            tag: 'categoryImage-${model.currentCategory.name}',
                            child: ClipOval(
                              child: CategoryImage(
                                photo: model.currentCategory.getImagePath(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        child:
                            Text(AppLocalizations.of(context).preparationPlay),
                        onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/play',
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: ScopedModelDescendant<QuestionModel>(
                          builder: (context, child, model) {
                            return buildQuestionCards(
                              context,
                              model.sampleQuestions,
                            );
                          },
                        ),
                      ),
                      ScopedModelDescendant<SettingsModel>(
                        builder: (context, child, settingsModel) {
                          String timeDisplay = FormatterService.secondsToTime(
                              settingsModel.roundTime);

                          return Column(
                            children: <Widget>[
                              Slider(
                                value: settingsModel.roundTime.toDouble(),
                                min: 30.0,
                                max: 120.0,
                                divisions: 6,
                                onChanged: (value) => settingsModel
                                    .changeRoundTime(value.toInt()),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: AppLocalizations.of(context).roundTime,
                                  style: Theme.of(context).textTheme.body1,
                                  children: [
                                    TextSpan(
                                      text: ' $timeDisplay',
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                BottomButton(
                  child: Text(AppLocalizations.of(context).preparationBack),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildQuestionCards(BuildContext context, List<Question> questions) {
    return Center(
      child: Column(
        children: [
          Column(
            children: questions
                .map(
                  (question) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ThemeConfig.categorySampleQuestionPadding,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              size: 16.0,
                              color: Theme.of(context).accentColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                question.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(fontStyle: FontStyle.italic)),
                              ),
                            ),
                          ],
                        ),
                      ),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              AppLocalizations.of(context).moreQuestionsAvailable,
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .merge(TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
