library angular2.src.core.forms.directives.validators;

import "package:angular2/src/core/di.dart" show Provider, OpaqueToken;
import "package:angular2/src/core/metadata.dart" show Attribute, Directive;
import "../validators.dart" show Validators, NG_VALIDATORS;
import "../model.dart" show Control;
import "../model.dart" as modelModule;
import "package:angular2/src/core/facade/lang.dart" show NumberWrapper;

/**
 * An interface that can be implemented by classes that can act as validators.
 *
 * ## Usage
 *
 * ```typescript
 * @Directive({
 *   selector: '[custom-validator]',
 *   providers: [provide(NG_VALIDATORS, {useExisting: CustomValidatorDirective, multi: true})]
 * })
 * class CustomValidatorDirective implements Validator {
 *   validate(c: Control): {[key: string]: any} {
 *     return {"custom": true};
 *   }
 * }
 * ```
 */
abstract class Validator {
  Map<String, dynamic> validate(modelModule.Control c);
}

const REQUIRED_VALIDATOR =
    const Provider(NG_VALIDATORS, useValue: Validators.required, multi: true);

@Directive(
    selector:
        "[required][ng-control],[required][ng-form-control],[required][ng-model]",
    providers: const [REQUIRED_VALIDATOR])
class RequiredValidator {}

const MIN_LENGTH_VALIDATOR =
    const Provider(NG_VALIDATORS, useExisting: MinLengthValidator, multi: true);

@Directive(
    selector:
        "[minlength][ng-control],[minlength][ng-form-control],[minlength][ng-model]",
    providers: const [MIN_LENGTH_VALIDATOR])
class MinLengthValidator implements Validator {
  Function _validator;
  MinLengthValidator(@Attribute("minlength") String minLength) {
    this._validator =
        Validators.minLength(NumberWrapper.parseInt(minLength, 10));
  }
  Map<String, dynamic> validate(Control c) {
    return this._validator(c);
  }
}

const MAX_LENGTH_VALIDATOR =
    const Provider(NG_VALIDATORS, useExisting: MaxLengthValidator, multi: true);

@Directive(
    selector:
        "[maxlength][ng-control],[maxlength][ng-form-control],[maxlength][ng-model]",
    providers: const [MAX_LENGTH_VALIDATOR])
class MaxLengthValidator implements Validator {
  Function _validator;
  MaxLengthValidator(@Attribute("maxlength") String minLength) {
    this._validator =
        Validators.maxLength(NumberWrapper.parseInt(minLength, 10));
  }
  Map<String, dynamic> validate(Control c) {
    return this._validator(c);
  }
}
