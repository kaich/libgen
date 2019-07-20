root_path=$1
ndk_path=$2
asset_path=$3
tmp_path=$root_path/tmp
to_ndk_path=$tmp_path/android-ndk

if [ ! -e $tmp_path ] 
then
	mkdir $tmp_path
fi
cp -r -n $ndk_path $tmp_path

if [ ! -e $tmp_path/ndk ]
then 
	cd $to_ndk_path/build/tools
	./make_standalone_toolchain.py --arch arm --api 21 --stl libc++ --install-dir $tmp_path/ndk
fi

echo "---------build x265-----------"
cd $tmp_path
git clone https://github.com/videolan/x265 -q

out_dir=$root_path/out/x256

cd $tmp_path/x265/build
mkdir -p arm-android && cd arm-android
cmake -DCROSS_COMPILE_ARM=1 -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=armv7l \
        -DCMAKE_C_COMPILER=/tmp/ndk/bin/arm-linux-androideabi-clang -DCMAKE_CXX_COMPILER=/tmp/ndk/bin/arm-linux-androideabi-clang++ \
        -DCMAKE_FIND_ROOT_PATH=/tmp/ndk/sysroot -DENABLE_ASSEMBLY=OFF -DENABLE_CLI=OFF \
        -DENABLE_PIC=ON -DENABLE_SHARED=OFF -DCMAKE_INSTALL_PREFIX=$out_dir -DCMAKE_C_FLAGS="" \
        -G "Unix Makefiles" ../../source
make -j8 && make install