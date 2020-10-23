import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/models/usuario.dart';

class UsuariosPage extends StatelessWidget {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'Limberg', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'José', email: 'test2@test.com', online: false),
    Usuario(uid: '3', nombre: 'Anzaldo', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(usuario.nombre, style: TextStyle(color: Colors.black54)),
          leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.black54,
            onPressed: () {
              //TODO: desconectarse del socket
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue[400],
          ),
          child: _usuarioListView(),
        ));
  }

  ListView _usuarioListView() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (_, i) => Divider(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[200],
      ),
      trailing: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
