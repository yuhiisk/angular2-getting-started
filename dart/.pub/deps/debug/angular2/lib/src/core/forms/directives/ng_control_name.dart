library angular2.src.core.forms.directives.ng_control_name;

import "package:angular2/src/core/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/lifecycle_hooks.dart" show OnChanges, OnDestroy;
import "package:angular2/src/core/change_detection.dart" show SimpleChange;
import "package:angular2/src/core/metadata.dart" show Query, Directive;
import "package:angular2/src/core/di.dart"
    show Host, SkipSelf, Provider, Inject, Optional;
import "control_container.dart" show ControlContainer;
import "ng_control.dart" show NgControl;
import "control_value_accessor.dart"
    show ControlValueAccessor, NG_VALUE_ACCESSOR;
import "shared.dart"
    show controlPath, composeValidators, isPropertyUpdated, selectValueAccessor;
import "../model.dart" show Control;
import "../validators.dart" show Validators, NG_VALIDATORS;

const controlNameBinding =
    const Provider(NgControl, useExisting: NgControlName);

/**
 * Creates and binds a control with a specified name to a DOM element.
 *
 * This directive can only be used as a child of [NgForm] or [NgFormModel].

 * ### Example
 *
 * In this example, we create the login and password controls.
 * We can work with each control separately: check its validity, get its value, listen to its
 * changes.
 *
 *  ```
 * @Component({
 *      selector: "login-comp",
 *      directives: [FORM_DIRECTIVES],
 *      template: `
 *        <form #f="form" (submit)='onLogIn(f.value)'>
 *          Login <input type='text' ng-control='login' #l="form">
 *          <div *ng-if="!l.valid">Login is invalid</div>
 *
 *          Password <input type='password' ng-control='password'>
 *          <button type='submit'>Log in!</button>
 *        </form>
 *      `})
 * class LoginComp {
 *  onLogIn(value): void {
 *    // value === {login: 'some login', password: 'some password'}
 *  }
 * }
 *  ```
 *
 * We can also use ng-model to bind a domain model to the form.
 *
 *  ```
 * @Component({
 *      selector: "login-comp",
 *      directives: [FORM_DIRECTIVES],
 *      template: `
 *        <form (submit)='onLogIn()'>
 *          Login <input type='text' ng-control='login' [(ng-model)]="credentials.login">
 *          Password <input type='password' ng-control='password'
 *                          [(ng-model)]="credentials.password">
 *          <button type='submit'>Log in!</button>
 *        </form>
 *      `})
 * class LoginComp {
 *  credentials: {login:string, password:string};
 *
 *  onLogIn(): void {
 *    // this.credentials.login === "some login"
 *    // this.credentials.password === "some password"
 *  }
 * }
 *  ```
 */
@Directive(
    selector: "[ng-control]",
    bindings: const [controlNameBinding],
    inputs: const ["name: ngControl", "model: ngModel"],
    outputs: const ["update: ngModelChange"],
    exportAs: "form")
class NgControlName extends NgControl implements OnChanges, OnDestroy {
  /** @internal */
  ControlContainer _parent;
  var update = new EventEmitter();
  dynamic model;
  dynamic viewModel;
  Function _validator;
  /** @internal */
  var _added = false;
  NgControlName(
      @Host() @SkipSelf() ControlContainer parent,
      @Optional()
      @Inject(NG_VALIDATORS)
      /* Array<Validator|Function> */ List<dynamic> validators,
      @Optional()
      @Inject(NG_VALUE_ACCESSOR)
      List<ControlValueAccessor> valueAccessors)
      : super() {
    /* super call moved to initializer */;
    this._parent = parent;
    this._validator = composeValidators(validators);
    this.valueAccessor = selectValueAccessor(this, valueAccessors);
  }
  onChanges(Map<String, SimpleChange> changes) {
    if (!this._added) {
      this.formDirective.addControl(this);
      this._added = true;
    }
    if (isPropertyUpdated(changes, this.viewModel)) {
      this.viewModel = this.model;
      this.formDirective.updateModel(this, this.model);
    }
  }

  void onDestroy() {
    this.formDirective.removeControl(this);
  }

  void viewToModelUpdate(dynamic newValue) {
    this.viewModel = newValue;
    ObservableWrapper.callNext(this.update, newValue);
  }

  List<String> get path {
    return controlPath(this.name, this._parent);
  }

  dynamic get formDirective {
    return this._parent.formDirective;
  }

  Function get validator {
    return this._validator;
  }

  Control get control {
    return this.formDirective.getControl(this);
  }
}
