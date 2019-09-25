//
//  CheckoutView.swift
//  iDine
//
//  Created by Artur Pedyczak on 2019-09-23.
//  Copyright © 2019 Artur Pedyczak. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var order : Order
    @State private var paymentType = 0
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 1
    @State private var showingPaymentAlert = false
    static let tipAmounts = [10, 15,20, 25, 0]
    var totalPrice: Double {
        let total = Double(order.total)
        let tipValue = total / 100 * Double(Self.tipAmounts[tipAmount])
        return total + tipValue
    }
    
    static let paymentTypes = ["cash", "Credit card", "iDine points"]
    var body: some View {
        Form {
            Section {
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach (0 ..< Self.paymentTypes.count) {
                        Text(Self.paymentTypes[$0])
                    }
                }
                Toggle(isOn: $addLoyaltyDetails.animation()) {
                    Text("Add iDine loyalty card")
                }
                if addLoyaltyDetails {
                    TextField("Enter your iDine ID", text: $loyaltyNumber)
                }
            }
            Section(header : Text("add a tip?")) {
                Picker("Percentage:", selection:  $tipAmount) {
                    ForEach(0 ..< Self.tipAmounts.count) {
                        Text("\(Self.tipAmounts[$0])%")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("TOTAL: $\(totalPrice, specifier: "%.2f")") .font(.largeTitle)
)
            {
                Button("Confirm Order") {
                    self.showingPaymentAlert.toggle()
                }
            }
        
        }
        .navigationBarTitle(Text("Payment"), displayMode: .inline)
        .alert(isPresented: $showingPaymentAlert) {
            Alert(title: Text("Order COnfirmed"), message: Text("Your total was $\(totalPrice, specifier: "%.2f")"), dismissButton: .default(Text("OK")))
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        CheckoutView()
    }
}
