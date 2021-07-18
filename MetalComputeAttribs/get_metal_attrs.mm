#include <memory>
#include <TargetConditionals.h>

#import "get_metal_attrs.h"

typedef struct my_uint3
{
    uint32 x;
    uint32 y;
    uint32 z;
} my_uint3;

struct kernel_attribs
{
    // input from the host CPU
    my_uint3 request_thread_position_in_grid;

    // output from the metal device GPU
    uint32   dispatch_quadgroups_per_threadgroup;
    uint32   dispatch_simdgroups_per_threadgroup;
    my_uint3 dispatch_threads_per_threadgroup;
    my_uint3 grid_origin;
    my_uint3 grid_size;
    uint32   quadgroup_index_in_threadgroup;
    uint32   quadgroups_per_threadgroup;
    uint32   simdgroup_index_in_threadgroup;
    uint32   simdgroups_per_threadgroup;
    uint32   thread_execution_width;
    uint32   thread_index_in_quadgroup;
    uint32   thread_index_in_simdgroup;
    uint32   thread_index_in_threadgroup;
    my_uint3 thread_position_in_grid;
    my_uint3 thread_position_in_threadgroup;
    my_uint3 threadgroup_position_in_grid;
    my_uint3 threadgroups_per_grid;
    my_uint3 threads_per_grid;
    uint32   threads_per_simdgroup;
    my_uint3 threads_per_threadgroup;
};

@implementation GetMetalAttrs
{
    id<MTLDevice>               _mDevice;
    id<MTLComputePipelineState> _mPSO;
    id<MTLCommandQueue>         _mCommandQueue;
    id<MTLBuffer>               _mAttr;
}

- (void) setRequest_thread_position_in_gridWithX:(uint32)x Y:(uint32)y Z:(uint32)z
{
    _request_thread_position_in_grid = MTLSizeMake(x, y, z);
    my_uint3& tid = ( (struct kernel_attribs*)_mAttr.contents )->request_thread_position_in_grid;
    tid.x = x;
    tid.y = y;
    tid.z = z;
}

- (void) setRequest_groups_per_gridWithX:(uint32)x Y:(uint32)y Z:(uint32)z
{
    _request_groups_per_grid = MTLSizeMake(x, y, z);
}

- (void) setRequest_threads_per_threadgroupWithX:(uint32)x Y:(uint32)y Z:(uint32)z
{
    _request_threads_per_threadgroup = MTLSizeMake(x, y, z);

}

- (MTLSize) dispatch_threads_per_threadgroup
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->dispatch_threads_per_threadgroup;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (MTLSize) grid_origin
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->grid_origin;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (MTLSize) grid_size
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->grid_size;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (MTLSize) thread_position_in_grid
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->thread_position_in_grid;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (MTLSize) thread_position_in_threadgroup
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->thread_position_in_threadgroup;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (MTLSize) threadgroup_position_in_grid
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->threadgroup_position_in_grid;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (MTLSize) threadgroups_per_grid
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->threadgroups_per_grid;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (MTLSize) threads_per_grid
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->threads_per_grid;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (MTLSize) threads_per_threadgroup
{
    my_uint3& s = ( (struct kernel_attribs*)_mAttr.contents )->threads_per_threadgroup;
    return MTLSizeMake( s.x, s.y, s.z );
}

- (uint32) dispatch_quadgroups_per_threadgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->dispatch_quadgroups_per_threadgroup;
}

- (uint32) dispatch_simdgroups_per_threadgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->dispatch_simdgroups_per_threadgroup;
}

- (uint32) quadgroup_index_in_threadgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->quadgroup_index_in_threadgroup;
}

- (uint32) quadgroups_per_threadgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->quadgroups_per_threadgroup;
}

- (uint32) simdgroup_index_in_threadgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->simdgroup_index_in_threadgroup;
}

- (uint32) simdgroups_per_threadgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->simdgroups_per_threadgroup;
}

- (uint32) thread_execution_width
{
    return ( (struct kernel_attribs*)_mAttr.contents )->thread_execution_width;
}

- (uint32) thread_index_in_quadgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->thread_index_in_quadgroup;
}

- (uint32) thread_index_in_simdgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->thread_index_in_simdgroup;
}

- (uint32) thread_index_in_threadgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->thread_index_in_threadgroup;
}

