// TODO (jteplitz602): This whole file is nearly identical to core/application.ts.

// There should be a way to refactor application so that this file is unnecessary. See #3277
library angular2.src.web_workers.ui.di_bindings;

import "package:angular2/src/core/di.dart" show Injector, provide, Provider;
import "package:angular2/src/core/pipes.dart" show DEFAULT_PIPES;
import "package:angular2/src/animate/animation_builder.dart"
    show AnimationBuilder;
import "package:angular2/src/animate/browser_details.dart" show BrowserDetails;
import "package:angular2/src/core/reflection/reflection.dart"
    show Reflector, reflector;
import "package:angular2/src/core/change_detection/change_detection.dart"
    show Parser, Lexer;
import "package:angular2/src/core/render/dom/events/event_manager.dart"
    show EventManager, DomEventsPlugin, EVENT_MANAGER_PLUGINS;
import "package:angular2/src/core/linker/proto_view_factory.dart"
    show ProtoViewFactory;
import "package:angular2/src/core/dom/browser_adapter.dart"
    show BrowserDomAdapter;
import "package:angular2/src/core/render/dom/events/key_events.dart"
    show KeyEventsPlugin;
import "package:angular2/src/core/render/dom/events/hammer_gestures.dart"
    show HammerGesturesPlugin;
import "package:angular2/src/core/linker/view_pool.dart"
    show AppViewPool, APP_VIEW_POOL_CAPACITY;
import "package:angular2/src/core/render/api.dart" show Renderer;
import "package:angular2/src/core/compiler/app_root_url.dart" show AppRootUrl;
import "package:angular2/src/core/render/render.dart"
    show DomRenderer, DomRenderer_, DOCUMENT;
import "package:angular2/src/core/application_tokens.dart"
    show APP_ID_RANDOM_PROVIDER;
import "package:angular2/src/core/compiler/schema/element_schema_registry.dart"
    show ElementSchemaRegistry;
import "package:angular2/src/core/compiler/schema/dom_element_schema_registry.dart"
    show DomElementSchemaRegistry;
import "package:angular2/src/core/render/dom/shared_styles_host.dart"
    show SharedStylesHost, DomSharedStylesHost;
import "package:angular2/src/core/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
import "package:angular2/src/core/linker/view_manager.dart"
    show AppViewManager, AppViewManager_;
import "package:angular2/src/core/linker/view_manager_utils.dart"
    show AppViewManagerUtils;
import "package:angular2/src/core/linker/view_listener.dart"
    show AppViewListener;
import "package:angular2/src/core/linker/view_resolver.dart" show ViewResolver;
import "package:angular2/src/core/linker/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/src/core/facade/exceptions.dart" show ExceptionHandler;
import "package:angular2/src/core/linker/dynamic_component_loader.dart"
    show DynamicComponentLoader, DynamicComponentLoader_;
import "package:angular2/src/core/compiler/url_resolver.dart" show UrlResolver;
import "package:angular2/src/core/testability/testability.dart"
    show Testability;
import "package:angular2/src/core/compiler/xhr.dart" show XHR;
import "package:angular2/src/core/compiler/xhr_impl.dart" show XHRImpl;
import "package:angular2/src/web_workers/shared/serializer.dart"
    show Serializer;
import "package:angular2/src/web_workers/shared/api.dart" show ON_WEB_WORKER;
import "package:angular2/src/web_workers/shared/render_proto_view_ref_store.dart"
    show RenderProtoViewRefStore;
import "package:angular2/src/web_workers/shared/render_view_with_fragments_store.dart"
    show RenderViewWithFragmentsStore;
import "package:angular2/src/core/compiler/anchor_based_app_root_url.dart"
    show AnchorBasedAppRootUrl;
import "package:angular2/src/web_workers/ui/impl.dart"
    show WebWorkerApplication;
import "package:angular2/src/web_workers/shared/message_bus.dart"
    show MessageBus;
import "package:angular2/src/web_workers/ui/renderer.dart"
    show MessageBasedRenderer;
import "package:angular2/src/web_workers/ui/xhr_impl.dart"
    show MessageBasedXHRImpl;
import "package:angular2/src/web_workers/ui/setup.dart" show WebWorkerSetup;
import "package:angular2/src/web_workers/shared/service_message_broker.dart"
    show ServiceMessageBrokerFactory, ServiceMessageBrokerFactory_;
import "package:angular2/src/web_workers/shared/client_message_broker.dart"
    show ClientMessageBrokerFactory, ClientMessageBrokerFactory_;

Injector _rootInjector;
// Contains everything that is safe to share between applications.
var _rootProviders = [provide(Reflector, useValue: reflector)];
// TODO: This code is nearly identical to core/application. There should be a way to only write it

// once
List<dynamic> _injectorProviders() {
  return [
    provide(DOCUMENT, useValue: DOM.defaultDoc()),
    EventManager,
    new Provider(EVENT_MANAGER_PLUGINS, useClass: DomEventsPlugin, multi: true),
    new Provider(EVENT_MANAGER_PLUGINS, useClass: KeyEventsPlugin, multi: true),
    new Provider(EVENT_MANAGER_PLUGINS,
        useClass: HammerGesturesPlugin, multi: true),
    provide(DomRenderer, useClass: DomRenderer_),
    provide(Renderer, useExisting: DomRenderer),
    APP_ID_RANDOM_PROVIDER,
    DomSharedStylesHost,
    provide(SharedStylesHost, useExisting: DomSharedStylesHost),
    Serializer,
    provide(ON_WEB_WORKER, useValue: false),
    provide(ElementSchemaRegistry, useValue: new DomElementSchemaRegistry()),
    RenderViewWithFragmentsStore,
    RenderProtoViewRefStore,
    AppViewPool,
    provide(APP_VIEW_POOL_CAPACITY, useValue: 10000),
    provide(AppViewManager, useClass: AppViewManager_),
    AppViewManagerUtils,
    AppViewListener,
    ProtoViewFactory,
    ViewResolver,
    DEFAULT_PIPES,
    DirectiveResolver,
    Parser,
    Lexer,
    provide(ExceptionHandler,
        useFactory: () => new ExceptionHandler(DOM), deps: []),
    provide(XHR, useValue: new XHRImpl()),
    UrlResolver,
    provide(DynamicComponentLoader, useClass: DynamicComponentLoader_),
    Testability,
    AnchorBasedAppRootUrl,
    provide(AppRootUrl, useExisting: AnchorBasedAppRootUrl),
    WebWorkerApplication,
    WebWorkerSetup,
    MessageBasedXHRImpl,
    MessageBasedRenderer,
    provide(ServiceMessageBrokerFactory,
        useClass: ServiceMessageBrokerFactory_),
    provide(ClientMessageBrokerFactory, useClass: ClientMessageBrokerFactory_),
    BrowserDetails,
    AnimationBuilder
  ];
}

Injector createInjector(NgZone zone, MessageBus bus) {
  BrowserDomAdapter.makeCurrent();
  _rootProviders.add(provide(NgZone, useValue: zone));
  _rootProviders.add(provide(MessageBus, useValue: bus));
  Injector injector = Injector.resolveAndCreate(_rootProviders);
  return injector.resolveAndCreateChild(_injectorProviders());
}
