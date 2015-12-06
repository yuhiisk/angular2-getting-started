library angular2.src.core.render.dom.dom_renderer;

import "package:angular2/src/core/di.dart" show Inject, Injectable, OpaqueToken;
import "package:angular2/src/animate/animation_builder.dart"
    show AnimationBuilder;
import "package:angular2/src/core/facade/lang.dart"
    show isPresent, isBlank, RegExpWrapper, stringify;
import "package:angular2/src/core/facade/exceptions.dart"
    show BaseException, WrappedException;
import "package:angular2/src/core/dom/dom_adapter.dart" show DOM;
import "events/event_manager.dart" show EventManager;
import "shared_styles_host.dart" show DomSharedStylesHost;
import "../../profile/profile.dart" show WtfScopeFn, wtfLeave, wtfCreateScope;
import "../api.dart"
    show
        Renderer,
        RenderProtoViewRef,
        RenderViewRef,
        RenderElementRef,
        RenderFragmentRef,
        RenderViewWithFragments,
        RenderTemplateCmd,
        RenderEventDispatcher;
import "dom_tokens.dart" show DOCUMENT;
import "../view_factory.dart" show createRenderView, NodeFactory;
import "../view.dart"
    show DefaultRenderView, DefaultRenderFragmentRef, DefaultProtoViewRef;
import "util.dart" show camelCaseToDashCase;

// TODO(tbosch): solve SVG properly once https://github.com/angular/angular/issues/4417 is done
const XLINK_NAMESPACE = "http://www.w3.org/1999/xlink";
const SVG_NAMESPACE = "http://www.w3.org/2000/svg";
const SVG_ELEMENT_NAMES = const {
  "altGlyph": true,
  "altGlyphDef": true,
  "altGlyphItem": true,
  "animate": true,
  "animateColor": true,
  "animateMotion": true,
  "animateTransform": true,
  "circle": true,
  "clipPath": true,
  "color-profile": true,
  "cursor": true,
  "defs": true,
  "desc": true,
  "ellipse": true,
  "feBlend": true,
  "feColorMatrix": true,
  "feComponentTransfer": true,
  "feComposite": true,
  "feConvolveMatrix": true,
  "feDiffuseLighting": true,
  "feDisplacementMap": true,
  "feDistantLight": true,
  "feFlood": true,
  "feFuncA": true,
  "feFuncB": true,
  "feFuncG": true,
  "feFuncR": true,
  "feGaussianBlur": true,
  "feImage": true,
  "feMerge": true,
  "feMergeNode": true,
  "feMorphology": true,
  "feOffset": true,
  "fePointLight": true,
  "feSpecularLighting": true,
  "feSpotLight": true,
  "feTile": true,
  "feTurbulence": true,
  "filter": true,
  "font": true,
  "font-face": true,
  "font-face-format": true,
  "font-face-name": true,
  "font-face-src": true,
  "font-face-uri": true,
  "foreignObject": true,
  "g": true,
  "glyph": true,
  "glyphRef": true,
  "hkern": true,
  "image": true,
  "line": true,
  "linearGradient": true,
  "marker": true,
  "mask": true,
  "metadata": true,
  "missing-glyph": true,
  "mpath": true,
  "path": true,
  "pattern": true,
  "polygon": true,
  "polyline": true,
  "radialGradient": true,
  "rect": true,
  "set": true,
  "stop": true,
  "style": true,
  "svg": true,
  "switch": true,
  "symbol": true,
  "text": true,
  "textPath": true,
  "title": true,
  "tref": true,
  "tspan": true,
  "use": true,
  "view": true,
  "vkern": true
};
const SVG_ATTR_NAMESPACES = const {
  "href": XLINK_NAMESPACE,
  "xlink:href": XLINK_NAMESPACE
};

abstract class DomRenderer extends Renderer implements NodeFactory<dynamic> {
  registerComponentTemplate(num templateId, List<RenderTemplateCmd> commands,
      List<String> styles, bool nativeShadow);
  List<RenderTemplateCmd> resolveComponentTemplate(num templateId);
  RenderProtoViewRef createProtoView(List<RenderTemplateCmd> cmds) {
    return new DefaultProtoViewRef(cmds);
  }

