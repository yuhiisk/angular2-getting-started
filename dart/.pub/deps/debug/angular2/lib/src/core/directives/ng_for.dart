library angular2.src.core.directives.ng_for;

import "package:angular2/lifecycle_hooks.dart" show DoCheck;
import "package:angular2/src/core/metadata.dart" show Directive;
import "package:angular2/src/core/change_detection.dart"
    show ChangeDetectorRef, IterableDiffer, IterableDiffers;
import "package:angular2/src/core/linker.dart"
    show ViewContainerRef, TemplateRef, ViewRef;
import "package:angular2/src/core/facade/lang.dart" show isPresent, isBlank;

/**
 * The `NgFor` directive instantiates a template once per item from an iterable. The context for
 * each instantiated template inherits from the outer context with the given loop variable set
 * to the current item from the iterable.
 *
 * It is possible to alias the `index` to a local variable that will be set to the current loop
 * iteration in the template context, and also to alias the 'last' to a local variable that will
 * be set to a boolean indicating if the item is the last one in the iteration
 *
 * When the contents of the iterator changes, `NgFor` makes the corresponding changes to the DOM:
 *
 * * When an item is added, a new instance of the template is added to the DOM.
 * * When an item is removed, its template instance is removed from the DOM.
 * * When items are reordered, their respective templates are reordered in the DOM.
 *
 * ### Example
 *
 * ```
 * <ul>
 *   <li *ng-for="#error of errors; #i = index">
 *     Error {{i}} of {{errors.length}}: {{error.message}}
 *   </li>
 * </ul>
 * ```
 *
 *##Syntax
 *
 * - `<li *ng-for="#item of items; #i = index">...</li>`
 * - `<li template="ng-for #item of items; #i = index">...</li>`
 * - `<template ng-for #item [ng-for-of]="items" #i="index"><li>...</li></template>`
 */
@Directive(
    selector: "[ng-for][ng-for-of]", inputs: const ["ngForOf", "ngForTemplate"])
class NgFor implements DoCheck {
  ViewContainerRef _viewContainer;
  TemplateRef _templateRef;
  IterableDiffers _iterableDiffers;
  ChangeDetectorRef _cdr;
  /** @internal */
  dynamic _ngForOf;
  IterableDiffer _differ;
  NgFor(this._viewContainer, this._templateRef, this._iterableDiffers,
      this._cdr) {}
  set ngForOf(dynamic value) {
    this._ngForOf = value;
    if (isBlank(this._differ) && isPresent(value)) {
      this._differ = this._iterableDiffers.find(value).create(this._cdr);
    }
  }

  set ngForTemplate(TemplateRef value) {
    this._templateRef = value;
  }

  doCheck() {
    if (isPresent(this._differ)) {
      var changes = this._differ.diff(this._ngForOf);
      if (isPresent(changes)) this._applyChanges(changes);
    }
  }

  _applyChanges(changes) {
    // TODO(rado): check if change detection can produce a change record that is

    // easier to consume than current.
    var recordViewTuples = [];
    changes.forEachRemovedItem((removedRecord) =>
        recordViewTuples.add(new RecordViewTuple(removedRecord, null)));
    changes.forEachMovedItem((movedRecord) =>
        recordViewTuples.add(new RecordViewTuple(movedRecord, null)));
    var insertTuples = this._bulkRemove(recordViewTuples);
    changes.forEachAddedItem((addedRecord) =>
        insertTuples.add(new RecordViewTuple(addedRecord, null)));
    this._bulkInsert(insertTuples);
    for (var i = 0; i < insertTuples.length; i++) {
      this._perViewChange(insertTuples[i].view, insertTuples[i].record);
    }
    for (var i = 0, ilen = this._viewContainer.length; i < ilen; i++) {
      this._viewContainer.get(i).setLocal("last", identical(i, ilen - 1));
    }
  }

  _perViewChange(view, record) {
    view.setLocal("\$implicit", record.item);
    view.setLocal("index", record.currentIndex);
    view.setLocal("even", (record.currentIndex % 2 == 0));
    view.setLocal("odd", (record.currentIndex % 2 == 1));
  }

  List<RecordViewTuple> _bulkRemove(List<RecordViewTuple> tuples) {
    tuples.sort((a, b) => a.record.previousIndex - b.record.previousIndex);
    var movedTuples = [];
    for (var i = tuples.length - 1; i >= 0; i--) {
      var tuple = tuples[i];
      // separate moved views from removed views.
      if (isPresent(tuple.record.currentIndex)) {
        tuple.view = this._viewContainer.detach(tuple.record.previousIndex);
        movedTuples.add(tuple);
      } else {
        this._viewContainer.remove(tuple.record.previousIndex);
      }
    }
    return movedTuples;
  }

  List<RecordViewTuple> _bulkInsert(List<RecordViewTuple> tuples) {
    tuples.sort((a, b) => a.record.currentIndex - b.record.currentIndex);
    for (var i = 0; i < tuples.length; i++) {
      var tuple = tuples[i];
      if (isPresent(tuple.view)) {
        this._viewContainer.insert(tuple.view, tuple.record.currentIndex);
      } else {
        tuple.view = this
            ._viewContainer
            .createEmbeddedView(this._templateRef, tuple.record.currentIndex);
      }
    }
    return tuples;
  }
}

class RecordViewTuple {
  ViewRef view;
  dynamic record;
  RecordViewTuple(record, view) {
    this.record = record;
    this.view = view;
  }
}
