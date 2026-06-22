// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductEvent {

 String? get category; String? get search; bool? get featured; int get page; int get limit;
/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductEventCopyWith<ProductEvent> get copyWith => _$ProductEventCopyWithImpl<ProductEvent>(this as ProductEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEvent&&(identical(other.category, category) || other.category == category)&&(identical(other.search, search) || other.search == search)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,category,search,featured,page,limit);

@override
String toString() {
  return 'ProductEvent(category: $category, search: $search, featured: $featured, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $ProductEventCopyWith<$Res>  {
  factory $ProductEventCopyWith(ProductEvent value, $Res Function(ProductEvent) _then) = _$ProductEventCopyWithImpl;
@useResult
$Res call({
 String? category, String? search, bool? featured, int page, int limit
});




}
/// @nodoc
class _$ProductEventCopyWithImpl<$Res>
    implements $ProductEventCopyWith<$Res> {
  _$ProductEventCopyWithImpl(this._self, this._then);

  final ProductEvent _self;
  final $Res Function(ProductEvent) _then;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = freezed,Object? search = freezed,Object? featured = freezed,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,featured: freezed == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductEvent].
extension ProductEventPatterns on ProductEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GetProducts value)?  getProducts,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetProducts() when getProducts != null:
return getProducts(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GetProducts value)  getProducts,}){
final _that = this;
switch (_that) {
case _GetProducts():
return getProducts(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GetProducts value)?  getProducts,}){
final _that = this;
switch (_that) {
case _GetProducts() when getProducts != null:
return getProducts(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? category,  String? search,  bool? featured,  int page,  int limit)?  getProducts,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetProducts() when getProducts != null:
return getProducts(_that.category,_that.search,_that.featured,_that.page,_that.limit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? category,  String? search,  bool? featured,  int page,  int limit)  getProducts,}) {final _that = this;
switch (_that) {
case _GetProducts():
return getProducts(_that.category,_that.search,_that.featured,_that.page,_that.limit);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? category,  String? search,  bool? featured,  int page,  int limit)?  getProducts,}) {final _that = this;
switch (_that) {
case _GetProducts() when getProducts != null:
return getProducts(_that.category,_that.search,_that.featured,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _GetProducts implements ProductEvent {
  const _GetProducts({this.category, this.search, this.featured, this.page = 1, this.limit = 10});
  

@override final  String? category;
@override final  String? search;
@override final  bool? featured;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetProductsCopyWith<_GetProducts> get copyWith => __$GetProductsCopyWithImpl<_GetProducts>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetProducts&&(identical(other.category, category) || other.category == category)&&(identical(other.search, search) || other.search == search)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,category,search,featured,page,limit);

@override
String toString() {
  return 'ProductEvent.getProducts(category: $category, search: $search, featured: $featured, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$GetProductsCopyWith<$Res> implements $ProductEventCopyWith<$Res> {
  factory _$GetProductsCopyWith(_GetProducts value, $Res Function(_GetProducts) _then) = __$GetProductsCopyWithImpl;
@override @useResult
$Res call({
 String? category, String? search, bool? featured, int page, int limit
});




}
/// @nodoc
class __$GetProductsCopyWithImpl<$Res>
    implements _$GetProductsCopyWith<$Res> {
  __$GetProductsCopyWithImpl(this._self, this._then);

  final _GetProducts _self;
  final $Res Function(_GetProducts) _then;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = freezed,Object? search = freezed,Object? featured = freezed,Object? page = null,Object? limit = null,}) {
  return _then(_GetProducts(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,featured: freezed == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ProductState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductState()';
}


}

/// @nodoc
class $ProductStateCopyWith<$Res>  {
$ProductStateCopyWith(ProductState _, $Res Function(ProductState) __);
}


/// Adds pattern-matching-related methods to [ProductState].
extension ProductStatePatterns on ProductState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Product> products,  PaginationMeta? meta)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.products,_that.meta);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Product> products,  PaginationMeta? meta)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.products,_that.meta);case _Error():
return error(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Product> products,  PaginationMeta? meta)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.products,_that.meta);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ProductState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductState.initial()';
}


}




/// @nodoc


class _Loading implements ProductState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductState.loading()';
}


}




/// @nodoc


class _Loaded implements ProductState {
  const _Loaded(final  List<Product> products, this.meta): _products = products;
  

 final  List<Product> _products;
 List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  PaginationMeta? meta;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.meta, meta) || other.meta == meta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),meta);

@override
String toString() {
  return 'ProductState.loaded(products: $products, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ProductStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<Product> products, PaginationMeta? meta
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,Object? meta = freezed,}) {
  return _then(_Loaded(
null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}


}

/// @nodoc


class _Error implements ProductState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProductState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ProductStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
