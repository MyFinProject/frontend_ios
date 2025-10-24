import SwiftUI

struct CategoryCardView: View {
    var number: Int = 1
    var name: String = "название"
    var limitation: Int = 0
    
    var body: some View {
        HStack(spacing: 46) {
            HStack(spacing: 2) {
                Text("\(number).")
                Text(name)
            }
            
            HStack {
                Text("ограничение:\(limitation)")
                
                Button {
                    //
                } label: {
                    Image(systemName: "pencil")
                }
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.fontApp, lineWidth: 2)
                )
            }
        }
    }
}

#Preview {
    CategoryCardView()
}
