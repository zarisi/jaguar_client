// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library http.json;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:auth_header/auth_header.dart';

import 'package:jaguar_serializer/serializer.dart';
import 'package:jaguar_common/jaguar_common.dart';

part 'authenticators.dart';
part 'based_client.dart';
part 'client.dart';
part 'path_client.dart';
part 'response.dart';
part 'resource.dart';
part 'session_manager.dart';
