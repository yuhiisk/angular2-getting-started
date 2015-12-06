library angular2.src.core.compiler.runtime_metadata;

import "package:angular2/src/core/di.dart" show resolveForwardRef;
import "package:angular2/src/core/facade/lang.dart"
    show Type, isBlank, isPresent, isArray, stringify, RegExpWrapper;
import "package:angular2/src/core/facade/exceptions.dart" show BaseException;
import "package:angular2/src/core/facade/collection.dart"
    show MapWrapper, StringMapWrapper, ListWrapper;
import "directive_metadata.dart" as cpl;
import "package:angular2/src/core/metadata/directives.dart" as md;
import "package:angular2/src/core/linker/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/src/core/linker/view_resolver.dart" show ViewResolver;
import "package:angular2/src/core/metadata/view.dart" show ViewMetadata;
import "package:angular2/src/core/linker/directive_lifecycle_reflector.dart"
    show hasLifecycleHook;
import "package:angular2/src/core/linker/interfaces.dart"
    show LifecycleHooks, LIFECYCLE_HOOKS_VALUES;
import "package:angular2/src/core/reflection/reflection.dart" show reflector;
import "package:angular2/src/core/di.dart" show Injectable;
import "util.dart" show MODULE_SUFFIX;

@Injectable()
class RuntimeMetadataResolver {
  DirectiveResolver _directiveResolver;
  ViewResolver _viewResolver;
  var _cache = new Map<Type, cpl.CompileDirectiveMetadata>();
  RuntimeMetadataResolver(this._directiveResolver, this._viewResolver) {}
  cpl.CompileDirectiveMetadata getMetadata(Type directiveType) {
    var meta = this._cache[directiveType];
    if (isBlank(meta)) {
      var dirMeta = this._directiveResolver.resolve(directiveType);
      var moduleUrl = calcModuleUrl(directiveType, dirMeta);
      var templateMeta = null;
      var changeDetectionStrategy = null;
      if (dirMeta is md.ComponentMetadata) {
        var cmpMeta = (dirMeta as md.ComponentMetadata);
        var viewMeta = this._viewResolver.resolve(directiveType);
        templateMeta = new cpl.CompileTemplateMetadata(
            encapsulation: viewMeta.encapsulation,
            template: viewMeta.template,
            templateUrl: viewMeta.templateUrl,
            styles: viewMeta.styles,
            styleUrls: viewMeta.styleUrls);
        changeDetectionStrategy = cmpMeta.changeDetection;
      }
      meta = cpl.CompileDirectiveMetadata.create(
          selector: dirMeta.selector,
          exportAs: dirMeta.exportAs,
          isComponent: isPresent(templateMeta),
          dynamicLoadable: true,
          type: new cpl.CompileTypeMetadata(
              name: stringify(directiveType),
              moduleUrl: moduleUrl,
              runtime: directiveType),
          template: templateMeta,
          changeDetection: changeDetectionStrategy,
          inputs: dirMeta.inputs,
          outputs: dirMeta.outputs,
          host: dirMeta.host,
          lifecycleHooks: ListWrapper.filter(LIFECYCLE_HOOKS_VALUES,
              (hook) => hasLifecycleHook(hook, directiveType)));
      this._cache[directiveType] = meta;
    }
    return meta;
  }

  List<cpl.CompileDirectiveMetadata> getViewDirectivesMetadata(Type component) {
    var view = this._viewResolver.resolve(component);
    var directives = flattenDirectives(view);
    for (var i = 0; i < directives.length; i++) {
      if (!isValidDirective(directives[i])) {
        throw new BaseException(
            '''Unexpected directive value \'${ stringify ( directives [ i ] )}\' on the View of component \'${ stringify ( component )}\'''');
      }
    }
    return removeDuplicates(directives)
        .map((type) => this.getMetadata(type))
        .toList();
  }
}

List<dynamic> removeDuplicates(List<dynamic> items) {
  var m = new Map<dynamic, dynamic>();
  items.forEach((i) => m[i] = null);
  return MapWrapper.keys(m);
}

List<Type> flattenDirectives(ViewMetadata view) {
  if (isBlank(view.directives)) return [];
  var directives = [];
  flattenList(view.directives, directives);
  return directives;
}

void flattenList(
    List<dynamic> tree, List<dynamic /* Type | List < dynamic > */ > out) {
  for (var i = 0; i < tree.length; i++) {
    var item = resolveForwardRef(tree[i]);
    if (isArray(item)) {
      flattenList(item, out);
    } else {
      out.add(item);
    }
  }
}

bool isValidDirective(Type value) {
  return isPresent(value) && (value is Type);
}

String calcModuleUrl(Type type, md.DirectiveMetadata dirMeta) {
  if (isPresent(dirMeta.moduleId)) {
    return '''package:${ dirMeta . moduleId}${ MODULE_SUFFIX}''';
  } else {
    return reflector.importUri(type);
  }
}
