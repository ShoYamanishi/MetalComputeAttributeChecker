import SwiftUI

class NumbersOnly: ObservableObject {
    @Published var value = "0" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
    
    init(_ val: Int) {
        value = String(val)
    }
    
    func num() -> Int {
        let r = Int(value) ?? 0
        return r
    }
    
}

struct ContentView: View {
    
    @State private var needsUpdate = false
    
    @ObservedObject private var threadIdX        = NumbersOnly(    0 )
    @ObservedObject private var threadIdY        = NumbersOnly(    0 )
    @ObservedObject private var threadIdZ        = NumbersOnly(    0 )
    @ObservedObject private var groupsPerGridX   = NumbersOnly( 1024 )
    @ObservedObject private var groupsPerGridY   = NumbersOnly(    1 )
    @ObservedObject private var groupsPerGridZ   = NumbersOnly(    1 )
    @ObservedObject private var threadsPerGroupX = NumbersOnly(  512 )
    @ObservedObject private var threadsPerGroupY = NumbersOnly(    1 )
    @ObservedObject private var threadsPerGroupZ = NumbersOnly(    1 )

    var metalAttribs = MetalAttribs( device: MTLCreateSystemDefaultDevice()! )
    
    var body: some View {

        VStack( alignment:.center ) {

            HStack{

                Text( "thread index (x,y,z)" )
                
                TextField( "X", text: $threadIdX.value ).padding().keyboardType(.decimalPad)
                TextField( "Y", text: $threadIdY.value ).padding().keyboardType(.decimalPad)
                TextField( "Z", text: $threadIdZ.value ).padding().keyboardType(.decimalPad)

            }

            HStack{
                
                Text( "groups per grid (x,y,z)" )
                
                TextField( "X", text: $groupsPerGridX .value ).padding().keyboardType(.decimalPad)
                TextField( "Y", text: $groupsPerGridY .value ).padding().keyboardType(.decimalPad)
                TextField( "Z", text: $groupsPerGridZ .value ).padding().keyboardType(.decimalPad)
            }

            HStack{
                
                Text("threads per group (x,y,z)")

                TextField( "X", text: $threadsPerGroupX .value ).padding().keyboardType(.decimalPad)
                TextField( "Y", text: $threadsPerGroupY .value ).padding().keyboardType(.decimalPad)
                TextField( "Z", text: $threadsPerGroupZ .value ).padding().keyboardType(.decimalPad)
            }

            Button( "press to update" ) {
                
                needsUpdate.toggle()
               
                metalAttribs.threadPositionInGrid = MTLSizeMake(
                    max( 0, threadIdX.num() ),
                    max( 0, threadIdY.num() ),
                    max( 0, threadIdZ.num() ) )

                metalAttribs.groupsPerGrid = MTLSizeMake(
                    max( 1, groupsPerGridX.num() ),
                    max( 1, groupsPerGridY.num() ),
                    max( 1, groupsPerGridZ.num() ) )

                metalAttribs.threadsPerGroup = MTLSizeMake(
                    max( 1, threadsPerGroupX.num() ),
                    max( 1, threadsPerGroupY.num() ),
                    max( 1, threadsPerGroupZ.num() ) )

                hideKeyboard()
            }

            List( metalAttribs.stringArrayWithState(needsUpdate), id:\.self ) { Text($0) }
        }
    }
}

#if canImport(UIKit)
extension ContentView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector( UIResponder.resignFirstResponder ), to: nil, from: nil, for: nil )
    }
}
#endif

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject( MetalAttribs( device: MTLCreateSystemDefaultDevice()! ) )
    }
}
