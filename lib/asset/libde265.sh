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

echo "---------build libde265---------"

cd $tmp_path
if [ ! -e ./libheif ]
then 
	git clone https://github.com/strukturag/libde265 -q
fi

out_dir=$root_path/out/libde265

cd libde265
export CC=$tmp_path/ndk/bin/clang 
export CXX=$tmp_path/ndk/bin/clang++
export CFLAGS="-fPIE"
export LDFLAGS="-fPIE"
export PATH=$PATH:$tmp_path/ndk/bin
sh ./autogen.sh
./configure --prefix=$out_dir --enable-shared=no --host=arm-linux-androideabi --disable-arm --disable-sse --disable-sherlock265 
make -j8 && make install

