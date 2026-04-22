// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfileTableTable extends ProfileTable
    with TableInfo<$ProfileTableTable, ProfileTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _initialsMeta =
      const VerificationMeta('initials');
  @override
  late final GeneratedColumn<String> initials = GeneratedColumn<String>(
      'initials', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
      'dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastWriterDeviceIdMeta =
      const VerificationMeta('lastWriterDeviceId');
  @override
  late final GeneratedColumn<String> lastWriterDeviceId =
      GeneratedColumn<String>('last_writer_device_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        initials,
        age,
        gender,
        accountId,
        updatedAt,
        deletedAt,
        dirty,
        lastWriterDeviceId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_table';
  @override
  VerificationContext validateIntegrity(Insertable<ProfileTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('initials')) {
      context.handle(_initialsMeta,
          initials.isAcceptableOrUnknown(data['initials']!, _initialsMeta));
    } else if (isInserting) {
      context.missing(_initialsMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('dirty')) {
      context.handle(
          _dirtyMeta, dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta));
    }
    if (data.containsKey('last_writer_device_id')) {
      context.handle(
          _lastWriterDeviceIdMeta,
          lastWriterDeviceId.isAcceptableOrUnknown(
              data['last_writer_device_id']!, _lastWriterDeviceIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      initials: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}initials'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      dirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dirty'])!,
      lastWriterDeviceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_writer_device_id']),
    );
  }

  @override
  $ProfileTableTable createAlias(String alias) {
    return $ProfileTableTable(attachedDatabase, alias);
  }
}

