with Ada.Text_IO; use Ada.Text_IO;
with dcola;
with dpila;
with d_open_hash;
with davl;

--PRACTICA 3 - Trenes
--Marc Torres Torres, Jorge Gonzalez Pascual

generic
   
package dtrenes is
   
   --Elemento principal del paquete
   type cTrenes is limited private;
   
   subtype tcodigo is String(1..8);
      
   --excepciones
   aparcamiento_locomotoras_completo: exception;
   aparcamiento_vagones_completo: exception;
   locomotoras_agotadas: exception;
   vagones_agotados: exception;
   inventario_trenes_completo: exception;
   tren_no_existe: exception;
   
   --procedures
   procedure vacio(cia: out cTrenes);
   procedure aparcaLocomotora(cia: in out cTrenes; k: in tcodigo);
   procedure aparcaVagon(cia: in out cTrenes; k: in tcodigo;pmax: in integer);
   procedure listarTrenes(cia: in cTrenes);                      
   procedure creaTren(cia: in out cTrenes; t: out tcodigo; num_vagones:in Integer);
   procedure consultaTren(cia: in cTrenes; t: in tcodigo); 
   procedure desmantelarTren(cia: in out cTrenes); 
   
private
   --Fuciones
   -- Funciones AVL
   function mayor (k1, k2: in Integer) return boolean;
   function menor (k1, k2: in Integer) return boolean; 
   
   -- Funciones Hash
   function hashf (k: in tcodigo ; b: in Integer) return natural;
   function igual (k1, k2: in tcodigo) return boolean;

   
   -- Tipos de "Datos"
   type vagon;
   type vagon is record
      Vcodigo:  tcodigo;
      pesoMax:  Integer;
   end record;
   
   type locomotora is record
      lcodigo: tcodigo;
   end record;
   
   --Lista enlazada de vagones
   type node; 
   type pnode is access node;
   type node is record
      nvagon: vagon;
      psig: pnode;
   end record;
   
   --parking de locomotoras
   package colaP is new dcola(locomotora);
   use colaP;
   
   --parking de vagones
   package pilaP is new dpila(vagon);
   use pilaP;

   type tren is record
      locoT: locomotora;
      pnodo: pnode;
   end record;
   
   type p_tren is access tren;
   
   --hash para buscar por código
   package dhashT is new d_open_hash(key           => tcodigo,
                                     item          => p_tren,
                                     "="           => igual,
                                     hash          => hashF,
                                     size          => 97);
   use dhashT;
   
  
   --AVL para buscar por peso
   package davlT is new davl(  key           => Integer,
                               item          => p_tren,
                               "<"           =>  menor,
                               ">"           =>  mayor);
   use davlT;
   
   
   type cTrenes is record
      pkLoco: cola;
      pkVagon: pila;
      hash: conjuntoH;
      avl: conjunto;
   end record;


end dtrenes;
