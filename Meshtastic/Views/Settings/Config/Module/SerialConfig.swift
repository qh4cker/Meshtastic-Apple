//
//  SerialConfig.swift
//  Meshtastic Apple
//
//  Copyright (c) Garth Vander Houwen 6/22/22.
//
import SwiftUI

struct SerialConfig: View {
	
	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var bleManager: BLEManager
	
	var node: NodeInfoEntity?
	
	@State private var isPresentingSaveConfirm: Bool = false
	@State var initialLoad: Bool = true
	@State var hasChanges = false
	
	@State var enabled = false
	@State var echo = false
	@State var rxd = 0
	@State var txd = 0
	@State var baudRate = 0
	@State var timeout = 0
	@State var mode = 0
	
	var body: some View {
		
		VStack {

			Form {
				
				Section(header: Text("Options")) {
				
					Toggle(isOn: $enabled) {

						Label("Enabled", systemImage: "terminal")
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))
					
					Toggle(isOn: $echo) {

						Label("Echo", systemImage: "repeat")
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))
					Text("If set, any packets you send will be echoed back to your device.")
						.font(.caption)
					
					Picker("Baud Rate", selection: $baudRate ) {
						ForEach(SerialBaudRates.allCases) { sbr in
							Text(sbr.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
					
					Picker("Timeout", selection: $timeout ) {
						ForEach(SerialTimeoutIntervals.allCases) { sti in
							Text(sti.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
					Text("The amount of time to wait before we consider your packet as done.")
						.font(.caption)
					
					Picker("Mode", selection: $mode ) {
						ForEach(SerialModeTypes.allCases) { smt in
							Text(smt.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
				}
				Section(header: Text("GPIO")) {
					
					Picker("Receive data (rxd) GPIO pin", selection: $rxd) {
						ForEach(0..<40) {
							
							if $0 == 0 {
								
								Text("Unset")
								
							} else {
							
								Text("Pin \($0)")
							}
						}
					}
					.pickerStyle(DefaultPickerStyle())

					Picker("Transmit data (txd) GPIO pin", selection: $txd) {
						ForEach(0..<40) {
							
							if $0 == 0 {
								
								Text("Unset")
								
							} else {
							
								Text("Pin \($0)")
							}
						}
					}
					.pickerStyle(DefaultPickerStyle())
					Text("Set the GPIO pins for RXD and TXD.")
						.font(.caption)
				}
			}
			.disabled(node == nil)
			
			Button {
							
				isPresentingSaveConfirm = true
				
			} label: {
				
				Label("Save", systemImage: "square.and.arrow.down")
			}
			.disabled(bleManager.connectedPeripheral == nil || !hasChanges || !(node?.myInfo?.hasWifi ?? false))
			.buttonStyle(.bordered)
			.buttonBorderShape(.capsule)
			.controlSize(.large)
			.padding()
			.confirmationDialog(
				
				"Are you sure?",
				isPresented: $isPresentingSaveConfirm
			) {
				Button("Save Serial Module Config to \(bleManager.connectedPeripheral != nil ? bleManager.connectedPeripheral.longName : "Unknown")?") {
					guard let user = node?.user else { return }
						
					var sc = ModuleConfig.SerialConfig()
					sc.enabled = enabled
					sc.echo = echo
					sc.rxd = UInt32(rxd)
					sc.txd = UInt32(txd)
					sc.baud = SerialBaudRates(rawValue: baudRate)!.protoEnumValue()
					sc.timeout = UInt32(timeout)
					sc.mode	= SerialModeTypes(rawValue: mode)!.protoEnumValue()
					
					let adminMessageId =  bleManager.saveSerialModuleConfig(config: sc, fromUser: user, toUser: user)
					
					if adminMessageId > 0 {
						
						// Should show a saved successfully alert once I know that to be true
						// for now just disable the button after a successful save
						hasChanges = false
						
					} else {
						
					}
				}
			}
			
			.navigationTitle("Serial Config")
			.navigationBarItems(trailing:

				ZStack {

					ConnectedDevice(bluetoothOn: bleManager.isSwitchedOn, deviceConnected: bleManager.connectedPeripheral != nil, name: (bleManager.connectedPeripheral != nil) ? bleManager.connectedPeripheral.shortName : "????")
			})
			.onAppear {

				if self.initialLoad{
					guard let node else { return }
					
					self.bleManager.context = context
					
					self.enabled = node.serialConfig?.enabled ?? false
					self.echo = node.serialConfig?.echo ?? false
					self.rxd = Int(node.serialConfig?.rxd ?? 0)
					self.txd = Int(node.serialConfig?.txd ?? 0)
					self.baudRate = Int(node.serialConfig?.baudRate ?? 0)
					self.timeout = Int(node.serialConfig?.timeout ?? 0)
					self.mode = Int(node.serialConfig?.mode ?? 0)
					
					self.hasChanges = false
					self.initialLoad = false
				}
			}
			.onChange(of: enabled) { newEnabled in
				
			if let serialConfig = node?.serialConfig {
				if newEnabled != serialConfig.enabled { hasChanges = true	}
				}
			}
			.onChange(of: echo) { newEcho in
				
			if let serialConfig = node?.serialConfig {
				if newEcho != serialConfig.echo { hasChanges = true	}
				}
			}
			.onChange(of: rxd) { newRxd in
				
			if let serialConfig = node?.serialConfig {
				if newRxd != serialConfig.rxd { hasChanges = true	}
				}
			}
			.onChange(of: txd) { newTxd in
				
			if let serialConfig = node?.serialConfig {
				if newTxd != serialConfig.txd { hasChanges = true	}
				}
			}
			.onChange(of: baudRate) { newBaud in
				
			if let serialConfig = node?.serialConfig {
				if newBaud != serialConfig.baudRate { hasChanges = true	}
				}
			}
			.onChange(of: timeout) { newTimeout in
				
			if let serialConfig = node?.serialConfig {
				if newTimeout != serialConfig.timeout { hasChanges = true	}
				}
			}
			.onChange(of: mode) { newMode in
				
			if let serialConfig = node?.serialConfig {
				if newMode != serialConfig.mode { hasChanges = true	}
				}
			}
			.navigationViewStyle(StackNavigationViewStyle())
		}
	}
}
