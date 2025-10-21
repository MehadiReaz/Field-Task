// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateTimeMeta =
      const VerificationMeta('dueDateTime');
  @override
  late final GeneratedColumn<DateTime> dueDateTime = GeneratedColumn<DateTime>(
      'due_date_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assignedToIdMeta =
      const VerificationMeta('assignedToId');
  @override
  late final GeneratedColumn<String> assignedToId = GeneratedColumn<String>(
      'assigned_to_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assignedToNameMeta =
      const VerificationMeta('assignedToName');
  @override
  late final GeneratedColumn<String> assignedToName = GeneratedColumn<String>(
      'assigned_to_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdByIdMeta =
      const VerificationMeta('createdById');
  @override
  late final GeneratedColumn<String> createdById = GeneratedColumn<String>(
      'created_by_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdByNameMeta =
      const VerificationMeta('createdByName');
  @override
  late final GeneratedColumn<String> createdByName = GeneratedColumn<String>(
      'created_by_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _checkedInAtMeta =
      const VerificationMeta('checkedInAt');
  @override
  late final GeneratedColumn<DateTime> checkedInAt = GeneratedColumn<DateTime>(
      'checked_in_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _checkedOutAtMeta =
      const VerificationMeta('checkedOutAt');
  @override
  late final GeneratedColumn<DateTime> checkedOutAt = GeneratedColumn<DateTime>(
      'checked_out_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _photoUrlsMeta =
      const VerificationMeta('photoUrls');
  @override
  late final GeneratedColumn<String> photoUrls = GeneratedColumn<String>(
      'photo_urls', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkInPhotoUrlMeta =
      const VerificationMeta('checkInPhotoUrl');
  @override
  late final GeneratedColumn<String> checkInPhotoUrl = GeneratedColumn<String>(
      'check_in_photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completionPhotoUrlMeta =
      const VerificationMeta('completionPhotoUrl');
  @override
  late final GeneratedColumn<String> completionPhotoUrl =
      GeneratedColumn<String>('completion_photo_url', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncRetryCountMeta =
      const VerificationMeta('syncRetryCount');
  @override
  late final GeneratedColumn<int> syncRetryCount = GeneratedColumn<int>(
      'sync_retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completionNotesMeta =
      const VerificationMeta('completionNotes');
  @override
  late final GeneratedColumn<String> completionNotes = GeneratedColumn<String>(
      'completion_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        dueDateTime,
        status,
        priority,
        latitude,
        longitude,
        address,
        assignedToId,
        assignedToName,
        createdById,
        createdByName,
        createdAt,
        updatedAt,
        checkedInAt,
        checkedOutAt,
        completedAt,
        photoUrls,
        checkInPhotoUrl,
        completionPhotoUrl,
        syncStatus,
        syncRetryCount,
        completionNotes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<TaskEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('due_date_time')) {
      context.handle(
          _dueDateTimeMeta,
          dueDateTime.isAcceptableOrUnknown(
              data['due_date_time']!, _dueDateTimeMeta));
    } else if (isInserting) {
      context.missing(_dueDateTimeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('assigned_to_id')) {
      context.handle(
          _assignedToIdMeta,
          assignedToId.isAcceptableOrUnknown(
              data['assigned_to_id']!, _assignedToIdMeta));
    } else if (isInserting) {
      context.missing(_assignedToIdMeta);
    }
    if (data.containsKey('assigned_to_name')) {
      context.handle(
          _assignedToNameMeta,
          assignedToName.isAcceptableOrUnknown(
              data['assigned_to_name']!, _assignedToNameMeta));
    } else if (isInserting) {
      context.missing(_assignedToNameMeta);
    }
    if (data.containsKey('created_by_id')) {
      context.handle(
          _createdByIdMeta,
          createdById.isAcceptableOrUnknown(
              data['created_by_id']!, _createdByIdMeta));
    } else if (isInserting) {
      context.missing(_createdByIdMeta);
    }
    if (data.containsKey('created_by_name')) {
      context.handle(
          _createdByNameMeta,
          createdByName.isAcceptableOrUnknown(
              data['created_by_name']!, _createdByNameMeta));
    } else if (isInserting) {
      context.missing(_createdByNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('checked_in_at')) {
      context.handle(
          _checkedInAtMeta,
          checkedInAt.isAcceptableOrUnknown(
              data['checked_in_at']!, _checkedInAtMeta));
    }
    if (data.containsKey('checked_out_at')) {
      context.handle(
          _checkedOutAtMeta,
          checkedOutAt.isAcceptableOrUnknown(
              data['checked_out_at']!, _checkedOutAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('photo_urls')) {
      context.handle(_photoUrlsMeta,
          photoUrls.isAcceptableOrUnknown(data['photo_urls']!, _photoUrlsMeta));
    }
    if (data.containsKey('check_in_photo_url')) {
      context.handle(
          _checkInPhotoUrlMeta,
          checkInPhotoUrl.isAcceptableOrUnknown(
              data['check_in_photo_url']!, _checkInPhotoUrlMeta));
    }
    if (data.containsKey('completion_photo_url')) {
      context.handle(
          _completionPhotoUrlMeta,
          completionPhotoUrl.isAcceptableOrUnknown(
              data['completion_photo_url']!, _completionPhotoUrlMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('sync_retry_count')) {
      context.handle(
          _syncRetryCountMeta,
          syncRetryCount.isAcceptableOrUnknown(
              data['sync_retry_count']!, _syncRetryCountMeta));
    }
    if (data.containsKey('completion_notes')) {
      context.handle(
          _completionNotesMeta,
          completionNotes.isAcceptableOrUnknown(
              data['completion_notes']!, _completionNotesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      dueDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}due_date_time'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      assignedToId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assigned_to_id'])!,
      assignedToName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}assigned_to_name'])!,
      createdById: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by_id'])!,
      createdByName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}created_by_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      checkedInAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}checked_in_at']),
      checkedOutAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}checked_out_at']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      photoUrls: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_urls']),
      checkInPhotoUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}check_in_photo_url']),
      completionPhotoUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}completion_photo_url']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncRetryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_retry_count'])!,
      completionNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}completion_notes']),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskEntity extends DataClass implements Insertable<TaskEntity> {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDateTime;
  final String status;
  final String priority;
  final double latitude;
  final double longitude;
  final String? address;
  final String assignedToId;
  final String assignedToName;
  final String createdById;
  final String createdByName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? checkedInAt;
  final DateTime? checkedOutAt;
  final DateTime? completedAt;
  final String? photoUrls;
  final String? checkInPhotoUrl;
  final String? completionPhotoUrl;
  final String syncStatus;
  final int syncRetryCount;
  final String? completionNotes;
  const TaskEntity(
      {required this.id,
      required this.title,
      this.description,
      required this.dueDateTime,
      required this.status,
      required this.priority,
      required this.latitude,
      required this.longitude,
      this.address,
      required this.assignedToId,
      required this.assignedToName,
      required this.createdById,
      required this.createdByName,
      required this.createdAt,
      required this.updatedAt,
      this.checkedInAt,
      this.checkedOutAt,
      this.completedAt,
      this.photoUrls,
      this.checkInPhotoUrl,
      this.completionPhotoUrl,
      required this.syncStatus,
      required this.syncRetryCount,
      this.completionNotes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['due_date_time'] = Variable<DateTime>(dueDateTime);
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['assigned_to_id'] = Variable<String>(assignedToId);
    map['assigned_to_name'] = Variable<String>(assignedToName);
    map['created_by_id'] = Variable<String>(createdById);
    map['created_by_name'] = Variable<String>(createdByName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || checkedInAt != null) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt);
    }
    if (!nullToAbsent || checkedOutAt != null) {
      map['checked_out_at'] = Variable<DateTime>(checkedOutAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || photoUrls != null) {
      map['photo_urls'] = Variable<String>(photoUrls);
    }
    if (!nullToAbsent || checkInPhotoUrl != null) {
      map['check_in_photo_url'] = Variable<String>(checkInPhotoUrl);
    }
    if (!nullToAbsent || completionPhotoUrl != null) {
      map['completion_photo_url'] = Variable<String>(completionPhotoUrl);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_retry_count'] = Variable<int>(syncRetryCount);
    if (!nullToAbsent || completionNotes != null) {
      map['completion_notes'] = Variable<String>(completionNotes);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDateTime: Value(dueDateTime),
      status: Value(status),
      priority: Value(priority),
      latitude: Value(latitude),
      longitude: Value(longitude),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      assignedToId: Value(assignedToId),
      assignedToName: Value(assignedToName),
      createdById: Value(createdById),
      createdByName: Value(createdByName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      checkedInAt: checkedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedInAt),
      checkedOutAt: checkedOutAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedOutAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      photoUrls: photoUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrls),
      checkInPhotoUrl: checkInPhotoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInPhotoUrl),
      completionPhotoUrl: completionPhotoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(completionPhotoUrl),
      syncStatus: Value(syncStatus),
      syncRetryCount: Value(syncRetryCount),
      completionNotes: completionNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(completionNotes),
    );
  }

  factory TaskEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDateTime: serializer.fromJson<DateTime>(json['dueDateTime']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      address: serializer.fromJson<String?>(json['address']),
      assignedToId: serializer.fromJson<String>(json['assignedToId']),
      assignedToName: serializer.fromJson<String>(json['assignedToName']),
      createdById: serializer.fromJson<String>(json['createdById']),
      createdByName: serializer.fromJson<String>(json['createdByName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      checkedInAt: serializer.fromJson<DateTime?>(json['checkedInAt']),
      checkedOutAt: serializer.fromJson<DateTime?>(json['checkedOutAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      photoUrls: serializer.fromJson<String?>(json['photoUrls']),
      checkInPhotoUrl: serializer.fromJson<String?>(json['checkInPhotoUrl']),
      completionPhotoUrl:
          serializer.fromJson<String?>(json['completionPhotoUrl']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncRetryCount: serializer.fromJson<int>(json['syncRetryCount']),
      completionNotes: serializer.fromJson<String?>(json['completionNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDateTime': serializer.toJson<DateTime>(dueDateTime),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'address': serializer.toJson<String?>(address),
      'assignedToId': serializer.toJson<String>(assignedToId),
      'assignedToName': serializer.toJson<String>(assignedToName),
      'createdById': serializer.toJson<String>(createdById),
      'createdByName': serializer.toJson<String>(createdByName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'checkedInAt': serializer.toJson<DateTime?>(checkedInAt),
      'checkedOutAt': serializer.toJson<DateTime?>(checkedOutAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'photoUrls': serializer.toJson<String?>(photoUrls),
      'checkInPhotoUrl': serializer.toJson<String?>(checkInPhotoUrl),
      'completionPhotoUrl': serializer.toJson<String?>(completionPhotoUrl),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncRetryCount': serializer.toJson<int>(syncRetryCount),
      'completionNotes': serializer.toJson<String?>(completionNotes),
    };
  }

  TaskEntity copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? dueDateTime,
          String? status,
          String? priority,
          double? latitude,
          double? longitude,
          Value<String?> address = const Value.absent(),
          String? assignedToId,
          String? assignedToName,
          String? createdById,
          String? createdByName,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> checkedInAt = const Value.absent(),
          Value<DateTime?> checkedOutAt = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> photoUrls = const Value.absent(),
          Value<String?> checkInPhotoUrl = const Value.absent(),
          Value<String?> completionPhotoUrl = const Value.absent(),
          String? syncStatus,
          int? syncRetryCount,
          Value<String?> completionNotes = const Value.absent()}) =>
      TaskEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        dueDateTime: dueDateTime ?? this.dueDateTime,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address.present ? address.value : this.address,
        assignedToId: assignedToId ?? this.assignedToId,
        assignedToName: assignedToName ?? this.assignedToName,
        createdById: createdById ?? this.createdById,
        createdByName: createdByName ?? this.createdByName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        checkedInAt: checkedInAt.present ? checkedInAt.value : this.checkedInAt,
        checkedOutAt:
            checkedOutAt.present ? checkedOutAt.value : this.checkedOutAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        photoUrls: photoUrls.present ? photoUrls.value : this.photoUrls,
        checkInPhotoUrl: checkInPhotoUrl.present
            ? checkInPhotoUrl.value
            : this.checkInPhotoUrl,
        completionPhotoUrl: completionPhotoUrl.present
            ? completionPhotoUrl.value
            : this.completionPhotoUrl,
        syncStatus: syncStatus ?? this.syncStatus,
        syncRetryCount: syncRetryCount ?? this.syncRetryCount,
        completionNotes: completionNotes.present
            ? completionNotes.value
            : this.completionNotes,
      );
  TaskEntity copyWithCompanion(TasksCompanion data) {
    return TaskEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      dueDateTime:
          data.dueDateTime.present ? data.dueDateTime.value : this.dueDateTime,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      address: data.address.present ? data.address.value : this.address,
      assignedToId: data.assignedToId.present
          ? data.assignedToId.value
          : this.assignedToId,
      assignedToName: data.assignedToName.present
          ? data.assignedToName.value
          : this.assignedToName,
      createdById:
          data.createdById.present ? data.createdById.value : this.createdById,
      createdByName: data.createdByName.present
          ? data.createdByName.value
          : this.createdByName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      checkedInAt:
          data.checkedInAt.present ? data.checkedInAt.value : this.checkedInAt,
      checkedOutAt: data.checkedOutAt.present
          ? data.checkedOutAt.value
          : this.checkedOutAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      photoUrls: data.photoUrls.present ? data.photoUrls.value : this.photoUrls,
      checkInPhotoUrl: data.checkInPhotoUrl.present
          ? data.checkInPhotoUrl.value
          : this.checkInPhotoUrl,
      completionPhotoUrl: data.completionPhotoUrl.present
          ? data.completionPhotoUrl.value
          : this.completionPhotoUrl,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncRetryCount: data.syncRetryCount.present
          ? data.syncRetryCount.value
          : this.syncRetryCount,
      completionNotes: data.completionNotes.present
          ? data.completionNotes.value
          : this.completionNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('assignedToId: $assignedToId, ')
          ..write('assignedToName: $assignedToName, ')
          ..write('createdById: $createdById, ')
          ..write('createdByName: $createdByName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('checkedOutAt: $checkedOutAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('photoUrls: $photoUrls, ')
          ..write('checkInPhotoUrl: $checkInPhotoUrl, ')
          ..write('completionPhotoUrl: $completionPhotoUrl, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncRetryCount: $syncRetryCount, ')
          ..write('completionNotes: $completionNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        description,
        dueDateTime,
        status,
        priority,
        latitude,
        longitude,
        address,
        assignedToId,
        assignedToName,
        createdById,
        createdByName,
        createdAt,
        updatedAt,
        checkedInAt,
        checkedOutAt,
        completedAt,
        photoUrls,
        checkInPhotoUrl,
        completionPhotoUrl,
        syncStatus,
        syncRetryCount,
        completionNotes
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDateTime == this.dueDateTime &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.address == this.address &&
          other.assignedToId == this.assignedToId &&
          other.assignedToName == this.assignedToName &&
          other.createdById == this.createdById &&
          other.createdByName == this.createdByName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.checkedInAt == this.checkedInAt &&
          other.checkedOutAt == this.checkedOutAt &&
          other.completedAt == this.completedAt &&
          other.photoUrls == this.photoUrls &&
          other.checkInPhotoUrl == this.checkInPhotoUrl &&
          other.completionPhotoUrl == this.completionPhotoUrl &&
          other.syncStatus == this.syncStatus &&
          other.syncRetryCount == this.syncRetryCount &&
          other.completionNotes == this.completionNotes);
}

class TasksCompanion extends UpdateCompanion<TaskEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> dueDateTime;
  final Value<String> status;
  final Value<String> priority;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> address;
  final Value<String> assignedToId;
  final Value<String> assignedToName;
  final Value<String> createdById;
  final Value<String> createdByName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> checkedInAt;
  final Value<DateTime?> checkedOutAt;
  final Value<DateTime?> completedAt;
  final Value<String?> photoUrls;
  final Value<String?> checkInPhotoUrl;
  final Value<String?> completionPhotoUrl;
  final Value<String> syncStatus;
  final Value<int> syncRetryCount;
  final Value<String?> completionNotes;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDateTime = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.assignedToId = const Value.absent(),
    this.assignedToName = const Value.absent(),
    this.createdById = const Value.absent(),
    this.createdByName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.checkedInAt = const Value.absent(),
    this.checkedOutAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.photoUrls = const Value.absent(),
    this.checkInPhotoUrl = const Value.absent(),
    this.completionPhotoUrl = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncRetryCount = const Value.absent(),
    this.completionNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required DateTime dueDateTime,
    required String status,
    required String priority,
    required double latitude,
    required double longitude,
    this.address = const Value.absent(),
    required String assignedToId,
    required String assignedToName,
    required String createdById,
    required String createdByName,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.checkedInAt = const Value.absent(),
    this.checkedOutAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.photoUrls = const Value.absent(),
    this.checkInPhotoUrl = const Value.absent(),
    this.completionPhotoUrl = const Value.absent(),
    required String syncStatus,
    this.syncRetryCount = const Value.absent(),
    this.completionNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        dueDateTime = Value(dueDateTime),
        status = Value(status),
        priority = Value(priority),
        latitude = Value(latitude),
        longitude = Value(longitude),
        assignedToId = Value(assignedToId),
        assignedToName = Value(assignedToName),
        createdById = Value(createdById),
        createdByName = Value(createdByName),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        syncStatus = Value(syncStatus);
  static Insertable<TaskEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDateTime,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? address,
    Expression<String>? assignedToId,
    Expression<String>? assignedToName,
    Expression<String>? createdById,
    Expression<String>? createdByName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? checkedInAt,
    Expression<DateTime>? checkedOutAt,
    Expression<DateTime>? completedAt,
    Expression<String>? photoUrls,
    Expression<String>? checkInPhotoUrl,
    Expression<String>? completionPhotoUrl,
    Expression<String>? syncStatus,
    Expression<int>? syncRetryCount,
    Expression<String>? completionNotes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDateTime != null) 'due_date_time': dueDateTime,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
      if (assignedToId != null) 'assigned_to_id': assignedToId,
      if (assignedToName != null) 'assigned_to_name': assignedToName,
      if (createdById != null) 'created_by_id': createdById,
      if (createdByName != null) 'created_by_name': createdByName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (checkedInAt != null) 'checked_in_at': checkedInAt,
      if (checkedOutAt != null) 'checked_out_at': checkedOutAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (photoUrls != null) 'photo_urls': photoUrls,
      if (checkInPhotoUrl != null) 'check_in_photo_url': checkInPhotoUrl,
      if (completionPhotoUrl != null)
        'completion_photo_url': completionPhotoUrl,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncRetryCount != null) 'sync_retry_count': syncRetryCount,
      if (completionNotes != null) 'completion_notes': completionNotes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? dueDateTime,
      Value<String>? status,
      Value<String>? priority,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String?>? address,
      Value<String>? assignedToId,
      Value<String>? assignedToName,
      Value<String>? createdById,
      Value<String>? createdByName,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? checkedInAt,
      Value<DateTime?>? checkedOutAt,
      Value<DateTime?>? completedAt,
      Value<String?>? photoUrls,
      Value<String?>? checkInPhotoUrl,
      Value<String?>? completionPhotoUrl,
      Value<String>? syncStatus,
      Value<int>? syncRetryCount,
      Value<String?>? completionNotes,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToName: assignedToName ?? this.assignedToName,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      checkedOutAt: checkedOutAt ?? this.checkedOutAt,
      completedAt: completedAt ?? this.completedAt,
      photoUrls: photoUrls ?? this.photoUrls,
      checkInPhotoUrl: checkInPhotoUrl ?? this.checkInPhotoUrl,
      completionPhotoUrl: completionPhotoUrl ?? this.completionPhotoUrl,
      syncStatus: syncStatus ?? this.syncStatus,
      syncRetryCount: syncRetryCount ?? this.syncRetryCount,
      completionNotes: completionNotes ?? this.completionNotes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDateTime.present) {
      map['due_date_time'] = Variable<DateTime>(dueDateTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (assignedToId.present) {
      map['assigned_to_id'] = Variable<String>(assignedToId.value);
    }
    if (assignedToName.present) {
      map['assigned_to_name'] = Variable<String>(assignedToName.value);
    }
    if (createdById.present) {
      map['created_by_id'] = Variable<String>(createdById.value);
    }
    if (createdByName.present) {
      map['created_by_name'] = Variable<String>(createdByName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (checkedInAt.present) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt.value);
    }
    if (checkedOutAt.present) {
      map['checked_out_at'] = Variable<DateTime>(checkedOutAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (photoUrls.present) {
      map['photo_urls'] = Variable<String>(photoUrls.value);
    }
    if (checkInPhotoUrl.present) {
      map['check_in_photo_url'] = Variable<String>(checkInPhotoUrl.value);
    }
    if (completionPhotoUrl.present) {
      map['completion_photo_url'] = Variable<String>(completionPhotoUrl.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncRetryCount.present) {
      map['sync_retry_count'] = Variable<int>(syncRetryCount.value);
    }
    if (completionNotes.present) {
      map['completion_notes'] = Variable<String>(completionNotes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('assignedToId: $assignedToId, ')
          ..write('assignedToName: $assignedToName, ')
          ..write('createdById: $createdById, ')
          ..write('createdByName: $createdByName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('checkedOutAt: $checkedOutAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('photoUrls: $photoUrls, ')
          ..write('checkInPhotoUrl: $checkInPhotoUrl, ')
          ..write('completionPhotoUrl: $completionPhotoUrl, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncRetryCount: $syncRetryCount, ')
          ..write('completionNotes: $completionNotes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _photoUrlMeta =
      const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
      'photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _departmentMeta =
      const VerificationMeta('department');
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
      'department', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        email,
        displayName,
        photoUrl,
        role,
        createdAt,
        updatedAt,
        isActive,
        phoneNumber,
        department
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<UserEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(_photoUrlMeta,
          photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('department')) {
      context.handle(
          _departmentMeta,
          department.isAcceptableOrUnknown(
              data['department']!, _departmentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      photoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_url']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      department: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}department']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String? phoneNumber;
  final String? department;
  const UserEntity(
      {required this.id,
      required this.email,
      required this.displayName,
      this.photoUrl,
      required this.role,
      required this.createdAt,
      required this.updatedAt,
      required this.isActive,
      this.phoneNumber,
      this.department});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      displayName: Value(displayName),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      role: Value(role),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isActive: Value(isActive),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntity(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String>(json['displayName']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      department: serializer.fromJson<String?>(json['department']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String>(displayName),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isActive': serializer.toJson<bool>(isActive),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'department': serializer.toJson<String?>(department),
    };
  }

  UserEntity copyWith(
          {String? id,
          String? email,
          String? displayName,
          Value<String?> photoUrl = const Value.absent(),
          String? role,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isActive,
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> department = const Value.absent()}) =>
      UserEntity(
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isActive: isActive ?? this.isActive,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        department: department.present ? department.value : this.department,
      );
  UserEntity copyWithCompanion(UsersCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      department:
          data.department.present ? data.department.value : this.department,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntity(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('department: $department')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, displayName, photoUrl, role,
      createdAt, updatedAt, isActive, phoneNumber, department);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.photoUrl == this.photoUrl &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isActive == this.isActive &&
          other.phoneNumber == this.phoneNumber &&
          other.department == this.department);
}

class UsersCompanion extends UpdateCompanion<UserEntity> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> displayName;
  final Value<String?> photoUrl;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isActive;
  final Value<String?> phoneNumber;
  final Value<String?> department;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String displayName,
    this.photoUrl = const Value.absent(),
    required String role,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isActive = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        email = Value(email),
        displayName = Value(displayName),
        role = Value(role),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<UserEntity> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? photoUrl,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isActive,
    Expression<String>? phoneNumber,
    Expression<String>? department,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isActive != null) 'is_active': isActive,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (department != null) 'department': department,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? email,
      Value<String>? displayName,
      Value<String?>? photoUrl,
      Value<String>? role,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isActive,
      Value<String?>? phoneNumber,
      Value<String?>? department,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('department: $department, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastRetryAtMeta =
      const VerificationMeta('lastRetryAt');
  @override
  late final GeneratedColumn<DateTime> lastRetryAt = GeneratedColumn<DateTime>(
      'last_retry_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskId,
        operation,
        payload,
        timestamp,
        retryCount,
        lastRetryAt,
        errorMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('last_retry_at')) {
      context.handle(
          _lastRetryAtMeta,
          lastRetryAt.isAcceptableOrUnknown(
              data['last_retry_at']!, _lastRetryAtMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      lastRetryAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_retry_at']),
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueEntity extends DataClass implements Insertable<SyncQueueEntity> {
  final String id;
  final String taskId;
  final String operation;
  final String payload;
  final DateTime timestamp;
  final int retryCount;
  final DateTime? lastRetryAt;
  final String? errorMessage;
  const SyncQueueEntity(
      {required this.id,
      required this.taskId,
      required this.operation,
      required this.payload,
      required this.timestamp,
      required this.retryCount,
      this.lastRetryAt,
      this.errorMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastRetryAt != null) {
      map['last_retry_at'] = Variable<DateTime>(lastRetryAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      taskId: Value(taskId),
      operation: Value(operation),
      payload: Value(payload),
      timestamp: Value(timestamp),
      retryCount: Value(retryCount),
      lastRetryAt: lastRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRetryAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory SyncQueueEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueEntity(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastRetryAt: serializer.fromJson<DateTime?>(json['lastRetryAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastRetryAt': serializer.toJson<DateTime?>(lastRetryAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  SyncQueueEntity copyWith(
          {String? id,
          String? taskId,
          String? operation,
          String? payload,
          DateTime? timestamp,
          int? retryCount,
          Value<DateTime?> lastRetryAt = const Value.absent(),
          Value<String?> errorMessage = const Value.absent()}) =>
      SyncQueueEntity(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        timestamp: timestamp ?? this.timestamp,
        retryCount: retryCount ?? this.retryCount,
        lastRetryAt: lastRetryAt.present ? lastRetryAt.value : this.lastRetryAt,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
      );
  SyncQueueEntity copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueEntity(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      lastRetryAt:
          data.lastRetryAt.present ? data.lastRetryAt.value : this.lastRetryAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntity(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('timestamp: $timestamp, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastRetryAt: $lastRetryAt, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, operation, payload, timestamp,
      retryCount, lastRetryAt, errorMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueEntity &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.timestamp == this.timestamp &&
          other.retryCount == this.retryCount &&
          other.lastRetryAt == this.lastRetryAt &&
          other.errorMessage == this.errorMessage);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueEntity> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> timestamp;
  final Value<int> retryCount;
  final Value<DateTime?> lastRetryAt;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastRetryAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String taskId,
    required String operation,
    required String payload,
    required DateTime timestamp,
    this.retryCount = const Value.absent(),
    this.lastRetryAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        operation = Value(operation),
        payload = Value(payload),
        timestamp = Value(timestamp);
  static Insertable<SyncQueueEntity> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? timestamp,
    Expression<int>? retryCount,
    Expression<DateTime>? lastRetryAt,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (timestamp != null) 'timestamp': timestamp,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastRetryAt != null) 'last_retry_at': lastRetryAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? operation,
      Value<String>? payload,
      Value<DateTime>? timestamp,
      Value<int>? retryCount,
      Value<DateTime?>? lastRetryAt,
      Value<String?>? errorMessage,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      lastRetryAt: lastRetryAt ?? this.lastRetryAt,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastRetryAt.present) {
      map['last_retry_at'] = Variable<DateTime>(lastRetryAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('timestamp: $timestamp, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastRetryAt: $lastRetryAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksStatsTable extends TasksStats
    with TableInfo<$TasksStatsTable, TaskStatsEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalTasksMeta =
      const VerificationMeta('totalTasks');
  @override
  late final GeneratedColumn<int> totalTasks = GeneratedColumn<int>(
      'total_tasks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pendingTasksMeta =
      const VerificationMeta('pendingTasks');
  @override
  late final GeneratedColumn<int> pendingTasks = GeneratedColumn<int>(
      'pending_tasks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedTasksMeta =
      const VerificationMeta('completedTasks');
  @override
  late final GeneratedColumn<int> completedTasks = GeneratedColumn<int>(
      'completed_tasks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _checkedInTasksMeta =
      const VerificationMeta('checkedInTasks');
  @override
  late final GeneratedColumn<int> checkedInTasks = GeneratedColumn<int>(
      'checked_in_tasks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _expiredTasksMeta =
      const VerificationMeta('expiredTasks');
  @override
  late final GeneratedColumn<int> expiredTasks = GeneratedColumn<int>(
      'expired_tasks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dueTodayTasksMeta =
      const VerificationMeta('dueTodayTasks');
  @override
  late final GeneratedColumn<int> dueTodayTasks = GeneratedColumn<int>(
      'due_today_tasks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        totalTasks,
        pendingTasks,
        completedTasks,
        checkedInTasks,
        expiredTasks,
        dueTodayTasks,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_stats';
  @override
  VerificationContext validateIntegrity(Insertable<TaskStatsEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('total_tasks')) {
      context.handle(
          _totalTasksMeta,
          totalTasks.isAcceptableOrUnknown(
              data['total_tasks']!, _totalTasksMeta));
    }
    if (data.containsKey('pending_tasks')) {
      context.handle(
          _pendingTasksMeta,
          pendingTasks.isAcceptableOrUnknown(
              data['pending_tasks']!, _pendingTasksMeta));
    }
    if (data.containsKey('completed_tasks')) {
      context.handle(
          _completedTasksMeta,
          completedTasks.isAcceptableOrUnknown(
              data['completed_tasks']!, _completedTasksMeta));
    }
    if (data.containsKey('checked_in_tasks')) {
      context.handle(
          _checkedInTasksMeta,
          checkedInTasks.isAcceptableOrUnknown(
              data['checked_in_tasks']!, _checkedInTasksMeta));
    }
    if (data.containsKey('expired_tasks')) {
      context.handle(
          _expiredTasksMeta,
          expiredTasks.isAcceptableOrUnknown(
              data['expired_tasks']!, _expiredTasksMeta));
    }
    if (data.containsKey('due_today_tasks')) {
      context.handle(
          _dueTodayTasksMeta,
          dueTodayTasks.isAcceptableOrUnknown(
              data['due_today_tasks']!, _dueTodayTasksMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskStatsEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskStatsEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      totalTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_tasks'])!,
      pendingTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pending_tasks'])!,
      completedTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_tasks'])!,
      checkedInTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}checked_in_tasks'])!,
      expiredTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expired_tasks'])!,
      dueTodayTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_today_tasks'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TasksStatsTable createAlias(String alias) {
    return $TasksStatsTable(attachedDatabase, alias);
  }
}

class TaskStatsEntity extends DataClass implements Insertable<TaskStatsEntity> {
  final String id;
  final String userId;
  final int totalTasks;
  final int pendingTasks;
  final int completedTasks;
  final int checkedInTasks;
  final int expiredTasks;
  final int dueTodayTasks;
  final DateTime updatedAt;
  const TaskStatsEntity(
      {required this.id,
      required this.userId,
      required this.totalTasks,
      required this.pendingTasks,
      required this.completedTasks,
      required this.checkedInTasks,
      required this.expiredTasks,
      required this.dueTodayTasks,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['total_tasks'] = Variable<int>(totalTasks);
    map['pending_tasks'] = Variable<int>(pendingTasks);
    map['completed_tasks'] = Variable<int>(completedTasks);
    map['checked_in_tasks'] = Variable<int>(checkedInTasks);
    map['expired_tasks'] = Variable<int>(expiredTasks);
    map['due_today_tasks'] = Variable<int>(dueTodayTasks);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksStatsCompanion toCompanion(bool nullToAbsent) {
    return TasksStatsCompanion(
      id: Value(id),
      userId: Value(userId),
      totalTasks: Value(totalTasks),
      pendingTasks: Value(pendingTasks),
      completedTasks: Value(completedTasks),
      checkedInTasks: Value(checkedInTasks),
      expiredTasks: Value(expiredTasks),
      dueTodayTasks: Value(dueTodayTasks),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskStatsEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskStatsEntity(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      totalTasks: serializer.fromJson<int>(json['totalTasks']),
      pendingTasks: serializer.fromJson<int>(json['pendingTasks']),
      completedTasks: serializer.fromJson<int>(json['completedTasks']),
      checkedInTasks: serializer.fromJson<int>(json['checkedInTasks']),
      expiredTasks: serializer.fromJson<int>(json['expiredTasks']),
      dueTodayTasks: serializer.fromJson<int>(json['dueTodayTasks']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'totalTasks': serializer.toJson<int>(totalTasks),
      'pendingTasks': serializer.toJson<int>(pendingTasks),
      'completedTasks': serializer.toJson<int>(completedTasks),
      'checkedInTasks': serializer.toJson<int>(checkedInTasks),
      'expiredTasks': serializer.toJson<int>(expiredTasks),
      'dueTodayTasks': serializer.toJson<int>(dueTodayTasks),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskStatsEntity copyWith(
          {String? id,
          String? userId,
          int? totalTasks,
          int? pendingTasks,
          int? completedTasks,
          int? checkedInTasks,
          int? expiredTasks,
          int? dueTodayTasks,
          DateTime? updatedAt}) =>
      TaskStatsEntity(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        totalTasks: totalTasks ?? this.totalTasks,
        pendingTasks: pendingTasks ?? this.pendingTasks,
        completedTasks: completedTasks ?? this.completedTasks,
        checkedInTasks: checkedInTasks ?? this.checkedInTasks,
        expiredTasks: expiredTasks ?? this.expiredTasks,
        dueTodayTasks: dueTodayTasks ?? this.dueTodayTasks,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TaskStatsEntity copyWithCompanion(TasksStatsCompanion data) {
    return TaskStatsEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      totalTasks:
          data.totalTasks.present ? data.totalTasks.value : this.totalTasks,
      pendingTasks: data.pendingTasks.present
          ? data.pendingTasks.value
          : this.pendingTasks,
      completedTasks: data.completedTasks.present
          ? data.completedTasks.value
          : this.completedTasks,
      checkedInTasks: data.checkedInTasks.present
          ? data.checkedInTasks.value
          : this.checkedInTasks,
      expiredTasks: data.expiredTasks.present
          ? data.expiredTasks.value
          : this.expiredTasks,
      dueTodayTasks: data.dueTodayTasks.present
          ? data.dueTodayTasks.value
          : this.dueTodayTasks,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskStatsEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('totalTasks: $totalTasks, ')
          ..write('pendingTasks: $pendingTasks, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('checkedInTasks: $checkedInTasks, ')
          ..write('expiredTasks: $expiredTasks, ')
          ..write('dueTodayTasks: $dueTodayTasks, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, totalTasks, pendingTasks,
      completedTasks, checkedInTasks, expiredTasks, dueTodayTasks, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskStatsEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.totalTasks == this.totalTasks &&
          other.pendingTasks == this.pendingTasks &&
          other.completedTasks == this.completedTasks &&
          other.checkedInTasks == this.checkedInTasks &&
          other.expiredTasks == this.expiredTasks &&
          other.dueTodayTasks == this.dueTodayTasks &&
          other.updatedAt == this.updatedAt);
}

class TasksStatsCompanion extends UpdateCompanion<TaskStatsEntity> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> totalTasks;
  final Value<int> pendingTasks;
  final Value<int> completedTasks;
  final Value<int> checkedInTasks;
  final Value<int> expiredTasks;
  final Value<int> dueTodayTasks;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksStatsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.totalTasks = const Value.absent(),
    this.pendingTasks = const Value.absent(),
    this.completedTasks = const Value.absent(),
    this.checkedInTasks = const Value.absent(),
    this.expiredTasks = const Value.absent(),
    this.dueTodayTasks = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksStatsCompanion.insert({
    required String id,
    required String userId,
    this.totalTasks = const Value.absent(),
    this.pendingTasks = const Value.absent(),
    this.completedTasks = const Value.absent(),
    this.checkedInTasks = const Value.absent(),
    this.expiredTasks = const Value.absent(),
    this.dueTodayTasks = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        updatedAt = Value(updatedAt);
  static Insertable<TaskStatsEntity> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? totalTasks,
    Expression<int>? pendingTasks,
    Expression<int>? completedTasks,
    Expression<int>? checkedInTasks,
    Expression<int>? expiredTasks,
    Expression<int>? dueTodayTasks,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (totalTasks != null) 'total_tasks': totalTasks,
      if (pendingTasks != null) 'pending_tasks': pendingTasks,
      if (completedTasks != null) 'completed_tasks': completedTasks,
      if (checkedInTasks != null) 'checked_in_tasks': checkedInTasks,
      if (expiredTasks != null) 'expired_tasks': expiredTasks,
      if (dueTodayTasks != null) 'due_today_tasks': dueTodayTasks,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksStatsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? totalTasks,
      Value<int>? pendingTasks,
      Value<int>? completedTasks,
      Value<int>? checkedInTasks,
      Value<int>? expiredTasks,
      Value<int>? dueTodayTasks,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TasksStatsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalTasks: totalTasks ?? this.totalTasks,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      checkedInTasks: checkedInTasks ?? this.checkedInTasks,
      expiredTasks: expiredTasks ?? this.expiredTasks,
      dueTodayTasks: dueTodayTasks ?? this.dueTodayTasks,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (totalTasks.present) {
      map['total_tasks'] = Variable<int>(totalTasks.value);
    }
    if (pendingTasks.present) {
      map['pending_tasks'] = Variable<int>(pendingTasks.value);
    }
    if (completedTasks.present) {
      map['completed_tasks'] = Variable<int>(completedTasks.value);
    }
    if (checkedInTasks.present) {
      map['checked_in_tasks'] = Variable<int>(checkedInTasks.value);
    }
    if (expiredTasks.present) {
      map['expired_tasks'] = Variable<int>(expiredTasks.value);
    }
    if (dueTodayTasks.present) {
      map['due_today_tasks'] = Variable<int>(dueTodayTasks.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksStatsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('totalTasks: $totalTasks, ')
          ..write('pendingTasks: $pendingTasks, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('checkedInTasks: $checkedInTasks, ')
          ..write('expiredTasks: $expiredTasks, ')
          ..write('dueTodayTasks: $dueTodayTasks, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $TasksStatsTable tasksStats = $TasksStatsTable(this);
  late final TaskDao taskDao = TaskDao(this as AppDatabase);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [tasks, users, syncQueue, tasksStats];
}

typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  required DateTime dueDateTime,
  required String status,
  required String priority,
  required double latitude,
  required double longitude,
  Value<String?> address,
  required String assignedToId,
  required String assignedToName,
  required String createdById,
  required String createdByName,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> checkedInAt,
  Value<DateTime?> checkedOutAt,
  Value<DateTime?> completedAt,
  Value<String?> photoUrls,
  Value<String?> checkInPhotoUrl,
  Value<String?> completionPhotoUrl,
  required String syncStatus,
  Value<int> syncRetryCount,
  Value<String?> completionNotes,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> dueDateTime,
  Value<String> status,
  Value<String> priority,
  Value<double> latitude,
  Value<double> longitude,
  Value<String?> address,
  Value<String> assignedToId,
  Value<String> assignedToName,
  Value<String> createdById,
  Value<String> createdByName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> checkedInAt,
  Value<DateTime?> checkedOutAt,
  Value<DateTime?> completedAt,
  Value<String?> photoUrls,
  Value<String?> checkInPhotoUrl,
  Value<String?> completionPhotoUrl,
  Value<String> syncStatus,
  Value<int> syncRetryCount,
  Value<String?> completionNotes,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDateTime => $composableBuilder(
      column: $table.dueDateTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignedToId => $composableBuilder(
      column: $table.assignedToId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignedToName => $composableBuilder(
      column: $table.assignedToName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdByName => $composableBuilder(
      column: $table.createdByName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkedInAt => $composableBuilder(
      column: $table.checkedInAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkedOutAt => $composableBuilder(
      column: $table.checkedOutAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrls => $composableBuilder(
      column: $table.photoUrls, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkInPhotoUrl => $composableBuilder(
      column: $table.checkInPhotoUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completionPhotoUrl => $composableBuilder(
      column: $table.completionPhotoUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncRetryCount => $composableBuilder(
      column: $table.syncRetryCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completionNotes => $composableBuilder(
      column: $table.completionNotes,
      builder: (column) => ColumnFilters(column));
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDateTime => $composableBuilder(
      column: $table.dueDateTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedToId => $composableBuilder(
      column: $table.assignedToId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedToName => $composableBuilder(
      column: $table.assignedToName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdByName => $composableBuilder(
      column: $table.createdByName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkedInAt => $composableBuilder(
      column: $table.checkedInAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkedOutAt => $composableBuilder(
      column: $table.checkedOutAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrls => $composableBuilder(
      column: $table.photoUrls, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkInPhotoUrl => $composableBuilder(
      column: $table.checkInPhotoUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completionPhotoUrl => $composableBuilder(
      column: $table.completionPhotoUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncRetryCount => $composableBuilder(
      column: $table.syncRetryCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completionNotes => $composableBuilder(
      column: $table.completionNotes,
      builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDateTime => $composableBuilder(
      column: $table.dueDateTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get assignedToId => $composableBuilder(
      column: $table.assignedToId, builder: (column) => column);

  GeneratedColumn<String> get assignedToName => $composableBuilder(
      column: $table.assignedToName, builder: (column) => column);

  GeneratedColumn<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => column);

  GeneratedColumn<String> get createdByName => $composableBuilder(
      column: $table.createdByName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedInAt => $composableBuilder(
      column: $table.checkedInAt, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedOutAt => $composableBuilder(
      column: $table.checkedOutAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get photoUrls =>
      $composableBuilder(column: $table.photoUrls, builder: (column) => column);

  GeneratedColumn<String> get checkInPhotoUrl => $composableBuilder(
      column: $table.checkInPhotoUrl, builder: (column) => column);

  GeneratedColumn<String> get completionPhotoUrl => $composableBuilder(
      column: $table.completionPhotoUrl, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get syncRetryCount => $composableBuilder(
      column: $table.syncRetryCount, builder: (column) => column);

  GeneratedColumn<String> get completionNotes => $composableBuilder(
      column: $table.completionNotes, builder: (column) => column);
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskEntity,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskEntity, BaseReferences<_$AppDatabase, $TasksTable, TaskEntity>),
    TaskEntity,
    PrefetchHooks Function()> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> dueDateTime = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> assignedToId = const Value.absent(),
            Value<String> assignedToName = const Value.absent(),
            Value<String> createdById = const Value.absent(),
            Value<String> createdByName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> checkedInAt = const Value.absent(),
            Value<DateTime?> checkedOutAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> photoUrls = const Value.absent(),
            Value<String?> checkInPhotoUrl = const Value.absent(),
            Value<String?> completionPhotoUrl = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> syncRetryCount = const Value.absent(),
            Value<String?> completionNotes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            title: title,
            description: description,
            dueDateTime: dueDateTime,
            status: status,
            priority: priority,
            latitude: latitude,
            longitude: longitude,
            address: address,
            assignedToId: assignedToId,
            assignedToName: assignedToName,
            createdById: createdById,
            createdByName: createdByName,
            createdAt: createdAt,
            updatedAt: updatedAt,
            checkedInAt: checkedInAt,
            checkedOutAt: checkedOutAt,
            completedAt: completedAt,
            photoUrls: photoUrls,
            checkInPhotoUrl: checkInPhotoUrl,
            completionPhotoUrl: completionPhotoUrl,
            syncStatus: syncStatus,
            syncRetryCount: syncRetryCount,
            completionNotes: completionNotes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime dueDateTime,
            required String status,
            required String priority,
            required double latitude,
            required double longitude,
            Value<String?> address = const Value.absent(),
            required String assignedToId,
            required String assignedToName,
            required String createdById,
            required String createdByName,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> checkedInAt = const Value.absent(),
            Value<DateTime?> checkedOutAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> photoUrls = const Value.absent(),
            Value<String?> checkInPhotoUrl = const Value.absent(),
            Value<String?> completionPhotoUrl = const Value.absent(),
            required String syncStatus,
            Value<int> syncRetryCount = const Value.absent(),
            Value<String?> completionNotes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            title: title,
            description: description,
            dueDateTime: dueDateTime,
            status: status,
            priority: priority,
            latitude: latitude,
            longitude: longitude,
            address: address,
            assignedToId: assignedToId,
            assignedToName: assignedToName,
            createdById: createdById,
            createdByName: createdByName,
            createdAt: createdAt,
            updatedAt: updatedAt,
            checkedInAt: checkedInAt,
            checkedOutAt: checkedOutAt,
            completedAt: completedAt,
            photoUrls: photoUrls,
            checkInPhotoUrl: checkInPhotoUrl,
            completionPhotoUrl: completionPhotoUrl,
            syncStatus: syncStatus,
            syncRetryCount: syncRetryCount,
            completionNotes: completionNotes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskEntity,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskEntity, BaseReferences<_$AppDatabase, $TasksTable, TaskEntity>),
    TaskEntity,
    PrefetchHooks Function()>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String email,
  required String displayName,
  Value<String?> photoUrl,
  required String role,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isActive,
  Value<String?> phoneNumber,
  Value<String?> department,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> email,
  Value<String> displayName,
  Value<String?> photoUrl,
  Value<String> role,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isActive,
  Value<String?> phoneNumber,
  Value<String?> department,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    UserEntity,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (UserEntity, BaseReferences<_$AppDatabase, $UsersTable, UserEntity>),
    UserEntity,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> department = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            email: email,
            displayName: displayName,
            photoUrl: photoUrl,
            role: role,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isActive: isActive,
            phoneNumber: phoneNumber,
            department: department,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String email,
            required String displayName,
            Value<String?> photoUrl = const Value.absent(),
            required String role,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isActive = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> department = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            email: email,
            displayName: displayName,
            photoUrl: photoUrl,
            role: role,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isActive: isActive,
            phoneNumber: phoneNumber,
            department: department,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    UserEntity,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (UserEntity, BaseReferences<_$AppDatabase, $UsersTable, UserEntity>),
    UserEntity,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  required String taskId,
  required String operation,
  required String payload,
  required DateTime timestamp,
  Value<int> retryCount,
  Value<DateTime?> lastRetryAt,
  Value<String?> errorMessage,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> operation,
  Value<String> payload,
  Value<DateTime> timestamp,
  Value<int> retryCount,
  Value<DateTime?> lastRetryAt,
  Value<String?> errorMessage,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastRetryAt => $composableBuilder(
      column: $table.lastRetryAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastRetryAt => $composableBuilder(
      column: $table.lastRetryAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRetryAt => $composableBuilder(
      column: $table.lastRetryAt, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueEntity,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueEntity,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueEntity>
    ),
    SyncQueueEntity,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime?> lastRetryAt = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            taskId: taskId,
            operation: operation,
            payload: payload,
            timestamp: timestamp,
            retryCount: retryCount,
            lastRetryAt: lastRetryAt,
            errorMessage: errorMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required String operation,
            required String payload,
            required DateTime timestamp,
            Value<int> retryCount = const Value.absent(),
            Value<DateTime?> lastRetryAt = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            taskId: taskId,
            operation: operation,
            payload: payload,
            timestamp: timestamp,
            retryCount: retryCount,
            lastRetryAt: lastRetryAt,
            errorMessage: errorMessage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueEntity,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueEntity,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueEntity>
    ),
    SyncQueueEntity,
    PrefetchHooks Function()>;
typedef $$TasksStatsTableCreateCompanionBuilder = TasksStatsCompanion Function({
  required String id,
  required String userId,
  Value<int> totalTasks,
  Value<int> pendingTasks,
  Value<int> completedTasks,
  Value<int> checkedInTasks,
  Value<int> expiredTasks,
  Value<int> dueTodayTasks,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TasksStatsTableUpdateCompanionBuilder = TasksStatsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<int> totalTasks,
  Value<int> pendingTasks,
  Value<int> completedTasks,
  Value<int> checkedInTasks,
  Value<int> expiredTasks,
  Value<int> dueTodayTasks,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TasksStatsTableFilterComposer
    extends Composer<_$AppDatabase, $TasksStatsTable> {
  $$TasksStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTasks => $composableBuilder(
      column: $table.totalTasks, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pendingTasks => $composableBuilder(
      column: $table.pendingTasks, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedTasks => $composableBuilder(
      column: $table.completedTasks,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checkedInTasks => $composableBuilder(
      column: $table.checkedInTasks,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expiredTasks => $composableBuilder(
      column: $table.expiredTasks, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueTodayTasks => $composableBuilder(
      column: $table.dueTodayTasks, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TasksStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksStatsTable> {
  $$TasksStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTasks => $composableBuilder(
      column: $table.totalTasks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pendingTasks => $composableBuilder(
      column: $table.pendingTasks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedTasks => $composableBuilder(
      column: $table.completedTasks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checkedInTasks => $composableBuilder(
      column: $table.checkedInTasks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expiredTasks => $composableBuilder(
      column: $table.expiredTasks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueTodayTasks => $composableBuilder(
      column: $table.dueTodayTasks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TasksStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksStatsTable> {
  $$TasksStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get totalTasks => $composableBuilder(
      column: $table.totalTasks, builder: (column) => column);

  GeneratedColumn<int> get pendingTasks => $composableBuilder(
      column: $table.pendingTasks, builder: (column) => column);

  GeneratedColumn<int> get completedTasks => $composableBuilder(
      column: $table.completedTasks, builder: (column) => column);

  GeneratedColumn<int> get checkedInTasks => $composableBuilder(
      column: $table.checkedInTasks, builder: (column) => column);

  GeneratedColumn<int> get expiredTasks => $composableBuilder(
      column: $table.expiredTasks, builder: (column) => column);

  GeneratedColumn<int> get dueTodayTasks => $composableBuilder(
      column: $table.dueTodayTasks, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasksStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksStatsTable,
    TaskStatsEntity,
    $$TasksStatsTableFilterComposer,
    $$TasksStatsTableOrderingComposer,
    $$TasksStatsTableAnnotationComposer,
    $$TasksStatsTableCreateCompanionBuilder,
    $$TasksStatsTableUpdateCompanionBuilder,
    (
      TaskStatsEntity,
      BaseReferences<_$AppDatabase, $TasksStatsTable, TaskStatsEntity>
    ),
    TaskStatsEntity,
    PrefetchHooks Function()> {
  $$TasksStatsTableTableManager(_$AppDatabase db, $TasksStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> totalTasks = const Value.absent(),
            Value<int> pendingTasks = const Value.absent(),
            Value<int> completedTasks = const Value.absent(),
            Value<int> checkedInTasks = const Value.absent(),
            Value<int> expiredTasks = const Value.absent(),
            Value<int> dueTodayTasks = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksStatsCompanion(
            id: id,
            userId: userId,
            totalTasks: totalTasks,
            pendingTasks: pendingTasks,
            completedTasks: completedTasks,
            checkedInTasks: checkedInTasks,
            expiredTasks: expiredTasks,
            dueTodayTasks: dueTodayTasks,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<int> totalTasks = const Value.absent(),
            Value<int> pendingTasks = const Value.absent(),
            Value<int> completedTasks = const Value.absent(),
            Value<int> checkedInTasks = const Value.absent(),
            Value<int> expiredTasks = const Value.absent(),
            Value<int> dueTodayTasks = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksStatsCompanion.insert(
            id: id,
            userId: userId,
            totalTasks: totalTasks,
            pendingTasks: pendingTasks,
            completedTasks: completedTasks,
            checkedInTasks: checkedInTasks,
            expiredTasks: expiredTasks,
            dueTodayTasks: dueTodayTasks,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksStatsTable,
    TaskStatsEntity,
    $$TasksStatsTableFilterComposer,
    $$TasksStatsTableOrderingComposer,
    $$TasksStatsTableAnnotationComposer,
    $$TasksStatsTableCreateCompanionBuilder,
    $$TasksStatsTableUpdateCompanionBuilder,
    (
      TaskStatsEntity,
      BaseReferences<_$AppDatabase, $TasksStatsTable, TaskStatsEntity>
    ),
    TaskStatsEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$TasksStatsTableTableManager get tasksStats =>
      $$TasksStatsTableTableManager(_db, _db.tasksStats);
}
