require 'rake/clean'

##############################################
## Define Compiler/linker Variables 
##############################################


SOURCE_DIR  = "src"
INCLUDE_DIR = "include/"
OBJ_DIR     = "build/obj"
BUILD_DIR   = "build"
GCC         = "/home/me/ti/ccs1000/ccs/tools/compiler/ti-cgt-msp430_20.2.0.LTS/bin/cl430" 

DEV_NAME = "msp430fr5969"

DEVICE = "__#{DEV_NAME.upcase}__"
LINKER_CMD_FILE = "lnk_#{DEV_NAME.downcase}.cmd"

FileUtils.mkdir_p "#{OBJ_DIR}/"
FileUtils.mkdir_p "#{BUILD_DIR}/"

SOURCES     = Rake::FileList["#{SOURCE_DIR}/*.c"]
OBJECTS     = SOURCES.ext(".obj").pathmap("#{OBJ_DIR}/%f")
INCLUDES    = INCLUDE_DIR
TARGET      = "#{BUILD_DIR}/app"

STATIC_LIBS = "-llibmath.a -llibc.a"

MEMORY_MAP = "#{BUILD_DIR}/memory.map"

##############################################
## Ruby Tools 
##############################################
require_relative "tools/RakeSupportFunctions"
include RakeSupportFunctions

##############################################
## Building Process
##############################################
task :default => :build

task :build => OBJECTS do
    puts "#{BBlue}[Linking]#{Color_Off}\n"
    quiet_sh "#{GCC} -vmspx --use_hw_mpy=F5 --advice:power=\"all\" --advice:hw_config=\"all\" --define=#{DEVICE} -g --c99 --printf_support=minimal --diag_warning=225 --diag_wrap=off --display_error_number --silicon_errata=CPU21 --silicon_errata=CPU22 --silicon_errata=CPU40 -z -m#{MEMORY_MAP} --heap_size=160 --stack_size=160 --cinit_hold_wdt=on -i\"/home/me/ti/ccs1000/ccs/ccs_base/msp430/include\" -i\"/home/me/ti/ccs1000/ccs/ccs_base/msp430/lib/5xx_6xx_FRxx\" -i\"/home/me/ti/ccs1000/ccs/tools/compiler/ti-cgt-msp430_20.2.0.LTS/lib\" -i\"/home/me/ti/ccs1000/ccs/tools/compiler/ti-cgt-msp430_20.2.0.LTS/include\" --reread_libs --diag_wrap=off --display_error_number --warn_sections --xml_link_info=\"#{TARGET}.xml\" --use_hw_mpy=F5 --rom_model -o #{TARGET}.out #{OBJECTS} #{LINKER_CMD_FILE}  #{STATIC_LIBS}"
   
end


# %f The base filename of the path, with its file extension,
# pathmap :Apply the pathmap spec to each of the included file names, returning a new file list with the modified paths. (See String#pathmap for details.)
#  lambda:     say_something = -> { puts "This is a lambda" }

# For each '.o' file add path "SOURCE_DIR/ " and change extension to C
rule '.obj' => ->(t){t.pathmap("#{SOURCE_DIR}/%f").ext(".c")} do |task|
    puts "#{BBlue}[Building Object] #{task.name} #{Color_Off} \n"
    quiet_sh "#{GCC} -vmspx --use_hw_mpy=F5 --include_path=\"/home/me/ti/ccs1000/ccs/ccs_base/msp430/include\"  --include_path=#{INCLUDES} --include_path=\"/home/me/ti/ccs1000/ccs/tools/compiler/ti-cgt-msp430_20.2.0.LTS/include\" --advice:power=\"all\" --advice:hw_config=\"all\" --define=#{DEVICE} -g --c99 --printf_support=minimal --diag_warning=225 --diag_wrap=off --display_error_number --silicon_errata=CPU21 --silicon_errata=CPU22 --silicon_errata=CPU40 --preproc_with_compile --preproc_dependency=#{task.name.ext(".d_raw")} --obj_directory=#{OBJ_DIR}/ #{task.source} #{COLOR_OUTPUT} " 

end

CLEAN.include("#{OBJ_DIR}", "#{BUILD_DIR}" )
# CLOBBER.include("#{BUILD_DIR}")


