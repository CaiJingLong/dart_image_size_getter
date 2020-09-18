# Migrate

## 0.1.x To 0.2.x

Replace `FileInput` to `File`

old:

```dart
File file = File("asset/IMG_20180908_080245.jpg");
final size = ImageSizGetter.getSize(file);
print('jpg = $size');
```

new:

```dart
final file = File('asset/IMG_20180908_080245.jpg');
final size = ImageSizGetter.getSize(FileInput(file));
print('jpg = $size');
```
