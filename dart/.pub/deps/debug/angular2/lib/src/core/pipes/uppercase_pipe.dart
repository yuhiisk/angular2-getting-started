library angular2.src.core.pipes.uppercase_pipe;

import "package:angular2/src/core/facade/lang.dart"
    show isString, StringWrapper, isBlank;
import "package:angular2/src/core/metadata.dart" show Pipe;
import "package:angular2/src/core/di.dart" show Injectable;
import "package:angular2/src/core/change_detection.dart"
    show PipeTransform, WrappedValue;
import "invalid_pipe_argument_exception.dart" show InvalidPipeArgumentException;

/**
 * Implements uppercase transforms to text.
 *
 * ### Example
 *
 * In this example we transform the user text uppercase.
 *
 *  ```
 * @Component({
 *   selector: "username-cmp",
 *   template: "Username: {{ user | uppercase }}"
 * })
 * class Username {
 *   user:string;
 * }
 *
 * ```
 */
@Pipe(name: "uppercase")
@Injectable()
class UpperCasePipe implements PipeTransform {
  String transform(String value, [List<dynamic> args = null]) {
    if (isBlank(value)) return value;
    if (!isString(value)) {
      throw new InvalidPipeArgumentException(UpperCasePipe, value);
    }
    return StringWrapper.toUpperCase(value);
  }

  const UpperCasePipe();
}
