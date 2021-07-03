import 'package:path/path.dart';

/// If import starts with package, it is valid already so no modification
/// [locationItem] can start with either package or asset:
///
String? locationToImport({
  required String locationItem,
  required String currentPath,
}) {
  var newPath = locationItem;
  if (!locationItem.startsWith("package") &&
      !locationItem.startsWith("asset:") &&
      !locationItem.startsWith("dart")) {
    throw "Invalid argument. Location item must be from library.imports";
  }
  if (locationItem.startsWith("asset:")) {
    if (currentPath.startsWith("asset:")) {
      throw "Invalid Argument. "
          "Current Path must be a direct relative path without prefix. "
          "from buildStep.inputId.uri.path";
    }
    final package = locationItem.replaceFirst("asset:", "");
    newPath = relative(package, from: currentPath).replaceFirst('../', '');
  }
  if (newPath == ".") return null;
  return "import '$newPath';";
}