  RenderViewWithFragments createRootHostView(
      RenderProtoViewRef hostProtoViewRef,
      num fragmentCount,
      String hostElementSelector);
  RenderViewWithFragments createView(
      RenderProtoViewRef protoViewRef, num fragmentCount);
  destroyView(RenderViewRef viewRef);
  createRootContentInsertionPoint();
  dynamic getNativeElementSync(RenderElementRef location) {
    return resolveInternalDomView(location.renderView).boundElements[
        location.boundElementIndex];
  }

  List<dynamic> getRootNodes(RenderFragmentRef fragment) {
    return resolveInternalDomFragment(fragment);
  }

  attachFragmentAfterFragment(
      RenderFragmentRef previousFragmentRef, RenderFragmentRef fragmentRef) {
    var previousFragmentNodes = resolveInternalDomFragment(previousFragmentRef);
    if (previousFragmentNodes.length > 0) {
      var sibling = previousFragmentNodes[previousFragmentNodes.length - 1];
      var nodes = resolveInternalDomFragment(fragmentRef);
      moveNodesAfterSibling(sibling, nodes);
      this.animateNodesEnter(nodes);
    }
  }

  /**
   * Iterates through all nodes being added to the DOM and animates them if necessary
   * @param nodes
   */
  animateNodesEnter(List<dynamic> nodes) {
    for (var i = 0; i < nodes.length; i++) this.animateNodeEnter(nodes[i]);
  }

  /**
   * Performs animations if necessary
   * @param node
   */
  animateNodeEnter(dynamic node);
  /**
   * If animations are necessary, performs animations then removes the element; otherwise, it just
   * removes the element.
   * @param node
   */
  animateNodeLeave(dynamic node);
  attachFragmentAfterElement(
      RenderElementRef elementRef, RenderFragmentRef fragmentRef) {
    var parentView = resolveInternalDomView(elementRef.renderView);
    var element = parentView.boundElements[elementRef.boundElementIndex];
    var nodes = resolveInternalDomFragment(fragmentRef);
    moveNodesAfterSibling(element, nodes);
    this.animateNodesEnter(nodes);
  }

  detachFragment(RenderFragmentRef fragmentRef);
  hydrateView(RenderViewRef viewRef) {
    resolveInternalDomView(viewRef).hydrate();
  }

  dehydrateView(RenderViewRef viewRef) {
    resolveInternalDomView(viewRef).dehydrate();
  }

  dynamic createTemplateAnchor(List<String> attrNameAndValues) {
    return this.createElement("script", attrNameAndValues);
  }

  dynamic createElement(String name, List<String> attrNameAndValues);
  mergeElement(dynamic existing, List<String> attrNameAndValues);
  dynamic createShadowRoot(dynamic host, num templateId);
  dynamic createText(String value) {
    return DOM.createTextNode(isPresent(value) ? value : "");
  }

  appendChild(dynamic parent, dynamic child) {
    DOM.appendChild(parent, child);
  }

  on(dynamic element, String eventName, Function callback);
  Function globalOn(String target, String eventName, Function callback);
  void setElementProperty(
      RenderElementRef location, String propertyName, dynamic propertyValue) {
    var view = resolveInternalDomView(location.renderView);
    DOM.setProperty((view.boundElements[location.boundElementIndex] as dynamic),
        propertyName, propertyValue);
  }

  void setElementAttribute(
      RenderElementRef location, String attributeName, String attributeValue) {
    var view = resolveInternalDomView(location.renderView);
    var element = view.boundElements[location.boundElementIndex];
    var dashCasedAttributeName = camelCaseToDashCase(attributeName);
    if (isPresent(attributeValue)) {
      DOM.setAttribute(
          element, dashCasedAttributeName, stringify(attributeValue));
    } else {
      DOM.removeAttribute(element, dashCasedAttributeName);
    }
  }

  void setElementClass(
      RenderElementRef location, String className, bool isAdd) {
    var view = resolveInternalDomView(location.renderView);
    var element = view.boundElements[location.boundElementIndex];
    if (isAdd) {
      DOM.addClass(element, className);
    } else {
      DOM.removeClass(element, className);
    }
  }

