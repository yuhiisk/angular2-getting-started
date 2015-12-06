library angular2.src.router.location;

import "location_strategy.dart" show LocationStrategy;
import "package:angular2/src/core/facade/lang.dart"
    show StringWrapper, isPresent;
import "package:angular2/src/core/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/src/core/facade/lang.dart" show isBlank;
import "package:angular2/src/core/facade/exceptions.dart"
    show BaseException, WrappedException;
import "package:angular2/angular2.dart"
    show OpaqueToken, Injectable, Optional, Inject;

/**
 * The `APP_BASE_HREF` token represents the base href to be used with the
 * [PathLocationStrategy].
 *
 * If you're using [PathLocationStrategy], you must provide a provider to a string
 * representing the URL prefix that should be preserved when generating and recognizing
 * URLs.
 *
 * ### Example
 *
 * ```
 * import {Component} from 'angular2/angular2';
 * import {ROUTER_DIRECTIVES, ROUTER_PROVIDERS, RouteConfig} from 'angular2/router';
 *
 * @Component({directives: [ROUTER_DIRECTIVES]})
 * @RouteConfig([
 *  {...},
 * ])
 * class AppCmp {
 *   // ...
 * }
 *
 * bootstrap(AppCmp, [
 *   ROUTER_PROVIDERS,
 *   PathLocationStrategy,
 *   provide(APP_BASE_HREF, {useValue: '/my/app'})
 * ]);
 * ```
 */
const OpaqueToken APP_BASE_HREF = const OpaqueToken("appBaseHref");

/**
 * `Location` is a service that applications can use to interact with a browser's URL.
 * Depending on which [LocationStrategy] is used, `Location` will either persist
 * to the URL's path or the URL's hash segment.
 *
 * Note: it's better to use [Router#navigate] service to trigger route changes. Use
 * `Location` only if you need to interact with or create normalized URLs outside of
 * routing.
 *
 * `Location` is responsible for normalizing the URL against the application's base href.
 * A normalized URL is absolute from the URL host, includes the application's base href, and has no
 * trailing slash:
 * - `/my/app/user/123` is normalized
 * - `my/app/user/123` **is not** normalized
 * - `/my/app/user/123/` **is not** normalized
 *
 * ### Example
 *
 * ```
 * import {Component} from 'angular2/angular2';
 * import {
 *   ROUTER_DIRECTIVES,
 *   ROUTER_PROVIDERS,
 *   RouteConfig,
 *   Location
 * } from 'angular2/router';
 *
 * @Component({directives: [ROUTER_DIRECTIVES]})
 * @RouteConfig([
 *  {...},
 * ])
 * class AppCmp {
 *   constructor(location: Location) {
 *     location.go('/foo');
 *   }
 * }
 *
 * bootstrap(AppCmp, [ROUTER_PROVIDERS]);
 * ```
 */
@Injectable()
class Location {
  LocationStrategy platformStrategy;
  /** @internal */
  EventEmitter _subject = new EventEmitter();
  /** @internal */
  String _baseHref;
  Location(this.platformStrategy,
      [@Optional() @Inject(APP_BASE_HREF) String href]) {
    var browserBaseHref =
        isPresent(href) ? href : this.platformStrategy.getBaseHref();
    if (isBlank(browserBaseHref)) {
      throw new BaseException(
          '''No base href set. Either provide a provider for the APP_BASE_HREF token or add a base element to the document.''');
    }
    this._baseHref = stripTrailingSlash(stripIndexHtml(browserBaseHref));
    this.platformStrategy.onPopState((_) {
      ObservableWrapper.callNext(
          this._subject, {"url": this.path(), "pop": true});
    });
  }
  /**
   * Returns the normalized URL path.
   */
  String path() {
    return this.normalize(this.platformStrategy.path());
  }

  /**
   * Given a string representing a URL, returns the normalized URL path without leading or
   * trailing slashes
   */
  String normalize(String url) {
    return stripTrailingSlash(
        _stripBaseHref(this._baseHref, stripIndexHtml(url)));
  }

  /**
   * Given a string representing a URL, returns the platform-specific external URL path.
   * If the given URL doesn't begin with a leading slash (`'/'`), this method adds one
   * before normalizing. This method will also add a hash if `HashLocationStrategy` is
   * used, or the `APP_BASE_HREF` if the `PathLocationStrategy` is in use.
   */
  String prepareExternalUrl(String url) {
    if (!url.startsWith("/")) {
      url = "/" + url;
    }
    return this.platformStrategy.prepareExternalUrl(
        stripTrailingSlash(_addBaseHref(this._baseHref, url)));
  }

  /**
   * Changes the browsers URL to the normalized version of the given URL, and pushes a
   * new item onto the platform's history.
   */
  void go(String path, [String query = ""]) {
    this.platformStrategy.pushState(null, "", path, query);
  }

  /**
   * Navigates forward in the platform's history.
   */
  void forward() {
    this.platformStrategy.forward();
  }

  /**
   * Navigates back in the platform's history.
   */
  void back() {
    this.platformStrategy.back();
  }

  /**
   * Subscribe to the platform's `popState` events.
   */
  Object subscribe(dynamic /* (value: any) => void */ onNext,
      [dynamic /* (exception: any) => void */ onThrow = null,
      dynamic /* () => void */ onReturn = null]) {
    return ObservableWrapper.subscribe(
        this._subject, onNext, onThrow, onReturn);
  }
}

String _stripBaseHref(String baseHref, String url) {
  if (baseHref.length > 0 && url.startsWith(baseHref)) {
    return url.substring(baseHref.length);
  }
  return url;
}

String _addBaseHref(String baseHref, String url) {
  if (!url.startsWith(baseHref)) {
    return baseHref + url;
  }
  return url;
}

String stripIndexHtml(String url) {
  if (new RegExp(r'\/index.html$').hasMatch(url)) {
    // '/index.html'.length == 11
    return url.substring(0, url.length - 11);
  }
  return url;
}

String stripTrailingSlash(String url) {
  if (new RegExp(r'\/$').hasMatch(url)) {
    url = url.substring(0, url.length - 1);
  }
  return url;
}
