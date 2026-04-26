import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink('http://62.151.182.241:4055/workfreeli');

  static AuthLink authLink = AuthLink(
    getToken: () async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) return null;
      return 'Bearer $token';
    },
  );

  static ValueNotifier<GraphQLClient> graphInit() {
    final Link combinedLink = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: combinedLink,
        cache: GraphQLCache(store: InMemoryStore()),
        defaultPolicies: DefaultPolicies(
          query: Policies(fetch: FetchPolicy.networkOnly),
        ),
      ),
    );

    return client;
  }
}

class GraphQLSchema {
  static String getData = r""" 
  query Me {
    me {
        id
        firstname
        lastname
        email
        company_id
        company_name
        fnln
        dept
        designation
        account_type
        lat
        log
        gcm_id
        img
        role
        reset_id
        conference_id
        created_by
        updated_by
        updated_at
        class
        section
        campus
        parent_id
        student_id
        relationship
        login_id
        roll_number
        birth_day
        mobile_otp
        email_otp
        verified
        last_login_address
        gender
        blood_group
        marital_status
        nickname
        present_address
        permanent_address
        employee_id
        nid
        intro
        father_name
        mother_name
        do_not_disturb
        screen_time_today
        face_detection
        finger_detection
        vacation_mode
        in_time_today
        out_time_today
        phone_optional
        school
        short_id
        mute
        short_id_guest
        customer_id
        timezone
        email_send_time
        is_active
        is_delete
        is_busy
        login_total
        login_attempt
        mute_all
        digest_email
        sso
        phone
        device
        access
        pin_access
        unpin_access
        last_login
        createdat
        updatedAt
        erpNext
        erpNextPass
        erpNextRoles
        multi_company
    }
}
 """;

  static String loginMutation = r"""
  mutation Login(
  $email: String!, 
  $password: String, 
  $companyId: String, 
  $code: String,
  $step: String,
  $deviceId: String!,
  $sessionToken: String
) {
  login(
    input: {
      email: $email,
      password: $password,
      step: $step,
      device_type: "mobile",    
      device_id: $deviceId,
      company_id: $companyId,
      code: $code,
      session_token: $sessionToken
    }
  ) {
    token
    refresh_token
    status
    status_code
    message
    next_step
    session_token
    companies {
    company_id
    company_name
    created_by
    updated_by
    company_img
    role
    industry
    domain_name
    plan_name
    plan_user_limit
    plan_storage_limit
    is_deactivate
    plan_id
    subscription_id
    product_id
    price_id
    class
    campus
    section
    plan_access
    created_at
    updated_at
    createdAt
    updatedAt
    team_title
    company_size
    hear_about
    phone_number
    company_email
    company_address
    company_website
    business_type
    registration_number
    tin_number
    social_link
    module
    created_by_role
    company_contact_person
    same_address
    }
  }
}
""";
}
