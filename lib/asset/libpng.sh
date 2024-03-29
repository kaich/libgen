root_path=$1
ndk_path=$2
asset_path=$3
tmp_path=$root_path/tmp
to_ndk_path=$tmp_path/android-ndk
toolchain_path=$tmp_path/ndk

if [ ! -e $tmp_path ]
then
    mkdir $tmp_path
fi
cp -r -n $ndk_path $tmp_path

if [ ! -e $tmp_path/ndk ]
then
    cd $to_ndk_path/build/tools
    ./make_standalone_toolchain.py --arch arm --api 21 --stl libc++ --install-dir $toolchain_path
fi

cd $tmp_path
if [ ! -e ./libpng ]
then
	git clone https://github.com/glennrp/libpng.git -q
fi

out_dir=$root_path/out/libpng
cd $tmp_path/libpng

export CC=$toolchain_path/bin/arm-linux-androideabi-clang
export CFLAGS='-fPIE -fno-integrated-as' 
export LDFLAGS='-fPIE -pie' 
export PATH=$PATH:$toolchain_path/bin
./configure --prefix=$out_dir --host=arm-linux-androideabi --enable-shared=no --enable-arm-neon
make -j8 && make install