library angular2.src.core.compiler.template_ast.ng_deps.dart;

import 'template_ast.dart';
import 'package:angular2/src/core/reflection/reflection.dart' as _ngRef;
import 'package:angular2/src/core/change_detection/change_detection.dart' show AST;
import 'package:angular2/src/core/change_detection/change_detection.ng_deps.dart' as i0;
import 'package:angular2/src/core/facade/lang.dart' show isPresent;
import 'directive_metadata.dart' show CompileDirectiveMetadata;
import 'directive_metadata.ng_deps.dart' as i2;
export 'template_ast.dart';
var _visited = false;
void initReflector() {
if (_visited) return; _visited = true;
i0.initReflector();
i2.initReflector();
}
