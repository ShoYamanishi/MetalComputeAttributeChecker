#import <Foundation/Foundation.h>
#import <Metal/Metal.h>


// For ILP32, LLP64, and LP64 systems
typedef unsigned int uint32;

@interface GetMetalAttrs : NSObject

- (instancetype) init;
- (void) get;
- (void) setRequest_thread_position_in_gridWithX:(uint32)x Y:(uint32)y Z:(uint32)z;
- (void) setRequest_groups_per_gridWithX:        (uint32)x Y:(uint32)y Z:(uint32)z;
- (void) setRequest_threads_per_threadgroupWithX:(uint32)x Y:(uint32)y Z:(uint32)z;

@property MTLSize request_thread_position_in_grid;
@property MTLSize request_groups_per_grid;
@property MTLSize request_threads_per_threadgroup;

@property (readonly) uint32  dispatch_quadgroups_per_threadgroup;
@property (readonly) uint32  dispatch_simdgroups_per_threadgroup;
@property (readonly) MTLSize dispatch_threads_per_threadgroup;
@property (readonly) MTLSize grid_origin;
@property (readonly) MTLSize grid_size;
@property (readonly) uint32  quadgroup_index_in_threadgroup;
@property (readonly) uint32  quadgroups_per_threadgroup;
@property (readonly) uint32  simdgroup_index_in_threadgroup;
@property (readonly) uint32  simdgroups_per_threadgroup;
@property (readonly) uint32  thread_execution_width;
@property (readonly) uint32  thread_index_in_quadgroup;
@property (readonly) uint32  thread_index_in_simdgroup;
@property (readonly) uint32  thread_index_in_threadgroup;
@property (readonly) MTLSize thread_position_in_grid;
@property (readonly) MTLSize thread_position_in_threadgroup;
@property (readonly) MTLSize threadgroup_position_in_grid;
@property (readonly) MTLSize threadgroups_per_grid;
@property (readonly) MTLSize threads_per_grid;
@property (readonly) uint32  threads_per_simdgroup;
@property (readonly) MTLSize threads_per_threadgroup;

@end
