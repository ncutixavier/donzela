import 'dart:convert';

import 'package:flutter/services.dart';

/// Content bundled with the app, so a first launch offline still has data.
///
/// Articles live in `assets/content/{lang}/{id}.md` with a front-matter block:
/// ```
/// ---
/// id: cycle-basics
/// category: mine
/// title: ...
/// reviewed_by:      <- empty until a health advisor signs off
/// reviewed_on:
/// ---
/// Markdown body
/// ```
/// The category list for each id is in `assets/content/index.json`.
///
/// Rules from the plan:
/// - An article with no reviewer is stored but never shown in release builds.
/// - Health centres must be phone-verified before they are added.
const contentLanguages = ['rw', 'en', 'fr'];

class SeedArticle {
  const SeedArticle({
    required this.id,
    required this.lang,
    required this.category,
    required this.title,
    required this.body,
    this.reviewedBy,
    this.reviewedOn,
  });

  final String id;
  final String lang;
  final String category;
  final String title;
  final String body;
  final String? reviewedBy;
  final DateTime? reviewedOn;
}

class SeedCentre {
  const SeedCentre({
    required this.id,
    required this.district,
    required this.sector,
    required this.name,
    required this.phone,
    required this.services,
  });

  final String id;
  final String district;
  final String sector;
  final String name;
  final String phone;
  final String services;
}

const seedCentres = <SeedCentre>[];

/// Reads every article for every language from the asset bundle.
Future<List<SeedArticle>> loadBundledArticles(AssetBundle bundle) async {
  final index = jsonDecode(
    await bundle.loadString('assets/content/index.json'),
  ) as List<dynamic>;

  final out = <SeedArticle>[];
  for (final entry in index) {
    final id = (entry as Map<String, dynamic>)['id'] as String;
    final category = entry['category'] as String;
    for (final lang in contentLanguages) {
      final raw = await bundle.loadString('assets/content/$lang/$id.md');
      out.add(parseArticle(raw, expectedLang: lang, expectedCategory: category));
    }
  }
  return out;
}

/// Parses one article file. Throws FormatException when the front matter is
/// missing, so a broken file is caught by the tests rather than shipped.
SeedArticle parseArticle(
  String raw, {
  required String expectedLang,
  required String expectedCategory,
}) {
  final lines = const LineSplitter().convert(raw);
  if (lines.isEmpty || lines.first.trim() != '---') {
    throw FormatException('Article is missing front matter');
  }
  final end = lines.indexOf('---', 1);
  if (end < 0) {
    throw FormatException('Front matter is not closed');
  }

  final meta = <String, String>{};
  for (final line in lines.sublist(1, end)) {
    final colon = line.indexOf(':');
    if (colon < 0) continue;
    meta[line.substring(0, colon).trim()] = line.substring(colon + 1).trim();
  }

  String? nonEmpty(String key) {
    final v = meta[key];
    return (v == null || v.isEmpty) ? null : v;
  }

  final id = meta['id'];
  final title = meta['title'];
  if (id == null || id.isEmpty || title == null || title.isEmpty) {
    throw FormatException('Article needs id and title');
  }

  final reviewedOnRaw = nonEmpty('reviewed_on');
  return SeedArticle(
    id: id,
    lang: expectedLang,
    category: meta['category'] ?? expectedCategory,
    title: title,
    body: lines.sublist(end + 1).join('\n').trim(),
    reviewedBy: nonEmpty('reviewed_by'),
    reviewedOn: reviewedOnRaw == null ? null : DateTime.tryParse(reviewedOnRaw),
  );
}
