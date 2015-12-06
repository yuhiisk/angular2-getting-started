library angular2.src.testing.test_injector.ng_deps.dart;

import 'test_injector.dart';
import 'package:angular2/src/core/reflection/reflection.dart' as _ngRef;
import 'package:angular2/src/core/di.dart' show provide, Provider;
import 'package:angular2/src/core/pipes.dart' show DEFAULT_PIPES;
import 'package:angular2/src/core/pipes.ng_deps.dart' as i1;
import 'package:angular2/src/animate/animation_builder.dart' show AnimationBuilder;
import 'package:angular2/src/animate/animation_builder.ng_deps.dart' as i2;
import 'package:angular2/src/mock/animation_builder_mock.dart' show MockAnimationBuilder;
import 'package:angular2/src/mock/animation_builder_mock.ng_deps.dart' as i3;
import 'package:angular2/src/core/linker/proto_view_factory.dart' show ProtoViewFactory;
import 'package:angular2/src/core/linker/proto_view_factory.ng_deps.dart' as i4;
import 'package:angular2/src/core/reflection/reflection.dart' show Reflector, reflector;
import 'package:angular2/src/core/reflection/reflection.ng_deps.dart' as i5;
import 'package:angular2/src/core/change_detection/change_detection.dart' show IterableDiffers, defaultIterableDiffers, KeyValueDiffers, defaultKeyValueDiffers, ChangeDetectorGenConfig;
import 'package:angular2/src/core/change_detection/change_detection.ng_deps.dart' as i6;
import 'package:angular2/src/core/facade/exceptions.dart' show ExceptionHandler;
import 'package:angular2/src/core/facade/exceptions.ng_deps.dart' as i7;
import 'package:angular2/src/core/linker/view_resolver.dart' show ViewResolver;
import 'package:angular2/src/core/linker/view_resolver.ng_deps.dart' as i8;
import 'package:angular2/src/core/linker/directive_resolver.dart' show DirectiveResolver;
import 'package:angular2/src/core/linker/directive_resolver.ng_deps.dart' as i9;
import 'package:angular2/src/core/linker/pipe_resolver.dart' show PipeResolver;
import 'package:angular2/src/core/linker/pipe_resolver.ng_deps.dart' as i10;
import 'package:angular2/src/core/linker/dynamic_component_loader.dart' show DynamicComponentLoader;
import 'package:angular2/src/core/compiler/xhr.dart' show XHR;
import 'package:angular2/src/core/compiler/xhr.ng_deps.dart' as i12;
import 'package:angular2/src/core/zone/ng_zone.dart' show NgZone;
import 'package:angular2/src/core/zone/ng_zone.ng_deps.dart' as i13;
import 'package:angular2/src/core/dom/dom_adapter.dart' show DOM;
import 'package:angular2/src/core/dom/dom_adapter.ng_deps.dart' as i14;
import 'package:angular2/src/core/render/dom/events/event_manager.dart' show EventManager, DomEventsPlugin, EVENT_MANAGER_PLUGINS;
import 'package:angular2/src/core/render/dom/events/event_manager.ng_deps.dart' as i15;
import 'package:angular2/src/mock/directive_resolver_mock.dart' show MockDirectiveResolver;
import 'package:angular2/src/mock/directive_resolver_mock.ng_deps.dart' as i16;
import 'package:angular2/src/mock/view_resolver_mock.dart' show MockViewResolver;
import 'package:angular2/src/mock/view_resolver_mock.ng_deps.dart' as i17;
import 'package:angular2/src/mock/mock_location_strategy.dart' show MockLocationStrategy;
import 'package:angular2/src/mock/mock_location_strategy.ng_deps.dart' as i18;
import 'package:angular2/src/router/location_strategy.dart' show LocationStrategy;
import 'package:angular2/src/mock/ng_zone_mock.dart' show MockNgZone;
import 'package:angular2/src/mock/ng_zone_mock.ng_deps.dart' as i20;
import 'test_component_builder.dart' show TestComponentBuilder;
import 'test_component_builder.ng_deps.dart' as i21;
import 'package:angular2/src/core/di.dart' show Injector;
import 'package:angular2/src/core/di.ng_deps.dart' as i22;
import 'package:angular2/src/core/debug.dart' show ELEMENT_PROBE_PROVIDERS;
import 'package:angular2/src/core/debug.ng_deps.dart' as i23;
import 'package:angular2/src/core/facade/collection.dart' show ListWrapper;
import 'package:angular2/src/core/facade/lang.dart' show FunctionWrapper, Type;
import 'package:angular2/src/core/linker/view_pool.dart' show AppViewPool, APP_VIEW_POOL_CAPACITY;
import 'package:angular2/src/core/linker/view_pool.ng_deps.dart' as i26;
import 'package:angular2/src/core/linker/view_manager.dart' show AppViewManager;
import 'package:angular2/src/core/linker/view_manager_utils.dart' show AppViewManagerUtils;
import 'package:angular2/src/core/linker/view_manager_utils.ng_deps.dart' as i28;
import 'package:angular2/src/core/render/api.dart' show Renderer;
import 'package:angular2/src/core/render/api.ng_deps.dart' as i29;
import 'package:angular2/src/core/render/render.dart' show DomRenderer, DOCUMENT, SharedStylesHost, DomSharedStylesHost;
import 'package:angular2/src/core/render/render.ng_deps.dart' as i30;
import 'package:angular2/src/core/application_tokens.dart' show APP_ID;
import 'package:angular2/src/core/application_tokens.ng_deps.dart' as i31;
import 'package:angular2/src/web_workers/shared/serializer.dart' show Serializer;
import 'package:angular2/src/web_workers/shared/serializer.ng_deps.dart' as i32;
import 'utils.dart' show Log;
import 'utils.ng_deps.dart' as i33;
import 'package:angular2/src/core/compiler/compiler.dart' show compilerProviders;
import 'package:angular2/src/core/compiler/compiler.ng_deps.dart' as i34;
import 'package:angular2/src/core/render/dom/dom_renderer.dart' show DomRenderer_;
import 'package:angular2/src/core/render/dom/dom_renderer.ng_deps.dart' as i35;
import 'package:angular2/src/core/linker/dynamic_component_loader.dart' show DynamicComponentLoader_;
import 'package:angular2/src/core/linker/dynamic_component_loader.ng_deps.dart' as i36;
import 'package:angular2/src/core/linker/view_manager.dart' show AppViewManager_;
import 'package:angular2/src/core/linker/view_manager.ng_deps.dart' as i37;
export 'test_injector.dart';
var _visited = false;
void initReflector() {
if (_visited) return; _visited = true;
i1.initReflector();
i2.initReflector();
i3.initReflector();
i4.initReflector();
i5.initReflector();
i6.initReflector();
i7.initReflector();
i8.initReflector();
i9.initReflector();
i10.initReflector();
i12.initReflector();
i13.initReflector();
i14.initReflector();
i15.initReflector();
i16.initReflector();
i17.initReflector();
i18.initReflector();
i20.initReflector();
i21.initReflector();
i22.initReflector();
i23.initReflector();
i26.initReflector();
i28.initReflector();
i29.initReflector();
i30.initReflector();
i31.initReflector();
i32.initReflector();
i33.initReflector();
i34.initReflector();
i35.initReflector();
i36.initReflector();
i37.initReflector();
}
