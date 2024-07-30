import 'package:flutter/material.dart';

class MenuBarView extends StatefulWidget implements PreferredSizeWidget {
  const MenuBarView({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(150);
  final String message;

  @override
  State<MenuBarView> createState() => _MenuBarViewState();
}

class _MenuBarViewState extends State<MenuBarView> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu');

  void _handleLogout() {
    final snackBar = SnackBar(
      content: Text('Has salido del sistema'),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Redirige a la pantalla de inicio después de que el mensaje haya sido mostrado
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.message, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.white, size: 30),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Menu", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                MenuAnchor(
                  builder: (BuildContext context, MenuController controller, Widget? child) {
                    return IconButton(
                      focusNode: _buttonFocusNode,
                      icon: Icon(Icons.person, size: 30, color: Colors.blueAccent),
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                    );
                  },
                  childFocusNode: _buttonFocusNode,
                  menuChildren: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Administrar",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 8),
                        MenuItemButton(
                          child: const Text("Principal"),
                          onPressed: () => Navigator.pushNamed(context, '/principal'),
                        ),
                        MenuItemButton(
                          child: const Text("Mapa"),
                          onPressed: () => Navigator.pushNamed(context, '/map'),
                        ),
                        const SizedBox(height: 16),
                        MenuItemButton(
                          child: const Text("Editar"),
                          onPressed: () => Navigator.pushNamed(context, '/editar'),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Recent Workspaces",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 16),
                        MenuItemButton(
                          child: const Text("Cerrar sesión"),
                          onPressed: _handleLogout, // Usar la función _handleLogout
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder widget for MenuItemButton
class MenuItemButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const MenuItemButton({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: child,
      ),
    );
  }
}

// Placeholder widget for SubmenuButton
class SubmenuButton extends StatelessWidget {
  final List<Widget> menuChildren;
  final Widget child;

  const SubmenuButton({
    required this.menuChildren,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => menuChildren.map((Widget menuItem) {
        return PopupMenuItem(child: menuItem);
      }).toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: child,
      ),
    );
  }
}
