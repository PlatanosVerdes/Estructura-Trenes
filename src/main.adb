with Ada.Strings.Unbounded; use ada.Strings.Unbounded;
with dtrenes;

procedure Main is

   package tren is new dtrenes;
   use tren;

   conjunto: cTrenes;
   codigo: tcodigo;

begin
   --preparamos el conjunto
   vacio(conjunto);

   --creamos tren (exception management)

   creaTren(conjunto,codigo,20);

   --insertamos locomotoras

   codigo := "L1234567";

   aparcaLocomotora(conjunto,codigo);

   codigo := "L2345678";

   aparcaLocomotora(conjunto,codigo);

   codigo := "L3456789";

   aparcaLocomotora(conjunto,codigo);

   --insertamos vagones

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

   --creamos trenenes

   creaTren(conjunto,codigo,2);
   creaTren(conjunto,codigo,3);
   creaTren(conjunto,codigo,2);

   --consultamos ultimo tren

   consultaTren(conjunto,codigo);

   --listamos trenes

   listarTrenes(conjunto);

   --eliminamos  tren

   desmantelarTren(conjunto);

   --listamos trenes

   listarTrenes(conjunto);

   --eliminamos  todos los trenes y uno mas (excepcion management)

   desmantelarTren(conjunto);
   desmantelarTren(conjunto);
   desmantelarTren(conjunto);

   --consultamos y listamos (exception management)

   consultaTren(conjunto,codigo);
   listarTrenes(conjunto);


end Main;

