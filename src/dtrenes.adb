with Ada.Text_IO; use Ada.Text_IO;

--with ada.Text_IO; use Ada.Text_IO;
package body dtrenes is
   
   --hash function
   function hashF (k : in tcodigo; b : in Positive) return Natural is
      s, p: natural;
   begin
      s:= 0;
      for i in k' range loop
         p:= character'pos(k(i)); -- código ASCII
         s:= (s+p) mod b;
      end loop;
      return s;
   end hashF;


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
   exception
         
      when Constraint_Error => raise aparcamiento_locomotoras_completo; --Aparcamiento completo
         
   end aparcaLocomotora;
   
   --aparcamos nuevo vagon en el parking 
   procedure aparcaVagon(cia: in out cTrenes; k: in tcodigo;pmax: in integer) is
      vagones: pila renames cia.pkVagon;
      vagonAux: vagon;

   begin
      
      --creamos nuevo vagon
      vagonAux.Vcodigo := k;
      vagonAux.pesoMax := pmax;
      vagonAux.pV := new vagon;
      
      --metemos nuevo vagon en el parking
      empila(vagones,vagonAux);
      
   exception
      
         --manejamos error parking completo
      when Constraint_Error => raise aparcamiento_vagones_completo; 
         
   end aparcaVagon;
   
   --Listamos trenes en orden creciente
   procedure listarTrenes(cia: in cTrenes) is
      avl: conjunto renames cia.avl;
      it: iterator;
      kAux: pesoAcumulado;
      xAux: p_tren;
      code: tcodigo;
      vagonAux: pvagon;
   begin
      
      first(avl,it);
      
      xAux := new tren;
      
      while is_valid(it) loop
         get(avl,it,kAux,xAux);
         
        
         --codigo 
         code := xAux.all.locoT.lcodigo;
         
         --codigo locomotora
         Put_Line(To_String(code));
         
         Replace_Element(code,1,'T');
         
         --codigo tren
         Put_Line(To_String(code));
         --pesoacumulado tren
         Put_Line(kAux'Img);
         
         --imprimimos primer vagon
         Put_Line(To_String(xAux.all.vagonT.Vcodigo));
         Put_Line(xAux.all.vagonT.pesoMax'Img);
         
         --puntero apuntando al segudno vagon
         vagonAux := new vagon;
         vagonAux := xAux.all.vagonT.pV;
         
         --mientras haya vagones imprimimos
         while(vagonAux /= null) loop
            
            Put_Line(To_String(vagonAux.all.Vcodigo));
            Put_Line(vagonAux.all.pesoMax'Img);
     
            --avanzamos puntero.
            vagonAux := vagonAux.pV;
         
         end loop;
         
      end loop;
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
      codigoAux: tcodigo;
      
      loco: locomotora;
      pnodo: pnode;
      pnodoAux: pnode;
      
      nvagones: Integer;
   begin
     
      --Cogemos una locomotora libre
      if not esta_vacia(locomotoras) then
         loco := coger_primero(locomotoras);
      end if;
      --FALTA ERROR: locomotoras_agotadas
      
      --Montamos tren
      ptren := new tren;
      ptren.all.locoT := loco;
      --Cambiamos el codigo
      codigoAux := loco.lcodigo;
      Replace_Element(codigoAux,1,'T');
      
      --Cogemos vagones
      pnodo := new node;
      pnodoAux := new node;
      
      nvagones := 0;
      while num_vagones > nvagones loop
         
         pnodoAux := ptren.all.pnodo;
         pnodo.all.vagon := cima(vagones);
         pnodo.all.psig := pnodoAux;
         desempila(vagones);
         
         nvagones := nvagones +1;
      end loop;
      --FALTA ERROR: vagones_agotados
      
   exception
      when Constraint_Error => raise locomotoras_agotadas; --Locomotoras agotadas
      
   end creaTren;
   
   procedure consultaTren(cia: in cTrenes; t: in tcodigo) is
   begin
      null;
   end consultaTren;
   
   procedure desmantelarTren(cia: in out cTrenes) is 
      hash: conjuntoH renames cia.hash;
      
      avl:  conjunto  renames cia.avl;
      itA:   iterator;
      kAux: pesoAcumulado;
      xAux: p_tren;
      vagonAux: pvagon;
      vagonAux2: pvagon;
      
   begin
      --cogemos el tren de peso menor
      first(avl,itA);
      
      if (is_valid(itA)) then 
         get(avl,itA,kAux,xAux);
      
         --puntero apuntando al segudno vagon
         vagonAux := new vagon;
         vagonAux2 := new vagon;
      
         vagonAux.all := xAux.all.vagonT;
         
         --mientras haya vagones imprimimos
         while(vagonAux /= null) loop
            
            if(vagonAux.pV /= null) then
               vagonAux2 := vagonAux.pV;
            end if;
         
            --imprimimos para debuggear luego
            Put_Line(To_String(vagonAux.all.Vcodigo));
            Put_Line(vagonAux.all.pesoMax'Img);
         
            --quitamos este vagón y lo aparcamos
            aparcaVagon(cia,vagonAux.all.Vcodigo,vagonAux.all.pesoMax);
            vagonAux.pV := null;
         
            --avanzamos puntero.
            vagonAux := vagonAux2;
         
         end loop;
         
         --aparcamos locomotor
         aparcaLocomotora(cia,xAux.all.locoT.lcodigo);
         
         --modificamos codigoLoco para borrarlo del hash
         Replace_Element(xAux.all.locoT.lcodigo,1,'T');
         borrar(hash,xAux.all.locoT.lcodigo);
         
         --borrarmos del avl
         borrar(avl,kAux);
      else  
         Put_Line("No hay trenes");
      end if;
     
   end desmantelarTren;
   
   
   --Mayor
   function mayor(k1, k2 : in pesoAcumulado) return boolean is
  
   begin
      
      return k1>k2;

   end mayor;
  --Menor
  function menor(k1,k2 : in pesoAcumulado) return boolean is

   begin

      return k1<k2;

   end menor;
   
   --Igual
   function igual(k1,k2 : in tcodigo) return boolean is

   begin

      return k1=k2; --esto es legal? lmao

   end igual;


end dtrenes;
