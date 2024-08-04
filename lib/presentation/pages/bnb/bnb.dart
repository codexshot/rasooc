import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/pages/campaigns/campaigns_screen.dart';
import 'package:rasooc/presentation/pages/chat/chat_screen.dart';
import 'package:rasooc/presentation/pages/posts/post_screen.dart';
import 'package:rasooc/presentation/pages/profile-settings/profile_settings_screen.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/styles.dart';

class RasoocBNB extends StatefulWidget {
  @override
  _RasoocBNBState createState() => _RasoocBNBState();
}

class _RasoocBNBState extends State<RasoocBNB> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CampaignsScreen(),
    PostScreen(),
    Scaffold(body: ChatScreen()),
    ProfileSettingsScreen(),
  ];

  final List<Map<String, IconData>> _items = [
    {
      "CAMPAIGNS": Icons.home_outlined,
    },
    {
      "POSTS": Icons.post_add,
    },
    {
      "INBOX": Icons.mail_outline,
    },
    {
      "YOU": Icons.person_outline,
    },
  ];

  BottomNavigationBarItem _buildBottomNavItem(
      String label, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
      backgroundColor: Colors.black,
    );
  }

  @override
  void initState() {
    super.initState();
    // intializeAppData();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    print(authState.userProfile.categories);
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: RStyles.selectedLabelStyle,
        selectedItemColor: RColors.primaryColor,
        unselectedItemColor: RColors.secondaryColor,
        unselectedLabelStyle: RStyles.unSelectedLabelStyle,
        selectedIconTheme: RStyles.selectedIconTheme,
        unselectedIconTheme: RStyles.unSelectedIconTheme,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: _items
            .asMap()
            .entries
            .map(
              (mE) => _buildBottomNavItem(
                mE.value.entries.first.key,
                mE.value.entries.first.value,
                mE.key,
              ),
            )
            .toList(),
      ),
    );
  }
}
