with Ada.Text_IO; use Ada.Text_IO;
with dtrenes;

--PRACTICA 3 - Trenes
--Marc Torres Torres, Jorge Gonzalwz Pascual
procedure Main is

   package tren is new dtrenes;
   use tren;

   conjunto: cTrenes;
   codigo: tcodigo;

begin
   --preparamos el conjunto
   vacio(conjunto);

   --creamos tren (exception management)
   --(conjunto,codigo,20);

   Put_Line("");

   --Insertamos locomotoras
   put_line("----CREAMOS LOCOMOTORAS----");
   codigo := "L1234567";
   aparcaLocomotora(conjunto,codigo);
   codigo := "L2345678";
   aparcaLocomotora(conjunto,codigo);
   codigo := "L3456789";
   aparcaLocomotora(conjunto,codigo);
   Put_Line("---------------------------");
   Put_Line("");

   --Insertamos vagones
   put_line("----CREAMOS VAGONES--------");
   codigo := "V1234567";
   aparcaVagon(conjunto,codigo,100);
   codigo := "V2345678";
   aparcaVagon(conjunto,codigo,125);
   codigo := "V3456789";
   aparcaVagon(conjunto,codigo,150);
   codigo := "V4567890";
   aparcaVagon(conjunto,codigo,175);
   codigo := "V7654321";
   aparcaVagon(conjunto,codigo,200);
   codigo := "V8765432";
   aparcaVagon(conjunto,codigo,225);
   codigo := "V9876543";
   aparcaVagon(conjunto,codigo,250);
   Put_Line("---------------------------");
   Put_Line("");

   --creamos trenene
   put_line("----CREAMOS TRENES--------");
   creaTren(conjunto,codigo,2);
   creaTren(conjunto,codigo,3);
   creaTren(conjunto,codigo,2);
   Put_Line("--------------------------");
   Put_Line("");

   --consultamos ultimo tren
   put_line("----CONSULTA--------------");
   consultaTren(conjunto,codigo);
   Put_Line("--------------------------");
   Put_Line("");

   --listamos trenes
   put_line("----LISTAMOS--------------");
   listarTrenes(conjunto);
   Put_Line("--------------------------");

   Put_Line("");

   --eliminamos tren
   put_line("----ELIMINAMOS UN TREN----");
   desmantelarTren(conjunto);
   Put_Line("--------------------------");
   Put_Line("");

   --listamos trenes
   put_line("----LISTAMOS--------------");
   listarTrenes(conjunto);
   Put_Line("--------------------------");

   --ERRORES:
   --eliminamos  todos los trenes y uno mas (excepcion management)
   --desmantelarTren(conjunto);

   --desmantelarTren(conjunto);
   --desmantelarTren(conjunto);

   --consultamos y listamos (exception management)

   --consultaTren(conjunto,codigo);
   --listarTrenes(conjunto);

end Main;

