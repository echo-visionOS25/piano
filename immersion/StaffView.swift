//
//  StaffView.swift
//  painoWindow
//
//  Created by AUNG TAYZA OO on 7/8/25.
//

import SwiftUI

struct StaffView: View {
    var lines: Int            // Number of staves (groups of 5 lines)
    var space: CGFloat = 1    // Spacing multiplier between lines

    var body: some View {
        VStack(spacing: 20 * space) {  // Space between staves
            ForEach(0..<lines, id: \.self) { _ in
                VStack(spacing: 10 * space) {  // Space between lines in a staff
                    ForEach(0..<5, id: \.self) { _ in
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {

    StaffView(lines: 2,space: 2)
}