- (uint32) threads_per_simdgroup
{
    return ( (struct kernel_attribs*)_mAttr.contents )->threads_per_simdgroup;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _mDevice = MTLCreateSystemDefaultDevice();

        if ( _mDevice == nil ) {
            NSLog(@"Failed to get the default Metal device.");
            return nil;
        }

        NSError* error = nil;
#if TARGET_OS_OSX
        id<MTLLibrary> library = [_mDevice newLibraryWithFile:@"./get_kernel_attribs.metallib" error: &error ];
#else
        id<MTLLibrary> library = [ _mDevice newDefaultLibrary ];
#endif
        if ( library == nil )
        {
            NSLog(@"Failed to find the default library.");
            return nil;
        }

        id<MTLFunction> kernel_func = [ library newFunctionWithName:@"get_kernel_attribs" ];
        if ( kernel_func == nil )
        {
            NSLog(@"Failed to find the kernel function.");
            return nil;
        }

        _mPSO = [_mDevice newComputePipelineStateWithFunction: kernel_func error:&error];
        if ( _mPSO == nil )
        {
            NSLog(@"Failed to created pipeline state object, error %@.", error);
            return nil;
        }

        _mCommandQueue = [_mDevice newCommandQueue];
        if ( _mCommandQueue == nil )
        {
            NSLog(@"Failed to find the command queue.");
            return nil;
        }

        _mAttr = [_mDevice newBufferWithLength:sizeof(struct kernel_attribs) options:MTLResourceStorageModeShared ];
        if ( _mAttr == nil )
        {
            NSLog(@"Failed to allocate new metal buffer for kernel_attribs.");
            return nil;
        }
        memset( _mAttr.contents, (int)0, sizeof(struct kernel_attribs) );
    }
    return self;
}

- (void) get;
{
    // Cleanup the attributes struct
    memset( _mAttr.contents, (int)0, sizeof(struct kernel_attribs) );

    my_uint3& tid = ( (struct kernel_attribs*)_mAttr.contents )->request_thread_position_in_grid;
    tid.x = _request_thread_position_in_grid.width;
    tid.y = _request_thread_position_in_grid.height;
    tid.z = _request_thread_position_in_grid.depth;

    id<MTLCommandBuffer> commandBuffer = [ _mCommandQueue commandBuffer ];

    assert( commandBuffer != nil );

    id<MTLComputeCommandEncoder> computeEncoder = [ commandBuffer computeCommandEncoder ];

    assert( computeEncoder != nil );

    [ computeEncoder setComputePipelineState:_mPSO ];

    [ computeEncoder setBuffer:_mAttr offset:0 atIndex:0 ];

    [ computeEncoder dispatchThreadgroups:_request_groups_per_grid threadsPerThreadgroup:_request_threads_per_threadgroup ];
//    [ computeEncoder dispatchThreads:_request_threads_per_grid threadsPerThreadgroup:_request_threads_per_threadgroup ];

    [ computeEncoder endEncoding ];

    [ commandBuffer commit ];

    [ commandBuffer waitUntilCompleted ];
}

@end


#if TARGET_OS_OSX

#include <iostream>

// Build:
// % xcrun -sdk macosx metal -c get_kernel_attribs.metal -o get_kernel_attribs.air
// % xcrun -sdk macosx metallib get_kernel_attribs.air -o get_kernel_attribs.metallib
// % g++ -Wall -framework Metal -framework Foundation -framework CoreGraphics -O3 -o get_metal_attrs get_metal_attrs.mm

static void print_usage()
{
    std::cerr << "\n";
    std::cerr << "get_metal_attr: shows \"kernel function input attributes\" of Metal.\n";
    std::cerr << "\n";
    std::cerr << "    Usage: get_metal_attr <px>, <py>, <pz>, <grid_x>, <grid_y>, <grid_z>, <group_x>, <group_y>, <group_z>\n";
    std::cerr << "\n";
    std::cerr << "        px,      py,      pz:      thread_position_in_grid where the attributes are sampled in the kernel, zero-origin.\n";
    std::cerr << "        grid_x,  grid_y,  grid_z:  dimension of the groups per grid\n";
    std::cerr << "        group_x, group_y, group_z: dimension of the threads per group\n";
    std::cerr << "\n";
    std::cerr << "    Example: get_metal_attr 2047 0 0 16384 1 1 1024 1 1\n";
    std::cerr << "\n";
    std::cerr << "        This means the dimension of the grid is 16777216 x 1 x 1 (one-dimensional) in threads,\n";
    std::cerr << "        the dimension of one group is 1024 x 1 x 1 (one-dimensional) in threads,\n";
    std::cerr << "        the position of the thread in the grid where the attributes are sampeled in the kernel is 2047 x 0 x 0 (one-dimensional).\n";
    std::cerr << "\n";
}

