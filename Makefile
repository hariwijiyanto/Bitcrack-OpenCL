# BitCrack OpenCL Build Makefile

CXX = g++
CXXFLAGS = -O2 -std=c++11 -Iinclude -I"C:/OCL_SDK_Light/include" -IKeyFinderLib
LDFLAGS = -L"C:/OCL_SDK_Light/lib/x86_64" -lOpenCL -lbcrypt

# Directories
SRCDIR = src
BUILDDIR = build
BINDIR = bin

# Source files
CORE_SOURCES = $(wildcard $(SRCDIR)/core/*.cpp)
OPENCL_SOURCES = $(wildcard $(SRCDIR)/opencl/*.cpp) $(SRCDIR)/bitcrack_cl.cpp
MAIN_SOURCES = $(filter-out %_backup.cpp, $(wildcard $(SRCDIR)/main/*.cpp))
EMBEDCL_SOURCES = $(SRCDIR)/embedcl.cpp

# Object files
CORE_OBJS = $(CORE_SOURCES:$(SRCDIR)/%.cpp=$(BUILDDIR)/%.o)
OPENCL_OBJS = $(OPENCL_SOURCES:$(SRCDIR)/%.cpp=$(BUILDDIR)/%.o)
MAIN_OBJS = $(MAIN_SOURCES:$(SRCDIR)/%.cpp=$(BUILDDIR)/%.o)
EMBEDCL_OBJS = $(BUILDDIR)/embedcl.o

# Targets
TARGETS = $(BINDIR)/bitcrack.exe $(BINDIR)/embedcl.exe

.PHONY: all clean

all: $(TARGETS)

$(BINDIR)/embedcl.exe: $(EMBEDCL_OBJS)
	@mkdir -p $(BINDIR)
	$(CXX) $(EMBEDCL_OBJS) -o $@

$(BINDIR)/bitcrack.exe: $(CORE_OBJS) $(OPENCL_OBJS) $(MAIN_OBJS)
	@mkdir -p $(BINDIR)
	$(CXX) $^ $(LDFLAGS) -o $@

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILDDIR)/embedcl.o: $(EMBEDCL_SOURCES)
	@mkdir -p $(BUILDDIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILDDIR) $(BINDIR)

# Copy OpenCL kernel files to build directory
$(BUILDDIR)/kernels: $(wildcard $(SRCDIR)/*.cl)
	@mkdir -p $(BUILDDIR)
	cp $(SRCDIR)/*.cl $(BUILDDIR)/

# Build dependencies
$(CORE_OBJS): $(BUILDDIR)/kernels
$(OPENCL_OBJS): $(BUILDDIR)/kernels
$(MAIN_OBJS): $(BUILDDIR)/kernels
