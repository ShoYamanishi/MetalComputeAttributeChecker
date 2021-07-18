#include <metal_stdlib>
using namespace metal;

// uint3 can not be used due to alignment (16 bytes, not 3*4 = 12 bytes)
using namespace metal;
typedef
struct _my_uint3
{
    uint32_t x;
    uint32_t y;
    uint32_t z;
} my_uint3;

struct kernel_attribs
{
    // input from the host CPU
    my_uint3 request_thread_position_in_grid;

    // output from the metal device GPU
    uint32_t dispatch_quadgroups_per_threadgroup;
    uint32_t dispatch_simdgroups_per_threadgroup;
    my_uint3 dispatch_threads_per_threadgroup;
    my_uint3 grid_origin;
    my_uint3 grid_size;
    uint32_t quadgroup_index_in_threadgroup;
    uint32_t quadgroups_per_threadgroup;
    uint32_t simdgroup_index_in_threadgroup;
    uint32_t simdgroups_per_threadgroup;
    uint32_t thread_execution_width;
    uint32_t thread_index_in_quadgroup;
    uint32_t thread_index_in_simdgroup;
    uint32_t thread_index_in_threadgroup;
    my_uint3 thread_position_in_grid;
    my_uint3 thread_position_in_threadgroup;
    my_uint3 threadgroup_position_in_grid;
    my_uint3 threadgroups_per_grid;
    my_uint3 threads_per_grid;
    uint32_t threads_per_simdgroup;
    my_uint3 threads_per_threadgroup;
};

kernel void get_kernel_attribs(

    device       kernel_attribs& attr [[ buffer(0) ]],

    const uint  dispatch_quadgroups_per_threadgroup [[ dispatch_quadgroups_per_threadgroup ]],
    const uint  dispatch_simdgroups_per_threadgroup [[ dispatch_simdgroups_per_threadgroup ]], // ios-metal2.2 or higher i.e. ios 13.
    const uint3 dispatch_threads_per_threadgroup    [[ dispatch_threads_per_threadgroup ]],
    const uint3 grid_origin                         [[ grid_origin ]],
    const uint3 grid_size                           [[ grid_size ]],
    const uint  quadgroup_index_in_threadgroup      [[ quadgroup_index_in_threadgroup ]],
    const uint  quadgroups_per_threadgroup          [[ quadgroups_per_threadgroup ]],
    const uint  simdgroup_index_in_threadgroup      [[ simdgroup_index_in_threadgroup ]],
    const uint  simdgroups_per_threadgroup          [[ simdgroups_per_threadgroup ]], // ios-metal2.2 or higher i.e. ios 13.
    const uint  thread_execution_width              [[ thread_execution_width ]],
    const uint  thread_index_in_quadgroup           [[ thread_index_in_quadgroup ]],
    const uint  thread_index_in_simdgroup           [[ thread_index_in_simdgroup ]], // ios-metal2.2 or higher i.e. ios 13.
    const uint  thread_index_in_threadgroup         [[ thread_index_in_threadgroup ]],
    const uint3 thread_position_in_grid             [[ thread_position_in_grid ]],
    const uint3 thread_position_in_threadgroup      [[ thread_position_in_threadgroup ]],
    const uint3 threadgroup_position_in_grid        [[ threadgroup_position_in_grid ]],
    const uint3 threadgroups_per_grid               [[ threadgroups_per_grid ]],
    const uint3 threads_per_grid                    [[ threads_per_grid ]],
    const uint  threads_per_simdgroup               [[ threads_per_simdgroup ]], // ios-metal2.2 or higher i.e. ios 13.
    const uint3 threads_per_threadgroup             [[ threads_per_threadgroup ]]

) {
    if (    thread_position_in_grid.x == attr.request_thread_position_in_grid.x
         && thread_position_in_grid.y == attr.request_thread_position_in_grid.y
         && thread_position_in_grid.z == attr.request_thread_position_in_grid.z ) {

        attr.dispatch_quadgroups_per_threadgroup = dispatch_quadgroups_per_threadgroup;
        attr.dispatch_simdgroups_per_threadgroup = dispatch_simdgroups_per_threadgroup;
        attr.dispatch_threads_per_threadgroup.x  = dispatch_threads_per_threadgroup.x;
        attr.dispatch_threads_per_threadgroup.y  = dispatch_threads_per_threadgroup.y;
        attr.dispatch_threads_per_threadgroup.z  = dispatch_threads_per_threadgroup.z;
        attr.grid_origin.x                       = grid_origin.x;
        attr.grid_origin.y                       = grid_origin.y;
        attr.grid_origin.z                       = grid_origin.z;
        attr.grid_size.x                         = grid_size.x;
        attr.grid_size.y                         = grid_size.y;
        attr.grid_size.z                         = grid_size.z;
        attr.quadgroup_index_in_threadgroup      = quadgroup_index_in_threadgroup;
        attr.quadgroups_per_threadgroup          = quadgroups_per_threadgroup;
        attr.simdgroup_index_in_threadgroup      = simdgroup_index_in_threadgroup;
        attr.simdgroups_per_threadgroup          = simdgroups_per_threadgroup;
        attr.thread_execution_width              = thread_execution_width;
        attr.thread_index_in_quadgroup           = thread_index_in_quadgroup;
        attr.thread_index_in_simdgroup           = thread_index_in_simdgroup;
        attr.thread_index_in_threadgroup         = thread_index_in_threadgroup;
        attr.thread_position_in_grid.x           = thread_position_in_grid.x;
        attr.thread_position_in_grid.y           = thread_position_in_grid.y;
        attr.thread_position_in_grid.z           = thread_position_in_grid.z;
        attr.thread_position_in_threadgroup.x    = thread_position_in_threadgroup.x;
        attr.thread_position_in_threadgroup.y    = thread_position_in_threadgroup.y;
        attr.thread_position_in_threadgroup.z    = thread_position_in_threadgroup.z;
        attr.threadgroup_position_in_grid.x      = threadgroup_position_in_grid.x;
        attr.threadgroup_position_in_grid.y      = threadgroup_position_in_grid.y;
        attr.threadgroup_position_in_grid.z      = threadgroup_position_in_grid.z;
        attr.threadgroups_per_grid.x             = threadgroups_per_grid.x;
        attr.threadgroups_per_grid.y             = threadgroups_per_grid.y;
        attr.threadgroups_per_grid.z             = threadgroups_per_grid.z;
        attr.threads_per_grid.x                  = threads_per_grid.x;
        attr.threads_per_grid.y                  = threads_per_grid.y;
        attr.threads_per_grid.z                  = threads_per_grid.z;
        attr.threads_per_simdgroup               = threads_per_simdgroup;
        attr.threads_per_threadgroup.x           = threads_per_threadgroup.x;
        attr.threads_per_threadgroup.y           = threads_per_threadgroup.y;
        attr.threads_per_threadgroup.z           = threads_per_threadgroup.z;
    }
}
