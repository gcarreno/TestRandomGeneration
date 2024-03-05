
{ Code taken from: https://wiki.freepascal.org/Marsaglia%27s_pseudo_random_number_generators }

program TestRandomGeneration;

{ author: Thaddy de Koning, based on the original C sourcecode in the original post by George Marsaglia }
{ http://www.ciphersbyritter.com/NEWS4/RANDC.HTM#369B5E30.65A55FD1@stat.fsu.edu }

{$mode objfpc}{$H+}{$I-}

{ It is basically Marsaglia's C test program in Pascal }
uses 
  Random.Marsaglia;
  
var
  i:integer;
  k:dword;
  
begin 
  // Set the table to known values, so we can verify the results.
  // The one million iterations per prng are  not a mistake.
  // The whole program will finish in less than .5 seconds even on a Raspberry pi one.
  // Order is important: some seeds are taken from other prng's
  Prng.SetTable(12345,65435,34221,12345,9983651,95746118);
  for i:=1 to 1000000 do k:=Prng.LFIB4;WriteLn('LFIB4 ','Pass: ',k-1064612766=0);
  for i:=1 to 1000000 do k:=Prng.SWB;  WriteLn('SWB   ','Pass: ',k- 627749721=0);
  for i:=1 to 1000000 do k:=Prng.KISS; WriteLn('KISS  ','Pass: ',k-1372460312=0);
  for i:=1 to 1000000 do k:=Prng.CONG; WriteLn('CONG  ','Pass: ',k-1529210297=0);
  for i:=1 to 1000000 do k:=Prng.SHR3; WriteLn('SHR3  ','Pass: ',k-2642725982=0);
  for i:=1 to 1000000 do k:=Prng.MWC;  WriteLn('MWC   ','Pass: ',k- 904977562=0);
  for i:=1 to 1000000 do k:=Prng.FIB;  WriteLn('FIB   ','Pass: ',k-3519793928=0);
  for i:=1 to 1000000 do k:=Prng.XOS;  WriteLn('XOS   ','Pass: ',k-1110212780=0);
  // Scale to float demo 
  for i := 0 to 9 do WriteLn(ScaleToFloat(Prng.SHR3):2:10);
  WriteLn('..........................');
  for i := 0 to 9 do WriteLn(ScaleToFloat(Prng.SHR3, false):2:10);
end.
