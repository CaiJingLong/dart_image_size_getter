# Migrate

## 1.x.x To 2.0.0

Remove `AsyncImageSizeGetter`.

Now, We use `ImageSizeGetter.getSizeAsync(AsyncImageInput)` to get image size.

## 1.0.x To 1.1.0

Usually no change.

However, if you use `AsyncImageSizeGetter` or `AsyncImageInput`, you need to implement 2 new methods.

## 0.x To 1.x

The version is null-safety version.

The `ImageSizGetter` typo will fixed, please use `ImageSizeGetter` or `AsyncImageSizeGetter`.

## 0.2.x To 0.3.x

This version only completes the part that was not completed last time, that is.

Use `AsyncImageInput` and `AsyncImageSizeGetter` to get image size of async image.

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
