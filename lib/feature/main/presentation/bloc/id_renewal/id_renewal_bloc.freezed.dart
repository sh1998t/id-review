// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'id_renewal_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IdRenewalState {

 bool get isLoading; int get currentStep; String? get applicationId; String? get applicationStatus; String? get serviceType; ApplicantInfo? get applicant; Uint8List? get facePhoto; Map<int, FingerprintPrint> get fingerprints; Set<int> get disabledFingers; Uint8List? get signature; String? get phone; bool get isSubmitted; Failure? get error;
/// Create a copy of IdRenewalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IdRenewalStateCopyWith<IdRenewalState> get copyWith => _$IdRenewalStateCopyWithImpl<IdRenewalState>(this as IdRenewalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdRenewalState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.applicationStatus, applicationStatus) || other.applicationStatus == applicationStatus)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.applicant, applicant) || other.applicant == applicant)&&const DeepCollectionEquality().equals(other.facePhoto, facePhoto)&&const DeepCollectionEquality().equals(other.fingerprints, fingerprints)&&const DeepCollectionEquality().equals(other.disabledFingers, disabledFingers)&&const DeepCollectionEquality().equals(other.signature, signature)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isSubmitted, isSubmitted) || other.isSubmitted == isSubmitted)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,currentStep,applicationId,applicationStatus,serviceType,applicant,const DeepCollectionEquality().hash(facePhoto),const DeepCollectionEquality().hash(fingerprints),const DeepCollectionEquality().hash(disabledFingers),const DeepCollectionEquality().hash(signature),phone,isSubmitted,error);

@override
String toString() {
  return 'IdRenewalState(isLoading: $isLoading, currentStep: $currentStep, applicationId: $applicationId, applicationStatus: $applicationStatus, serviceType: $serviceType, applicant: $applicant, facePhoto: $facePhoto, fingerprints: $fingerprints, disabledFingers: $disabledFingers, signature: $signature, phone: $phone, isSubmitted: $isSubmitted, error: $error)';
}


}

