workdir="$( cd "$( dirname "$0"  )" && pwd  )"

echo $workdir

cd $workdir/library
dart pub get
dart test

cd $workdir/image_size_getter_http_input
dart pub get
dart test