  void setElementStyle(
      RenderElementRef location, String styleName, String styleValue) {
    var view = resolveInternalDomView(location.renderView);
    var element = view.boundElements[location.boundElementIndex];
    var dashCasedStyleName = camelCaseToDashCase(styleName);
    if (isPresent(styleValue)) {
      DOM.setStyle(element, dashCasedStyleName, stringify(styleValue));
    } else {
      DOM.removeStyle(element, dashCasedStyleName);
    }
  }

  void invokeElementMethod(
      RenderElementRef location, String methodName, List<dynamic> args) {
    var view = resolveInternalDomView(location.renderView);
    var element = (view.boundElements[location.boundElementIndex] as dynamic);
    DOM.invoke(element, methodName, args);
  }

  void setText(RenderViewRef viewRef, num textNodeIndex, String text) {
    var view = resolveInternalDomView(viewRef);
    DOM.setText(view.boundTextNodes[textNodeIndex], text);
  }

  void setEventDispatcher(
      RenderViewRef viewRef, RenderEventDispatcher dispatcher) {
    resolveInternalDomView(viewRef).setEventDispatcher(dispatcher);
  }
}

@Injectable()
class DomRenderer_ extends DomRenderer {
  EventManager _eventManager;
  DomSharedStylesHost _domSharedStylesHost;
  AnimationBuilder _animate;
  Map<num, List<RenderTemplateCmd>> _componentCmds =
      new Map<num, List<RenderTemplateCmd>>();
  Map<num, List<String>> _nativeShadowStyles = new Map<num, List<String>>();
  var _document;
  DomRenderer_(this._eventManager, this._domSharedStylesHost, this._animate,
      @Inject(DOCUMENT) document)
      : super() {
    /* super call moved to initializer */;
    this._document = document;
  }
  registerComponentTemplate(num templateId, List<RenderTemplateCmd> commands,
      List<String> styles, bool nativeShadow) {
    this._componentCmds[templateId] = commands;
    if (nativeShadow) {
      this._nativeShadowStyles[templateId] = styles;
    } else {
      this._domSharedStylesHost.addStyles(styles);
    }
  }

  List<RenderTemplateCmd> resolveComponentTemplate(num templateId) {
    return this._componentCmds[templateId];
  }

  /** @internal */
  WtfScopeFn _createRootHostViewScope =
      wtfCreateScope("DomRenderer#createRootHostView()");
  RenderViewWithFragments createRootHostView(
      RenderProtoViewRef hostProtoViewRef,
      num fragmentCount,
      String hostElementSelector) {
    var s = this._createRootHostViewScope();
    var element = DOM.querySelector(this._document, hostElementSelector);
    if (isBlank(element)) {
      wtfLeave(s);
      throw new BaseException(
          '''The selector "${ hostElementSelector}" did not match any elements''');
    }
    return wtfLeave(s, this._createView(hostProtoViewRef, element));
  }

  /** @internal */
  var _createViewScope = wtfCreateScope("DomRenderer#createView()");
  RenderViewWithFragments createView(
      RenderProtoViewRef protoViewRef, num fragmentCount) {
    var s = this._createViewScope();
    return wtfLeave(s, this._createView(protoViewRef, null));
  }

  RenderViewWithFragments _createView(
      RenderProtoViewRef protoViewRef, dynamic inplaceElement) {
    var view = createRenderView(
        ((protoViewRef as DefaultProtoViewRef)).cmds, inplaceElement, this);
    var sdRoots = view.nativeShadowRoots;
    for (var i = 0; i < sdRoots.length; i++) {
      this._domSharedStylesHost.addHost(sdRoots[i]);
    }
    return new RenderViewWithFragments(view, view.fragments);
  }

  destroyView(RenderViewRef viewRef) {
    var view = (viewRef as DefaultRenderView<dynamic>);
    var sdRoots = view.nativeShadowRoots;
    for (var i = 0; i < sdRoots.length; i++) {
      this._domSharedStylesHost.removeHost(sdRoots[i]);
    }
  }

