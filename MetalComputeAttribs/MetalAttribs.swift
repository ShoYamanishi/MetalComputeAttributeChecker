import Foundation
import Metal

// import simd
// Apparently SIMD3<UInt64> can not be used due to alignment.
struct MyUInt3  {
    var x = UInt32(0)
    var y = UInt32(0)
    var z = UInt32(0)
}

struct KernelAttribs
{
    // input from the host CPU
    var request_thread_position_in_grid = MyUInt3()

    // output from the metal device GPU
    var dispatch_quadgroups_per_threadgroup = UInt32(0)
    var dispatch_simdgroups_per_threadgroup = UInt32(0)
    var dispatch_threads_per_threadgroup    = MyUInt3()
    var grid_origin                         = MyUInt3()
    var grid_size                           = MyUInt3()
    var quadgroup_index_in_threadgroup      = UInt32(0)
    var quadgroups_per_threadgroup          = UInt32(0)
    var simdgroup_index_in_threadgroup      = UInt32(0)
    var simdgroups_per_threadgroup          = UInt32(0)
    var thread_execution_width              = UInt32(0)
    var thread_index_in_quadgroup           = UInt32(0)
    var thread_index_in_simdgroup           = UInt32(0)
    var thread_index_in_threadgroup         = UInt32(0)
    var thread_position_in_grid             = MyUInt3()
    var thread_position_in_threadgroup      = MyUInt3()
    var threadgroup_position_in_grid        = MyUInt3()
    var threadgroups_per_grid               = MyUInt3()
    var threads_per_grid                    = MyUInt3()
    var threads_per_simdgroup               = UInt32(0)
    var threads_per_threadgroup             = MyUInt3()
}

class MetalAttribs: ObservableObject {

    private let _pipelineState : MTLComputePipelineState
    private let _commandQueue  : MTLCommandQueue
    private let _attrMetal     : MTLBuffer

    var threadPositionInGrid = MTLSize( width: 0, height:0, depth: 0 )
    var groupsPerGrid        = MTLSize( width: 1, height:1, depth: 1 )
    var threadsPerGroup      = MTLSize( width: 1, height:1, depth: 1 )
    
    init( device: MTLDevice ) {
        
        do {
            guard let library = device.makeDefaultLibrary() else {

                fatalError("Can not make default Metal library")
            }
            
            guard let kernelFunc = library.makeFunction( name: "get_kernel_attribs" ) else {

                fatalError("Can not find kernel function")
            }

            _pipelineState = try device.makeComputePipelineState( function: kernelFunc )
           
            _commandQueue = device.makeCommandQueue()!
            
            _attrMetal = device.makeBuffer( length: MemoryLayout<KernelAttribs>.size, options: MTLResourceOptions.storageModeShared )!
            
        }
        catch {
            fatalError("Exception occurred during Metal pipeline construction.")
        }
        
    }
    
    func run() {
        memset ( _attrMetal.contents(),  0, MemoryLayout<KernelAttribs>.size )
        
        let Attrs : UnsafeMutablePointer<KernelAttribs> = _attrMetal.contents().assumingMemoryBound( to: KernelAttribs.self )
        let pos = MyUInt3( x: (UInt32)( self.threadPositionInGrid.width  ),
                           y: (UInt32)( self.threadPositionInGrid.height ),
                           z: (UInt32)( self.threadPositionInGrid.depth  )  )
        
        Attrs.pointee.request_thread_position_in_grid = pos

        guard let commandBuffer = _commandQueue.makeCommandBuffer() else{
            fatalError("Can not get the Metal command buffer.")
        }
        
        guard let encoder = commandBuffer.makeComputeCommandEncoder() else {
            fatalError("Can not get the Metal encoder.")
        }
        
        encoder.setComputePipelineState( _pipelineState )
        
        encoder.setBuffer( _attrMetal, offset: 0, index: 0 )
        
        encoder.dispatchThreadgroups( groupsPerGrid, threadsPerThreadgroup: threadsPerGroup );
        
        encoder.endEncoding()
        
        commandBuffer.commit()
        
        commandBuffer.waitUntilCompleted()
        
    }
    
