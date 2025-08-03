// // TODO Implement this library.
// import 'package:flutter/material.dart';

// class AdminActionsWidget extends StatelessWidget {
//   const AdminActionsWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle('Aksi Cepat'),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildActionButton(
//                   icon: Icons.settings_outlined,
//                   label: 'Pengaturan',
//                   color: const Color(0xFF3F51B5),
//                   onTap: () => _showComingSoon(context),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildActionButton(
//                   icon: Icons.bar_chart_outlined,
//                   label: 'Statistik',
//                   color: const Color(0xFF4CAF50),
//                   onTap: () => _showComingSoon(context),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildActionButton(
//                   icon: Icons.people_outline,
//                   label: 'Kelola User',
//                   color: const Color(0xFFFF9800),
//                   onTap: () => _showComingSoon(context),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildActionButton(
//                   icon: Icons.history_outlined,
//                   label: 'Log Aktivitas',
//                   color: const Color(0xFF9C27B0),
//                   onTap: () => _showComingSoon(context),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF2C3E50),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: color.withOpacity(0.2), width: 1),
//           ),
//           child: Column(
//             children: [
//               Icon(icon, size: 24, color: color),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: color,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showComingSoon(BuildContext context) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: const Row(
//               children: [
//                 Icon(Icons.info_outline, color: Color(0xFF3F51B5)),
//                 SizedBox(width: 8),
//                 Text('Informasi'),
//               ],
//             ),
//             content: const Text('Fitur ini akan segera tersedia!'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//     );
//   }
// }
