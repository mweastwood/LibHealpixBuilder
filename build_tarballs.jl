using BinaryBuilder

# Collection of sources required to build LibHealpix
sources = [
    "https://downloads.sourceforge.net/project/healpix/Healpix_3.31/Healpix_3.31_2016Aug26.tar.gz" =>
    "ddf437442b6d5ae7d75c9afaafc4ec43921f903c976e25db3c5ed5185a181542",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd Healpix_3.31/src/C/autotools
autoreconf --install
./configure --prefix=$prefix --host=$target
make -j
make install
cd $WORKSPACE/srcdir
cd Healpix_3.31/src/cxx/autotools
autoreconf --install
./configure --prefix=$prefix --host=$target
make -j
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc, :blank_abi),
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Linux(:powerpc64le, :glibc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
    BinaryProvider.MacOS(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libhealpix_cxx", :libhealpix_cxx),
    LibraryProduct(prefix, "libchealpix", :libchealpix)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaAstro/CFITSIOBuilder/releases/download/v3.440-1/build.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "LibHealpix", sources, script, platforms, products, dependencies)

