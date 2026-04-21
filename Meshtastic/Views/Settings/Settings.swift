//
//  Settings.swift
//  MeshtasticApple
//
//  Copyright (c) Garth Vander Houwen 6/9/22.
//

import SwiftUI

struct Settings: View {
	
	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var bleManager: BLEManager
	@EnvironmentObject var userSettings: UserSettings
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(key: "lastHeard", ascending: false)],
		animation: .default)

	private var nodes: FetchedResults<NodeInfoEntity>
	
	var body: some View {
		NavigationView {
			
			List {
				
				let connectedNodeNum = bleManager.connectedPeripheral != nil ? bleManager.connectedPeripheral.num : 0
				let connectedNode = nodes.first(where: { $0.num == connectedNodeNum })
				let waitingForNodeRecord = bleManager.connectedPeripheral != nil && connectedNode == nil
				
				NavigationLink() {
					AppSettings()
				} label: {

					Image(systemName: "gearshape")
						.symbolRenderingMode(.hierarchical)
					Text("App Settings")
				}
				
				Section("Radio Configuration") {
					
					NavigationLink {
						ShareChannel(node: connectedNode)
					} label: {
						Image(systemName: "qrcode")
							.symbolRenderingMode(.hierarchical)
						VStack(alignment: .leading) {
							Text("Share Channel QR Code")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink {
						UserConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "person.crop.rectangle.fill")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("User")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink() {
						
						LoRaConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "dot.radiowaves.left.and.right")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("LoRa")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink() {
						
						BluetoothConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "antenna.radiowaves.left.and.right")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("Bluetooth (BLE)")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink {
						DeviceConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "flipphone")
							.symbolRenderingMode(.hierarchical)
						VStack(alignment: .leading) {
							Text("Device")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink {
						DisplayConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "display")
							.symbolRenderingMode(.hierarchical)
						VStack(alignment: .leading) {
							Text("Display (Device Screen)")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink {
						NetworkConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "network")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("Network (ESP32 Only)")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
				
					NavigationLink {
						PositionConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "location")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("Position")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
				}
				Section("Module Configuration") {
					
					NavigationLink {
						CannedMessagesConfig(node: connectedNode)
					} label: {

						Image(systemName: "list.bullet.rectangle.fill")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("Canned Messages")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink {
						ExternalNotificationConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "megaphone")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("External Notification")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink {
						MQTTConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "dot.radiowaves.right")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("MQTT (ESP32 Only)")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink {
						RangeTestConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "point.3.connected.trianglepath.dotted")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("Range Test (ESP32 Only)")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					
					NavigationLink {
						SerialConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "terminal")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("Serial")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
					

					NavigationLink {
						TelemetryConfig(node: connectedNode)
					} label: {
					
						Image(systemName: "chart.xyaxis.line")
							.symbolRenderingMode(.hierarchical)

						VStack(alignment: .leading) {
							Text("Telemetry (Sensors)")
							if waitingForNodeRecord {
								Text("Waiting for node record")
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
					.disabled(bleManager.connectedPeripheral == nil || connectedNode == nil)
				}
				Section(header: Text("Logging")) {
					
					NavigationLink {
						
						MeshLog()
						
					} label: {

						Image(systemName: "list.bullet.rectangle")
							.symbolRenderingMode(.hierarchical)

						Text("Mesh Log")
					}
					
					NavigationLink {
						
						AdminMessageList(user: connectedNode?.user)
					} label: {

						Image(systemName: "building.columns")
							.symbolRenderingMode(.hierarchical)

						Text("Admin Message Log")
					}
					.disabled(bleManager.connectedPeripheral == nil)
				}
				
				// Not Implemented:
				// Store Forward Config - Not Working, TBEAM Only
				// MQTT Config - Can do from WebUI once WiFi is enabled
			}
			.onAppear {

				self.bleManager.context = context
				self.bleManager.userSettings = userSettings
				
			}
			.listStyle(GroupedListStyle())
			.navigationTitle("Settings")
		}
	}
}
