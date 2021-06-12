package body dtrenes is
   --HASH
   --hash function
   function hashF (k : in tcodigo; b : in Integer) return Natural is
      s, p: natural;
   begin
      s:= 0;
      for i in k' range loop
         p:= character'pos(k(i)); -- código ASCII
         s:= (s+p) mod b;
      end loop;
      return s;
   end hashF;
   --Hash Igual
   function igual(k1,k2 : in tcodigo) return boolean is
   begin
      return k1=k2;
   end igual;
   
   --AVL
   --Mayor
   function mayor(k1, k2 : in Integer) return boolean is
   begin
      return k1>k2;
   end mayor;
   
   --Menor
   function menor(k1,k2 : in Integer) return boolean is
   begin
      return k1<k2;
   end menor;

   --preparamos estructuras
   procedure vacio(cia: out cTrenes) is
      locomotoras: cola renames cia.pkLoco;
      vagones: pila renames cia.pkVagon;
      hashing: conjuntoH renames cia.hash;
      tree: conjunto renames cia.avl;
     
   begin
      --vaciamos parkings
      cvacia(locomotoras);
      pvacia(vagones);
      
      --vaciamos estructuras de busqueda
      cvacio(hashing);
      cvacio(tree);
   end vacio;
   

   
   --Da de alta una nueva locomotora y la aparca en el aparcamiento
   --de locomotoras libres.
   --Si el aparcamiento de locomotoras libres se encuentra completo,
   --debe lanzar una excepcion aparcamiento locomotoras completo.
   procedure aparcaLocomotora(cia: in out cTrenes; k: in tcodigo) is
      locomotoras: cola renames cia.pkLoco;
      locoAux: locomotora;
   begin
      locoAux.lcodigo := k;
      poner(locomotoras, locoAux);
      Put_Line( "Locomotora aparcada: " & locoAux.lcodigo);

   exception
      when colaP.espacio_desbordado => raise aparcamiento_locomotoras_completo;
   end aparcaLocomotora;
   
   --aparcamos nuevo vagon en el parking 
   procedure aparcaVagon(cia: in out cTrenes; k: in tcodigo;pmax: in integer) is
      vagones: pila renames cia.pkVagon;
      vagonAux: vagon;

   begin
      
      --creamos nuevo vagon
      vagonAux.Vcodigo := k;
      vagonAux.pesoMax := pmax;
      Put_Line( "Vagon aparcado: " & vagonAux.Vcodigo & " con peso:" & vagonAux.pesoMax'Img);
      
      --metemos nuevo vagon en el parking
      empila(vagones,vagonAux);
      
   exception
      
         --manejamos error parking completo
      when pilaP.espacio_desbordado => raise aparcamiento_vagones_completo; 
         
   end aparcaVagon;
   
   --Listamos trenes en orden creciente
   procedure listarTrenes(cia: in cTrenes) is
      avl: conjunto renames cia.avl;
      it: iterator;
      kAux: Integer;
      xAux: p_tren;
      code: tcodigo;
      pnodo: pnode;
   begin
      
      first(avl,it);
      
      xAux := new tren;
      
      while is_valid(it) loop
         get(avl,it,kAux,xAux);
        
         --codigo 
         code := xAux.locoT.lcodigo;

         --codigo locomotora
         Put_Line("Codigo locomotora: " & code);
         
         code(1):= 'T';
         
         --codigo tren y peso
         Put_Line("Codigo Tren: " & code & " con peso:" & kAux'Img);

         --Imprimir vagones
         --Recorrido vagones
         pnodo := new node;
         pnodo := xAux.pnodo;
         while pnodo /= null loop
            Put_Line("Vagon:" & pnodo.nvagon.Vcodigo & "con peso:" & pnodo.nvagon.pesoMax'Img);
            pnodo:= pnodo.psig;
         end loop;
         Put_Line(" ");
         next(avl,it);
      end loop;
      
      exception
      when davlT.no_existe => raise tren_no_existe;
   end listarTrenes;
   
   --Crear un nuevo tren a partir de una locomotora libre y el numero
   --indicado de vagones (de entre los vagones libres aparcados).
   
   --El codigo del tren se corresponde con el codigo de la locomotora
   --que lo forma pero, en lugar de empezar por L, debe empezar por T.
   
   --Si no quedan locomotoras libres, debe lanzar la excepcion loco-
   --motoras agotadas.
   
   --Si no quedan suficientes vagones libres, debe lanzar la excepcion
   --vagones agotadas.
  
   --Si no se dispone de espacio suficientes para almacenar el tren montado,
   --debe lanzar la excepcion inventario trenes completo
   procedure creaTren(cia: in out cTrenes; t: out tcodigo; num_vagones:in Integer) is
      locomotoras: cola renames cia.pkLoco; 
      vagones: pila renames cia.pkVagon; 
      
      ptren: p_tren;
      --Lista
      pnodoNew: pnode;
      pnodoAux: pnode;
      
      pnodo: pnode; --Para recorrido vagones imprimir
      
      loco: locomotora;
      
      nvagones: Integer;
      pesoAcu: Integer;
      
      i:Integer;
            
   begin
     
      --Cogemos una locomotora libre
      loco := coger_primero(locomotoras);
      borrar_primero(locomotoras);
      
      --Montamos tren
      ptren := new tren;
      ptren.pnodo := new node;
      
      ptren.locoT := loco;
      --Cambiamos el codigo
      t := loco.lcodigo;
      t(1) := 'T';
      
      --Cogemos vagones
      pnodoNew := new node;
      pnodoAux := new node;
      nvagones := 0;
      pesoAcu := 0;
      
      while num_vagones > nvagones loop
  
         --Primer vagon
         if nvagones = 0 then          
            --Ponemos el nuevo
            pnodoNew.nvagon := cima(vagones);
            pnodoNew.psig := null;
         
            --Enlazamos
            ptren.pnodo.nvagon := pnodoNew.nvagon;
            ptren.pnodo.psig := pnodoNew.psig;
            
         else --Segundo vagon
            --Guardamos el vagon del tren
            pnodoAux := new node;
            pnodoAux.nvagon := ptren.pnodo.nvagon;
            pnodoAux.psig := ptren.pnodo.psig;
         
            --Ponemos el nuevo
            pnodoNew := new node;
            pnodoNew.nvagon := cima(vagones);
            pnodoNew.psig := pnodoAux;
         
            --Enlazamos
            ptren.pnodo.nvagon := pnodoNew.nvagon;
            ptren.pnodo.psig := pnodoNew.psig;
            
         end if;
         
         --Aumentamos peso
         pesoAcu := pesoAcu + ptren.pnodo.nvagon.pesoMax;
         desempila(vagones);
         
         nvagones := nvagones + 1;
      end loop;
      
      --Imprimimos
      Put_Line("");
      Put_Line("Se ha creado un tren con codigo: " & t & " con Peso MAX: " & pesoAcu'Img);
      Put_Line("Locomotora: " & ptren.locoT.lcodigo);      
      
      --Recorrido vagones
      i := 0;
      pnodo := new node;
      pnodo := ptren.pnodo;
      while pnodo /= null loop
         Put_Line("Vagon" & i'Img);
         Put_Line("Consulta Vagon: " & pnodo.nvagon.Vcodigo & " con peso:" & pnodo.nvagon.pesoMax'Img);
         pnodo:= pnodo.psig;
         i := i + 1;
      end loop;
      Put_Line("");
      
      --Registramos el tren en los respectivos conjuntos
      poner(cia.hash,t,ptren); --En el hash
      davlT.poner(cia.avl,pesoAcu,ptren); --En el AVL   

      --Excepciones
   exception
      when colaP.mal_uso => raise locomotoras_agotadas;
      when pilaP.mal_uso => raise vagones_agotados; 
   end creaTren;
   
   --Debe mostrar la informacion del tren con el codigo identicativo 't'.
   
   --La informacion del tren que debe mostrarse es: codigo del tren,
   --codigo de su locomotora y, por cada uno de los vagones que lo
   --componen, el codigo y el peso maximo de cada vagon.
   
   --Si no existe en el inventario de trenes montados un tren con el
   --codigo identificativo t, debe lanzar la excepcion tren no existe.
   procedure consultaTren(cia: in cTrenes; t: in tcodigo) is
      ptren: p_tren;
      pnodo: pnode;
   begin
      
      ptren := new tren;
      
      --Consultar hash
      consultar(cia.hash,t,ptren);
      
      Put_Line("Codigo del tren: " & t);
      Put_Line("Codigo locomotora: " & ptren.locoT.lcodigo);

      --Recorrido vagones
      pnodo := new node;
      pnodo := ptren.pnodo;
      while pnodo /= null loop
         Put_Line("Consulta Vagon: " & pnodo.nvagon.Vcodigo & " con peso:" & pnodo.nvagon.pesoMax'Img);
         pnodo:= pnodo.psig;
      end loop;

   exception
      when dhashT.no_existe => raise tren_no_existe;
      
   end consultaTren;
   
   procedure desmantelarTren(cia: in out cTrenes) is 
      hash: conjuntoH renames cia.hash;
      vagones: pila renames cia.pkVagon;
      
      avl:  conjunto  renames cia.avl;
      itA:   iterator;
      kAux: Integer;
      xAux: p_tren;
      pnodo:  pnode;

   begin
      --cogemos el tren de peso menor
      first(avl,itA);
      
      if (is_valid(itA)) then
         get(avl,itA,kAux,xAux);
         
         --Desmantelamos vagones
         --Recorrido vagones
         pnodo := new node;
         pnodo := xAux.pnodo;
         while pnodo /= null loop
            Put_Line("Vagon aparcado:" & pnodo.nvagon.Vcodigo & " con peso:" & pnodo.nvagon.pesoMax'Img);
            --Aparcar
            empila(vagones,pnodo.nvagon);
            pnodo:= pnodo.psig;
         end loop;
         
         --aparcamos locomotor
         aparcaLocomotora(cia,xAux.all.locoT.lcodigo);
         
         --modificamos codigoLoco para borrarlo del hash
         xAux.locoT.lcodigo(1) := 'T';
         borrar(hash,xAux.all.locoT.lcodigo);
         
         --borrarmos del avl
         borrar(avl,kAux);

      end if;
      
      exception
      when davlT.no_existe => raise tren_no_existe;  
   end desmantelarTren;

end dtrenes;
