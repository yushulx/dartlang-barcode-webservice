import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

// Refer to https://webdev.dartlang.org/articles/get-data/json-web-service
readBarcode(String base64) async {
  if (base64 == null) {
    print("No data available");
    return;
  }

  String jsonData = '{"image":"$base64","barcodeFormat":234882047,"maxNumPerPage":1}';
  var url =
      'http://demo1.dynamsoft.com/dbr/webservice/BarcodeReaderService.svc/Read';

  // Invoke web service for reading barcode
  var response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonData);
  print("Response status: ${response.statusCode}");
  print(response.headers);
  if (response.statusCode != 200) {
    print("Server Error !!!");
    return;
  }
  print("Response body: ${response.body}");

  // https://api.dartlang.org/stable/1.21.0/dart-convert/JSON-constant.html
  Map result = JSON.decode(response.body);
  print("Barcode result: " + result['barcodes'][0]['displayValue']);
}

// Refer to https://www.dartlang.org/dart-vm/dart-by-example
Future<String> readFile2Base64() async {
  final filename = 'code128.png';

  try {
    var bytes = await new File(filename).readAsBytes();
    // https://api.dartlang.org/stable/1.21.0/dart-convert/BASE64-constant.html
    String base64 = BASE64.encode(bytes);
    return base64;
  } catch (e) {
    print('There was a ${e.runtimeType} error');
    print('Could not read $filename');
  }

  return null;
}

main(List<String> args) {
  Future<String> result = readFile2Base64();
  result.then((String value) => readBarcode(value));
}
