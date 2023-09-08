pushd "$(dirname "$0")"

cp $(kscript -p lo-kts-converter.main.kts 2> >(grep -o "/.*")).jar .

popd
