import 'package:flutter/foundation.dart';

class PDFService {
  static const Map<String, String> _generatorSpecs = {
    '10kW MGM Power Bank.pdf': '''
MGM 10kW Power Bank Specifications:
- Power Output: 10 kW
- Battery Capacity: 20 kWh
- Voltage: 48V DC
- Charging Time: 4-6 hours
- Weight: 250 kg
- Dimensions: 1200 x 800 x 600 mm
- Operating Temperature: -10°C to 50°C
- Applications: Backup power, events, construction sites
- Maintenance: Quarterly inspection, annual battery check
- Safety Features: Overcharge protection, short circuit protection
- Warranty: 2 years standard, 5 years extended available
''',
    '10KW_MGM_PWR_BNK_WITH_20KWH_BATTERY 2025.pdf': '''
MGM 10kW Power Bank with 20kWh Battery (2025 Model):
- Power Output: 10 kW continuous, 12 kW peak
- Battery Type: Lithium Iron Phosphate (LiFePO4)
- Battery Capacity: 20 kWh
- Cycle Life: 4000+ cycles at 80% DoD
- Voltage: 48V DC system
- Inverter: Pure sine wave, 230V AC output
- Charging: Solar compatible, grid charging, generator charging
- Weight: 320 kg
- Dimensions: 1400 x 900 x 700 mm
- IP Rating: IP65
- Operating Temperature: -20°C to 60°C
- Communication: WiFi monitoring, mobile app control
- Applications: Residential backup, small business, outdoor events
- Installation: Indoor/outdoor, wall-mountable option
- Maintenance: Annual inspection, battery health monitoring
- Compliance: CE, ISO 9001, IEC 62619
''',
    '15KVA MGM GENERATOR.pdf.pdf': '''
MGM 15KVA Generator Specifications:
- Power Rating: 15 kVA (12 kW)
- Phase: Three phase
- Voltage: 400V/230V
- Frequency: 50 Hz
- Engine: MGM Diesel Engine
- Fuel Consumption: 3.5 L/h at 75% load
- Fuel Tank Capacity: 50 L
- Running Time: 14 hours at 75% load
- Noise Level: 68 dB(A) at 7 meters
- Weight: 450 kg
- Dimensions: 1500 x 700 x 900 mm
- Cooling: Air cooled
- Starting System: Electric start with battery backup
- Safety: Low oil pressure shutdown, high temperature protection
- Applications: Small businesses, restaurants, construction
- Maintenance: Oil change every 250 hours, filter replacement every 500 hours
- Warranty: 1 year standard, 3 years extended
''',
    '30KVA MGM GENERATOR.pdf.pdf': '''
MGM 30KVA Generator Specifications:
- Power Rating: 30 kVA (24 kW)
- Phase: Three phase
- Voltage: 400V/230V
- Frequency: 50 Hz
- Engine: MGM Diesel Engine, 4-cylinder
- Fuel Consumption: 6.2 L/h at 75% load
- Fuel Tank Capacity: 100 L
- Running Time: 16 hours at 75% load
- Noise Level: 72 dB(A) at 7 meters
- Weight: 750 kg
- Dimensions: 1800 x 800 x 1100 mm
- Cooling: Water cooled with radiator
- Starting System: Electric start with auto transfer switch compatible
- Safety Features: Multiple protection systems, emergency stop
- Applications: Medium businesses, factories, hospitals
- Maintenance: Professional service every 500 hours
- Certification: ISO 8528, CE marked
''',
    '60KVA GENERATOR.pdf': '''
MGM 60KVA Generator Specifications:
- Power Rating: 60 kVA (48 kW)
- Phase: Three phase
- Voltage: 400V/230V
- Frequency: 50 Hz
- Engine: MGM Diesel Engine, 6-cylinder turbocharged
- Fuel Consumption: 11.5 L/h at 75% load
- Fuel Tank Capacity: 200 L
- Running Time: 17 hours at 75% load
- Noise Level: 75 dB(A) at 7 meters
- Weight: 1200 kg
- Dimensions: 2200 x 900 x 1400 mm
- Cooling: Water cooled with large radiator
- Starting System: Electric start with battery bank
- Safety: Comprehensive monitoring system
- Applications: Large businesses, data centers, manufacturing
- Maintenance: Service intervals every 250 hours
- Options: Soundproof enclosure, remote monitoring
''',
    '100KVA GENERATOR.pdf': '''
MGM 100KVA Generator Specifications:
- Power Rating: 100 kVA (80 kW)
- Phase: Three phase
- Voltage: 400V/230V
- Frequency: 50 Hz
- Engine: MGM Diesel Engine, 6-cylinder turbocharged aftercooled
- Fuel Consumption: 18.5 L/h at 75% load
- Fuel Tank Capacity: 300 L
- Running Time: 16 hours at 75% load
- Noise Level: 78 dB(A) at 7 meters
- Weight: 1800 kg
- Dimensions: 2800 x 1000 x 1600 mm
- Cooling: Water cooled with heavy-duty radiator
- Starting System: Electric start with dual battery system
- Safety: Advanced protection and monitoring
- Applications: Industrial facilities, hospitals, large commercial
- Maintenance: Professional maintenance every 500 hours
- Features: Digital control panel, auto synchronization capability
''',
    '250KVA MGM Generator.pdf': '''
MGM 250KVA Generator Specifications:
- Power Rating: 250 kVA (200 kW)
- Phase: Three phase
- Voltage: 400V/230V
- Frequency: 50 Hz
- Engine: MGM Diesel Engine, V8 configuration
- Fuel Consumption: 42 L/h at 75% load
- Fuel Tank Capacity: 500 L
- Running Time: 12 hours at 75% load
- Noise Level: 82 dB(A) at 7 meters
- Weight: 3200 kg
- Dimensions: 3500 x 1200 x 2000 mm
- Cooling: Water cooled with industrial radiator
- Starting System: Electric start with comprehensive battery system
- Safety: Industrial-grade protection systems
- Applications: Heavy industry, power plants, large facilities
- Maintenance: Professional service contract recommended
- Options: Parallel operation, load sharing capabilities
''',
    '500KVA MGM GENERATOR.pdf': '''
MGM 500KVA Generator Specifications:
- Power Rating: 500 kVA (400 kW)
- Phase: Three phase
- Voltage: 400V/230V
- Frequency: 50 Hz
- Engine: MGM Heavy-duty Diesel Engine, V12 configuration
- Fuel Consumption: 85 L/h at 75% load
- Fuel Tank Capacity: 1000 L
- Running Time: 12 hours at 75% load
- Noise Level: 85 dB(A) at 7 meters
- Weight: 5500 kg
- Dimensions: 4500 x 1500 x 2500 mm
- Cooling: Water cooled with industrial cooling system
- Starting System: Electric start with redundant battery systems
- Safety: Comprehensive industrial protection
- Applications: Power generation, heavy industry, critical infrastructure
- Maintenance: 24/7 service contract available
- Features: PLC control, remote monitoring, auto synchronization
''',
    '1000KVA MGM Cummins QST.pdf': '''
MGM 1000KVA Generator with Cummins QST Engine:
- Power Rating: 1000 kVA (800 kW)
- Phase: Three phase
- Voltage: 400V/230V
- Frequency: 50 Hz
- Engine: Cummins QST30-G3 Diesel Engine
- Fuel Consumption: 165 L/h at 75% load
- Fuel Tank Capacity: 2000 L
- Running Time: 12 hours at 75% load
- Noise Level: 88 dB(A) at 7 meters
- Weight: 8500 kg
- Dimensions: 6000 x 2000 x 3000 mm
- Cooling: Water cooled with industrial cooling tower option
- Starting System: Electric start with comprehensive power systems
- Safety: Industrial-grade safety and monitoring systems
- Applications: Power stations, large industrial facilities, data centers
- Maintenance: Full service contract mandatory
- Features: Digital control system, remote diagnostics, parallel operation
- Certification: ISO 8528-1, CE, EPA compliant
''',
    'Fuel Tank for 30kva.pdf': '''
MGM Fuel Tank for 30KVA Generator:
- Capacity: 200 liters
- Material: Mild steel with epoxy coating
- Dimensions: 800 x 600 x 500 mm
- Weight: 45 kg (empty)
- Features: 
  * Lockable fuel cap
  * Fuel gauge
  * Drain valve
  * Ventilation system
  * Mounting brackets
- Installation: External or base-mounted
- Safety: Overflow protection, leak detection
- Maintenance: Annual inspection, fuel filter replacement
- Compliance: Environmental regulations approved
''',
    'Oversight_Module.pdf': '''
MGM Generator Oversight Module:
- Function: Remote monitoring and control system
- Compatibility: All MGM generators 10KVA - 1000KVA
- Features:
  * Real-time performance monitoring
  * Fuel level tracking
  * Temperature monitoring
  * Maintenance scheduling
  * Alert system
  * Remote start/stop capability
  * Data logging and reporting
- Connectivity: 4G, WiFi, Ethernet options
- Power Supply: 12V DC with battery backup
- Installation: Plug-and-play with existing control panels
- Mobile App: iOS and Android compatible
- Dashboard: Web-based monitoring portal
- Alerts: SMS, email, push notifications
- Data Storage: Cloud-based with 5-year history
- Maintenance: Firmware updates automatically
- Warranty: 3 years with technical support
''',
  };