int main(int argc, const char * argv[]) {

   if ( argc != 10 ) {
        print_usage();
        return 1;
    }

    @autoreleasepool {

        GetMetalAttrs* attr =  [[GetMetalAttrs alloc] init];

        [ attr setRequest_thread_position_in_gridWithX: atoi(argv[1]) Y:atoi(argv[2]) Z:atoi(argv[3]) ];
        [ attr setRequest_groups_per_gridWithX:         atoi(argv[4]) Y:atoi(argv[5]) Z:atoi(argv[6]) ];
        [ attr setRequest_threads_per_threadgroupWithX: atoi(argv[7]) Y:atoi(argv[8]) Z:atoi(argv[9]) ];

        [ attr get ];

        NSLog( @"dispatch_quadgroups_per_threadgroup: %u",  attr.dispatch_quadgroups_per_threadgroup );
        NSLog( @"dispatch_simdgroups_per_threadgroup: %u",  attr.dispatch_simdgroups_per_threadgroup );
        NSLog( @"dispatch_threads_per_threadgroup: (%lu, %lu, %lu)"
                                                           ,attr.dispatch_threads_per_threadgroup.width
                                                           ,attr.dispatch_threads_per_threadgroup.height
                                                           ,attr.dispatch_threads_per_threadgroup.depth );
        NSLog( @"grid_origin: (%lu, %lu, %lu)",             attr.grid_origin.width
                                                           ,attr.grid_origin.height
                                                           ,attr.grid_origin.depth );
        NSLog( @"grid_size: (%lu, %lu, %lu)",               attr.grid_size.width
                                                           ,attr.grid_size.height
                                                           ,attr.grid_size.depth );
        NSLog( @"quadgroup_index_in_threadgroup: %u",       attr.quadgroup_index_in_threadgroup );
        NSLog( @"quadgroups_per_threadgroup: %u",           attr.quadgroups_per_threadgroup );

        NSLog( @"simdgroup_index_in_threadgroup: %u",       attr.simdgroup_index_in_threadgroup );
        NSLog( @"simdgroups_per_threadgroup: %u",           attr.simdgroups_per_threadgroup );
        NSLog( @"thread_execution_width: %u",               attr.thread_execution_width );
        NSLog( @"thread_index_in_quadgroup: %u",            attr.thread_index_in_quadgroup );
        NSLog( @"thread_index_in_simdgroup: %u",            attr.thread_index_in_simdgroup );
        NSLog( @"thread_index_in_threadgroup: %u",          attr.thread_index_in_threadgroup );
        NSLog( @"thread_position_in_grid: (%lu, %lu, %lu)", attr.thread_position_in_grid.width
                                                           ,attr.thread_position_in_grid.height
                                                           ,attr.thread_position_in_grid.depth );
        NSLog( @"thread_position_in_threadgroup: (%lu, %lu, %lu)"
                                                           ,attr.thread_position_in_threadgroup.width
                                                           ,attr.thread_position_in_threadgroup.height
                                                           ,attr.thread_position_in_threadgroup.depth );
        NSLog( @"threadgroup_position_in_grid: (%lu, %lu, %lu)"
                                                           ,attr.threadgroup_position_in_grid.width
                                                           ,attr.threadgroup_position_in_grid.height
                                                           ,attr.threadgroup_position_in_grid.depth );
        NSLog( @"threadgroups_per_grid: (%lu, %lu, %lu)",   attr.threadgroups_per_grid.width
                                                           ,attr.threadgroups_per_grid.height
                                                           ,attr.threadgroups_per_grid.depth );
        NSLog( @"threads_per_grid: (%lu, %lu, %lu)",        attr.threads_per_grid.width
                                                           ,attr.threads_per_grid.height
                                                           ,attr.threads_per_grid.depth );
        NSLog( @"threads_per_simdgroup: %u",                attr. threads_per_simdgroup );
        NSLog( @"threads_per_threadgroup: (%lu, %lu, %lu)", attr.threads_per_threadgroup.width
                                                           ,attr.threads_per_threadgroup.height
                                                           ,attr.threads_per_threadgroup.depth );

    }
    return 0;
}

#endif /*TARGET_OS_OSX*/


