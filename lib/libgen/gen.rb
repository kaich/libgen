require 'optparse'
require 'pathname'
require "colorize"

module Gen

    def self.root
        File.dirname __dir__
    end

    def self.tmp_dir
        "/tmp/libgen"  
    end

    def self.asset_path 
        root + "/asset"
    end

    def self.libgen_path 
        root + "/libgen"
    end

    def self.run
        options = {}
        OptionParser.new do |opts|
            opts.banner = "Usage: 编译C/C++库为提供安卓/ios所用"

            opts.on("-o", "--out folder", "输入目录") do |v|
                options[:out] = v
            end

            opts.on("-n", "--ndk folder","ndk所在的目录") do |v|
                options[:ndk] = v 
            end

            opts.on("-l", "--lib lib",Array,"库名称，例如：libpng、x256、libde265、libheif ...") do |v|
                options[:lib] = v 
            end
        end.parse!

        out_dir = options[:out] 
        ndk_dir = options[:ndk]
        lib_type = options[:lib]

        if file_exist? tmp_dir 
            `rm -rf #{tmp_dir}`
            `mkdir -p #{tmp_dir}`
        end

        if !(file_exist?(out_dir) && file_exist?(ndk_dir)) 
            puts "指定的目录不存在".colorize(:red)
            return 
        end

        lib_type.each do |lib| 
            if lib == "libheif" 
                ["x256", "libde265" , "libpng"].each do |dlib|
                    buildlib out_dir, ndk_dir, dlib 
                end
            end
            buildlib out_dir, ndk_dir, lib 
        end

        if lib_type.length == 0  
            puts "请指定 -t，可选为 [libpng、x256、libde265、libheif]"
        end

        `cp -r -f "#{tmp_dir}/out" "#{out_dir}"`
        puts "任务完成，请查看目标目录".colorize(:green)
        `open #{out_dir}`

        if file_exist? tmp_dir 
            `rm -rf #{tmp_dir}`
        end
    end

    def self.buildlib(out_dir, ndk_dir, lib) 
        puts "开始编译#{lib}，请耐心等待...".colorize(:green)
        sh_path = asset_path + "/#{lib}.sh"
        `sh "#{sh_path}" "#{tmp_dir}" "#{ndk_dir}"  "#{asset_path}"`
    end

    def self.empty?(val) 
        val && !val.empty? 
    end

    def self.file_exist?(path) 
        File.exist?(path)
    end

end