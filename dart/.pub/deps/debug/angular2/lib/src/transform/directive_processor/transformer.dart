library angular2.transform.directive_processor.transformer;

import 'dart:async';
import 'dart:convert';

import 'package:angular2/src/core/dom/html_adapter.dart';
import 'package:angular2/src/transform/common/asset_reader.dart';
import 'package:angular2/src/transform/common/logging.dart' as log;
import 'package:angular2/src/transform/common/names.dart';
import 'package:angular2/src/transform/common/options.dart';
import 'package:barback/barback.dart';

import 'rewriter.dart';

/// Transformer responsible for processing all .dart assets and creating
/// .ng_summary.json files which summarize those assets.
///
/// See `angular2/src/transform/common/ng_meta.dart` for the structure of these
/// output files.
///
/// This transformer is part of a multi-phase transform.
/// See `angular2/src/transform/transformer.dart` for transformer ordering.
class DirectiveProcessor extends Transformer {
  final TransformerOptions options;
  final _encoder = const JsonEncoder.withIndent('  ');

  DirectiveProcessor(this.options);

  @override
  bool isPrimary(AssetId id) => id.extension.endsWith('dart');

  @override
  Future apply(Transform transform) async {
    Html5LibDomAdapter.makeCurrent();
    await log.initZoned(transform, () async {
      var primaryId = transform.primaryInput.id;
      var reader = new AssetReader.fromTransform(transform);
      var ngMeta =
          await createNgMeta(reader, primaryId, options.annotationMatcher);
      if (ngMeta == null || ngMeta.isEmpty) {
        return;
      }
      transform.addOutput(new Asset.fromString(
          _ngSummaryAssetId(primaryId), _encoder.convert(ngMeta.toJson())));
    });
  }
}

AssetId _ngSummaryAssetId(AssetId primaryInputId) {
  return new AssetId(
      primaryInputId.package, toSummaryExtension(primaryInputId.path));
}
