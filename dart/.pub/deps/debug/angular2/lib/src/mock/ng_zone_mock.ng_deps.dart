library angular2.src.mock.ng_zone_mock.ng_deps.dart;

import 'ng_zone_mock.dart';
import 'package:angular2/src/core/reflection/reflection.dart' as _ngRef;
import 'package:angular2/src/core/zone/ng_zone.dart' show NgZone;
import 'package:angular2/src/core/zone/ng_zone.ng_deps.dart' as i0;
export 'ng_zone_mock.dart';
var _visited = false;
void initReflector() {
if (_visited) return; _visited = true;
i0.initReflector();
}
