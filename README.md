# Crear usuarios admin manualmente
1. Registrar normalmente  
2. En firebase/Authenticaction/Users obtener el uid y el email del usuario que  
   se quiere hacer admin  
3. En firebase/Realtime Database/Datos agregar en el nodo admins el uid y como hijo  
   agregar el campo "email" y como valor el email correspondiente  
4. En firebase/Realtime Database/Reglas/Editar reglas modificar la regla de write  
   agregando: auth.uid === 'new_uid'  
   donde new_uid es el uid del usuario que se quiere hacer admin.