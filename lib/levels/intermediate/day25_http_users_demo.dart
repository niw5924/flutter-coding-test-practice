import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Day25Page extends StatefulWidget {
  const Day25Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day25PageState();
}

class _Day25PageState extends State<Day25Page> {
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    _loadUserList();
  }

  Future<void> _loadUserList() async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          userList = data.map((e) => User.fromJson(e)).toList();
        });
        print(userList);
      } else {
        throw Exception('Failed to load users ${response.statusCode}');
      }
    } catch (e) {
      print('유저 불러오기 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('http 통신')),
      body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final User user = userList[index];

            return ListTile(
              leading: Text('${user.id}'),
              title: Text(user.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username),
                  Text(user.email),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailPage(
                      address: user.address,
                      phone: user.phone,
                      website: user.website,
                      company: user.company,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      phone: json['phone'],
      website: json['website'],
      company: Company.fromJson(json['company']),
    );
  }
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
      geo: Geo.fromJson(json['geo']),
    );
  }
}

class Geo {
  final String lat;
  final String lng;

  const Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }
}

class UserDetailPage extends StatelessWidget {
  final Address address;
  final String phone;
  final String website;
  final Company company;

  const UserDetailPage({
    super.key,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(phone),
      ),
      body: Column(
        children: [
          Text(website),
          Text(address.geo.lat),
          Text(company.catchPhrase),
        ],
      ),
    );
  }
}
