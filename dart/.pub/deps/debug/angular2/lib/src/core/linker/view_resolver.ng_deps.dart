library angular2.src.core.linker.view_resolver.ng_deps.dart;

import 'view_resolver.dart';
import 'package:angular2/src/core/reflection/reflection.dart' as _ngRef;
import 'package:angular2/src/core/di.dart' show Injectable;
import 'package:angular2/src/core/di.ng_deps.dart' as i0;
import '../metadata/view.dart' show ViewMetadata;
import '../metadata/view.ng_deps.dart' as i1;
import '../metadata/directives.dart' show ComponentMetadata;
import '../metadata/directives.ng_deps.dart' as i2;
import 'package:angular2/src/core/facade/lang.dart' show Type, stringify, isBlank, isPresent;
import 'package:angular2/src/core/facade/exceptions.dart' show BaseException;
import 'package:angular2/src/core/facade/exceptions.ng_deps.dart' as i4;
import 'package:angular2/src/core/facade/collection.dart' show Map, MapWrapper, ListWrapper;
import 'package:angular2/src/core/reflection/reflection.dart' show reflector;
import 'package:angular2/src/core/reflection/reflection.ng_deps.dart' as i6;
export 'view_resolver.dart';
var _visited = false;
void initReflector() {
if (_visited) return; _visited = true;
_ngRef.reflector
..registerType(ViewResolver, new _ngRef.ReflectionInfo(
const [const Injectable()],
const [],
() => new ViewResolver())
)
;
i0.initReflector();
i1.initReflector();
i2.initReflector();
i4.initReflector();
i6.initReflector();
}