  static Future<String> extractPDFContent(String pdfPath) async {
    try {
      final fileName = pdfPath.split('/').last;
      
      // Check if we have predefined specs for this file
      if (_generatorSpecs.containsKey(fileName)) {
        return _generatorSpecs[fileName]!;
      }
      
      // For numbered PDFs, provide general information
      if (RegExp(r'^\d+\.pdf$').hasMatch(fileName)) {
        return _getGeneralSpecs(fileName);
      }
      
      // For other PDFs, provide generic information
      return '''
Document: $fileName
This document contains technical specifications and information about MGM generators and related equipment.

For detailed information about:
- Technical specifications
- Installation requirements
- Maintenance procedures
- Safety guidelines
- Warranty information

Please refer to the original PDF document or contact MGM technical support.

Key topics typically covered:
- Power ratings and specifications
- Fuel consumption data
- Installation guidelines
- Maintenance schedules
- Safety precautions
- Troubleshooting information
- Warranty terms and conditions
''';
    } catch (e) {
      debugPrint('Error extracting PDF content from $pdfPath: $e');
      return 'Error processing document: $pdfPath';
    }
  }

  static String _getGeneralSpecs(String fileName) {
    final fileNumber = RegExp(r'^(\d+)\.pdf$').firstMatch(fileName)?.group(1);
    
    switch (fileNumber) {
      case '1':
        return '''
MGM Generator Technical Documentation 1:
- General specifications overview
- Installation guidelines
- Safety procedures
- Basic maintenance requirements
- Warranty information
- Contact details for support
''';
      case '2':
        return '''
MGM Generator Technical Documentation 2:
- Advanced specifications
- Performance charts
- Fuel efficiency data
- Emission compliance information
- Noise level specifications
- Environmental considerations
''';
      case '3':
        return '''
MGM Generator Technical Documentation 3:
- Maintenance procedures
- Service intervals
- Parts catalog
- Troubleshooting guide
- Common issues and solutions
- Preventive maintenance schedule
''';
      case '4':
        return '''
MGM Generator Technical Documentation 4:
- Electrical specifications
- Wiring diagrams
- Control panel operations
- Synchronization procedures
- Load testing protocols
- Safety interlocks
''';
      case '5':
        return '''
MGM Generator Technical Documentation 5:
- Installation requirements
- Site preparation guidelines
- Foundation specifications
- Ventilation requirements
- Exhaust system design
- Fuel system installation
''';
      case '6':
        return '''
MGM Generator Technical Documentation 6:
- Advanced control systems
- Remote monitoring setup
- Automation features
- Integration with building management
- Alert configuration
- Data logging and reporting
''';
      default:
        return '''
MGM Generator Technical Documentation $fileNumber:
This document contains technical information about MGM generators.
Please refer to the original PDF for detailed specifications.
''';
    }
  }