    var attributes: KernelAttribs {
    
        self.run()
        
        var kernelAttribs = KernelAttribs()
        memcpy ( &kernelAttribs, _attrMetal.contents(), MemoryLayout<KernelAttribs>.size )
        
        return kernelAttribs;
    }
    
    // State is not used. It is needed to dynamically update List in the view.
    func stringArrayWithState(_ dummyState: Bool) -> [String] {
        return self.stringArray
    }
    
    var stringArray: [String] {
        
        let attr = self.attributes
        
        var kv = [String]()
        
        kv.append( String( format: "dispatch_quadgroups_per_threadgroup: %u", attr.dispatch_quadgroups_per_threadgroup ) )
        kv.append( String( format: "dispatch_simdgroups_per_threadgroup: %u", attr.dispatch_simdgroups_per_threadgroup ) )
        kv.append( String( format: "dispatch_threads_per_threadgroup: (%u, %u, %u)",
                                                      attr.dispatch_threads_per_threadgroup.x,
                                                      attr.dispatch_threads_per_threadgroup.y,
                                                      attr.dispatch_threads_per_threadgroup.z  ) )
        kv.append( String( format: "grid_origin: (%u, %u, %u)",
                                                      attr.grid_origin.x,
                                                      attr.grid_origin.y,
                                                      attr.grid_origin.z  ) )
        kv.append( String( format: "grid_size: (%u, %u, %u)",
                                                      attr.grid_size.x,
                                                      attr.grid_size.y,
                                                      attr.grid_size.z  ) )
        kv.append( String( format: "quadgroup_index_in_threadgroup: %u",      attr.quadgroup_index_in_threadgroup) )
        kv.append( String( format: "quadgroups_per_threadgroup: %u",          attr.quadgroups_per_threadgroup) )
        kv.append( String( format: "simdgroup_index_in_threadgroup: %u",      attr.simdgroup_index_in_threadgroup) )
        kv.append( String( format: "simdgroups_per_threadgroup: %u",          attr.simdgroups_per_threadgroup) )
        kv.append( String( format: "thread_execution_width: %u",              attr.thread_execution_width) )
        kv.append( String( format: "thread_index_in_quadgroup: %u",           attr.thread_index_in_quadgroup) )
        kv.append( String( format: "thread_index_in_simdgroup: %u",           attr.thread_index_in_simdgroup) )
        kv.append( String( format: "thread_index_in_threadgroup: %u",         attr.thread_index_in_threadgroup) )
        kv.append( String( format: "thread_position_in_grid: (%u, %u, %u)",
                                                      attr.thread_position_in_grid.x,
                                                      attr.thread_position_in_grid.y,
                                                      attr.thread_position_in_grid.z  ) )
        kv.append( String( format: "thread_position_in_threadgroup: (%u, %u, %u)",
                                                      attr.thread_position_in_threadgroup.x,
                                                      attr.thread_position_in_threadgroup.y,
                                                      attr.thread_position_in_threadgroup.z  ) )
        kv.append( String( format: "threadgroup_position_in_grid: (%u, %u, %u)",
                                                      attr.threadgroup_position_in_grid.x,
                                                      attr.threadgroup_position_in_grid.y,
                                                      attr.threadgroup_position_in_grid.z  ) )
        kv.append( String( format: "threadgroups_per_grid: (%u, %u, %u)",
                                                      attr.threadgroups_per_grid.x,
                                                      attr.threadgroups_per_grid.y,
                                                      attr.threadgroups_per_grid.z  ) )
        kv.append( String( format: "threads_per_simdgroup: %u",               attr.threads_per_simdgroup) )
        kv.append( String( format: "threads_per_threadgroup: (%u, %u, %u)",
                                                      attr.threads_per_threadgroup.x,
                                                      attr.threads_per_threadgroup.y,
                                                      attr.threads_per_threadgroup.z  ))
        return kv
    }

}
