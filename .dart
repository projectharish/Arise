import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const AriseApp());

class AriseApp extends StatelessWidget {
  const AriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 1,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = const [
    HabitsScreen(),
    TasksScreen(),
    JournalScreen(),
    InsightsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
        ],
      ),
    );
  }
}

// ==================== HABITS SCREEN ====================
class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final List<Map<String, dynamic>> _habits = [];

  void _addHabit(String title) {
    setState(() {
      _habits.add({
        'title': title,
        'streak': 0,
        'lastUpdated': DateTime.now(),
        'history': [],
      });
    });
  }

  void _updateStreak(int index) {
    setState(() {
      _habits[index]['streak']++;
      _habits[index]['lastUpdated'] = DateTime.now();
      _habits[index]['history'].add({
        'date': DateTime.now(),
        'completed': true,
      });
    });
  }

  void _showAddHabitDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Morning prayer',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addHabit(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: _habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.track_changes, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No habits yet', style: TextStyle(color: Colors.grey[600])),
                  Text('Tap + to add your first habit', 
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return Card(
                  child: ListTile(
                    title: Text(habit['title'], 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${habit['streak']} day streak', 
                        style: TextStyle(color: Colors.grey[600])),
                    trailing: Checkbox(
                      value: false,
                      onChanged: (_) => _updateStreak(index),
                    ),
                    onLongPress: () => _showEditHabitDialog(context, index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddHabitDialog(context),
      ),
    );
  }

  void _showEditHabitDialog(BuildContext context, int index) {
    final controller = TextEditingController(text: _habits[index]['title']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Habit'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _habits.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _habits[index]['title'] = controller.text;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ==================== TASKS SCREEN ====================
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> _tasks = [];

  void _addTask(String title) {
    setState(() {
      _tasks.add({
        'title': title,
        'completed': false,
      });
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Read scripture',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addTask(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checklist, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No tasks yet', style: TextStyle(color: Colors.grey[600])),
                  Text('Tap + to add your first task', 
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  child: CheckboxListTile(
                    title: Text(task['title'],
                        style: TextStyle(
                          decoration: task['completed'] 
                              ? TextDecoration.lineThrough 
                              : null,
                          color: task['completed'] 
                              ? Colors.grey[500] 
                              : Colors.grey[800],
                        )),
                    value: task['completed'],
                    onChanged: (_) => _toggleTask(index),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }
}

// ==================== JOURNAL SCREEN ====================
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<Map<String, dynamic>> _entries = [];
  final TextEditingController _controller = TextEditingController();
  String _selectedMood = '😊';

  void _saveEntry() {
    if (_controller.text.isEmpty) return;
    
    setState(() {
      _entries.insert(0, {
        'text': _controller.text,
        'mood': _selectedMood,
        'date': DateTime.now(),
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: Column(
        children: [
          Expanded(
            child: _entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No entries yet', 
                            style: TextStyle(color: Colors.grey[600])),
                        Text('Write your first entry below', 
                            style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return Card(
                        child: ListTile(
                          title: Text(entry['text']),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Text(
                                  DateFormat('MMM d, y').format(entry['date']),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                Text(entry['mood'], 
                                    style: const TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "How's your day going?",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _selectedMood,
                      items: ['😊', '😐', '😢'].map((mood) {
                        return DropdownMenuItem(
                          value: mood,
                          child: Text(mood, style: const TextStyle(fontSize: 24)),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedMood = value!),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveEntry,
                    child: const Text('SAVE ENTRY', 
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== INSIGHTS SCREEN ====================
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insights, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Coming Soon', 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                )),
            const SizedBox(height: 8),
            Text('Habit analytics and progress reports',
                style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
