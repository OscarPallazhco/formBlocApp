# Crear ícono
    Ubicar la imagen del ícono en los assets, debe ser tamaño 1024*1024  
    Instalar: flutter_launcher_icons en dev_dependencies en el pubspec.yaml  
    En el pubspec.yaml al mismo nivel del dev_dependencies agregar lo siguiente  
        flutter_icons:  
            android: "launcher_icon"  
            ios: true  
            image_path: "assets/icon/movie-icon.png"  
            adaptive_icon_background: "assets/icon/movie-icon.png"  
    Después de que se haga el flutter packages get ejecutar:  
        flutter packages pub run flutter_launcher_icons:main  
    Se generarán automáticamente las imágenes necesarias del ícono 
