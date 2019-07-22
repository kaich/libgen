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

echo "---------build libheif---------"

cd $tmp_path
if [ ! -e ./libheif ]
then 
	git clone https://github.com/strukturag/libheif -q
fi

cd libheif
sh ./autogen.sh

export CC=$tmp_path/ndk/bin/arm-linux-androideabi-clang
export CXX=$tmp_path/ndk/bin/arm-linux-androideabi-clang++
export CFLAGS="-fPIE -Wno-tautological-constant-compare"
export CXXFLAGS="-fPIE -Wno-tautological-constant-compare"
export LDFLAGS="-fPIE -pie" 
export PKG_CONFIG_PATH=$root_path/out/x265/lib/pkgconfig:$root_path/out/libde265/lib/pkgconfig:$root_path/out/libpng/lib/pkgconfig 
export PATH=$PATH:$tmp_path/ndk/bin

out_dir=$root_path/out/libheif
./configure --prefix=$out_dir --host=arm-linux-androideabi