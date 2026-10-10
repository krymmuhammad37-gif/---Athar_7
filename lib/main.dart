import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const AtharApp());
}

class AtharApp extends StatelessWidget {
  const AtharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أَثَر | Athar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        primaryColor: const Color(0xFF1F6FEB),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLiveActive = false;
  late Timer _timer;
  String _currentTime = '';
  String _timeStatus = '🌙 طبت وطابت ساعاتك بذكر الله';

  @override
  void initState() {
    super.initState();
    _updateLiveTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateLiveTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateLiveTime() {
    final now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;
    String period = hour >= 12 ? 'مساءً' : 'صباحاً';
    
    int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    setState(() {
      _currentTime = "${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')} $period";

      if (hour == 18) {
        _timeStatus = '🌅 أذن المغرب الآن - تقبل الله طاعتكم';
      } else if (hour >= 17 && hour < 19) {
        _timeStatus = '🌇 وقت الغروب وأذكار المساء';
      } else if (hour >= 4 && hour < 6) {
        _timeStatus = '🌄 وقت الفجر وبداية يوم مبارك';
      } else {
        _timeStatus = '📖 استمر في ذكر الله وقراءة القرآن';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق أَثَر | Athar 🌙', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF161B22),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1F6FEB), Color(0xFF238636)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentTime,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _timeStatus,
                        style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Icon(Icons.access_time_filled, size: 36, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  isLiveActive = !isLiveActive;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isLiveActive ? '🟢 تم تشغيل إذاعة أَثَر المباشرة بنجاح!' : '🔴 تم إيقاف الإذاعة.'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: isLiveActive ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isLiveActive ? Colors.green : const Color(0xFF30363D),
                    width: isLiveActive ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: const Text(
                    'إذاعة أَثَر المباشرة 📻',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      isLiveActive ? '🟢 مباشر الآن - البث يعمل' : '🔴 البث مغلق - انقر للتشغيل',
                      style: TextStyle(
                        color: isLiveActive ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: isLiveActive ? Colors.green : Colors.red.shade700,
                    radius: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              title: 'المصحف الشريف 📖',
              subtitle: 'قراءة القرآن بالرسم العثماني كاملاً',
              color: const Color(0xFF1F6FEB),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QuranScreen()));
              },
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              title: 'المكتبة الصوتية الشاملة 🎧',
              subtitle: 'أكثر من 50 قارئاً مع المصحف المرتل',
              color: const Color(0xFF238636),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AudioLibraryScreen()));
              },
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              title: 'السبحة الرقمية الذكية 📿',
              subtitle: 'عداد أذكار يحفظ التسبيحات تلقائياً',
              color: const Color(0xFF9E6A03),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SebhaScreen()));
              },
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              title: 'الأذكار والأدعية 🤲',
              subtitle: 'أذكار الصباح والمساء والاستيقاظ والنوم',
              color: const Color(0xFF8957E5),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AzkarScreen()));
              },
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              title: 'مواقيت الصلاة والقبلة 🕌',
              subtitle: 'تحديد أوقات الصلاة واتجاه القبلة بدقة',
              color: const Color(0xFFDA3633),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayerTimesScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ),
        trailing: CircleAvatar(backgroundColor: color, radius: 10),
        onTap: onTap,
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات التطبيق ⚙️'), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('تفضيلات الإشعارات', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            title: Text('تنبيهات أذكار الصباح والمساء'),
            subtitle: Text('مفعلة تلقائياً'),
            trailing: Icon(Icons.notifications_active, color: Colors.greenAccent),
          ),
          ListTile(
            title: Text('تنبيهات أوقات الصلاة'),
            subtitle: Text('مفعلة تلقائياً'),
            trailing: Icon(Icons.alarm, color: Colors.amberAccent),
          ),
          Divider(height: 30, color: Colors.white24),
          Text('معلومات التطبيق', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            title: Text('اسم التطبيق'),
            subtitle: Text('أَثَر | Athar (الإصدار 1.0)'),
            trailing: Icon(Icons.info, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}

class SebhaScreen extends StatefulWidget {
  const SebhaScreen({super.key});

  @override
  State<SebhaScreen> createState() => _SebhaScreenState();
}

class _SebhaScreenState extends State<SebhaScreen> {
  int counter = 0;
  String currentZekr = 'سبحان الله';

  void incrementCounter() {
    setState(() {
      counter++;
      if (counter == 33) {
        currentZekr = 'الحمد لله';
      } else if (counter == 66) {
        currentZekr = 'الله أكبر';
      } else if (counter >= 100) {
        currentZekr = 'لا إله إلا الله';
      }
    });
  }

  void resetCounter() {
    setState(() {
      counter = 0;
      currentZekr = 'سبحان الله';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السبحة الرقمية الذكية 📿'), backgroundColor: const Color(0xFF161B22)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentZekr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: incrementCounter,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF161B22),
                  border: Border.all(color: const Color(0xFF9E6A03), width: 4),
                ),
                child: Center(
                  child: Text(
                    '$counter',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: incrementCounter,
                  icon: const Icon(Icons.add),
                  label: const Text('تسبيح'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF238636), foregroundColor: Colors.white),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: resetCounter,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة ضبط'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800, foregroundColor: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المصحف الشريف 📖'), backgroundColor: const Color(0xFF161B22)),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('سورة رقم ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('الرسم العثماني - مكية / مدنية', style: TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جاري فتح سورة رقم ${index + 1}')));
            },
          );
        },
      ),
    );
  }
}

class AudioLibraryScreen extends StatelessWidget {
  const AudioLibraryScreen({super.key});

  final List<String> readers = const [
    'محمود خليل الحصري',
    'عبد الباسط عبد الصمد',
    'محمد صديق المنشاوي',
    'مشاري العفاسي',
    'ماهر المعيقلي',
    'ياسر الدوسري',
    'سعد الغامدي',
    'أحمد العجمي',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المكتبة الصوتية الشاملة 🎧'), backgroundColor: const Color(0xFF161B22)),
      body: ListView.builder(
        itemCount: readers.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFF161B22),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(readers[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('المصحف المرتل كاملاً', style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.play_circle_fill, color: Colors.greenAccent, size: 32),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تشغيل تلاوات القارئ: ${readers[index]}')));
              },
            ),
          );
        },
      ),
    );
  }
}

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  final List<String> azkarCategories = const [
    'أذكار الصباح 🌅',
    'أذكار المساء 🌃',
    'أذكار الاستيقاظ ☀️',
    'أذكار النوم 🌙',
    'أدعية نبوية 🤲',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأذكار والأدعية 🤲'), backgroundColor: const Color(0xFF161B22)),
      body: ListView.builder(
        itemCount: azkarCategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.bookmark, color: Colors.purpleAccent),
            title: Text(azkarCategories[index], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم اختيار: ${azkarCategories[index]}')));
            },
          );
        },
      ),
    );
  }
}

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  final List<Map<String, String>> prayers = const [
    {'name': 'الفجر', 'time': '04:17 ص'},
    {'name': 'الشروق', 'time': '05:45 ص'},
    {'name': 'الظهر', 'time': '11:52 ص'},
    {'name': 'العصر', 'time': '03:15 م'},
    {'name': 'المغرب', 'time': '05:58 م'},
    {'name': 'العشاء', 'time': '07:15 م'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة والقبلة 🕌'), backgroundColor: const Color(0xFF161B22)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF30363D)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🧭 اتجاه القبلة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('مكة المكرمة (135°)', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: prayers.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF161B22),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(prayers[index]['name']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: Text(prayers[index]['time']!, style: const TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}