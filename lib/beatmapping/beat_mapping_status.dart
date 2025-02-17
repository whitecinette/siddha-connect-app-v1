import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api_method.dart';

import 'dart:convert';

final beatMappingProvider = FutureProvider((ref) async {
  final api = ApiMethod(url: ApiUrl.adminGetWeeklyBeatMapping);
  final response = await api.getDioRequest();

  if (response != null && response['success'] == true) {
    return response['data'] as List<dynamic>;
  }
  throw Exception("Failed to load beat mapping data");
});


class BeatMappingStatusScreen extends ConsumerStatefulWidget {
  const BeatMappingStatusScreen({super.key});

  @override
  _BeatMappingStatusScreenState createState() => _BeatMappingStatusScreenState();
}

class _BeatMappingStatusScreenState extends ConsumerState<BeatMappingStatusScreen> {
  String selectedFilter = "All"; // Default filter
  final List<String> filters = ["All", "TSE", "ASM"];

  @override
  Widget build(BuildContext context) {
    final beatMappingData = ref.watch(beatMappingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Beat Mapping Status")),
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              items: filters.map((filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),

          // Data Display
          Expanded(
            child: beatMappingData.when(
              data: (data) {
                List<dynamic> filteredData = selectedFilter == "All"
                    ? data
                    : data.where((item) => item["Position"] == selectedFilter).toList();

                return ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final item = filteredData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(item["Name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${item["Position"]} | Total: ${item["Total"]}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${item["Done"]}",
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${item["Pending"]}",
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text("Error: $error")),
            ),
          ),
        ],
      ),
    );
  }
}
