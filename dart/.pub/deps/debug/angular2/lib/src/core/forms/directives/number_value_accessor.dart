library angular2.src.core.forms.directives.number_value_accessor;

import "package:angular2/src/core/metadata.dart" show Directive;
import "package:angular2/src/core/linker.dart" show ElementRef;
import "package:angular2/src/core/render.dart" show Renderer;
import "package:angular2/src/core/di.dart" show Self, Provider;
import "control_value_accessor.dart"
    show NG_VALUE_ACCESSOR, ControlValueAccessor;
import "package:angular2/src/core/facade/lang.dart" show isBlank, NumberWrapper;
import "shared.dart" show setProperty;

const NUMBER_VALUE_ACCESSOR = const Provider(NG_VALUE_ACCESSOR,
    useExisting: NumberValueAccessor, multi: true);

/**
 * The accessor for writing a number value and listening to changes that is used by the
 * [NgModel], [NgFormControl], and [NgControlName] directives.
 *
 *  ### Example
 *  ```
 *  <input type="number" [(ng-model)]="age">
 *  ```
 */
@Directive(
    selector:
        "input[type=number][ng-control],input[type=number][ng-form-control],input[type=number][ng-model]",
    host: const {
      "(change)": "onChange(\$event.target.value)",
      "(input)": "onChange(\$event.target.value)",
      "(blur)": "onTouched()"
    },
    bindings: const [NUMBER_VALUE_ACCESSOR])
class NumberValueAccessor implements ControlValueAccessor {
  Renderer _renderer;
  ElementRef _elementRef;
  var onChange = (_) {};
  var onTouched = () {};
  NumberValueAccessor(this._renderer, this._elementRef) {}
  void writeValue(num value) {
    setProperty(this._renderer, this._elementRef, "value", value);
  }

  void registerOnChange(dynamic /* (_: number) => void */ fn) {
    this.onChange = (value) {
      fn(NumberWrapper.parseFloat(value));
    };
  }

  void registerOnTouched(dynamic /* () => void */ fn) {
    this.onTouched = fn;
  }
}
