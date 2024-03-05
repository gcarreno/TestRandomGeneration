
{ Code taken from: https://wiki.freepascal.org/Marsaglia%27s_pseudo_random_number_generators }

unit Random.Marsaglia;

{ author: Thaddy de Koning, based on the original C sourcecode in the original post by George Marsaglia }
{ http://www.ciphersbyritter.com/NEWS4/RANDC.HTM#369B5E30.65A55FD1@stat.fsu.edu }

{$mode objfpc}{$H+}

interface

type
  { It is not meant to be extended, since it is based on a single article so I sealed the class }
  TMarsagliaPrngs = class sealed 
  strict private
    {static variables:}
    class var T: array [0..255] of dword;
    class var a,b,v,w,x,y,z,bro,jcong,jsr:dword;
    class var c:byte;
    class function wnew:dword;inline;static;    
    class function znew:dword;inline;static;
  public
    { You can also call the create explicitly to reset the static 
      variables.}
    class constructor Create;
    class procedure SetTable(const i1,i2,i3,i4,i5,i6:dword);static;
    class procedure Randomize;inline;static;
    class function MWC:dword;inline;static;  
    class function SHR3:dword;inline;static;  
    class function CONG:dword;inline;static;  
    class function FIB:dword;inline;static;  
    class function KISS:dword;inline;static; 
    class function LFIB4:dword;inline;static;
    class function SWB:dword;inline;static;  
    // From XSorShift Prng's, 2003
    class function XOS:dword;inline;static;
  end;
  
  { a shorthand alias: }
  Prng = type TMarsagliaPrngs;     
  
  { Because many simulations call for uniform
    random variables in 0<x<1 or -1<x<1, here's a utility function.
    Using Signed = false will provide a random single in range (0,1), 
    while Signed true will provide one in range (-1,1).
    Simply feed it the output of one of the Prng's}
  function ScaleToFloat(const value:dword; Signed:Boolean=true):single;inline;
     

implementation
  
    class function TMarsagliaPrngs.znew:dword;inline;static;
    begin
      z:=36969*(z and 65535)+(z >> 16);
      Result:= z;
    end;
        
    class function TMarsagliaPrngs.wnew:dword;inline;static;
    begin
      w:=18000*(w and 65535)+(w >> 16);
      Result := w;
    end;
    
    
    class constructor TMarsagliaPrngs.Create;
    begin
      a:=224466889; b:=7584631;c:=0;v:=2463534242;w:=521288629;x:=0;y:=0;
      z:=362436069;jsr:=123456789; jcong:=380116160;  
      SetTable(12345,65435,34221,12345,9983651,95746118);
    end;
    
    { Use random seeds to reset z,w,jsr,jcong,a,b, and the table t[256]}  
    class procedure TMarsagliaPrngs.SetTable(const i1,i2,i3,i4,i5,i6:dword);inline;static;
    var
      i:integer;
    begin
      z:=i1; w:=i2; jsr:=i3; jcong:=i4; a:=i5; b:=i6;
    { Example procedure to set the table using KISS:}
      for i:=0 to 255 do t[i]:=KISS;
    end;
    
    class function TMarsagliaPrngs.MWC:dword;inline;static;
    begin
      Result:= (znew << 16)+wnew; 
    end;
    
    class function TMarsagliaPrngs.SHR3:dword;inline;static;
    begin
      jsr:=jsr xor(jsr << 17); jsr:= jsr xor(jsr >> 13); jsr:=jsr xor(jsr << 5);
      result := jsr;
    end;
    
    class function TMarsagliaPrngs.CONG:dword;inline;static;
    begin
     jcong:=69069*jcong+1234567;
     Result := jcong;
    end;
    
    class function TMarsagliaPrngs.FIB:dword;inline;static;
    begin
       b:=a+b;a:=b-a;
       Result := a;
    end;
    
    class function TMarsagliaPrngs.KISS:dword;inline;static;
    begin
      Result:= (MWC xor CONG)+SHR3;
    end;
    
    class function TMarsagliaPrngs.LFIB4:dword;inline;static;
    begin
      inc(c);
      t[c]:=t[c]+t[(c+58) and 255]+t[(c+119) and 255]+t[(c+178) and 255];
      Result:=t[c];
    end;
    
    class function TMarsagliaPrngs.SWB:dword;inline;static;
    begin
      inc(c);bro:=ord(x<y);
      x:=t[(c+34) and 255];
      y:=t[(c+19) and 255]+bro;
      t[c] := x-y;
      Result:= t[c];
    end;

    class function TMarsagliaPrngs.XOS:dword;inline;static;
    var tmp:dword;
    begin
      tmp:=(x xor (x<<15)); 
      x:=y; 
      y:=z; 
      z:=w; 
      w:=(w xor (w>>21)) xor (tmp xor(tmp>>4));
      Result := w;
    end;
    
    class procedure TMarsagliaPrngs.Randomize;inline;static;
    var
      i: Integer;
    begin
      {$WARNING This is not implemented here yet, so use system.random}
      system.randomize;
      for i:=0 to 255 do t[i]:=system.random(256);
    end;
    
   function ScaleToFloat(const value:dword; Signed:Boolean=true):single;inline;
   begin
     case Signed of
     False:Result:= dword(value) * 2.328306e-10;
     True :Result:= longint(value) * 4.656613e-10;
     end;
  end;
     
 end.
