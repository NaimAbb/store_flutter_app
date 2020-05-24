import 'package:flutter/material.dart';
import 'localization.dart';

String getTranslated(BuildContext context , String key){
  return Localization.of(context).getTranslatedValue(key);
}