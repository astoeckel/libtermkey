#
# libtermkey - Easy processing of keyboard entry from terminal-based programs
#
# Meson wrapper for libtermkey. To use, install the Python 3 package "meson" via
# pip, as well as the "ninja" build system. Then run
#
# > mkdir build; cd build
# > meson -Dbuildtype=release ..
# > ninja
# > ninja test
#
# File: meson.build
# Author: Andreas Stöckel, 2019  https://github.com/astoeckel
#

project('libtermkey',
    ['c'],
    default_options: ['c_std=c99', 'b_ndebug=if-release'],
    version: '0.22')

################################################################################
# Library                                                                      #
################################################################################

dep_unibilium = dependency('unibilium',
    fallback:['unibilium', 'dep_unibilium'],
    required: true)

exe_sh = find_program('sh')

gen_termkey_h = custom_target(
    'termkey.h',
    input: ['gen_header.sh', 'Makefile', 'termkey.h.in'],
    output: ['termkey.h'],
    command: [exe_sh, '@INPUT0@', '@INPUT1@', '@INPUT2@', '@OUTPUT0@'],
    install: true,
    install_dir: 'include',
)

inc_termkey = include_directories('.')
lib_termkey = library(
    'termkey',
    [
        'termkey.c',
        'driver-csi.c',
        'driver-ti.c',
        gen_termkey_h,
    ],
    install: true,
    include_directories: [inc_termkey],
    dependencies: [dep_unibilium],
    c_args : ['-DHAVE_UNIBILIUM']
)

################################################################################
# Example applications                                                         #
################################################################################

exe_demo = executable(
    'demo',
    [
        'demo.c',
        gen_termkey_h,
    ],
    include_directories: [inc_termkey],
    link_with: [lib_termkey]
)

################################################################################
# Unit tests                                                                   #
################################################################################

exe_perl = find_program('perl')

arr_test_names = run_command(exe_perl, 't/list-tests.pl').stdout().strip().split('\0')
foreach test_name: arr_test_names
    exe_test = executable(
        'test_' + test_name,
        [
            't/' + test_name + '.c',
            't/taplib.c',
            gen_termkey_h,
        ],
        link_with: [lib_termkey],
        include_directories: [inc_termkey])
    test(test_name, exe_test)
endforeach


################################################################################
# Installation                                                                 #
################################################################################

# Meson dependency
dep_termkey = declare_dependency(
    link_with: [lib_termkey],
    include_directories: [inc_termkey],
)

# Generate a Pkg config file
pkg = import('pkgconfig')
pkg.generate(
    lib_termkey,
    name: 'termkey',
    version: meson.project_version(),
    description: 'Parser for CSI key sequences')