/// @nodoc
abstract mixin class $IdRenewalStateCopyWith<$Res>  {
  factory $IdRenewalStateCopyWith(IdRenewalState value, $Res Function(IdRenewalState) _then) = _$IdRenewalStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, int currentStep, String? applicationId, String? applicationStatus, String? serviceType, ApplicantInfo? applicant, Uint8List? facePhoto, Map<int, FingerprintPrint> fingerprints, Set<int> disabledFingers, Uint8List? signature, String? phone, bool isSubmitted, Failure? error
});




}
/// @nodoc
class _$IdRenewalStateCopyWithImpl<$Res>
    implements $IdRenewalStateCopyWith<$Res> {
  _$IdRenewalStateCopyWithImpl(this._self, this._then);

  final IdRenewalState _self;
  final $Res Function(IdRenewalState) _then;

/// Create a copy of IdRenewalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? currentStep = null,Object? applicationId = freezed,Object? applicationStatus = freezed,Object? serviceType = freezed,Object? applicant = freezed,Object? facePhoto = freezed,Object? fingerprints = null,Object? disabledFingers = null,Object? signature = freezed,Object? phone = freezed,Object? isSubmitted = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,applicationId: freezed == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String?,applicationStatus: freezed == applicationStatus ? _self.applicationStatus : applicationStatus // ignore: cast_nullable_to_non_nullable
as String?,serviceType: freezed == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String?,applicant: freezed == applicant ? _self.applicant : applicant // ignore: cast_nullable_to_non_nullable
as ApplicantInfo?,facePhoto: freezed == facePhoto ? _self.facePhoto : facePhoto // ignore: cast_nullable_to_non_nullable
as Uint8List?,fingerprints: null == fingerprints ? _self.fingerprints : fingerprints // ignore: cast_nullable_to_non_nullable
as Map<int, FingerprintPrint>,disabledFingers: null == disabledFingers ? _self.disabledFingers : disabledFingers // ignore: cast_nullable_to_non_nullable
as Set<int>,signature: freezed == signature ? _self.signature : signature // ignore: cast_nullable_to_non_nullable
as Uint8List?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isSubmitted: null == isSubmitted ? _self.isSubmitted : isSubmitted // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [IdRenewalState].
extension IdRenewalStatePatterns on IdRenewalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IdRenewalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IdRenewalState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IdRenewalState value)  $default,){
final _that = this;
switch (_that) {
case _IdRenewalState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IdRenewalState value)?  $default,){
final _that = this;
switch (_that) {
case _IdRenewalState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  int currentStep,  String? applicationId,  String? applicationStatus,  String? serviceType,  ApplicantInfo? applicant,  Uint8List? facePhoto,  Map<int, FingerprintPrint> fingerprints,  Set<int> disabledFingers,  Uint8List? signature,  String? phone,  bool isSubmitted,  Failure? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IdRenewalState() when $default != null:
return $default(_that.isLoading,_that.currentStep,_that.applicationId,_that.applicationStatus,_that.serviceType,_that.applicant,_that.facePhoto,_that.fingerprints,_that.disabledFingers,_that.signature,_that.phone,_that.isSubmitted,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  int currentStep,  String? applicationId,  String? applicationStatus,  String? serviceType,  ApplicantInfo? applicant,  Uint8List? facePhoto,  Map<int, FingerprintPrint> fingerprints,  Set<int> disabledFingers,  Uint8List? signature,  String? phone,  bool isSubmitted,  Failure? error)  $default,) {final _that = this;
switch (_that) {
case _IdRenewalState():
return $default(_that.isLoading,_that.currentStep,_that.applicationId,_that.applicationStatus,_that.serviceType,_that.applicant,_that.facePhoto,_that.fingerprints,_that.disabledFingers,_that.signature,_that.phone,_that.isSubmitted,_that.error);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  int currentStep,  String? applicationId,  String? applicationStatus,  String? serviceType,  ApplicantInfo? applicant,  Uint8List? facePhoto,  Map<int, FingerprintPrint> fingerprints,  Set<int> disabledFingers,  Uint8List? signature,  String? phone,  bool isSubmitted,  Failure? error)?  $default,) {final _that = this;
switch (_that) {
case _IdRenewalState() when $default != null:
return $default(_that.isLoading,_that.currentStep,_that.applicationId,_that.applicationStatus,_that.serviceType,_that.applicant,_that.facePhoto,_that.fingerprints,_that.disabledFingers,_that.signature,_that.phone,_that.isSubmitted,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _IdRenewalState implements IdRenewalState {
  const _IdRenewalState({this.isLoading = false, this.currentStep = 0, this.applicationId, this.applicationStatus, this.serviceType, this.applicant, this.facePhoto, final  Map<int, FingerprintPrint> fingerprints = const {}, final  Set<int> disabledFingers = const {}, this.signature, this.phone, this.isSubmitted = false, this.error}): _fingerprints = fingerprints,_disabledFingers = disabledFingers;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int currentStep;
@override final  String? applicationId;
@override final  String? applicationStatus;
@override final  String? serviceType;
@override final  ApplicantInfo? applicant;
@override final  Uint8List? facePhoto;
 final  Map<int, FingerprintPrint> _fingerprints;
@override@JsonKey() Map<int, FingerprintPrint> get fingerprints {
  if (_fingerprints is EqualUnmodifiableMapView) return _fingerprints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fingerprints);
}

 final  Set<int> _disabledFingers;
@override@JsonKey() Set<int> get disabledFingers {
  if (_disabledFingers is EqualUnmodifiableSetView) return _disabledFingers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_disabledFingers);
}

@override final  Uint8List? signature;
@override final  String? phone;
@override@JsonKey() final  bool isSubmitted;
@override final  Failure? error;

/// Create a copy of IdRenewalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdRenewalStateCopyWith<_IdRenewalState> get copyWith => __$IdRenewalStateCopyWithImpl<_IdRenewalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IdRenewalState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.applicationStatus, applicationStatus) || other.applicationStatus == applicationStatus)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.applicant, applicant) || other.applicant == applicant)&&const DeepCollectionEquality().equals(other.facePhoto, facePhoto)&&const DeepCollectionEquality().equals(other._fingerprints, _fingerprints)&&const DeepCollectionEquality().equals(other._disabledFingers, _disabledFingers)&&const DeepCollectionEquality().equals(other.signature, signature)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isSubmitted, isSubmitted) || other.isSubmitted == isSubmitted)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,currentStep,applicationId,applicationStatus,serviceType,applicant,const DeepCollectionEquality().hash(facePhoto),const DeepCollectionEquality().hash(_fingerprints),const DeepCollectionEquality().hash(_disabledFingers),const DeepCollectionEquality().hash(signature),phone,isSubmitted,error);

@override
String toString() {
  return 'IdRenewalState(isLoading: $isLoading, currentStep: $currentStep, applicationId: $applicationId, applicationStatus: $applicationStatus, serviceType: $serviceType, applicant: $applicant, facePhoto: $facePhoto, fingerprints: $fingerprints, disabledFingers: $disabledFingers, signature: $signature, phone: $phone, isSubmitted: $isSubmitted, error: $error)';
}


}

/// @nodoc
abstract mixin class _$IdRenewalStateCopyWith<$Res> implements $IdRenewalStateCopyWith<$Res> {
  factory _$IdRenewalStateCopyWith(_IdRenewalState value, $Res Function(_IdRenewalState) _then) = __$IdRenewalStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int currentStep, String? applicationId, String? applicationStatus, String? serviceType, ApplicantInfo? applicant, Uint8List? facePhoto, Map<int, FingerprintPrint> fingerprints, Set<int> disabledFingers, Uint8List? signature, String? phone, bool isSubmitted, Failure? error
});




}
/// @nodoc
class __$IdRenewalStateCopyWithImpl<$Res>
    implements _$IdRenewalStateCopyWith<$Res> {
  __$IdRenewalStateCopyWithImpl(this._self, this._then);

  final _IdRenewalState _self;
  final $Res Function(_IdRenewalState) _then;

/// Create a copy of IdRenewalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? currentStep = null,Object? applicationId = freezed,Object? applicationStatus = freezed,Object? serviceType = freezed,Object? applicant = freezed,Object? facePhoto = freezed,Object? fingerprints = null,Object? disabledFingers = null,Object? signature = freezed,Object? phone = freezed,Object? isSubmitted = null,Object? error = freezed,}) {
  return _then(_IdRenewalState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,applicationId: freezed == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String?,applicationStatus: freezed == applicationStatus ? _self.applicationStatus : applicationStatus // ignore: cast_nullable_to_non_nullable
as String?,serviceType: freezed == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String?,applicant: freezed == applicant ? _self.applicant : applicant // ignore: cast_nullable_to_non_nullable
as ApplicantInfo?,facePhoto: freezed == facePhoto ? _self.facePhoto : facePhoto // ignore: cast_nullable_to_non_nullable
as Uint8List?,fingerprints: null == fingerprints ? _self._fingerprints : fingerprints // ignore: cast_nullable_to_non_nullable
as Map<int, FingerprintPrint>,disabledFingers: null == disabledFingers ? _self._disabledFingers : disabledFingers // ignore: cast_nullable_to_non_nullable
as Set<int>,signature: freezed == signature ? _self.signature : signature // ignore: cast_nullable_to_non_nullable
as Uint8List?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isSubmitted: null == isSubmitted ? _self.isSubmitted : isSubmitted // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
