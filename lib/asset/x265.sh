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
if [ ! -e ./x265 ]
then 
    git clone https://github.com/videolan/x265 -q
fi

cd $tmp_path/x265/source/common/
cpu_content=`cat cpu.cpp`
replace_str1="void PFX(cpu_neon_test)(void) {}"
replace_str2="int PFX(cpu_fast_neon_mrc_test)(void) { return 0; }"
if [[ "$cpu_content" != *$replace_str1* ]]
then 
    sed -i '' 's/void PFX(cpu_neon_test)(void);/void PFX(cpu_neon_test)(void) {}/g' "cpu.cpp"
fi
if [[ "$cpu_content" != *$replace_str2* ]]
then
    sed -i '' 's/int PFX(cpu_fast_neon_mrc_test)(void);/int PFX(cpu_fast_neon_mrc_test)(void) { return 0; }/g' 'cpu.cpp'
fi

out_dir=$root_path/out/x265

cd $tmp_path/x265/build
mkdir -p arm-android && cd arm-android
cmake -DCROSS_COMPILE_ARM=1 -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=armv7l \
        -DCMAKE_C_COMPILER=$toolchain_path/bin/arm-linux-androideabi-clang -DCMAKE_CXX_COMPILER=$toolchain_path/bin/arm-linux-androideabi-clang++ \
        -DCMAKE_FIND_ROOT_PATH=$toolchain_path/sysroot -DENABLE_ASSEMBLY=OFF -DENABLE_CLI=OFF \
        -DENABLE_PIC=ON -DENABLE_SHARED=OFF -DCMAKE_INSTALL_PREFIX=$out_dir -DCMAKE_C_FLAGS="" \
        -G "Unix Makefiles" ../../source
make -j8 && make install