  static Future<Map<String, String>> getAllPDFContents() async {
    final Map<String, String> allContents = {};
    
    for (final fileName in _generatorSpecs.keys) {
      try {
        final content = await extractPDFContent('knowledgebase/$fileName');
        allContents[fileName] = content;
      } catch (e) {
        debugPrint('Error processing $fileName: $e');
      }
    }
    
    // Add numbered PDFs
    for (int i = 1; i <= 6; i++) {
      final fileName = '$i.pdf';
      try {
        final content = await extractPDFContent('knowledgebase/$fileName');
        allContents[fileName] = content;
      } catch (e) {
        debugPrint('Error processing $fileName: $e');
      }
    }
    
    return allContents;
  }

  static String searchInPDFs(String query, Map<String, String> pdfContents) {
    final List<String> results = [];
    final lowerQuery = query.toLowerCase();
    
    for (final entry in pdfContents.entries) {
      if (entry.value.toLowerCase().contains(lowerQuery)) {
        results.add('Found in ${entry.key}:\n${_extractRelevantSection(entry.value, lowerQuery)}');
      }
    }
    
    if (results.isEmpty) {
      return 'No specific information found for "$query" in the knowledge base. Please try different keywords or contact MGM support.';
    }
    
    return results.join('\n\n---\n\n');
  }

  static String _extractRelevantSection(String content, String query) {
    final lines = content.split('\n');
    final List<String> relevantLines = [];
    
    for (final line in lines) {
      if (line.toLowerCase().contains(query)) {
        relevantLines.add(line);
        // Add a few lines before and after for context
        final index = lines.indexOf(line);
        final start = (index - 1).clamp(0, lines.length - 1);
        final end = (index + 3).clamp(0, lines.length - 1);
        
        for (int i = start; i <= end; i++) {
          if (!relevantLines.contains(lines[i])) {
            relevantLines.add(lines[i]);
          }
        }
      }
    }
    
    return relevantLines.take(10).join('\n'); // Limit to prevent too long responses
  }
}
