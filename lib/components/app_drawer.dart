import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Text(
                'Bem vindo Usuário!',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Loja"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.authOrHome),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Pedidos"),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.orders),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Gerenciar Produtos"),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.products),
          ),
          const Spacer(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Sair"),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.authOrHome);
              })
        ],
      ),
    );
  }
}
