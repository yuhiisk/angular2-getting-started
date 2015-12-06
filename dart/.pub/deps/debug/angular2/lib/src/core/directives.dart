/**
 * @module
 * @description
 * Common directives shipped with Angular.
 */
library angular2.src.core.directives;

import "facade/lang.dart" show Type;
import "directives/ng_class.dart" show NgClass;
import "directives/ng_for.dart" show NgFor;
import "directives/ng_if.dart" show NgIf;
import "directives/ng_style.dart" show NgStyle;
import "directives/ng_switch.dart" show NgSwitch, NgSwitchWhen, NgSwitchDefault;
export "directives/ng_class.dart" show NgClass;
export "directives/ng_for.dart" show NgFor;
export "directives/ng_if.dart" show NgIf;
export "directives/ng_style.dart" show NgStyle;
export "directives/ng_switch.dart" show NgSwitch, NgSwitchWhen, NgSwitchDefault;
export "directives/observable_list_diff.dart";

/**
 * A collection of Angular core directives that are likely to be used in each and every Angular
 * application.
 *
 * This collection can be used to quickly enumerate all the built-in directives in the `directives`
 * property of the `@View` annotation.
 *
 * ### Example ([live demo](http://plnkr.co/edit/yakGwpCdUkg0qfzX5m8g?p=preview))
 *
 * Instead of writing:
 *
 * ```typescript
 * import {NgClass, NgIf, NgFor, NgSwitch, NgSwitchWhen, NgSwitchDefault} from 'angular2/angular2';
 * import {OtherDirective} from './myDirectives';
 *
 * @Component({
 *   selector: 'my-component',
 *   templateUrl: 'myComponent.html',
 *   directives: [NgClass, NgIf, NgFor, NgSwitch, NgSwitchWhen, NgSwitchDefault, OtherDirective]
 * })
 * export class MyComponent {
 *   ...
 * }
 * ```
 * one could import all the core directives at once:
 *
 * ```typescript
 * import {CORE_DIRECTIVES} from 'angular2/angular2';
 * import {OtherDirective} from './myDirectives';
 *
 * @Component({
 *   selector: 'my-component',
 *   templateUrl: 'myComponent.html',
 *   directives: [CORE_DIRECTIVES, OtherDirective]
 * })
 * export class MyComponent {
 *   ...
 * }
 * ```
 */
const List<Type> CORE_DIRECTIVES = const [
  NgClass,
  NgFor,
  NgIf,
  NgStyle,
  NgSwitch,
  NgSwitchWhen,
  NgSwitchDefault
];
