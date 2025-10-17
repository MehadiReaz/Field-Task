├── lib/
│   ├── main.dart
│   │
│   ├── app/                          # App-level configuration
│   │   ├── app.dart                  # MaterialApp configuration
│   │   ├── routes/
│   │   │   ├── app_router.dart       # Go_router configuration
│   │   │   └── route_names.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── app_colors.dart
│   │       └── app_text_styles.dart
│   │
│   ├── core/                         # Shared utilities
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── firebase_constants.dart
│   │   │   └── database_constants.dart
│   │   │
│   │   ├── enums/
│   │   │   ├── task_status.dart
│   │   │   ├── task_priority.dart
│   │   │   ├── user_role.dart
│   │   │   └── sync_status.dart
│   │   │
│   │   ├── errors/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   │
│   │   ├── network/
│   │   │   ├── network_info.dart
│   │   │   └── network_info_impl.dart
│   │   │
│   │   ├── usecases/
│   │   │   └── usecase.dart          # Base UseCase class
│   │   │
│   │   └── utils/
│   │       ├── date_time_utils.dart
│   │       ├── location_utils.dart
│   │       ├── validators.dart
│   │       ├── distance_calculator.dart
│   │       └── logger.dart
│   │
│   ├── features/                     # Feature modules
│   │   │
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── sign_in_with_google.dart
│   │   │   │       ├── sign_in_with_email.dart
│   │   │   │       ├── sign_out.dart
│   │   │   │       ├── get_current_user.dart
│   │   │   │       └── check_auth_status.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── auth_bloc.dart
│   │   │       │   ├── auth_event.dart
│   │   │       │   └── auth_state.dart
│   │   │       ├── pages/
│   │   │       │   ├── splash_page.dart
│   │   │       │   ├── login_page.dart
│   │   │       │   └── profile_page.dart
│   │   │       └── widgets/
│   │   │           ├── google_sign_in_button.dart
│   │   │           └── email_sign_in_form.dart
│   │   │
│   │   ├── tasks/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── task_local_datasource.dart
│   │   │   │   │   └── task_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── task_model.dart
│   │   │   │   │   └── check_in_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── task_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── task.dart
│   │   │   │   │   └── check_in.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── task_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_tasks.dart
│   │   │   │       ├── get_task_by_id.dart
│   │   │   │       ├── create_task.dart
│   │   │   │       ├── update_task.dart
│   │   │   │       ├── delete_task.dart
│   │   │   │       ├── check_in_task.dart
│   │   │   │       ├── complete_task.dart
│   │   │   │       ├── search_tasks.dart
│   │   │   │       └── filter_tasks.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── task_list/
│   │   │       │   │   ├── task_list_bloc.dart
│   │   │       │   │   ├── task_list_event.dart
│   │   │       │   │   └── task_list_state.dart
│   │   │       │   ├── task_detail/
│   │   │       │   │   ├── task_detail_bloc.dart
│   │   │       │   │   ├── task_detail_event.dart
│   │   │       │   │   └── task_detail_state.dart
│   │   │       │   └── task_form/
│   │   │       │       ├── task_form_bloc.dart
│   │   │       │       ├── task_form_event.dart
│   │   │       │       └── task_form_state.dart
│   │   │       │
│   │   │       ├── pages/
│   │   │       │   ├── task_list_page.dart
│   │   │       │   ├── task_detail_page.dart
│   │   │       │   └── task_form_page.dart
│   │   │       │
│   │   │       └── widgets/
│   │   │           ├── task_card.dart
│   │   │           ├── task_status_badge.dart
│   │   │           ├── distance_indicator.dart
│   │   │           ├── check_in_button.dart
│   │   │           ├── complete_task_button.dart
│   │   │           ├── task_search_bar.dart
│   │   │           ├── task_filter_chips.dart
│   │   │           └── empty_task_list.dart
│   │   │
│   │   ├── location/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── location_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── location_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── location_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── location_data.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── location_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_current_location.dart
│   │   │   │       ├── calculate_distance.dart
│   │   │   │       ├── validate_proximity.dart
│   │   │   │       └── request_location_permission.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── location_bloc.dart
│   │   │       │   ├── location_event.dart
│   │   │       │   └── location_state.dart
│   │   │       ├── pages/
│   │   │       │   ├── map_selection_page.dart
│   │   │       │   └── full_map_page.dart
│   │   │       └── widgets/
│   │   │           ├── task_map_marker.dart
│   │   │           ├── current_location_marker.dart
│   │   │           └── location_permission_dialog.dart
│   │   │
│   │   ├── sync/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── sync_queue_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── sync_queue_item_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── sync_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── sync_queue_item.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── sync_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── add_to_sync_queue.dart
│   │   │   │       ├── process_sync_queue.dart
│   │   │   │       └── clear_sync_queue.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── sync_bloc.dart
│   │   │       │   ├── sync_event.dart
│   │   │       │   └── sync_state.dart
│   │   │       └── widgets/
│   │   │           ├── sync_indicator.dart
│   │   │           └── network_status_banner.dart
│   │   │
│   │   └── settings/
│   │       └── presentation/
│   │           ├── pages/
│   │           │   └── settings_page.dart
│   │           └── widgets/
│   │               └── setting_tile.dart
│   │
│   ├── database/                     # Drift database
│   │   ├── database.dart             # Main database class
│   │   ├── database.g.dart           # Generated file
│   │   ├── tables/
│   │   │   ├── tasks_table.dart
│   │   │   ├── users_table.dart
│   │   │   └── sync_queue_table.dart
│   │   └── daos/
│   │       ├── task_dao.dart
│   │       ├── user_dao.dart
│   │       └── sync_queue_dao.dart
│   │
│   └── injection_container.dart      # Dependency injection (GetIt)