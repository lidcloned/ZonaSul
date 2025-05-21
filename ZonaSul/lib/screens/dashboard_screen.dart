import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _widgetOptions = const [
    HomeTab(),
    PointRegisterTab(),
    MissionsTab(),
    ChatTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // Mostrar indicador de carregamento enquanto os dados do usuário são carregados
    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Clã'),
        actions: [
          // Botão de notificações
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Abrir tela de notificações
            },
          ),
          // Menu de opções
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'admin') {
                // Verificar se o usuário é admin ou dono
                bool isAdmin = await userProvider.isAdminOrOwner();
                if (isAdmin && mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                  );
                } else {
                  // Mostrar mensagem de erro
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Você não tem permissão para acessar o painel administrativo.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } else if (value == 'settings') {
                // Abrir configurações
              } else if (value == 'logout') {
                // Fazer logout
                await userProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'admin',
                  child: Text('Painel Administrativo'),
                ),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Configurações'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Sair'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Ponto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Missões',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF7289DA),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF202225),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// Abas do Dashboard
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cartão de boas-vindas
          Card(
            color: const Color(0xFF2F3136),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo, ${user?.username ?? 'Jogador'}!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cargo atual: ${_getRoleName(user?.role)}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Nível', '${user?.level ?? 0}'),
                      _buildStatItem('Horas', '${user?.hoursPlayed ?? 0}'),
                      _buildStatItem('Pontos', '${user?.points ?? 0}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Seção de membros online
          const Text(
            'Membros Online',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                8,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[800],
                        child: Text(
                          'M${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Membro ${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Seção de anúncios
          const Text(
            'Anúncios Recentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                color: const Color(0xFF2F3136),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text('Anúncio ${index + 1}'),
                  subtitle: Text('Descrição do anúncio ${index + 1}. Clique para ver mais detalhes.'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Abrir detalhes do anúncio
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7289DA),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  String _getRoleName(String? role) {
    switch (role) {
      case 'owner':
        return 'Dono';
      case 'admin':
        return 'Administrador';
      case 'member':
        return 'Membro';
      default:
        return 'Membro';
    }
  }
}

class PointRegisterTab extends StatefulWidget {
  const PointRegisterTab({super.key});

  @override
  State<PointRegisterTab> createState() => _PointRegisterTabState();
}

class _PointRegisterTabState extends State<PointRegisterTab> {
  bool _isCheckedIn = false;
  String _lastCheckIn = '--:--';
  String _elapsedTime = '00:00:00';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cartão de status
          Card(
            color: const Color(0xFF2F3136),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    _isCheckedIn ? 'JOGANDO AGORA' : 'OFFLINE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _isCheckedIn ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isCheckedIn ? 'Tempo de jogo: $_elapsedTime' : 'Último ponto: $_lastCheckIn',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _toggleCheckIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isCheckedIn ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: Text(_isCheckedIn ? 'FINALIZAR SESSÃO' : 'INICIAR SESSÃO'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Histórico de pontos
          const Text(
            'Histórico de Pontos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                // Simulação de dados de histórico
                final date = DateTime.now().subtract(Duration(days: index));
                final formattedDate = '${date.day}/${date.month}/${date.year}';
                final startTime = '${8 + (index % 3)}:00';
                final endTime = '${10 + (index % 4)}:30';
                final duration = '${2 + (index % 4)}h 30min';
                
                return Card(
                  color: const Color(0xFF2F3136),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF7289DA)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Entrada: $startTime - Saída: $endTime',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          duration,
                          style: const TextStyle(
                            color: Color(0xFF7289DA),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCheckIn() {
    setState(() {
      _isCheckedIn = !_isCheckedIn;
      if (_isCheckedIn) {
        // Iniciar sessão
        final now = DateTime.now();
        _lastCheckIn = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
        _elapsedTime = '00:00:00';
      } else {
        // Finalizar sessão
        final now = DateTime.now();
        _lastCheckIn = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
      }
    });
  }
}

class MissionsTab extends StatelessWidget {
  const MissionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'DISPONÍVEIS'),
              Tab(text: 'EM ANDAMENTO'),
              Tab(text: 'CONCLUÍDAS'),
            ],
            labelColor: Color(0xFF7289DA),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF7289DA),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMissionsList(context, 'available'),
                _buildMissionsList(context, 'in_progress'),
                _buildMissionsList(context, 'completed'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Abrir tela para sugerir nova missão
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreateMissionScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('SUGERIR MISSÃO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7289DA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsList(BuildContext context, String type) {
    // Simulação de dados de missões
    final List<Map<String, dynamic>> missions = [];
    
    if (type == 'available') {
      missions.addAll([
        {
          'title': 'Recrutar 3 novos membros',
          'description': 'Encontre e convide 3 novos jogadores para o clã.',
          'reward': '500 pontos',
          'difficulty': 'Média',
        },
        {
          'title': 'Completar 5 corridas',
          'description': 'Participe e complete 5 corridas no modo multijogador.',
          'reward': '300 pontos',
          'difficulty': 'Fácil',
        },
        {
          'title': 'Organizar evento semanal',
          'description': 'Planeje e execute um evento para membros do clã.',
          'reward': '800 pontos',
          'difficulty': 'Difícil',
        },
      ]);
    } else if (type == 'in_progress') {
      missions.addAll([
        {
          'title': 'Alcançar nível 30',
          'description': 'Aumente seu nível para 30 ou superior.',
          'reward': '400 pontos',
          'difficulty': 'Média',
          'progress': 0.7,
        },
      ]);
    } else if (type == 'completed') {
      missions.addAll([
        {
          'title': 'Tutorial do jogo',
          'description': 'Complete o tutorial básico do jogo.',
          'reward': '100 pontos',
          'difficulty': 'Fácil',
          'completed_date': '15/05/2025',
        },
        {
          'title': 'Primeiro login',
          'description': 'Faça seu primeiro login no aplicativo.',
          'reward': '50 pontos',
          'difficulty': 'Fácil',
          'completed_date': '10/05/2025',
        },
      ]);
    }
    
    return missions.isEmpty
        ? const Center(
            child: Text(
              'Nenhuma missão disponível',
              style: TextStyle(color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              
              return Card(
                color: const Color(0xFF2F3136),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mission['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(mission['difficulty']),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              mission['difficulty'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mission['description'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      
                      // Mostrar progresso para missões em andamento
                      if (type == 'in_progress') ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: mission['progress'],
                          backgroundColor: Colors.grey[800],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF7289DA),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Progresso: ${(mission['progress'] * 100).toInt()}%',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                      
                      // Mostrar data de conclusão para missões completadas
                      if (type == 'completed') ...[
                        const SizedBox(height: 8),
                        Text(
                          'Concluída em: ${mission['completed_date']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Recompensa: ${mission['reward']}',
                                style: const TextStyle(
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          if (type == 'available')
                            ElevatedButton(
                              onPressed: () {
                                // Aceitar missão
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7289DA),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('ACEITAR'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Fácil':
        return Colors.green;
      case 'Média':
        return Colors.orange;
      case 'Difícil':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

class CreateMissionScreen extends StatefulWidget {
  const CreateMissionScreen({super.key});

  @override
  State<CreateMissionScreen> createState() => _CreateMissionScreenState();
}

class _CreateMissionScreenState extends State<CreateMissionScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardController = TextEditingController();
  String _selectedDifficulty = 'Média';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerir Missão'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sua sugestão será enviada para aprovação',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título da Missão',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Dificuldade',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
              items: ['Fácil', 'Média', 'Difícil'].map((difficulty) {
                return DropdownMenuItem<String>(
                  value: difficulty,
                  child: Text(difficulty),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _rewardController,
              decoration: const InputDecoration(
                labelText: 'Recompensa Sugerida',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF40444B),
              ),
            ),
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _submitMission,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7289DA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('ENVIAR SUGESTÃO'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitMission() {
    // Validar campos
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Simulação de envio
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missão Enviada'),
        content: const Text('Sua sugestão de missão foi enviada para aprovação.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar diálogo
              Navigator.of(context).pop(); // Voltar para tela de missões
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'Admin',
      'message': 'Bem-vindo ao chat do clã!',
      'time': '10:30',
      'isAdmin': true,
    },
    {
      'sender': 'Jogador 1',
      'message': 'Olá pessoal, alguém online para jogar?',
      'time': '10:35',
      'isAdmin': false,
    },
    {
      'sender': 'Jogador 2',
      'message': 'Estou disponível, vamos formar um grupo?',
      'time': '10:37',
      'isAdmin': false,
    },
    {
      'sender': 'Admin',
      'message': 'Lembrem-se do evento de hoje às 20h!',
      'time': '10:40',
      'isAdmin': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Abas de canais
        Container(
          color: const Color(0xFF2F3136),
          child: TabBar(
            isScrollable: true,
            tabs: [
              for (var channel in ['Geral', 'Anúncios', 'Estratégias', 'Eventos'])
                Tab(text: channel),
            ],
            labelColor: const Color(0xFF7289DA),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF7289DA),
          ),
        ),
        
        // Lista de mensagens
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: message['isAdmin']
                          ? const Color(0xFF7289DA)
                          : Colors.grey[700],
                      child: Text(
                        message['sender'][0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                message['sender'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: message['isAdmin']
                                      ? const Color(0xFF7289DA)
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                message['time'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(message['message']),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Campo de mensagem
        Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color(0xFF40444B),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_photo_alternate),
                color: Colors.grey,
                onPressed: () {
                  // Adicionar imagem
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Enviar mensagem...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                color: const Color(0xFF7289DA),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    
    setState(() {
      _messages.add({
        'sender': 'Você',
        'message': _messageController.text,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        'isAdmin': false,
      });
      _messageController.clear();
    });
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto de perfil
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFF7289DA),
            backgroundImage: user?.profileImageUrl.isNotEmpty == true
                ? NetworkImage(user!.profileImageUrl) as ImageProvider
                : null,
            child: user?.profileImageUrl.isEmpty == true
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          
          // Nome e cargo
          Text(
            user?.username ?? 'Jogador',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF7289DA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _getRoleName(user?.role),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Estatísticas
          Card(
            color: const Color(0xFF2F3136),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estatísticas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('Nível', '${user?.level ?? 0}'),
                  _buildStatRow('Horas Jogadas', '${user?.hoursPlayed ?? 0}'),
                  _buildStatRow('Pontos', '${user?.points ?? 0}'),
                  _buildStatRow('Membro Desde', _formatDate(user?.joinDate)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Informações de contato
          Card(
            color: const Color(0xFF2F3136),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações de Contato',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(Icons.person, 'Nome no Jogo', user?.gameName ?? 'Não definido'),
                  _buildContactRow(Icons.email, 'Email', user?.email ?? 'Não definido'),
                  _buildContactRow(Icons.phone, 'WhatsApp', user?.whatsapp ?? 'Não definido'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Botões de ação
          ElevatedButton.icon(
            onPressed: () {
              // Abrir tela de edição de perfil
            },
            icon: const Icon(Icons.edit),
            label: const Text('EDITAR PERFIL'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7289DA),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              // Abrir configurações
            },
            icon: const Icon(Icons.settings),
            label: const Text('CONFIGURAÇÕES'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7289DA), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getRoleName(String? role) {
    switch (role) {
      case 'owner':
        return 'Dono';
      case 'admin':
        return 'Administrador';
      case 'member':
        return 'Membro';
      default:
        return 'Membro';
    }
  }
  
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Não disponível';
    }
    
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Data inválida';
    }
  }
}

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        backgroundColor: const Color(0xFF7289DA),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cartão de status do clã
            Card(
              color: const Color(0xFF2F3136),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status do Clã',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAdminStat('Membros', '25'),
                        _buildAdminStat('Online', '8'),
                        _buildAdminStat('Missões', '12'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Seções administrativas
            const Text(
              'Gerenciamento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Grade de opções administrativas
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAdminCard(
                  context,
                  'Gerenciar Membros',
                  Icons.people,
                  () {
                    // Navegar para tela de gerenciamento de membros
                  },
                ),
                _buildAdminCard(
                  context,
                  'Validar Missões',
                  Icons.assignment_turned_in,
                  () {
                    // Navegar para tela de validação de missões
                  },
                ),
                _buildAdminCard(
                  context,
                  'Criar Questionários',
                  Icons.quiz,
                  () {
                    // Navegar para tela de criação de questionários
                  },
                ),
                _buildAdminCard(
                  context,
                  'Gerenciar Cargos',
                  Icons.badge,
                  () {
                    // Navegar para tela de gerenciamento de cargos
                  },
                ),
                _buildAdminCard(
                  context,
                  'Anúncios',
                  Icons.campaign,
                  () {
                    // Navegar para tela de anúncios
                  },
                ),
                _buildAdminCard(
                  context,
                  'Relatórios',
                  Icons.bar_chart,
                  () {
                    // Navegar para tela de relatórios
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Aprovações pendentes
            const Text(
              'Aprovações Pendentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF2F3136),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xFF40444B),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Solicitação de Missão #${index + 1}'),
                    subtitle: const Text('Enviada por: Membro'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            // Aprovar solicitação
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            // Rejeitar solicitação
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Ver detalhes da solicitação
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7289DA),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      color: const Color(0xFF2F3136),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFF7289DA),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
