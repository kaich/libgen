root_path=$1
ndk_path=$2
asset_path=$3
tmp_path=$root_path/tmp

if [ ! -e $tmp_path ] 
then
	mkdir -p $tmp_path
fi

export PATH=${PATH}:$ndk_path

cd $tmp_path
if [ ! -e ./libpng ]
then
	git clone https://github.com/glennrp/libpng.git -q
fi

if [ ! -e ./libpng-android ]
then 
	git clone https://github.com/julienr/libpng-android.git -q
fi

if [ ! -e ./zlib ]
then 
	git clone https://github.com/madler/zlib.git -q
fi

cd $tmp_path/libpng-android/jni


cd $tmp_path/libpng

for filename in * ; 
do 
	if [[ $filename = *.h ]] || [[ $filename = *.c ]] || [[ $filename = "arm" ]];
	then 
		if [ -d ./$filename ] 
		then 
			cp -f -r $tmp_path/libpng/$filename $tmp_path/libpng-android/jni/ 
		else 
			cp -f $tmp_path/libpng/$filename $tmp_path/libpng-android/jni/$filename 
		fi

	fi
done

cd $tmp_path/zlib

for filename in * ; 
do 
	if [[ $filename = *.h ]] || [[ $filename = *.c ]];
	then 
		cp -f $tmp_path/zlib/$filename $tmp_path/libpng-android/jni/$filename 
	fi
done

cd $tmp_path/libpng-android/jni

android_content=`cat Application.mk`
if [[ ! $android_content == *"APP_PLATFORM"* ]] 
then 
	echo 'APP_PLATFORM := android-16' >> Application.mk
fi
cp -r $asset_path/Android.mk $tmp_path/libpng-android/jni/Android.mk


cd $tmp_path/libpng-android
./build.sh

out_dir=$root_path/out/libpng
if [ ! -e $out_dir ] 
then
	mkdir -p $out_dir 
fi
cp -f -r $tmp_path/libpng-android/obj $out_dir