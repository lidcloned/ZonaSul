import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/role_service.dart';
import '../models/user_model.dart';

class MemberManagementScreen extends StatefulWidget {
  const MemberManagementScreen({super.key});

  @override
  State<MemberManagementScreen> createState() => _MemberManagementScreenState();
}

class _MemberManagementScreenState extends State<MemberManagementScreen> {
  final RoleService _roleService = RoleService();
  bool _isLoading = false;
  List<UserModel> _members = [];
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simular carregamento de membros do Firestore
      // Em produção, isso seria um stream do Firestore
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _members = [
          UserModel(
            uid: '1',
            username: 'Dono',
            email: 'dono@exemplo.com',
            gameName: 'Dono123',
            whatsapp: '11999999999',
            role: 'owner',
            level: 50,
            hoursPlayed: 500,
            points: 10000,
            joinDate: DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
          ),
          UserModel(
            uid: '2',
            username: 'Admin1',
            email: 'admin1@exemplo.com',
            gameName: 'Admin123',
            whatsapp: '11988888888',
            role: 'admin',
            level: 40,
            hoursPlayed: 400,
            points: 8000,
            joinDate: DateTime.now().subtract(const Duration(days: 300)).toIso8601String(),
          ),
          UserModel(
            uid: '3',
            username: 'Admin2',
            email: 'admin2@exemplo.com',
            gameName: 'Admin456',
            whatsapp: '11977777777',
            role: 'admin',
            level: 35,
            hoursPlayed: 350,
            points: 7000,
            joinDate: DateTime.now().subtract(const Duration(days: 250)).toIso8601String(),
          ),
          UserModel(
            uid: '4',
            username: 'Membro1',
            email: 'membro1@exemplo.com',
            gameName: 'Membro123',
            whatsapp: '11966666666',
            role: 'member',
            level: 25,
            hoursPlayed: 200,
            points: 4000,
            joinDate: DateTime.now().subtract(const Duration(days: 180)).toIso8601String(),
          ),
          UserModel(
            uid: '5',
            username: 'Membro2',
            email: 'membro2@exemplo.com',
            gameName: 'Membro456',
            whatsapp: '11955555555',
            role: 'member',
            level: 20,
            hoursPlayed: 150,
            points: 3000,
            joinDate: DateTime.now().subtract(const Duration(days: 150)).toIso8601String(),
          ),
          UserModel(
            uid: '6',
            username: 'Membro3',
            email: 'membro3@exemplo.com',
            gameName: 'Membro789',
            whatsapp: '11944444444',
            role: 'member',
            level: 15,
            hoursPlayed: 100,
            points: 2000,
            joinDate: DateTime.now().subtract(const Duration(days: 120)).toIso8601String(),
          ),
          UserModel(
            uid: '7',
            username: 'Novato1',
            email: 'novato1@exemplo.com',
            gameName: 'Novato123',
            whatsapp: '11933333333',
            role: 'member',
            level: 5,
            hoursPlayed: 20,
            points: 500,
            joinDate: DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
          ),
          UserModel(
            uid: '8',
            username: 'Novato2',
            email: 'novato2@exemplo.com',
            gameName: 'Novato456',
            whatsapp: '11922222222',
            role: 'member',
            level: 3,
            hoursPlayed: 10,
            points: 200,
            joinDate: DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
          ),
        ];
      });
    } catch (e) {
      // Tratar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar membros: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<UserModel> _getFilteredMembers() {
    switch (_selectedFilter) {
      case 'Donos':
        return _members.where((member) => member.role == 'owner').toList();
      case 'Administradores':
        return _members.where((member) => member.role == 'admin').toList();
      case 'Membros':
        return _members.where((member) => member.role == 'member').toList();
      default:
        return _members;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.user;
    final filteredMembers = _getFilteredMembers();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Membros'),
        backgroundColor: const Color(0xFF7289DA),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtros
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF2F3136),
                  child: Row(
                    children: [
                      const Text('Filtrar por:'),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF40444B),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFilter = newValue;
                              });
                            }
                          },
                          items: <String>[
                            'Todos',
                            'Donos',
                            'Administradores',
                            'Membros',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Lista de membros
                Expanded(
                  child: filteredMembers.isEmpty
                      ? const Center(
                          child: Text('Nenhum membro encontrado'),
                        )
                      : ListView.builder(
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            final bool isCurrentUser = currentUser?.uid == member.uid;
                            
                            return Card(
                              color: const Color(0xFF2F3136),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getRoleColor(member.role),
                                  child: Text(
                                    member.username[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(member.username),
                                    if (isCurrentUser)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[700],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          'Você',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Cargo: ${_getRoleName(member.role)}'),
                                    Text('Nível: ${member.level} | Pontos: ${member.points}'),
                                  ],
                                ),
                                trailing: currentUser?.role == 'owner' && !isCurrentUser
                                    ? PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (value) => _handleMemberAction(value, member),
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            if (member.role == 'member')
                                              const PopupMenuItem<String>(
                                                value: 'promote',
                                                child: Text('Promover a Administrador'),
                                              ),
                                            if (member.role == 'admin')
                                              const PopupMenuItem<String>(
                                                value: 'demote',
                                                child: Text('Rebaixar para Membro'),
                                              ),
                                            if (member.role == 'admin')
                                              const PopupMenuItem<String>(
                                                value: 'transfer',
                                                child: Text('Transferir Propriedade'),
                                              ),
                                            const PopupMenuItem<String>(
                                              value: 'view',
                                              child: Text('Ver Perfil Completo'),
                                            ),
                                          ];
                                        },
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.info_outline),
                                        onPressed: () => _handleMemberAction('view', member),
                                      ),
                                onTap: () => _handleMemberAction('view', member),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _handleMemberAction(String action, UserModel member) async {
    switch (action) {
      case 'promote':
        _showConfirmationDialog(
          'Promover Membro',
          'Tem certeza que deseja promover ${member.username} a Administrador?',
          () async {
            try {
              // Em produção, isso chamaria o serviço real
              // await _roleService.promoteToAdmin(member.uid);
              
              // Simulação
              setState(() {
                final index = _members.indexWhere((m) => m.uid == member.uid);
                if (index != -1) {
                  _members[index] = member.copyWith(role: 'admin');
                }
              });
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${member.username} foi promovido a Administrador'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao promover membro: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
        break;
        
      case 'demote':
        _showConfirmationDialog(
          'Rebaixar Administrador',
          'Tem certeza que deseja rebaixar ${member.username} para Membro?',
          () async {
            try {
              // Em produção, isso chamaria o serviço real
              // await _roleService.demoteToMember(member.uid);
              
              // Simulação
              setState(() {
                final index = _members.indexWhere((m) => m.uid == member.uid);
                if (index != -1) {
                  _members[index] = member.copyWith(role: 'member');
                }
              });
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${member.username} foi rebaixado para Membro'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao rebaixar administrador: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
        break;
        
      case 'transfer':
        _showConfirmationDialog(
          'Transferir Propriedade',
          'Tem certeza que deseja transferir a propriedade do clã para ${member.username}? Você se tornará um Administrador.',
          () async {
            try {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final currentUser = userProvider.user;
              
              if (currentUser == null) return;
              
              // Em produção, isso chamaria o serviço real
              // await _roleService.transferOwnership(member.uid, currentUser.uid);
              
              // Simulação
              setState(() {
                final currentUserIndex = _members.indexWhere((m) => m.uid == currentUser.uid);
                final newOwnerIndex = _members.indexWhere((m) => m.uid == member.uid);
                
                if (currentUserIndex != -1 && newOwnerIndex != -1) {
                  _members[currentUserIndex] = _members[currentUserIndex].copyWith(role: 'admin');
                  _members[newOwnerIndex] = _members[newOwnerIndex].copyWith(role: 'owner');
                }
              });
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Propriedade transferida para ${member.username}'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao transferir propriedade: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
        break;
        
      case 'view':
        _showMemberDetailsDialog(member);
        break;
    }
  }

  void _showConfirmationDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF36393F),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7289DA),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showMemberDetailsDialog(UserModel member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF36393F),
        title: Text(member.username),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Cargo', _getRoleName(member.role)),
            _buildDetailRow('Nome no Jogo', member.gameName),
            _buildDetailRow('Email', member.email),
            _buildDetailRow('WhatsApp', member.whatsapp),
            _buildDetailRow('Nível', member.level.toString()),
            _buildDetailRow('Pontos', member.points.toString()),
            _buildDetailRow('Horas Jogadas', member.hoursPlayed.toString()),
            _buildDetailRow('Membro Desde', _formatDate(member.joinDate)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7289DA),
            ),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'owner':
        return Colors.red;
      case 'admin':
        return Colors.orange;
      case 'member':
        return const Color(0xFF7289DA);
      default:
        return Colors.grey;
    }
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'owner':
        return 'Dono';
      case 'admin':
        return 'Administrador';
      case 'member':
        return 'Membro';
      default:
        return 'Desconhecido';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Data inválida';
    }
  }
}
