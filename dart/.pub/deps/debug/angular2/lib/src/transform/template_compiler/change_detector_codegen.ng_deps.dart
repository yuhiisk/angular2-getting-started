library angular2.transform.template_compiler.change_detector_codegen.ng_deps.dart;

import 'change_detector_codegen.dart';
import 'package:angular2/src/core/reflection/reflection.dart' as _ngRef;
import 'package:angular2/src/core/change_detection/change_detection.dart';
import 'package:angular2/src/core/change_detection/change_detection.ng_deps.dart' as i0;
import 'package:angular2/src/core/change_detection/change_detection_util.dart';
import 'package:angular2/src/core/change_detection/change_detection_util.ng_deps.dart' as i1;
import 'package:angular2/src/core/change_detection/codegen_facade.dart';
import 'package:angular2/src/core/change_detection/codegen_logic_util.dart';
import 'package:angular2/src/core/change_detection/codegen_logic_util.ng_deps.dart' as i3;
import 'package:angular2/src/core/change_detection/codegen_name_util.dart';
import 'package:angular2/src/core/change_detection/codegen_name_util.ng_deps.dart' as i4;
import 'package:angular2/src/core/change_detection/directive_record.dart';
import 'package:angular2/src/core/change_detection/directive_record.ng_deps.dart' as i5;
import 'package:angular2/src/core/change_detection/interfaces.dart';
import 'package:angular2/src/core/change_detection/interfaces.ng_deps.dart' as i6;
import 'package:angular2/src/core/change_detection/proto_change_detector.dart';
import 'package:angular2/src/core/change_detection/proto_change_detector.ng_deps.dart' as i7;
import 'package:angular2/src/core/change_detection/proto_record.dart';
import 'package:angular2/src/core/change_detection/proto_record.ng_deps.dart' as i8;
import 'package:angular2/src/core/change_detection/event_binding.dart';
import 'package:angular2/src/core/change_detection/event_binding.ng_deps.dart' as i9;
import 'package:angular2/src/core/change_detection/binding_record.dart';
import 'package:angular2/src/core/change_detection/binding_record.ng_deps.dart' as i10;
import 'package:angular2/src/core/change_detection/codegen_facade.dart' show codify;
import 'package:angular2/src/core/facade/exceptions.dart' show BaseException;
import 'package:angular2/src/core/facade/exceptions.ng_deps.dart' as i12;
export 'change_detector_codegen.dart';
var _visited = false;
void initReflector() {
if (_visited) return; _visited = true;
i0.initReflector();
i1.initReflector();
i3.initReflector();
i4.initReflector();
i5.initReflector();
i6.initReflector();
i7.initReflector();
i8.initReflector();
i9.initReflector();
i10.initReflector();
i12.initReflector();
}