  animateNodeEnter(dynamic node) {
    if (DOM.isElementNode(node) && DOM.hasClass(node, "ng-animate")) {
      DOM.addClass(node, "ng-enter");
      this
          ._animate
          .css()
          .addAnimationClass("ng-enter-active")
          .start((node as dynamic))
          .onComplete(() {
        DOM.removeClass(node, "ng-enter");
      });
    }
  }

  animateNodeLeave(dynamic node) {
    if (DOM.isElementNode(node) && DOM.hasClass(node, "ng-animate")) {
      DOM.addClass(node, "ng-leave");
      this
          ._animate
          .css()
          .addAnimationClass("ng-leave-active")
          .start((node as dynamic))
          .onComplete(() {
        DOM.removeClass(node, "ng-leave");
        DOM.remove(node);
      });
    } else {
      DOM.remove(node);
    }
  }

  /** @internal */
  var _detachFragmentScope = wtfCreateScope("DomRenderer#detachFragment()");
  detachFragment(RenderFragmentRef fragmentRef) {
    var s = this._detachFragmentScope();
    var fragmentNodes = resolveInternalDomFragment(fragmentRef);
    for (var i = 0; i < fragmentNodes.length; i++) {
      this.animateNodeLeave(fragmentNodes[i]);
    }
    wtfLeave(s);
  }

  dynamic createElement(String name, List<String> attrNameAndValues) {
    var isSvg = SVG_ELEMENT_NAMES[name] == true;
    var el = isSvg
        ? DOM.createElementNS(SVG_NAMESPACE, name)
        : DOM.createElement(name);
    this._setAttributes(el, attrNameAndValues, isSvg);
    return el;
  }

  mergeElement(dynamic existing, List<String> attrNameAndValues) {
    DOM.clearNodes(existing);
    this._setAttributes(existing, attrNameAndValues, false);
  }

  _setAttributes(dynamic node, List<String> attrNameAndValues, bool isSvg) {
    for (var attrIdx = 0; attrIdx < attrNameAndValues.length; attrIdx += 2) {
      var attrName = attrNameAndValues[attrIdx];
      var attrValue = attrNameAndValues[attrIdx + 1];
      var attrNs = isSvg ? SVG_ATTR_NAMESPACES[attrName] : null;
      if (isPresent(attrNs)) {
        DOM.setAttributeNS(node, XLINK_NAMESPACE, attrName, attrValue);
      } else {
        DOM.setAttribute(node, attrName, attrValue);
      }
    }
  }

  dynamic createRootContentInsertionPoint() {
    return DOM.createComment("root-content-insertion-point");
  }

  dynamic createShadowRoot(dynamic host, num templateId) {
    var sr = DOM.createShadowRoot(host);
    var styles = this._nativeShadowStyles[templateId];
    for (var i = 0; i < styles.length; i++) {
      DOM.appendChild(sr, DOM.createStyleElement(styles[i]));
    }
    return sr;
  }

  on(dynamic element, String eventName, Function callback) {
    this._eventManager.addEventListener(
        (element as dynamic), eventName, decoratePreventDefault(callback));
  }

  Function globalOn(String target, String eventName, Function callback) {
    return this._eventManager.addGlobalEventListener(
        target, eventName, decoratePreventDefault(callback));
  }
}

DefaultRenderView<dynamic> resolveInternalDomView(RenderViewRef viewRef) {
  return (viewRef as DefaultRenderView<dynamic>);
}

List<dynamic> resolveInternalDomFragment(RenderFragmentRef fragmentRef) {
  return ((fragmentRef as DefaultRenderFragmentRef<dynamic>)).nodes;
}

moveNodesAfterSibling(sibling, nodes) {
  if (nodes.length > 0 && isPresent(DOM.parentElement(sibling))) {
    for (var i = 0; i < nodes.length; i++) {
      DOM.insertBefore(sibling, nodes[i]);
    }
    DOM.insertBefore(nodes[0], sibling);
  }
}

Function decoratePreventDefault(Function eventHandler) {
  return (event) {
    var allowDefaultBehavior = eventHandler(event);
    if (!allowDefaultBehavior) {
      // TODO(tbosch): move preventDefault into event plugins...
      DOM.preventDefault(event);
    }
  };
}