class ProfileTableData extends DataClass
    implements Insertable<ProfileTableData> {
  final String id;
  final String name;
  final String initials;
  final int? age;
  final String? gender;
  final String? accountId;
  final int updatedAt;
  final int? deletedAt;
  final bool dirty;
  final String? lastWriterDeviceId;
  const ProfileTableData(
      {required this.id,
      required this.name,
      required this.initials,
      this.age,
      this.gender,
      this.accountId,
      required this.updatedAt,
      this.deletedAt,
      required this.dirty,
      this.lastWriterDeviceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['initials'] = Variable<String>(initials);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || lastWriterDeviceId != null) {
      map['last_writer_device_id'] = Variable<String>(lastWriterDeviceId);
    }
    return map;
  }

  ProfileTableCompanion toCompanion(bool nullToAbsent) {
    return ProfileTableCompanion(
      id: Value(id),
      name: Value(name),
      initials: Value(initials),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
      lastWriterDeviceId: lastWriterDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastWriterDeviceId),
    );
  }

  factory ProfileTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      initials: serializer.fromJson<String>(json['initials']),
      age: serializer.fromJson<int?>(json['age']),
      gender: serializer.fromJson<String?>(json['gender']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      lastWriterDeviceId:
          serializer.fromJson<String?>(json['lastWriterDeviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'initials': serializer.toJson<String>(initials),
      'age': serializer.toJson<int?>(age),
      'gender': serializer.toJson<String?>(gender),
      'accountId': serializer.toJson<String?>(accountId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'lastWriterDeviceId': serializer.toJson<String?>(lastWriterDeviceId),
    };
  }

  ProfileTableData copyWith(
          {String? id,
          String? name,
          String? initials,
          Value<int?> age = const Value.absent(),
          Value<String?> gender = const Value.absent(),
          Value<String?> accountId = const Value.absent(),
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          bool? dirty,
          Value<String?> lastWriterDeviceId = const Value.absent()}) =>
      ProfileTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        initials: initials ?? this.initials,
        age: age.present ? age.value : this.age,
        gender: gender.present ? gender.value : this.gender,
        accountId: accountId.present ? accountId.value : this.accountId,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        dirty: dirty ?? this.dirty,
        lastWriterDeviceId: lastWriterDeviceId.present
            ? lastWriterDeviceId.value
            : this.lastWriterDeviceId,
      );
  ProfileTableData copyWithCompanion(ProfileTableCompanion data) {
    return ProfileTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      initials: data.initials.present ? data.initials.value : this.initials,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      lastWriterDeviceId: data.lastWriterDeviceId.present
          ? data.lastWriterDeviceId.value
          : this.lastWriterDeviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('initials: $initials, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('accountId: $accountId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('lastWriterDeviceId: $lastWriterDeviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, initials, age, gender, accountId,
      updatedAt, deletedAt, dirty, lastWriterDeviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.initials == this.initials &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.accountId == this.accountId &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty &&
          other.lastWriterDeviceId == this.lastWriterDeviceId);
}

class ProfileTableCompanion extends UpdateCompanion<ProfileTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> initials;
  final Value<int?> age;
  final Value<String?> gender;
  final Value<String?> accountId;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<bool> dirty;
  final Value<String?> lastWriterDeviceId;
  final Value<int> rowid;
  const ProfileTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.initials = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.accountId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.lastWriterDeviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfileTableCompanion.insert({
    required String id,
    required String name,
    required String initials,
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.accountId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.lastWriterDeviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        initials = Value(initials);
  static Insertable<ProfileTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? initials,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? accountId,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<bool>? dirty,
    Expression<String>? lastWriterDeviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (initials != null) 'initials': initials,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (accountId != null) 'account_id': accountId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (lastWriterDeviceId != null)
        'last_writer_device_id': lastWriterDeviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfileTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? initials,
      Value<int?>? age,
      Value<String?>? gender,
      Value<String?>? accountId,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<bool>? dirty,
      Value<String?>? lastWriterDeviceId,
      Value<int>? rowid}) {
    return ProfileTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      accountId: accountId ?? this.accountId,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      lastWriterDeviceId: lastWriterDeviceId ?? this.lastWriterDeviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (initials.present) {
      map['initials'] = Variable<String>(initials.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (lastWriterDeviceId.present) {
      map['last_writer_device_id'] = Variable<String>(lastWriterDeviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('initials: $initials, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('accountId: $accountId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('lastWriterDeviceId: $lastWriterDeviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicineTableTable extends MedicineTable
    with TableInfo<$MedicineTableTable, MedicineTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES profile_table (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleMeta =
      const VerificationMeta('schedule');
  @override
  late final GeneratedColumn<String> schedule = GeneratedColumn<String>(
      'schedule', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stockRemainingMeta =
      const VerificationMeta('stockRemaining');
  @override
  late final GeneratedColumn<int> stockRemaining = GeneratedColumn<int>(
      'stock_remaining', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stockTotalMeta =
      const VerificationMeta('stockTotal');
  @override
  late final GeneratedColumn<int> stockTotal = GeneratedColumn<int>(
      'stock_total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _daysLeftMeta =
      const VerificationMeta('daysLeft');
  @override
  late final GeneratedColumn<int> daysLeft = GeneratedColumn<int>(
      'days_left', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isLowStockMeta =
      const VerificationMeta('isLowStock');
  @override
  late final GeneratedColumn<bool> isLowStock = GeneratedColumn<bool>(
      'is_low_stock', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_low_stock" IN (0, 1))'));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _strengthMeta =
      const VerificationMeta('strength');
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
      'strength', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderTimesMeta =
      const VerificationMeta('reminderTimes');
  @override
  late final GeneratedColumn<String> reminderTimes = GeneratedColumn<String>(
      'reminder_times', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _durationDaysMeta =
      const VerificationMeta('durationDays');
  @override
  late final GeneratedColumn<int> durationDays = GeneratedColumn<int>(
      'duration_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
      'dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastWriterDeviceIdMeta =
      const VerificationMeta('lastWriterDeviceId');
  @override
  late final GeneratedColumn<String> lastWriterDeviceId =
      GeneratedColumn<String>('last_writer_device_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        name,
        type,
        schedule,
        stockRemaining,
        stockTotal,
        daysLeft,
        isLowStock,
        imagePath,
        amount,
        strength,
        unit,
        reminderTimes,
        startDate,
        durationDays,
        accountId,
        updatedAt,
        deletedAt,
        dirty,
        lastWriterDeviceId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_table';
  @override
  VerificationContext validateIntegrity(Insertable<MedicineTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('schedule')) {
      context.handle(_scheduleMeta,
          schedule.isAcceptableOrUnknown(data['schedule']!, _scheduleMeta));
    } else if (isInserting) {
      context.missing(_scheduleMeta);
    }
    if (data.containsKey('stock_remaining')) {
      context.handle(
          _stockRemainingMeta,
          stockRemaining.isAcceptableOrUnknown(
              data['stock_remaining']!, _stockRemainingMeta));
    } else if (isInserting) {
      context.missing(_stockRemainingMeta);
    }
    if (data.containsKey('stock_total')) {
      context.handle(
          _stockTotalMeta,
          stockTotal.isAcceptableOrUnknown(
              data['stock_total']!, _stockTotalMeta));
    } else if (isInserting) {
      context.missing(_stockTotalMeta);
    }
    if (data.containsKey('days_left')) {
      context.handle(_daysLeftMeta,
          daysLeft.isAcceptableOrUnknown(data['days_left']!, _daysLeftMeta));
    } else if (isInserting) {
      context.missing(_daysLeftMeta);
    }
    if (data.containsKey('is_low_stock')) {
      context.handle(
          _isLowStockMeta,
          isLowStock.isAcceptableOrUnknown(
              data['is_low_stock']!, _isLowStockMeta));
    } else if (isInserting) {
      context.missing(_isLowStockMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('strength')) {
      context.handle(_strengthMeta,
          strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('reminder_times')) {
      context.handle(
          _reminderTimesMeta,
          reminderTimes.isAcceptableOrUnknown(
              data['reminder_times']!, _reminderTimesMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('duration_days')) {
      context.handle(
          _durationDaysMeta,
          durationDays.isAcceptableOrUnknown(
              data['duration_days']!, _durationDaysMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('dirty')) {
      context.handle(
          _dirtyMeta, dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta));
    }
    if (data.containsKey('last_writer_device_id')) {
      context.handle(
          _lastWriterDeviceIdMeta,
          lastWriterDeviceId.isAcceptableOrUnknown(
              data['last_writer_device_id']!, _lastWriterDeviceIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      schedule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule'])!,
      stockRemaining: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_remaining'])!,
      stockTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_total'])!,
      daysLeft: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days_left'])!,
      isLowStock: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_low_stock'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      strength: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strength']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      reminderTimes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_times']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      durationDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_days']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      dirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dirty'])!,
      lastWriterDeviceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_writer_device_id']),
    );
  }

  @override
  $MedicineTableTable createAlias(String alias) {
    return $MedicineTableTable(attachedDatabase, alias);
  }
}

class MedicineTableData extends DataClass
    implements Insertable<MedicineTableData> {
  final String id;
  final String? profileId;
  final String name;
  final String type;
  final String schedule;
  final int stockRemaining;
  final int stockTotal;
  final int daysLeft;
  final bool isLowStock;
  final String? imagePath;
  final double amount;
  final String? strength;
  final String? unit;
  final String? reminderTimes;
  final DateTime? startDate;
  final int? durationDays;
  final String? accountId;
  final int updatedAt;
  final int? deletedAt;
  final bool dirty;
  final String? lastWriterDeviceId;
  const MedicineTableData(
      {required this.id,
      this.profileId,
      required this.name,
      required this.type,
      required this.schedule,
      required this.stockRemaining,
      required this.stockTotal,
      required this.daysLeft,
      required this.isLowStock,
      this.imagePath,
      required this.amount,
      this.strength,
      this.unit,
      this.reminderTimes,
      this.startDate,
      this.durationDays,
      this.accountId,
      required this.updatedAt,
      this.deletedAt,
      required this.dirty,
      this.lastWriterDeviceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['schedule'] = Variable<String>(schedule);
    map['stock_remaining'] = Variable<int>(stockRemaining);
    map['stock_total'] = Variable<int>(stockTotal);
    map['days_left'] = Variable<int>(daysLeft);
    map['is_low_stock'] = Variable<bool>(isLowStock);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<String>(strength);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || reminderTimes != null) {
      map['reminder_times'] = Variable<String>(reminderTimes);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || durationDays != null) {
      map['duration_days'] = Variable<int>(durationDays);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || lastWriterDeviceId != null) {
      map['last_writer_device_id'] = Variable<String>(lastWriterDeviceId);
    }
    return map;
  }

  MedicineTableCompanion toCompanion(bool nullToAbsent) {
    return MedicineTableCompanion(
      id: Value(id),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      name: Value(name),
      type: Value(type),
      schedule: Value(schedule),
      stockRemaining: Value(stockRemaining),
      stockTotal: Value(stockTotal),
      daysLeft: Value(daysLeft),
      isLowStock: Value(isLowStock),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      amount: Value(amount),
      strength: strength == null && nullToAbsent
          ? const Value.absent()
          : Value(strength),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      reminderTimes: reminderTimes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTimes),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      durationDays: durationDays == null && nullToAbsent
          ? const Value.absent()
          : Value(durationDays),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
      lastWriterDeviceId: lastWriterDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastWriterDeviceId),
    );
  }

  factory MedicineTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineTableData(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String?>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      schedule: serializer.fromJson<String>(json['schedule']),
      stockRemaining: serializer.fromJson<int>(json['stockRemaining']),
      stockTotal: serializer.fromJson<int>(json['stockTotal']),
      daysLeft: serializer.fromJson<int>(json['daysLeft']),
      isLowStock: serializer.fromJson<bool>(json['isLowStock']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      amount: serializer.fromJson<double>(json['amount']),
      strength: serializer.fromJson<String?>(json['strength']),
      unit: serializer.fromJson<String?>(json['unit']),
      reminderTimes: serializer.fromJson<String?>(json['reminderTimes']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      durationDays: serializer.fromJson<int?>(json['durationDays']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      lastWriterDeviceId:
          serializer.fromJson<String?>(json['lastWriterDeviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String?>(profileId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'schedule': serializer.toJson<String>(schedule),
      'stockRemaining': serializer.toJson<int>(stockRemaining),
      'stockTotal': serializer.toJson<int>(stockTotal),
      'daysLeft': serializer.toJson<int>(daysLeft),
      'isLowStock': serializer.toJson<bool>(isLowStock),
      'imagePath': serializer.toJson<String?>(imagePath),
      'amount': serializer.toJson<double>(amount),
      'strength': serializer.toJson<String?>(strength),
      'unit': serializer.toJson<String?>(unit),
      'reminderTimes': serializer.toJson<String?>(reminderTimes),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'durationDays': serializer.toJson<int?>(durationDays),
      'accountId': serializer.toJson<String?>(accountId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'lastWriterDeviceId': serializer.toJson<String?>(lastWriterDeviceId),
    };
  }

  MedicineTableData copyWith(
          {String? id,
          Value<String?> profileId = const Value.absent(),
          String? name,
          String? type,
          String? schedule,
          int? stockRemaining,
          int? stockTotal,
          int? daysLeft,
          bool? isLowStock,
          Value<String?> imagePath = const Value.absent(),
          double? amount,
          Value<String?> strength = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> reminderTimes = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          Value<int?> durationDays = const Value.absent(),
          Value<String?> accountId = const Value.absent(),
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          bool? dirty,
          Value<String?> lastWriterDeviceId = const Value.absent()}) =>
      MedicineTableData(
        id: id ?? this.id,
        profileId: profileId.present ? profileId.value : this.profileId,
        name: name ?? this.name,
        type: type ?? this.type,
        schedule: schedule ?? this.schedule,
        stockRemaining: stockRemaining ?? this.stockRemaining,
        stockTotal: stockTotal ?? this.stockTotal,
        daysLeft: daysLeft ?? this.daysLeft,
        isLowStock: isLowStock ?? this.isLowStock,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        amount: amount ?? this.amount,
        strength: strength.present ? strength.value : this.strength,
        unit: unit.present ? unit.value : this.unit,
        reminderTimes:
            reminderTimes.present ? reminderTimes.value : this.reminderTimes,
        startDate: startDate.present ? startDate.value : this.startDate,
        durationDays:
            durationDays.present ? durationDays.value : this.durationDays,
        accountId: accountId.present ? accountId.value : this.accountId,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        dirty: dirty ?? this.dirty,
        lastWriterDeviceId: lastWriterDeviceId.present
            ? lastWriterDeviceId.value
            : this.lastWriterDeviceId,
      );
  MedicineTableData copyWithCompanion(MedicineTableCompanion data) {
    return MedicineTableData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      schedule: data.schedule.present ? data.schedule.value : this.schedule,
      stockRemaining: data.stockRemaining.present
          ? data.stockRemaining.value
          : this.stockRemaining,
      stockTotal:
          data.stockTotal.present ? data.stockTotal.value : this.stockTotal,
      daysLeft: data.daysLeft.present ? data.daysLeft.value : this.daysLeft,
      isLowStock:
          data.isLowStock.present ? data.isLowStock.value : this.isLowStock,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      amount: data.amount.present ? data.amount.value : this.amount,
      strength: data.strength.present ? data.strength.value : this.strength,
      unit: data.unit.present ? data.unit.value : this.unit,
      reminderTimes: data.reminderTimes.present
          ? data.reminderTimes.value
          : this.reminderTimes,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      durationDays: data.durationDays.present
          ? data.durationDays.value
          : this.durationDays,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      lastWriterDeviceId: data.lastWriterDeviceId.present
          ? data.lastWriterDeviceId.value
          : this.lastWriterDeviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineTableData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('schedule: $schedule, ')
          ..write('stockRemaining: $stockRemaining, ')
          ..write('stockTotal: $stockTotal, ')
          ..write('daysLeft: $daysLeft, ')
          ..write('isLowStock: $isLowStock, ')
          ..write('imagePath: $imagePath, ')
          ..write('amount: $amount, ')
          ..write('strength: $strength, ')
          ..write('unit: $unit, ')
          ..write('reminderTimes: $reminderTimes, ')
          ..write('startDate: $startDate, ')
          ..write('durationDays: $durationDays, ')
          ..write('accountId: $accountId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('lastWriterDeviceId: $lastWriterDeviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        profileId,
        name,
        type,
        schedule,
        stockRemaining,
        stockTotal,
        daysLeft,
        isLowStock,
        imagePath,
        amount,
        strength,
        unit,
        reminderTimes,
        startDate,
        durationDays,
        accountId,
        updatedAt,
        deletedAt,
        dirty,
        lastWriterDeviceId
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineTableData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.type == this.type &&
          other.schedule == this.schedule &&
          other.stockRemaining == this.stockRemaining &&
          other.stockTotal == this.stockTotal &&
          other.daysLeft == this.daysLeft &&
          other.isLowStock == this.isLowStock &&
          other.imagePath == this.imagePath &&
          other.amount == this.amount &&
          other.strength == this.strength &&
          other.unit == this.unit &&
          other.reminderTimes == this.reminderTimes &&
          other.startDate == this.startDate &&
          other.durationDays == this.durationDays &&
          other.accountId == this.accountId &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty &&
          other.lastWriterDeviceId == this.lastWriterDeviceId);
}

class MedicineTableCompanion extends UpdateCompanion<MedicineTableData> {
  final Value<String> id;
  final Value<String?> profileId;
  final Value<String> name;
  final Value<String> type;
  final Value<String> schedule;
  final Value<int> stockRemaining;
  final Value<int> stockTotal;
  final Value<int> daysLeft;
  final Value<bool> isLowStock;
  final Value<String?> imagePath;
  final Value<double> amount;
  final Value<String?> strength;
  final Value<String?> unit;
  final Value<String?> reminderTimes;
  final Value<DateTime?> startDate;
  final Value<int?> durationDays;
  final Value<String?> accountId;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<bool> dirty;
  final Value<String?> lastWriterDeviceId;
  final Value<int> rowid;
  const MedicineTableCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.schedule = const Value.absent(),
    this.stockRemaining = const Value.absent(),
    this.stockTotal = const Value.absent(),
    this.daysLeft = const Value.absent(),
    this.isLowStock = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.amount = const Value.absent(),
    this.strength = const Value.absent(),
    this.unit = const Value.absent(),
    this.reminderTimes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.durationDays = const Value.absent(),
    this.accountId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.lastWriterDeviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicineTableCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String name,
    required String type,
    required String schedule,
    required int stockRemaining,
    required int stockTotal,
    required int daysLeft,
    required bool isLowStock,
    this.imagePath = const Value.absent(),
    this.amount = const Value.absent(),
    this.strength = const Value.absent(),
    this.unit = const Value.absent(),
    this.reminderTimes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.durationDays = const Value.absent(),
    this.accountId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.lastWriterDeviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        schedule = Value(schedule),
        stockRemaining = Value(stockRemaining),
        stockTotal = Value(stockTotal),
        daysLeft = Value(daysLeft),
        isLowStock = Value(isLowStock);
  static Insertable<MedicineTableData> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? schedule,
    Expression<int>? stockRemaining,
    Expression<int>? stockTotal,
    Expression<int>? daysLeft,
    Expression<bool>? isLowStock,
    Expression<String>? imagePath,
    Expression<double>? amount,
    Expression<String>? strength,
    Expression<String>? unit,
    Expression<String>? reminderTimes,
    Expression<DateTime>? startDate,
    Expression<int>? durationDays,
    Expression<String>? accountId,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<bool>? dirty,
    Expression<String>? lastWriterDeviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (schedule != null) 'schedule': schedule,
      if (stockRemaining != null) 'stock_remaining': stockRemaining,
      if (stockTotal != null) 'stock_total': stockTotal,
      if (daysLeft != null) 'days_left': daysLeft,
      if (isLowStock != null) 'is_low_stock': isLowStock,
      if (imagePath != null) 'image_path': imagePath,
      if (amount != null) 'amount': amount,
      if (strength != null) 'strength': strength,
      if (unit != null) 'unit': unit,
      if (reminderTimes != null) 'reminder_times': reminderTimes,
      if (startDate != null) 'start_date': startDate,
      if (durationDays != null) 'duration_days': durationDays,
      if (accountId != null) 'account_id': accountId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (lastWriterDeviceId != null)
        'last_writer_device_id': lastWriterDeviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicineTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? profileId,
      Value<String>? name,
      Value<String>? type,
      Value<String>? schedule,
      Value<int>? stockRemaining,
      Value<int>? stockTotal,
      Value<int>? daysLeft,
      Value<bool>? isLowStock,
      Value<String?>? imagePath,
      Value<double>? amount,
      Value<String?>? strength,
      Value<String?>? unit,
      Value<String?>? reminderTimes,
      Value<DateTime?>? startDate,
      Value<int?>? durationDays,
      Value<String?>? accountId,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<bool>? dirty,
      Value<String?>? lastWriterDeviceId,
      Value<int>? rowid}) {
    return MedicineTableCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      type: type ?? this.type,
      schedule: schedule ?? this.schedule,
      stockRemaining: stockRemaining ?? this.stockRemaining,
      stockTotal: stockTotal ?? this.stockTotal,
      daysLeft: daysLeft ?? this.daysLeft,
      isLowStock: isLowStock ?? this.isLowStock,
      imagePath: imagePath ?? this.imagePath,
      amount: amount ?? this.amount,
      strength: strength ?? this.strength,
      unit: unit ?? this.unit,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      startDate: startDate ?? this.startDate,
      durationDays: durationDays ?? this.durationDays,
      accountId: accountId ?? this.accountId,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      lastWriterDeviceId: lastWriterDeviceId ?? this.lastWriterDeviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (schedule.present) {
      map['schedule'] = Variable<String>(schedule.value);
    }
    if (stockRemaining.present) {
      map['stock_remaining'] = Variable<int>(stockRemaining.value);
    }
    if (stockTotal.present) {
      map['stock_total'] = Variable<int>(stockTotal.value);
    }
    if (daysLeft.present) {
      map['days_left'] = Variable<int>(daysLeft.value);
    }
    if (isLowStock.present) {
      map['is_low_stock'] = Variable<bool>(isLowStock.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (reminderTimes.present) {
      map['reminder_times'] = Variable<String>(reminderTimes.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (durationDays.present) {
      map['duration_days'] = Variable<int>(durationDays.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (lastWriterDeviceId.present) {
      map['last_writer_device_id'] = Variable<String>(lastWriterDeviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineTableCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('schedule: $schedule, ')
          ..write('stockRemaining: $stockRemaining, ')
          ..write('stockTotal: $stockTotal, ')
          ..write('daysLeft: $daysLeft, ')
          ..write('isLowStock: $isLowStock, ')
          ..write('imagePath: $imagePath, ')
          ..write('amount: $amount, ')
          ..write('strength: $strength, ')
          ..write('unit: $unit, ')
          ..write('reminderTimes: $reminderTimes, ')
          ..write('startDate: $startDate, ')
          ..write('durationDays: $durationDays, ')
          ..write('accountId: $accountId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('lastWriterDeviceId: $lastWriterDeviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseLogTableTable extends DoseLogTable
    with TableInfo<$DoseLogTableTable, DoseLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicineIdMeta =
      const VerificationMeta('medicineId');
  @override
  late final GeneratedColumn<String> medicineId = GeneratedColumn<String>(
      'medicine_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES medicine_table (id)'));
  static const VerificationMeta _medicineNameMeta =
      const VerificationMeta('medicineName');
  @override
  late final GeneratedColumn<String> medicineName = GeneratedColumn<String>(
      'medicine_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _logDateTimeMeta =
      const VerificationMeta('logDateTime');
  @override
  late final GeneratedColumn<DateTime> logDateTime = GeneratedColumn<DateTime>(
      'log_date_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduledDateTimeMeta =
      const VerificationMeta('scheduledDateTime');
  @override
  late final GeneratedColumn<DateTime> scheduledDateTime =
      GeneratedColumn<DateTime>('scheduled_date_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
      'dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastWriterDeviceIdMeta =
      const VerificationMeta('lastWriterDeviceId');
  @override
  late final GeneratedColumn<String> lastWriterDeviceId =
      GeneratedColumn<String>('last_writer_device_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicineId,
        medicineName,
        logDateTime,
        status,
        note,
        scheduledDateTime,
        accountId,
        profileId,
        updatedAt,
        deletedAt,
        dirty,
        lastWriterDeviceId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_log_table';
  @override
  VerificationContext validateIntegrity(Insertable<DoseLogTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
          _medicineIdMeta,
          medicineId.isAcceptableOrUnknown(
              data['medicine_id']!, _medicineIdMeta));
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('medicine_name')) {
      context.handle(
          _medicineNameMeta,
          medicineName.isAcceptableOrUnknown(
              data['medicine_name']!, _medicineNameMeta));
    } else if (isInserting) {
      context.missing(_medicineNameMeta);
    }
    if (data.containsKey('log_date_time')) {
      context.handle(
          _logDateTimeMeta,
          logDateTime.isAcceptableOrUnknown(
              data['log_date_time']!, _logDateTimeMeta));
    } else if (isInserting) {
      context.missing(_logDateTimeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('scheduled_date_time')) {
      context.handle(
          _scheduledDateTimeMeta,
          scheduledDateTime.isAcceptableOrUnknown(
              data['scheduled_date_time']!, _scheduledDateTimeMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('dirty')) {
      context.handle(
          _dirtyMeta, dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta));
    }
    if (data.containsKey('last_writer_device_id')) {
      context.handle(
          _lastWriterDeviceIdMeta,
          lastWriterDeviceId.isAcceptableOrUnknown(
              data['last_writer_device_id']!, _lastWriterDeviceIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoseLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseLogTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicine_id'])!,
      medicineName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicine_name'])!,
      logDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}log_date_time'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      scheduledDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_date_time']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      dirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dirty'])!,
      lastWriterDeviceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_writer_device_id']),
    );
  }

  @override
  $DoseLogTableTable createAlias(String alias) {
    return $DoseLogTableTable(attachedDatabase, alias);
  }
}

class DoseLogTableData extends DataClass
    implements Insertable<DoseLogTableData> {
  final String id;
  final String medicineId;
  final String medicineName;
  final DateTime logDateTime;
  final int status;
  final String? note;
  final DateTime? scheduledDateTime;
  final String? accountId;
  final String? profileId;
  final int updatedAt;
  final int? deletedAt;
  final bool dirty;
  final String? lastWriterDeviceId;
  const DoseLogTableData(
      {required this.id,
      required this.medicineId,
      required this.medicineName,
      required this.logDateTime,
      required this.status,
      this.note,
      this.scheduledDateTime,
      this.accountId,
      this.profileId,
      required this.updatedAt,
      this.deletedAt,
      required this.dirty,
      this.lastWriterDeviceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medicine_id'] = Variable<String>(medicineId);
    map['medicine_name'] = Variable<String>(medicineName);
    map['log_date_time'] = Variable<DateTime>(logDateTime);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || scheduledDateTime != null) {
      map['scheduled_date_time'] = Variable<DateTime>(scheduledDateTime);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || lastWriterDeviceId != null) {
      map['last_writer_device_id'] = Variable<String>(lastWriterDeviceId);
    }
    return map;
  }

  DoseLogTableCompanion toCompanion(bool nullToAbsent) {
    return DoseLogTableCompanion(
      id: Value(id),
      medicineId: Value(medicineId),
      medicineName: Value(medicineName),
      logDateTime: Value(logDateTime),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      scheduledDateTime: scheduledDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledDateTime),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
      lastWriterDeviceId: lastWriterDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastWriterDeviceId),
    );
  }

  factory DoseLogTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseLogTableData(
      id: serializer.fromJson<String>(json['id']),
      medicineId: serializer.fromJson<String>(json['medicineId']),
      medicineName: serializer.fromJson<String>(json['medicineName']),
      logDateTime: serializer.fromJson<DateTime>(json['logDateTime']),
      status: serializer.fromJson<int>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
      scheduledDateTime:
          serializer.fromJson<DateTime?>(json['scheduledDateTime']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      profileId: serializer.fromJson<String?>(json['profileId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      lastWriterDeviceId:
          serializer.fromJson<String?>(json['lastWriterDeviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicineId': serializer.toJson<String>(medicineId),
      'medicineName': serializer.toJson<String>(medicineName),
      'logDateTime': serializer.toJson<DateTime>(logDateTime),
      'status': serializer.toJson<int>(status),
      'note': serializer.toJson<String?>(note),
      'scheduledDateTime': serializer.toJson<DateTime?>(scheduledDateTime),
      'accountId': serializer.toJson<String?>(accountId),
      'profileId': serializer.toJson<String?>(profileId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'lastWriterDeviceId': serializer.toJson<String?>(lastWriterDeviceId),
    };
  }

  DoseLogTableData copyWith(
          {String? id,
          String? medicineId,
          String? medicineName,
          DateTime? logDateTime,
          int? status,
          Value<String?> note = const Value.absent(),
          Value<DateTime?> scheduledDateTime = const Value.absent(),
          Value<String?> accountId = const Value.absent(),
          Value<String?> profileId = const Value.absent(),
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          bool? dirty,
          Value<String?> lastWriterDeviceId = const Value.absent()}) =>
      DoseLogTableData(
        id: id ?? this.id,
        medicineId: medicineId ?? this.medicineId,
        medicineName: medicineName ?? this.medicineName,
        logDateTime: logDateTime ?? this.logDateTime,
        status: status ?? this.status,
        note: note.present ? note.value : this.note,
        scheduledDateTime: scheduledDateTime.present
            ? scheduledDateTime.value
            : this.scheduledDateTime,
        accountId: accountId.present ? accountId.value : this.accountId,
        profileId: profileId.present ? profileId.value : this.profileId,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        dirty: dirty ?? this.dirty,
        lastWriterDeviceId: lastWriterDeviceId.present
            ? lastWriterDeviceId.value
            : this.lastWriterDeviceId,
      );
  DoseLogTableData copyWithCompanion(DoseLogTableCompanion data) {
    return DoseLogTableData(
      id: data.id.present ? data.id.value : this.id,
      medicineId:
          data.medicineId.present ? data.medicineId.value : this.medicineId,
      medicineName: data.medicineName.present
          ? data.medicineName.value
          : this.medicineName,
      logDateTime:
          data.logDateTime.present ? data.logDateTime.value : this.logDateTime,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      scheduledDateTime: data.scheduledDateTime.present
          ? data.scheduledDateTime.value
          : this.scheduledDateTime,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      lastWriterDeviceId: data.lastWriterDeviceId.present
          ? data.lastWriterDeviceId.value
          : this.lastWriterDeviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseLogTableData(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('medicineName: $medicineName, ')
          ..write('logDateTime: $logDateTime, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('scheduledDateTime: $scheduledDateTime, ')
          ..write('accountId: $accountId, ')
          ..write('profileId: $profileId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('lastWriterDeviceId: $lastWriterDeviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      medicineId,
      medicineName,
      logDateTime,
      status,
      note,
      scheduledDateTime,
      accountId,
      profileId,
      updatedAt,
      deletedAt,
      dirty,
      lastWriterDeviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseLogTableData &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.medicineName == this.medicineName &&
          other.logDateTime == this.logDateTime &&
          other.status == this.status &&
          other.note == this.note &&
          other.scheduledDateTime == this.scheduledDateTime &&
          other.accountId == this.accountId &&
          other.profileId == this.profileId &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty &&
          other.lastWriterDeviceId == this.lastWriterDeviceId);
}

class DoseLogTableCompanion extends UpdateCompanion<DoseLogTableData> {
  final Value<String> id;
  final Value<String> medicineId;
  final Value<String> medicineName;
  final Value<DateTime> logDateTime;
  final Value<int> status;
  final Value<String?> note;
  final Value<DateTime?> scheduledDateTime;
  final Value<String?> accountId;
  final Value<String?> profileId;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<bool> dirty;
  final Value<String?> lastWriterDeviceId;
  final Value<int> rowid;
  const DoseLogTableCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.medicineName = const Value.absent(),
    this.logDateTime = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.scheduledDateTime = const Value.absent(),
    this.accountId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.lastWriterDeviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseLogTableCompanion.insert({
    required String id,
    required String medicineId,
    required String medicineName,
    required DateTime logDateTime,
    required int status,
    this.note = const Value.absent(),
    this.scheduledDateTime = const Value.absent(),
    this.accountId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.lastWriterDeviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicineId = Value(medicineId),
        medicineName = Value(medicineName),
        logDateTime = Value(logDateTime),
        status = Value(status);
  static Insertable<DoseLogTableData> custom({
    Expression<String>? id,
    Expression<String>? medicineId,
    Expression<String>? medicineName,
    Expression<DateTime>? logDateTime,
    Expression<int>? status,
    Expression<String>? note,
    Expression<DateTime>? scheduledDateTime,
    Expression<String>? accountId,
    Expression<String>? profileId,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<bool>? dirty,
    Expression<String>? lastWriterDeviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (medicineName != null) 'medicine_name': medicineName,
      if (logDateTime != null) 'log_date_time': logDateTime,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (scheduledDateTime != null) 'scheduled_date_time': scheduledDateTime,
      if (accountId != null) 'account_id': accountId,
      if (profileId != null) 'profile_id': profileId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (lastWriterDeviceId != null)
        'last_writer_device_id': lastWriterDeviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseLogTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? medicineId,
      Value<String>? medicineName,
      Value<DateTime>? logDateTime,
      Value<int>? status,
      Value<String?>? note,
      Value<DateTime?>? scheduledDateTime,
      Value<String?>? accountId,
      Value<String?>? profileId,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<bool>? dirty,
      Value<String?>? lastWriterDeviceId,
      Value<int>? rowid}) {
    return DoseLogTableCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      logDateTime: logDateTime ?? this.logDateTime,
      status: status ?? this.status,
      note: note ?? this.note,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      accountId: accountId ?? this.accountId,
      profileId: profileId ?? this.profileId,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      lastWriterDeviceId: lastWriterDeviceId ?? this.lastWriterDeviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<String>(medicineId.value);
    }
    if (medicineName.present) {
      map['medicine_name'] = Variable<String>(medicineName.value);
    }
    if (logDateTime.present) {
      map['log_date_time'] = Variable<DateTime>(logDateTime.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (scheduledDateTime.present) {
      map['scheduled_date_time'] = Variable<DateTime>(scheduledDateTime.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (lastWriterDeviceId.present) {
      map['last_writer_device_id'] = Variable<String>(lastWriterDeviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseLogTableCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('medicineName: $medicineName, ')
          ..write('logDateTime: $logDateTime, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('scheduledDateTime: $scheduledDateTime, ')
          ..write('accountId: $accountId, ')
          ..write('profileId: $profileId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('lastWriterDeviceId: $lastWriterDeviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmergencyCardTableTable extends EmergencyCardTable
    with TableInfo<$EmergencyCardTableTable, EmergencyCardTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyCardTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('primary'));
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bloodTypeMeta =
      const VerificationMeta('bloodType');
  @override
  late final GeneratedColumn<String> bloodType = GeneratedColumn<String>(
      'blood_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _allergiesMeta =
      const VerificationMeta('allergies');
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
      'allergies', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conditionsMeta =
      const VerificationMeta('conditions');
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
      'conditions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emergencyContactNameMeta =
      const VerificationMeta('emergencyContactName');
  @override
  late final GeneratedColumn<String> emergencyContactName =
      GeneratedColumn<String>('emergency_contact_name', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emergencyContactPhoneMeta =
      const VerificationMeta('emergencyContactPhone');
  @override
  late final GeneratedColumn<String> emergencyContactPhone =
      GeneratedColumn<String>('emergency_contact_phone', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fullName,
        bloodType,
        allergies,
        conditions,
        emergencyContactName,
        emergencyContactPhone
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_card_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmergencyCardTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('blood_type')) {
      context.handle(_bloodTypeMeta,
          bloodType.isAcceptableOrUnknown(data['blood_type']!, _bloodTypeMeta));
    } else if (isInserting) {
      context.missing(_bloodTypeMeta);
    }
    if (data.containsKey('allergies')) {
      context.handle(_allergiesMeta,
          allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta));
    } else if (isInserting) {
      context.missing(_allergiesMeta);
    }
    if (data.containsKey('conditions')) {
      context.handle(
          _conditionsMeta,
          conditions.isAcceptableOrUnknown(
              data['conditions']!, _conditionsMeta));
    } else if (isInserting) {
      context.missing(_conditionsMeta);
    }
    if (data.containsKey('emergency_contact_name')) {
      context.handle(
          _emergencyContactNameMeta,
          emergencyContactName.isAcceptableOrUnknown(
              data['emergency_contact_name']!, _emergencyContactNameMeta));
    } else if (isInserting) {
      context.missing(_emergencyContactNameMeta);
    }
    if (data.containsKey('emergency_contact_phone')) {
      context.handle(
          _emergencyContactPhoneMeta,
          emergencyContactPhone.isAcceptableOrUnknown(
              data['emergency_contact_phone']!, _emergencyContactPhoneMeta));
    } else if (isInserting) {
      context.missing(_emergencyContactPhoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmergencyCardTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyCardTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      bloodType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blood_type'])!,
      allergies: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}allergies'])!,
      conditions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conditions'])!,
      emergencyContactName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}emergency_contact_name'])!,
      emergencyContactPhone: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}emergency_contact_phone'])!,
    );
  }

  @override
  $EmergencyCardTableTable createAlias(String alias) {
    return $EmergencyCardTableTable(attachedDatabase, alias);
  }
}

class EmergencyCardTableData extends DataClass
    implements Insertable<EmergencyCardTableData> {
  final String id;
  final String fullName;
  final String bloodType;
  final String allergies;
  final String conditions;
  final String emergencyContactName;
  final String emergencyContactPhone;
  const EmergencyCardTableData(
      {required this.id,
      required this.fullName,
      required this.bloodType,
      required this.allergies,
      required this.conditions,
      required this.emergencyContactName,
      required this.emergencyContactPhone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['blood_type'] = Variable<String>(bloodType);
    map['allergies'] = Variable<String>(allergies);
    map['conditions'] = Variable<String>(conditions);
    map['emergency_contact_name'] = Variable<String>(emergencyContactName);
    map['emergency_contact_phone'] = Variable<String>(emergencyContactPhone);
    return map;
  }

  EmergencyCardTableCompanion toCompanion(bool nullToAbsent) {
    return EmergencyCardTableCompanion(
      id: Value(id),
      fullName: Value(fullName),
      bloodType: Value(bloodType),
      allergies: Value(allergies),
      conditions: Value(conditions),
      emergencyContactName: Value(emergencyContactName),
      emergencyContactPhone: Value(emergencyContactPhone),
    );
  }

  factory EmergencyCardTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyCardTableData(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      bloodType: serializer.fromJson<String>(json['bloodType']),
      allergies: serializer.fromJson<String>(json['allergies']),
      conditions: serializer.fromJson<String>(json['conditions']),
      emergencyContactName:
          serializer.fromJson<String>(json['emergencyContactName']),
      emergencyContactPhone:
          serializer.fromJson<String>(json['emergencyContactPhone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'bloodType': serializer.toJson<String>(bloodType),
      'allergies': serializer.toJson<String>(allergies),
      'conditions': serializer.toJson<String>(conditions),
      'emergencyContactName': serializer.toJson<String>(emergencyContactName),
      'emergencyContactPhone': serializer.toJson<String>(emergencyContactPhone),
    };
  }

  EmergencyCardTableData copyWith(
          {String? id,
          String? fullName,
          String? bloodType,
          String? allergies,
          String? conditions,
          String? emergencyContactName,
          String? emergencyContactPhone}) =>
      EmergencyCardTableData(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        bloodType: bloodType ?? this.bloodType,
        allergies: allergies ?? this.allergies,
        conditions: conditions ?? this.conditions,
        emergencyContactName: emergencyContactName ?? this.emergencyContactName,
        emergencyContactPhone:
            emergencyContactPhone ?? this.emergencyContactPhone,
      );
  EmergencyCardTableData copyWithCompanion(EmergencyCardTableCompanion data) {
    return EmergencyCardTableData(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      bloodType: data.bloodType.present ? data.bloodType.value : this.bloodType,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      conditions:
          data.conditions.present ? data.conditions.value : this.conditions,
      emergencyContactName: data.emergencyContactName.present
          ? data.emergencyContactName.value
          : this.emergencyContactName,
      emergencyContactPhone: data.emergencyContactPhone.present
          ? data.emergencyContactPhone.value
          : this.emergencyContactPhone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyCardTableData(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('bloodType: $bloodType, ')
          ..write('allergies: $allergies, ')
          ..write('conditions: $conditions, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fullName, bloodType, allergies,
      conditions, emergencyContactName, emergencyContactPhone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyCardTableData &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.bloodType == this.bloodType &&
          other.allergies == this.allergies &&
          other.conditions == this.conditions &&
          other.emergencyContactName == this.emergencyContactName &&
          other.emergencyContactPhone == this.emergencyContactPhone);
}

class EmergencyCardTableCompanion
    extends UpdateCompanion<EmergencyCardTableData> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> bloodType;
  final Value<String> allergies;
  final Value<String> conditions;
  final Value<String> emergencyContactName;
  final Value<String> emergencyContactPhone;
  final Value<int> rowid;
  const EmergencyCardTableCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.allergies = const Value.absent(),
    this.conditions = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmergencyCardTableCompanion.insert({
    this.id = const Value.absent(),
    required String fullName,
    required String bloodType,
    required String allergies,
    required String conditions,
    required String emergencyContactName,
    required String emergencyContactPhone,
    this.rowid = const Value.absent(),
  })  : fullName = Value(fullName),
        bloodType = Value(bloodType),
        allergies = Value(allergies),
        conditions = Value(conditions),
        emergencyContactName = Value(emergencyContactName),
        emergencyContactPhone = Value(emergencyContactPhone);
  static Insertable<EmergencyCardTableData> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? bloodType,
    Expression<String>? allergies,
    Expression<String>? conditions,
    Expression<String>? emergencyContactName,
    Expression<String>? emergencyContactPhone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (bloodType != null) 'blood_type': bloodType,
      if (allergies != null) 'allergies': allergies,
      if (conditions != null) 'conditions': conditions,
      if (emergencyContactName != null)
        'emergency_contact_name': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergency_contact_phone': emergencyContactPhone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmergencyCardTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<String>? bloodType,
      Value<String>? allergies,
      Value<String>? conditions,
      Value<String>? emergencyContactName,
      Value<String>? emergencyContactPhone,
      Value<int>? rowid}) {
    return EmergencyCardTableCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      conditions: conditions ?? this.conditions,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (bloodType.present) {
      map['blood_type'] = Variable<String>(bloodType.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    if (emergencyContactName.present) {
      map['emergency_contact_name'] =
          Variable<String>(emergencyContactName.value);
    }
    if (emergencyContactPhone.present) {
      map['emergency_contact_phone'] =
          Variable<String>(emergencyContactPhone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyCardTableCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('bloodType: $bloodType, ')
          ..write('allergies: $allergies, ')
          ..write('conditions: $conditions, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrescriptionTableTable extends PrescriptionTable
    with TableInfo<$PrescriptionTableTable, PrescriptionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrescriptionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doctorNameMeta =
      const VerificationMeta('doctorName');
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
      'doctor_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _medicinesMeta =
      const VerificationMeta('medicines');
  @override
  late final GeneratedColumn<String> medicines = GeneratedColumn<String>(
      'medicines', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isScannedMeta =
      const VerificationMeta('isScanned');
  @override
  late final GeneratedColumn<bool> isScanned = GeneratedColumn<bool>(
      'is_scanned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_scanned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
      'dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastWriterDeviceIdMeta =
      const VerificationMeta('lastWriterDeviceId');
  @override
  late final GeneratedColumn<String> lastWriterDeviceId =
      GeneratedColumn<String>('last_writer_device_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        doctorName,
        date,
        reason,
        imageUrl,
        medicines,
        isScanned,
        accountId,
        profileId,
        updatedAt,
        deletedAt,
        dirty,
        lastWriterDeviceId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prescription_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PrescriptionTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
          _doctorNameMeta,
          doctorName.isAcceptableOrUnknown(
              data['doctor_name']!, _doctorNameMeta));
    } else if (isInserting) {
      context.missing(_doctorNameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('medicines')) {
      context.handle(_medicinesMeta,
          medicines.isAcceptableOrUnknown(data['medicines']!, _medicinesMeta));
    } else if (isInserting) {
      context.missing(_medicinesMeta);
    }
    if (data.containsKey('is_scanned')) {
      context.handle(_isScannedMeta,
          isScanned.isAcceptableOrUnknown(data['is_scanned']!, _isScannedMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('dirty')) {
      context.handle(
          _dirtyMeta, dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta));
    }
    if (data.containsKey('last_writer_device_id')) {
      context.handle(
          _lastWriterDeviceIdMeta,
          lastWriterDeviceId.isAcceptableOrUnknown(
              data['last_writer_device_id']!, _lastWriterDeviceIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrescriptionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrescriptionTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      doctorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}doctor_name'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      medicines: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicines'])!,
      isScanned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_scanned'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      dirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dirty'])!,
      lastWriterDeviceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_writer_device_id']),
    );
  }

  @override
  $PrescriptionTableTable createAlias(String alias) {
    return $PrescriptionTableTable(attachedDatabase, alias);
  }
}

class PrescriptionTableData extends DataClass
    implements Insertable<PrescriptionTableData> {
  final String id;
  final String doctorName;
  final DateTime date;
  final String reason;
  final String? imageUrl;
  final String medicines;
  final bool isScanned;
  final String? accountId;
  final String? profileId;
  final int updatedAt;
  final int? deletedAt;
  final bool dirty;
  final String? lastWriterDeviceId;
  const PrescriptionTableData(
      {required this.id,
      required this.doctorName,
      required this.date,
      required this.reason,
      this.imageUrl,
      required this.medicines,
      required this.isScanned,
      this.accountId,
      this.profileId,
      required this.updatedAt,
      this.deletedAt,
      required this.dirty,
      this.lastWriterDeviceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['doctor_name'] = Variable<String>(doctorName);
    map['date'] = Variable<DateTime>(date);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['medicines'] = Variable<String>(medicines);
    map['is_scanned'] = Variable<bool>(isScanned);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || lastWriterDeviceId != null) {
      map['last_writer_device_id'] = Variable<String>(lastWriterDeviceId);
    }
    return map;
  }

  PrescriptionTableCompanion toCompanion(bool nullToAbsent) {
    return PrescriptionTableCompanion(
      id: Value(id),
      doctorName: Value(doctorName),
      date: Value(date),
      reason: Value(reason),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      medicines: Value(medicines),
      isScanned: Value(isScanned),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
      lastWriterDeviceId: lastWriterDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastWriterDeviceId),
    );
  }

  factory PrescriptionTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrescriptionTableData(
      id: serializer.fromJson<String>(json['id']),
      doctorName: serializer.fromJson<String>(json['doctorName']),
      date: serializer.fromJson<DateTime>(json['date']),
      reason: serializer.fromJson<String>(json['reason']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      medicines: serializer.fromJson<String>(json['medicines']),
      isScanned: serializer.fromJson<bool>(json['isScanned']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      profileId: serializer.fromJson<String?>(json['profileId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      lastWriterDeviceId:
          serializer.fromJson<String?>(json['lastWriterDeviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'doctorName': serializer.toJson<String>(doctorName),
      'date': serializer.toJson<DateTime>(date),
      'reason': serializer.toJson<String>(reason),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'medicines': serializer.toJson<String>(medicines),
      'isScanned': serializer.toJson<bool>(isScanned),
      'accountId': serializer.toJson<String?>(accountId),
      'profileId': serializer.toJson<String?>(profileId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'lastWriterDeviceId': serializer.toJson<String?>(lastWriterDeviceId),
    };
  }

  PrescriptionTableData copyWith(
          {String? id,
          String? doctorName,
          DateTime? date,
          String? reason,
          Value<String?> imageUrl = const Value.absent(),
          String? medicines,
          bool? isScanned,
          Value<String?> accountId = const Value.absent(),
          Value<String?> profileId = const Value.absent(),
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          bool? dirty,
          Value<String?> lastWriterDeviceId = const Value.absent()}) =>
      PrescriptionTableData(
        id: id ?? this.id,
        doctorName: doctorName ?? this.doctorName,
        date: date ?? this.date,
        reason: reason ?? this.reason,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        medicines: medicines ?? this.medicines,
        isScanned: isScanned ?? this.isScanned,
        accountId: accountId.present ? accountId.value : this.accountId,
        profileId: profileId.present ? profileId.value : this.profileId,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        dirty: dirty ?? this.dirty,
        lastWriterDeviceId: lastWriterDeviceId.present
            ? lastWriterDeviceId.value
            : this.lastWriterDeviceId,
      );
  PrescriptionTableData copyWithCompanion(PrescriptionTableCompanion data) {
    return PrescriptionTableData(
      id: data.id.present ? data.id.value : this.id,
      doctorName:
          data.doctorName.present ? data.doctorName.value : this.doctorName,
      date: data.date.present ? data.date.value : this.date,
      reason: data.reason.present ? data.reason.value : this.reason,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      medicines: data.medicines.present ? data.medicines.value : this.medicines,
      isScanned: data.isScanned.present ? data.isScanned.value : this.isScanned,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      lastWriterDeviceId: data.lastWriterDeviceId.present
          ? data.lastWriterDeviceId.value
          : this.lastWriterDeviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionTableData(')
          ..write('id: $id, ')
          ..write('doctorName: $doctorName, ')
          ..write('date: $date, ')
          ..write('reason: $reason, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('medicines: $medicines, ')
          ..write('isScanned: $isScanned, ')
          ..write('accountId: $accountId, ')
          ..write('profileId: $profileId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('lastWriterDeviceId: $lastWriterDeviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      doctorName,
      date,
      reason,
      imageUrl,
      medicines,
      isScanned,
      accountId,
      profileId,
      updatedAt,
      deletedAt,
      dirty,
      lastWriterDeviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrescriptionTableData &&
          other.id == this.id &&
          other.doctorName == this.doctorName &&
          other.date == this.date &&
          other.reason == this.reason &&
          other.imageUrl == this.imageUrl &&
          other.medicines == this.medicines &&
          other.isScanned == this.isScanned &&
          other.accountId == this.accountId &&
          other.profileId == this.profileId &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty &&
          other.lastWriterDeviceId == this.lastWriterDeviceId);
}

class PrescriptionTableCompanion
    extends UpdateCompanion<PrescriptionTableData> {
  final Value<String> id;
  final Value<String> doctorName;
  final Value<DateTime> date;
  final Value<String> reason;
  final Value<String?> imageUrl;
  final Value<String> medicines;
  final Value<bool> isScanned;
  final Value<String?> accountId;
  final Value<String?> profileId;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<bool> dirty;
  final Value<String?> lastWriterDeviceId;
  final Value<int> rowid;
  const PrescriptionTableCompanion({
    this.id = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.date = const Value.absent(),
    this.reason = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.medicines = const Value.absent(),
    this.isScanned = const Value.absent(),
    this.accountId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.lastWriterDeviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrescriptionTableCompanion.insert({
    required String id,
    required String doctorName,
    required DateTime date,
    required String reason,
    this.imageUrl = const Value.absent(),
    required String medicines,
    this.isScanned = const Value.absent(),
    this.accountId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.lastWriterDeviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        doctorName = Value(doctorName),
        date = Value(date),
        reason = Value(reason),
        medicines = Value(medicines);
  static Insertable<PrescriptionTableData> custom({
    Expression<String>? id,
    Expression<String>? doctorName,
    Expression<DateTime>? date,
    Expression<String>? reason,
    Expression<String>? imageUrl,
    Expression<String>? medicines,
    Expression<bool>? isScanned,
    Expression<String>? accountId,
    Expression<String>? profileId,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<bool>? dirty,
    Expression<String>? lastWriterDeviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (doctorName != null) 'doctor_name': doctorName,
      if (date != null) 'date': date,
      if (reason != null) 'reason': reason,
      if (imageUrl != null) 'image_url': imageUrl,
      if (medicines != null) 'medicines': medicines,
      if (isScanned != null) 'is_scanned': isScanned,
      if (accountId != null) 'account_id': accountId,
      if (profileId != null) 'profile_id': profileId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (lastWriterDeviceId != null)
        'last_writer_device_id': lastWriterDeviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrescriptionTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? doctorName,
      Value<DateTime>? date,
      Value<String>? reason,
      Value<String?>? imageUrl,
      Value<String>? medicines,
      Value<bool>? isScanned,
      Value<String?>? accountId,
      Value<String?>? profileId,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<bool>? dirty,
      Value<String?>? lastWriterDeviceId,
      Value<int>? rowid}) {
    return PrescriptionTableCompanion(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      reason: reason ?? this.reason,
      imageUrl: imageUrl ?? this.imageUrl,
      medicines: medicines ?? this.medicines,
      isScanned: isScanned ?? this.isScanned,
      accountId: accountId ?? this.accountId,
      profileId: profileId ?? this.profileId,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      lastWriterDeviceId: lastWriterDeviceId ?? this.lastWriterDeviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (medicines.present) {
      map['medicines'] = Variable<String>(medicines.value);
    }
    if (isScanned.present) {
      map['is_scanned'] = Variable<bool>(isScanned.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (lastWriterDeviceId.present) {
      map['last_writer_device_id'] = Variable<String>(lastWriterDeviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionTableCompanion(')
          ..write('id: $id, ')
          ..write('doctorName: $doctorName, ')
          ..write('date: $date, ')
          ..write('reason: $reason, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('medicines: $medicines, ')
          ..write('isScanned: $isScanned, ')
          ..write('accountId: $accountId, ')
          ..write('profileId: $profileId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('lastWriterDeviceId: $lastWriterDeviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderSettingsTableTable extends ReminderSettingsTable
    with TableInfo<$ReminderSettingsTableTable, ReminderSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('primary'));
  static const VerificationMeta _enableNotificationsMeta =
      const VerificationMeta('enableNotifications');
  @override
  late final GeneratedColumn<bool> enableNotifications = GeneratedColumn<bool>(
      'enable_notifications', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_notifications" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _snoozeDurationMinutesMeta =
      const VerificationMeta('snoozeDurationMinutes');
  @override
  late final GeneratedColumn<int> snoozeDurationMinutes = GeneratedColumn<int>(
      'snooze_duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _notificationSoundMeta =
      const VerificationMeta('notificationSound');
  @override
  late final GeneratedColumn<String> notificationSound =
      GeneratedColumn<String>('notification_sound', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('default'));
  static const VerificationMeta _criticalAlertsMeta =
      const VerificationMeta('criticalAlerts');
  @override
  late final GeneratedColumn<bool> criticalAlerts = GeneratedColumn<bool>(
      'critical_alerts', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("critical_alerts" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        enableNotifications,
        snoozeDurationMinutes,
        notificationSound,
        criticalAlerts
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReminderSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enable_notifications')) {
      context.handle(
          _enableNotificationsMeta,
          enableNotifications.isAcceptableOrUnknown(
              data['enable_notifications']!, _enableNotificationsMeta));
    }
    if (data.containsKey('snooze_duration_minutes')) {
      context.handle(
          _snoozeDurationMinutesMeta,
          snoozeDurationMinutes.isAcceptableOrUnknown(
              data['snooze_duration_minutes']!, _snoozeDurationMinutesMeta));
    }
    if (data.containsKey('notification_sound')) {
      context.handle(
          _notificationSoundMeta,
          notificationSound.isAcceptableOrUnknown(
              data['notification_sound']!, _notificationSoundMeta));
    }
    if (data.containsKey('critical_alerts')) {
      context.handle(
          _criticalAlertsMeta,
          criticalAlerts.isAcceptableOrUnknown(
              data['critical_alerts']!, _criticalAlertsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderSettingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      enableNotifications: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}enable_notifications'])!,
      snoozeDurationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}snooze_duration_minutes'])!,
      notificationSound: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_sound'])!,
      criticalAlerts: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}critical_alerts'])!,
    );
  }

  @override
  $ReminderSettingsTableTable createAlias(String alias) {
    return $ReminderSettingsTableTable(attachedDatabase, alias);
  }
}

class ReminderSettingsTableData extends DataClass
    implements Insertable<ReminderSettingsTableData> {
  final String id;
  final bool enableNotifications;
  final int snoozeDurationMinutes;
  final String notificationSound;
  final bool criticalAlerts;
  const ReminderSettingsTableData(
      {required this.id,
      required this.enableNotifications,
      required this.snoozeDurationMinutes,
      required this.notificationSound,
      required this.criticalAlerts});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['enable_notifications'] = Variable<bool>(enableNotifications);
    map['snooze_duration_minutes'] = Variable<int>(snoozeDurationMinutes);
    map['notification_sound'] = Variable<String>(notificationSound);
    map['critical_alerts'] = Variable<bool>(criticalAlerts);
    return map;
  }

  ReminderSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return ReminderSettingsTableCompanion(
      id: Value(id),
      enableNotifications: Value(enableNotifications),
      snoozeDurationMinutes: Value(snoozeDurationMinutes),
      notificationSound: Value(notificationSound),
      criticalAlerts: Value(criticalAlerts),
    );
  }

  factory ReminderSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderSettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      enableNotifications:
          serializer.fromJson<bool>(json['enableNotifications']),
      snoozeDurationMinutes:
          serializer.fromJson<int>(json['snoozeDurationMinutes']),
      notificationSound: serializer.fromJson<String>(json['notificationSound']),
      criticalAlerts: serializer.fromJson<bool>(json['criticalAlerts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'enableNotifications': serializer.toJson<bool>(enableNotifications),
      'snoozeDurationMinutes': serializer.toJson<int>(snoozeDurationMinutes),
      'notificationSound': serializer.toJson<String>(notificationSound),
      'criticalAlerts': serializer.toJson<bool>(criticalAlerts),
    };
  }

  ReminderSettingsTableData copyWith(
          {String? id,
          bool? enableNotifications,
          int? snoozeDurationMinutes,
          String? notificationSound,
          bool? criticalAlerts}) =>
      ReminderSettingsTableData(
        id: id ?? this.id,
        enableNotifications: enableNotifications ?? this.enableNotifications,
        snoozeDurationMinutes:
            snoozeDurationMinutes ?? this.snoozeDurationMinutes,
        notificationSound: notificationSound ?? this.notificationSound,
        criticalAlerts: criticalAlerts ?? this.criticalAlerts,
      );
  ReminderSettingsTableData copyWithCompanion(
      ReminderSettingsTableCompanion data) {
    return ReminderSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      enableNotifications: data.enableNotifications.present
          ? data.enableNotifications.value
          : this.enableNotifications,
      snoozeDurationMinutes: data.snoozeDurationMinutes.present
          ? data.snoozeDurationMinutes.value
          : this.snoozeDurationMinutes,
      notificationSound: data.notificationSound.present
          ? data.notificationSound.value
          : this.notificationSound,
      criticalAlerts: data.criticalAlerts.present
          ? data.criticalAlerts.value
          : this.criticalAlerts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingsTableData(')
          ..write('id: $id, ')
          ..write('enableNotifications: $enableNotifications, ')
          ..write('snoozeDurationMinutes: $snoozeDurationMinutes, ')
          ..write('notificationSound: $notificationSound, ')
          ..write('criticalAlerts: $criticalAlerts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, enableNotifications,
      snoozeDurationMinutes, notificationSound, criticalAlerts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderSettingsTableData &&
          other.id == this.id &&
          other.enableNotifications == this.enableNotifications &&
          other.snoozeDurationMinutes == this.snoozeDurationMinutes &&
          other.notificationSound == this.notificationSound &&
          other.criticalAlerts == this.criticalAlerts);
}

class ReminderSettingsTableCompanion
    extends UpdateCompanion<ReminderSettingsTableData> {
  final Value<String> id;
  final Value<bool> enableNotifications;
  final Value<int> snoozeDurationMinutes;
  final Value<String> notificationSound;
  final Value<bool> criticalAlerts;
  final Value<int> rowid;
  const ReminderSettingsTableCompanion({
    this.id = const Value.absent(),
    this.enableNotifications = const Value.absent(),
    this.snoozeDurationMinutes = const Value.absent(),
    this.notificationSound = const Value.absent(),
    this.criticalAlerts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.enableNotifications = const Value.absent(),
    this.snoozeDurationMinutes = const Value.absent(),
    this.notificationSound = const Value.absent(),
    this.criticalAlerts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<ReminderSettingsTableData> custom({
    Expression<String>? id,
    Expression<bool>? enableNotifications,
    Expression<int>? snoozeDurationMinutes,
    Expression<String>? notificationSound,
    Expression<bool>? criticalAlerts,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enableNotifications != null)
        'enable_notifications': enableNotifications,
      if (snoozeDurationMinutes != null)
        'snooze_duration_minutes': snoozeDurationMinutes,
      if (notificationSound != null) 'notification_sound': notificationSound,
      if (criticalAlerts != null) 'critical_alerts': criticalAlerts,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderSettingsTableCompanion copyWith(
      {Value<String>? id,
      Value<bool>? enableNotifications,
      Value<int>? snoozeDurationMinutes,
      Value<String>? notificationSound,
      Value<bool>? criticalAlerts,
      Value<int>? rowid}) {
    return ReminderSettingsTableCompanion(
      id: id ?? this.id,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      snoozeDurationMinutes:
          snoozeDurationMinutes ?? this.snoozeDurationMinutes,
      notificationSound: notificationSound ?? this.notificationSound,
      criticalAlerts: criticalAlerts ?? this.criticalAlerts,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (enableNotifications.present) {
      map['enable_notifications'] = Variable<bool>(enableNotifications.value);
    }
    if (snoozeDurationMinutes.present) {
      map['snooze_duration_minutes'] =
          Variable<int>(snoozeDurationMinutes.value);
    }
    if (notificationSound.present) {
      map['notification_sound'] = Variable<String>(notificationSound.value);
    }
    if (criticalAlerts.present) {
      map['critical_alerts'] = Variable<bool>(criticalAlerts.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('enableNotifications: $enableNotifications, ')
          ..write('snoozeDurationMinutes: $snoozeDurationMinutes, ')
          ..write('notificationSound: $notificationSound, ')
          ..write('criticalAlerts: $criticalAlerts, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfileTableTable profileTable = $ProfileTableTable(this);
  late final $MedicineTableTable medicineTable = $MedicineTableTable(this);
  late final $DoseLogTableTable doseLogTable = $DoseLogTableTable(this);
  late final $EmergencyCardTableTable emergencyCardTable =
      $EmergencyCardTableTable(this);
  late final $PrescriptionTableTable prescriptionTable =
      $PrescriptionTableTable(this);
  late final $ReminderSettingsTableTable reminderSettingsTable =
      $ReminderSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        profileTable,
        medicineTable,
        doseLogTable,
        emergencyCardTable,
        prescriptionTable,
        reminderSettingsTable
      ];
}

typedef $$ProfileTableTableCreateCompanionBuilder = ProfileTableCompanion
    Function({
  required String id,
  required String name,
  required String initials,
  Value<int?> age,
  Value<String?> gender,
  Value<String?> accountId,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> dirty,
  Value<String?> lastWriterDeviceId,
  Value<int> rowid,
});
typedef $$ProfileTableTableUpdateCompanionBuilder = ProfileTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> initials,
  Value<int?> age,
  Value<String?> gender,
  Value<String?> accountId,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> dirty,
  Value<String?> lastWriterDeviceId,
  Value<int> rowid,
});

final class $$ProfileTableTableReferences extends BaseReferences<_$AppDatabase,
    $ProfileTableTable, ProfileTableData> {
  $$ProfileTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicineTableTable, List<MedicineTableData>>
      _medicineTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.medicineTable,
              aliasName: $_aliasNameGenerator(
                  db.profileTable.id, db.medicineTable.profileId));

  $$MedicineTableTableProcessedTableManager get medicineTableRefs {
    final manager = $$MedicineTableTableTableManager($_db, $_db.medicineTable)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicineTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileTableTable> {
  $$ProfileTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get initials => $composableBuilder(
      column: $table.initials, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId,
      builder: (column) => ColumnFilters(column));

  Expression<bool> medicineTableRefs(
      Expression<bool> Function($$MedicineTableTableFilterComposer f) f) {
    final $$MedicineTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicineTable,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineTableTableFilterComposer(
              $db: $db,
              $table: $db.medicineTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileTableTable> {
  $$ProfileTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get initials => $composableBuilder(
      column: $table.initials, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId,
      builder: (column) => ColumnOrderings(column));
}

class $$ProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileTableTable> {
  $$ProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get initials =>
      $composableBuilder(column: $table.initials, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId, builder: (column) => column);

  Expression<T> medicineTableRefs<T extends Object>(
      Expression<T> Function($$MedicineTableTableAnnotationComposer a) f) {
    final $$MedicineTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicineTable,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineTableTableAnnotationComposer(
              $db: $db,
              $table: $db.medicineTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProfileTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfileTableTable,
    ProfileTableData,
    $$ProfileTableTableFilterComposer,
    $$ProfileTableTableOrderingComposer,
    $$ProfileTableTableAnnotationComposer,
    $$ProfileTableTableCreateCompanionBuilder,
    $$ProfileTableTableUpdateCompanionBuilder,
    (ProfileTableData, $$ProfileTableTableReferences),
    ProfileTableData,
    PrefetchHooks Function({bool medicineTableRefs})> {
  $$ProfileTableTableTableManager(_$AppDatabase db, $ProfileTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> initials = const Value.absent(),
            Value<int?> age = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> lastWriterDeviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfileTableCompanion(
            id: id,
            name: name,
            initials: initials,
            age: age,
            gender: gender,
            accountId: accountId,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            dirty: dirty,
            lastWriterDeviceId: lastWriterDeviceId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String initials,
            Value<int?> age = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> lastWriterDeviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfileTableCompanion.insert(
            id: id,
            name: name,
            initials: initials,
            age: age,
            gender: gender,
            accountId: accountId,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            dirty: dirty,
            lastWriterDeviceId: lastWriterDeviceId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProfileTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({medicineTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicineTableRefs) db.medicineTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicineTableRefs)
                    await $_getPrefetchedData<ProfileTableData,
                            $ProfileTableTable, MedicineTableData>(
                        currentTable: table,
                        referencedTable: $$ProfileTableTableReferences
                            ._medicineTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfileTableTableReferences(db, table, p0)
                                .medicineTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProfileTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfileTableTable,
    ProfileTableData,
    $$ProfileTableTableFilterComposer,
    $$ProfileTableTableOrderingComposer,
    $$ProfileTableTableAnnotationComposer,
    $$ProfileTableTableCreateCompanionBuilder,
    $$ProfileTableTableUpdateCompanionBuilder,
    (ProfileTableData, $$ProfileTableTableReferences),
    ProfileTableData,
    PrefetchHooks Function({bool medicineTableRefs})>;
typedef $$MedicineTableTableCreateCompanionBuilder = MedicineTableCompanion
    Function({
  required String id,
  Value<String?> profileId,
  required String name,
  required String type,
  required String schedule,
  required int stockRemaining,
  required int stockTotal,
  required int daysLeft,
  required bool isLowStock,
  Value<String?> imagePath,
  Value<double> amount,
  Value<String?> strength,
  Value<String?> unit,
  Value<String?> reminderTimes,
  Value<DateTime?> startDate,
  Value<int?> durationDays,
  Value<String?> accountId,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> dirty,
  Value<String?> lastWriterDeviceId,
  Value<int> rowid,
});
typedef $$MedicineTableTableUpdateCompanionBuilder = MedicineTableCompanion
    Function({
  Value<String> id,
  Value<String?> profileId,
  Value<String> name,
  Value<String> type,
  Value<String> schedule,
  Value<int> stockRemaining,
  Value<int> stockTotal,
  Value<int> daysLeft,
  Value<bool> isLowStock,
  Value<String?> imagePath,
  Value<double> amount,
  Value<String?> strength,
  Value<String?> unit,
  Value<String?> reminderTimes,
  Value<DateTime?> startDate,
  Value<int?> durationDays,
  Value<String?> accountId,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> dirty,
  Value<String?> lastWriterDeviceId,
  Value<int> rowid,
});

final class $$MedicineTableTableReferences extends BaseReferences<_$AppDatabase,
    $MedicineTableTable, MedicineTableData> {
  $$MedicineTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProfileTableTable _profileIdTable(_$AppDatabase db) =>
      db.profileTable.createAlias(
          $_aliasNameGenerator(db.medicineTable.profileId, db.profileTable.id));

  $$ProfileTableTableProcessedTableManager? get profileId {
    final $_column = $_itemColumn<String>('profile_id');
    if ($_column == null) return null;
    final manager = $$ProfileTableTableTableManager($_db, $_db.profileTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DoseLogTableTable, List<DoseLogTableData>>
      _doseLogTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.doseLogTable,
              aliasName: $_aliasNameGenerator(
                  db.medicineTable.id, db.doseLogTable.medicineId));

  $$DoseLogTableTableProcessedTableManager get doseLogTableRefs {
    final manager = $$DoseLogTableTableTableManager($_db, $_db.doseLogTable)
        .filter((f) => f.medicineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseLogTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicineTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineTableTable> {
  $$MedicineTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get schedule => $composableBuilder(
      column: $table.schedule, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockRemaining => $composableBuilder(
      column: $table.stockRemaining,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockTotal => $composableBuilder(
      column: $table.stockTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get daysLeft => $composableBuilder(
      column: $table.daysLeft, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLowStock => $composableBuilder(
      column: $table.isLowStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get strength => $composableBuilder(
      column: $table.strength, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderTimes => $composableBuilder(
      column: $table.reminderTimes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationDays => $composableBuilder(
      column: $table.durationDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId,
      builder: (column) => ColumnFilters(column));

  $$ProfileTableTableFilterComposer get profileId {
    final $$ProfileTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profileTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfileTableTableFilterComposer(
              $db: $db,
              $table: $db.profileTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> doseLogTableRefs(
      Expression<bool> Function($$DoseLogTableTableFilterComposer f) f) {
    final $$DoseLogTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.doseLogTable,
        getReferencedColumn: (t) => t.medicineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DoseLogTableTableFilterComposer(
              $db: $db,
              $table: $db.doseLogTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicineTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineTableTable> {
  $$MedicineTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get schedule => $composableBuilder(
      column: $table.schedule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockRemaining => $composableBuilder(
      column: $table.stockRemaining,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockTotal => $composableBuilder(
      column: $table.stockTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get daysLeft => $composableBuilder(
      column: $table.daysLeft, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLowStock => $composableBuilder(
      column: $table.isLowStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strength => $composableBuilder(
      column: $table.strength, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderTimes => $composableBuilder(
      column: $table.reminderTimes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationDays => $composableBuilder(
      column: $table.durationDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId,
      builder: (column) => ColumnOrderings(column));

  $$ProfileTableTableOrderingComposer get profileId {
    final $$ProfileTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profileTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfileTableTableOrderingComposer(
              $db: $db,
              $table: $db.profileTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicineTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineTableTable> {
  $$MedicineTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get schedule =>
      $composableBuilder(column: $table.schedule, builder: (column) => column);

  GeneratedColumn<int> get stockRemaining => $composableBuilder(
      column: $table.stockRemaining, builder: (column) => column);

  GeneratedColumn<int> get stockTotal => $composableBuilder(
      column: $table.stockTotal, builder: (column) => column);

  GeneratedColumn<int> get daysLeft =>
      $composableBuilder(column: $table.daysLeft, builder: (column) => column);

  GeneratedColumn<bool> get isLowStock => $composableBuilder(
      column: $table.isLowStock, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get reminderTimes => $composableBuilder(
      column: $table.reminderTimes, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get durationDays => $composableBuilder(
      column: $table.durationDays, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId, builder: (column) => column);

  $$ProfileTableTableAnnotationComposer get profileId {
    final $$ProfileTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profileTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfileTableTableAnnotationComposer(
              $db: $db,
              $table: $db.profileTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> doseLogTableRefs<T extends Object>(
      Expression<T> Function($$DoseLogTableTableAnnotationComposer a) f) {
    final $$DoseLogTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.doseLogTable,
        getReferencedColumn: (t) => t.medicineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DoseLogTableTableAnnotationComposer(
              $db: $db,
              $table: $db.doseLogTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicineTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicineTableTable,
    MedicineTableData,
    $$MedicineTableTableFilterComposer,
    $$MedicineTableTableOrderingComposer,
    $$MedicineTableTableAnnotationComposer,
    $$MedicineTableTableCreateCompanionBuilder,
    $$MedicineTableTableUpdateCompanionBuilder,
    (MedicineTableData, $$MedicineTableTableReferences),
    MedicineTableData,
    PrefetchHooks Function({bool profileId, bool doseLogTableRefs})> {
  $$MedicineTableTableTableManager(_$AppDatabase db, $MedicineTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicineTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicineTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicineTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> schedule = const Value.absent(),
            Value<int> stockRemaining = const Value.absent(),
            Value<int> stockTotal = const Value.absent(),
            Value<int> daysLeft = const Value.absent(),
            Value<bool> isLowStock = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> strength = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> reminderTimes = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<int?> durationDays = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> lastWriterDeviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicineTableCompanion(
            id: id,
            profileId: profileId,
            name: name,
            type: type,
            schedule: schedule,
            stockRemaining: stockRemaining,
            stockTotal: stockTotal,
            daysLeft: daysLeft,
            isLowStock: isLowStock,
            imagePath: imagePath,
            amount: amount,
            strength: strength,
            unit: unit,
            reminderTimes: reminderTimes,
            startDate: startDate,
            durationDays: durationDays,
            accountId: accountId,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            dirty: dirty,
            lastWriterDeviceId: lastWriterDeviceId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> profileId = const Value.absent(),
            required String name,
            required String type,
            required String schedule,
            required int stockRemaining,
            required int stockTotal,
            required int daysLeft,
            required bool isLowStock,
            Value<String?> imagePath = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> strength = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> reminderTimes = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<int?> durationDays = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> lastWriterDeviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicineTableCompanion.insert(
            id: id,
            profileId: profileId,
            name: name,
            type: type,
            schedule: schedule,
            stockRemaining: stockRemaining,
            stockTotal: stockTotal,
            daysLeft: daysLeft,
            isLowStock: isLowStock,
            imagePath: imagePath,
            amount: amount,
            strength: strength,
            unit: unit,
            reminderTimes: reminderTimes,
            startDate: startDate,
            durationDays: durationDays,
            accountId: accountId,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            dirty: dirty,
            lastWriterDeviceId: lastWriterDeviceId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicineTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {profileId = false, doseLogTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (doseLogTableRefs) db.doseLogTable],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable:
                        $$MedicineTableTableReferences._profileIdTable(db),
                    referencedColumn:
                        $$MedicineTableTableReferences._profileIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (doseLogTableRefs)
                    await $_getPrefetchedData<MedicineTableData,
                            $MedicineTableTable, DoseLogTableData>(
                        currentTable: table,
                        referencedTable: $$MedicineTableTableReferences
                            ._doseLogTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicineTableTableReferences(db, table, p0)
                                .doseLogTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicineId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicineTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicineTableTable,
    MedicineTableData,
    $$MedicineTableTableFilterComposer,
    $$MedicineTableTableOrderingComposer,
    $$MedicineTableTableAnnotationComposer,
    $$MedicineTableTableCreateCompanionBuilder,
    $$MedicineTableTableUpdateCompanionBuilder,
    (MedicineTableData, $$MedicineTableTableReferences),
    MedicineTableData,
    PrefetchHooks Function({bool profileId, bool doseLogTableRefs})>;
typedef $$DoseLogTableTableCreateCompanionBuilder = DoseLogTableCompanion
    Function({
  required String id,
  required String medicineId,
  required String medicineName,
  required DateTime logDateTime,
  required int status,
  Value<String?> note,
  Value<DateTime?> scheduledDateTime,
  Value<String?> accountId,
  Value<String?> profileId,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> dirty,
  Value<String?> lastWriterDeviceId,
  Value<int> rowid,
});
typedef $$DoseLogTableTableUpdateCompanionBuilder = DoseLogTableCompanion
    Function({
  Value<String> id,
  Value<String> medicineId,
  Value<String> medicineName,
  Value<DateTime> logDateTime,
  Value<int> status,
  Value<String?> note,
  Value<DateTime?> scheduledDateTime,
  Value<String?> accountId,
  Value<String?> profileId,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> dirty,
  Value<String?> lastWriterDeviceId,
  Value<int> rowid,
});

final class $$DoseLogTableTableReferences extends BaseReferences<_$AppDatabase,
    $DoseLogTableTable, DoseLogTableData> {
  $$DoseLogTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicineTableTable _medicineIdTable(_$AppDatabase db) =>
      db.medicineTable.createAlias($_aliasNameGenerator(
          db.doseLogTable.medicineId, db.medicineTable.id));

  $$MedicineTableTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<String>('medicine_id')!;

    final manager = $$MedicineTableTableTableManager($_db, $_db.medicineTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DoseLogTableTableFilterComposer
    extends Composer<_$AppDatabase, $DoseLogTableTable> {
  $$DoseLogTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicineName => $composableBuilder(
      column: $table.medicineName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get logDateTime => $composableBuilder(
      column: $table.logDateTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledDateTime => $composableBuilder(
      column: $table.scheduledDateTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId,
      builder: (column) => ColumnFilters(column));

  $$MedicineTableTableFilterComposer get medicineId {
    final $$MedicineTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicineTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineTableTableFilterComposer(
              $db: $db,
              $table: $db.medicineTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DoseLogTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseLogTableTable> {
  $$DoseLogTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicineName => $composableBuilder(
      column: $table.medicineName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get logDateTime => $composableBuilder(
      column: $table.logDateTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledDateTime => $composableBuilder(
      column: $table.scheduledDateTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId,
      builder: (column) => ColumnOrderings(column));

  $$MedicineTableTableOrderingComposer get medicineId {
    final $$MedicineTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicineTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineTableTableOrderingComposer(
              $db: $db,
              $table: $db.medicineTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DoseLogTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseLogTableTable> {
  $$DoseLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicineName => $composableBuilder(
      column: $table.medicineName, builder: (column) => column);

  GeneratedColumn<DateTime> get logDateTime => $composableBuilder(
      column: $table.logDateTime, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDateTime => $composableBuilder(
      column: $table.scheduledDateTime, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId, builder: (column) => column);

  $$MedicineTableTableAnnotationComposer get medicineId {
    final $$MedicineTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicineId,
        referencedTable: $db.medicineTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicineTableTableAnnotationComposer(
              $db: $db,
              $table: $db.medicineTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DoseLogTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DoseLogTableTable,
    DoseLogTableData,
    $$DoseLogTableTableFilterComposer,
    $$DoseLogTableTableOrderingComposer,
    $$DoseLogTableTableAnnotationComposer,
    $$DoseLogTableTableCreateCompanionBuilder,
    $$DoseLogTableTableUpdateCompanionBuilder,
    (DoseLogTableData, $$DoseLogTableTableReferences),
    DoseLogTableData,
    PrefetchHooks Function({bool medicineId})> {
  $$DoseLogTableTableTableManager(_$AppDatabase db, $DoseLogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseLogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> medicineId = const Value.absent(),
            Value<String> medicineName = const Value.absent(),
            Value<DateTime> logDateTime = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> scheduledDateTime = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> lastWriterDeviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseLogTableCompanion(
            id: id,
            medicineId: medicineId,
            medicineName: medicineName,
            logDateTime: logDateTime,
            status: status,
            note: note,
            scheduledDateTime: scheduledDateTime,
            accountId: accountId,
            profileId: profileId,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            dirty: dirty,
            lastWriterDeviceId: lastWriterDeviceId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String medicineId,
            required String medicineName,
            required DateTime logDateTime,
            required int status,
            Value<String?> note = const Value.absent(),
            Value<DateTime?> scheduledDateTime = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> lastWriterDeviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseLogTableCompanion.insert(
            id: id,
            medicineId: medicineId,
            medicineName: medicineName,
            logDateTime: logDateTime,
            status: status,
            note: note,
            scheduledDateTime: scheduledDateTime,
            accountId: accountId,
            profileId: profileId,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            dirty: dirty,
            lastWriterDeviceId: lastWriterDeviceId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DoseLogTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({medicineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicineId,
                    referencedTable:
                        $$DoseLogTableTableReferences._medicineIdTable(db),
                    referencedColumn:
                        $$DoseLogTableTableReferences._medicineIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DoseLogTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DoseLogTableTable,
    DoseLogTableData,
    $$DoseLogTableTableFilterComposer,
    $$DoseLogTableTableOrderingComposer,
    $$DoseLogTableTableAnnotationComposer,
    $$DoseLogTableTableCreateCompanionBuilder,
    $$DoseLogTableTableUpdateCompanionBuilder,
    (DoseLogTableData, $$DoseLogTableTableReferences),
    DoseLogTableData,
    PrefetchHooks Function({bool medicineId})>;
typedef $$EmergencyCardTableTableCreateCompanionBuilder
    = EmergencyCardTableCompanion Function({
  Value<String> id,
  required String fullName,
  required String bloodType,
  required String allergies,
  required String conditions,
  required String emergencyContactName,
  required String emergencyContactPhone,
  Value<int> rowid,
});
typedef $$EmergencyCardTableTableUpdateCompanionBuilder
    = EmergencyCardTableCompanion Function({
  Value<String> id,
  Value<String> fullName,
  Value<String> bloodType,
  Value<String> allergies,
  Value<String> conditions,
  Value<String> emergencyContactName,
  Value<String> emergencyContactPhone,
  Value<int> rowid,
});

class $$EmergencyCardTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyCardTableTable> {
  $$EmergencyCardTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bloodType => $composableBuilder(
      column: $table.bloodType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergies => $composableBuilder(
      column: $table.allergies, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone,
      builder: (column) => ColumnFilters(column));
}

class $$EmergencyCardTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyCardTableTable> {
  $$EmergencyCardTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bloodType => $composableBuilder(
      column: $table.bloodType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergies => $composableBuilder(
      column: $table.allergies, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone,
      builder: (column) => ColumnOrderings(column));
}

class $$EmergencyCardTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyCardTableTable> {
  $$EmergencyCardTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get bloodType =>
      $composableBuilder(column: $table.bloodType, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => column);

  GeneratedColumn<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName, builder: (column) => column);

  GeneratedColumn<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone, builder: (column) => column);
}

class $$EmergencyCardTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmergencyCardTableTable,
    EmergencyCardTableData,
    $$EmergencyCardTableTableFilterComposer,
    $$EmergencyCardTableTableOrderingComposer,
    $$EmergencyCardTableTableAnnotationComposer,
    $$EmergencyCardTableTableCreateCompanionBuilder,
    $$EmergencyCardTableTableUpdateCompanionBuilder,
    (
      EmergencyCardTableData,
      BaseReferences<_$AppDatabase, $EmergencyCardTableTable,
          EmergencyCardTableData>
    ),
    EmergencyCardTableData,
    PrefetchHooks Function()> {
  $$EmergencyCardTableTableTableManager(
      _$AppDatabase db, $EmergencyCardTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyCardTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyCardTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyCardTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> bloodType = const Value.absent(),
            Value<String> allergies = const Value.absent(),
            Value<String> conditions = const Value.absent(),
            Value<String> emergencyContactName = const Value.absent(),
            Value<String> emergencyContactPhone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmergencyCardTableCompanion(
            id: id,
            fullName: fullName,
            bloodType: bloodType,
            allergies: allergies,
            conditions: conditions,
            emergencyContactName: emergencyContactName,
            emergencyContactPhone: emergencyContactPhone,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String fullName,
            required String bloodType,
            required String allergies,
            required String conditions,
            required String emergencyContactName,
            required String emergencyContactPhone,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmergencyCardTableCompanion.insert(
            id: id,
            fullName: fullName,
            bloodType: bloodType,
            allergies: allergies,
            conditions: conditions,
            emergencyContactName: emergencyContactName,
            emergencyContactPhone: emergencyContactPhone,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmergencyCardTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmergencyCardTableTable,
    EmergencyCardTableData,
    $$EmergencyCardTableTableFilterComposer,
    $$EmergencyCardTableTableOrderingComposer,
    $$EmergencyCardTableTableAnnotationComposer,
    $$EmergencyCardTableTableCreateCompanionBuilder,
    $$EmergencyCardTableTableUpdateCompanionBuilder,
    (
      EmergencyCardTableData,
      BaseReferences<_$AppDatabase, $EmergencyCardTableTable,
          EmergencyCardTableData>
    ),
    EmergencyCardTableData,
    PrefetchHooks Function()>;
typedef $$PrescriptionTableTableCreateCompanionBuilder
    = PrescriptionTableCompanion Function({
  required String id,
  required String doctorName,
  required DateTime date,
  required String reason,
  Value<String?> imageUrl,
  required String medicines,
  Value<bool> isScanned,
  Value<String?> accountId,
  Value<String?> profileId,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> dirty,
  Value<String?> lastWriterDeviceId,
  Value<int> rowid,
});
typedef $$PrescriptionTableTableUpdateCompanionBuilder
    = PrescriptionTableCompanion Function({
  Value<String> id,
  Value<String> doctorName,
  Value<DateTime> date,
  Value<String> reason,
  Value<String?> imageUrl,
  Value<String> medicines,
  Value<bool> isScanned,
  Value<String?> accountId,
  Value<String?> profileId,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> dirty,
  Value<String?> lastWriterDeviceId,
  Value<int> rowid,
});

class $$PrescriptionTableTableFilterComposer
    extends Composer<_$AppDatabase, $PrescriptionTableTable> {
  $$PrescriptionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicines => $composableBuilder(
      column: $table.medicines, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isScanned => $composableBuilder(
      column: $table.isScanned, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId,
      builder: (column) => ColumnFilters(column));
}

class $$PrescriptionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PrescriptionTableTable> {
  $$PrescriptionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicines => $composableBuilder(
      column: $table.medicines, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isScanned => $composableBuilder(
      column: $table.isScanned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId,
      builder: (column) => ColumnOrderings(column));
}

class $$PrescriptionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrescriptionTableTable> {
  $$PrescriptionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get medicines =>
      $composableBuilder(column: $table.medicines, builder: (column) => column);

  GeneratedColumn<bool> get isScanned =>
      $composableBuilder(column: $table.isScanned, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get lastWriterDeviceId => $composableBuilder(
      column: $table.lastWriterDeviceId, builder: (column) => column);
}

class $$PrescriptionTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrescriptionTableTable,
    PrescriptionTableData,
    $$PrescriptionTableTableFilterComposer,
    $$PrescriptionTableTableOrderingComposer,
    $$PrescriptionTableTableAnnotationComposer,
    $$PrescriptionTableTableCreateCompanionBuilder,
    $$PrescriptionTableTableUpdateCompanionBuilder,
    (
      PrescriptionTableData,
      BaseReferences<_$AppDatabase, $PrescriptionTableTable,
          PrescriptionTableData>
    ),
    PrescriptionTableData,
    PrefetchHooks Function()> {
  $$PrescriptionTableTableTableManager(
      _$AppDatabase db, $PrescriptionTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrescriptionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrescriptionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrescriptionTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> doctorName = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String> medicines = const Value.absent(),
            Value<bool> isScanned = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> lastWriterDeviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrescriptionTableCompanion(
            id: id,
            doctorName: doctorName,
            date: date,
            reason: reason,
            imageUrl: imageUrl,
            medicines: medicines,
            isScanned: isScanned,
            accountId: accountId,
            profileId: profileId,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            dirty: dirty,
            lastWriterDeviceId: lastWriterDeviceId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String doctorName,
            required DateTime date,
            required String reason,
            Value<String?> imageUrl = const Value.absent(),
            required String medicines,
            Value<bool> isScanned = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> lastWriterDeviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrescriptionTableCompanion.insert(
            id: id,
            doctorName: doctorName,
            date: date,
            reason: reason,
            imageUrl: imageUrl,
            medicines: medicines,
            isScanned: isScanned,
            accountId: accountId,
            profileId: profileId,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            dirty: dirty,
            lastWriterDeviceId: lastWriterDeviceId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PrescriptionTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PrescriptionTableTable,
    PrescriptionTableData,
    $$PrescriptionTableTableFilterComposer,
    $$PrescriptionTableTableOrderingComposer,
    $$PrescriptionTableTableAnnotationComposer,
    $$PrescriptionTableTableCreateCompanionBuilder,
    $$PrescriptionTableTableUpdateCompanionBuilder,
    (
      PrescriptionTableData,
      BaseReferences<_$AppDatabase, $PrescriptionTableTable,
          PrescriptionTableData>
    ),
    PrescriptionTableData,
    PrefetchHooks Function()>;
typedef $$ReminderSettingsTableTableCreateCompanionBuilder
    = ReminderSettingsTableCompanion Function({
  Value<String> id,
  Value<bool> enableNotifications,
  Value<int> snoozeDurationMinutes,
  Value<String> notificationSound,
  Value<bool> criticalAlerts,
  Value<int> rowid,
});
typedef $$ReminderSettingsTableTableUpdateCompanionBuilder
    = ReminderSettingsTableCompanion Function({
  Value<String> id,
  Value<bool> enableNotifications,
  Value<int> snoozeDurationMinutes,
  Value<String> notificationSound,
  Value<bool> criticalAlerts,
  Value<int> rowid,
});

class $$ReminderSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTableTable> {
  $$ReminderSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enableNotifications => $composableBuilder(
      column: $table.enableNotifications,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get snoozeDurationMinutes => $composableBuilder(
      column: $table.snoozeDurationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationSound => $composableBuilder(
      column: $table.notificationSound,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get criticalAlerts => $composableBuilder(
      column: $table.criticalAlerts,
      builder: (column) => ColumnFilters(column));
}

class $$ReminderSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTableTable> {
  $$ReminderSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enableNotifications => $composableBuilder(
      column: $table.enableNotifications,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get snoozeDurationMinutes => $composableBuilder(
      column: $table.snoozeDurationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationSound => $composableBuilder(
      column: $table.notificationSound,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get criticalAlerts => $composableBuilder(
      column: $table.criticalAlerts,
      builder: (column) => ColumnOrderings(column));
}

class $$ReminderSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTableTable> {
  $$ReminderSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get enableNotifications => $composableBuilder(
      column: $table.enableNotifications, builder: (column) => column);

  GeneratedColumn<int> get snoozeDurationMinutes => $composableBuilder(
      column: $table.snoozeDurationMinutes, builder: (column) => column);

  GeneratedColumn<String> get notificationSound => $composableBuilder(
      column: $table.notificationSound, builder: (column) => column);

  GeneratedColumn<bool> get criticalAlerts => $composableBuilder(
      column: $table.criticalAlerts, builder: (column) => column);
}

class $$ReminderSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReminderSettingsTableTable,
    ReminderSettingsTableData,
    $$ReminderSettingsTableTableFilterComposer,
    $$ReminderSettingsTableTableOrderingComposer,
    $$ReminderSettingsTableTableAnnotationComposer,
    $$ReminderSettingsTableTableCreateCompanionBuilder,
    $$ReminderSettingsTableTableUpdateCompanionBuilder,
    (
      ReminderSettingsTableData,
      BaseReferences<_$AppDatabase, $ReminderSettingsTableTable,
          ReminderSettingsTableData>
    ),
    ReminderSettingsTableData,
    PrefetchHooks Function()> {
  $$ReminderSettingsTableTableTableManager(
      _$AppDatabase db, $ReminderSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderSettingsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderSettingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<bool> enableNotifications = const Value.absent(),
            Value<int> snoozeDurationMinutes = const Value.absent(),
            Value<String> notificationSound = const Value.absent(),
            Value<bool> criticalAlerts = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderSettingsTableCompanion(
            id: id,
            enableNotifications: enableNotifications,
            snoozeDurationMinutes: snoozeDurationMinutes,
            notificationSound: notificationSound,
            criticalAlerts: criticalAlerts,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<bool> enableNotifications = const Value.absent(),
            Value<int> snoozeDurationMinutes = const Value.absent(),
            Value<String> notificationSound = const Value.absent(),
            Value<bool> criticalAlerts = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderSettingsTableCompanion.insert(
            id: id,
            enableNotifications: enableNotifications,
            snoozeDurationMinutes: snoozeDurationMinutes,
            notificationSound: notificationSound,
            criticalAlerts: criticalAlerts,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReminderSettingsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ReminderSettingsTableTable,
        ReminderSettingsTableData,
        $$ReminderSettingsTableTableFilterComposer,
        $$ReminderSettingsTableTableOrderingComposer,
        $$ReminderSettingsTableTableAnnotationComposer,
        $$ReminderSettingsTableTableCreateCompanionBuilder,
        $$ReminderSettingsTableTableUpdateCompanionBuilder,
        (
          ReminderSettingsTableData,
          BaseReferences<_$AppDatabase, $ReminderSettingsTableTable,
              ReminderSettingsTableData>
        ),
        ReminderSettingsTableData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfileTableTableTableManager get profileTable =>
      $$ProfileTableTableTableManager(_db, _db.profileTable);
  $$MedicineTableTableTableManager get medicineTable =>
      $$MedicineTableTableTableManager(_db, _db.medicineTable);
  $$DoseLogTableTableTableManager get doseLogTable =>
      $$DoseLogTableTableTableManager(_db, _db.doseLogTable);
  $$EmergencyCardTableTableTableManager get emergencyCardTable =>
      $$EmergencyCardTableTableTableManager(_db, _db.emergencyCardTable);
  $$PrescriptionTableTableTableManager get prescriptionTable =>
      $$PrescriptionTableTableTableManager(_db, _db.prescriptionTable);
  $$ReminderSettingsTableTableTableManager get reminderSettingsTable =>
      $$ReminderSettingsTableTableTableManager(_db, _db.reminderSettingsTable);
}
