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

echo "---------build libde265---------"

cd $tmp_path
if [ ! -e ./libheif ]
then 
	git clone https://github.com/strukturag/libde265 -q
fi

out_dir=$root_path/out/libde265

cd libde265
export CC=$toolchain_path/bin/arm-linux-androideabi-clang
export CXX=$toolchain_path/bin/arm-linux-androideabi-clang++
export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"
export LDFLAGS="-fPIC"
export PATH=$PATH:$toolchain_path/bin
sh ./autogen.sh
./configure --prefix=$out_dir --enable-shared=no --host=arm-linux-androideabi --disable-arm --disable-sse --disable-sherlock265 
make -j8 && make install

