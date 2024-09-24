--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.melodie_constants_pkg.all;


package melodie is

	constant hit_racket : song_type := (
		(pause, z, f),
		(a1, a, f),
		(res, z, o),
		others => (res, z, o)
		);

	constant hit_wall : song_type := (
		(pause, z, f),
		(f2, z, f),
		(res, z, o),
		others => (res, z, o)
		);

	constant hit_out : song_type := (
		(pause, z, f),
		(f1, v, f),
		(a_2, v, f),
		(a_2, v, f),
		(pause, z, f),
		(res, z, o),
		(pause, z, f),
		others => (res, z, o)
		);

	constant looser : song_type := (
		(pause, z, f),
		(a0, a, f),
		(d0, v, f),
		(d0, v, f),
		(pause, a, f),
		--(d0, v, f),
		--(pause, z, f),
		(d0, z, f),
		(e0, v, f),
		(d0, v, f),
		(d0, v, f),
		(fis0, v, f),
		(g0, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(pause, v, f),
		(res, z, o),
		others => (res, z, o)
		);
		
	constant background_melody : song_type := (
		(pause, z, f),
		-- erster Takt
		(e2,v,f),
		(h1,a,f),
		(c2,a,f),
		(d2,a,f),
		(e2,s,f),
		(d2,s,f),
		(c2,a,f),
		(h1,a,f),

		-- zweiter Takt
		(a1,v,f),
		(a1,a,f),
		(c2,a,f),
		(e2,v,f),
		(d2,a,f),
		(c2,a,f),

		-- dritter Takt
		(h1,a,f),
		(e1,a,f),
		(gis1,a,f),
		(c2,a,f),
		(d2,v,f),
		(e2,v,f),

		-- vierter Takt
		(c2,v,f),
		(a1,v,f),
		(a1,v,f),
		(h_1,a,m),-- Bass-Toene
		(c0,a,m), -- Bass-Toene


		-- fuenfter Takt
		(d0,a,m), -- Bass-Toene
		(d2,v,f),
		(f2,a,f),
		(a2,v,f),
		(g2,a,f),
		(f2,a,f),

		-- sechster Takt
		(e2,v,f),
		(e2,a,f),
		(c2,a,f),
		(e2,v,f),
		(d2,a,f),
		(c2,a,f),

		-- siebter Takt
		(h1,v,f),
		(h1,a,f),
		(c2,a,f),
		(d2,v,f),
		(e2,v,f),

		-- achter Takt
		(c2,v,f),
		(a1,v,f),
		(a1,v,f),
		(pause,v,f),


		-- Wiederholung der ersten acht Takte

		-- erster Takt
		(e2,v,f),
		(h1,a,f),
		(c2,a,f),
		(d2,a,f),
		(e2,s,f),
		(d2,s,f),
		(c2,a,f),
		(h1,a,f),

		-- zweiter Takt
		(a1,v,f),
		(a1,a,f),
		(c2,a,f),
		(e2,v,f),
		(d2,a,f),
		(c2,a,f),

		-- dritter Takt
		(h1,a,f),
		(e1,a,f),
		(gis1,a,f),
		(c2,a,f),
		(d2,v,f),
		(e2,v,f),

		-- vierter Takt
		(c2,v,f),
		(a1,v,f),
		(a1,v,f),
		(h_1,a,m),-- Bass-Toene
		(c0,a,m), -- Bass-Toene


		-- fuenfter Takt
		(d0,a,m), -- Bass-Toene
		(d2,v,f),
		(f2,a,f),
		(a2,v,f),
		(g2,a,f),
		(f2,a,f),

		-- sechster Takt
		(e2,v,f),
		(e2,a,f),
		(c2,a,f),
		(e2,v,f),
		(d2,a,f),
		(c2,a,f),

		-- siebter Takt
		(h1,v,f),
		(h1,a,f),
		(c2,a,f),
		(d2,v,f),
		(e2,v,f),

		-- achter Takt
		(c2,v,f),
		(a1,v,f),
		(a1,v,f),
		(pause,v,f),


		-- zweiter Teil

		-- neunter Takt
		(e1,v,m),
		(e1,v,m),
		(c1,v,m),
		(c1,v,m),

		-- zehnter Takt
		(d1,v,m),
		(d1,v,m),
		(h0,v,m),
		(h0,v,m),

		-- elfter Takt
		(c1,v,m),
		(c1,v,m),
		(a0,v,m),
		(a0,v,m),

		-- zwoelfter Takt
		(gis0,v,m),
		(gis0,v,m),
		(h0,v,m),
		(h0,v,m),

		-- dreizehnter Takt
		(e1,v,m),
		(e1,v,m),
		(c1,v,m),
		(c1,v,m),

		-- vierzehnter Takt
		(d1,v,m),
		(d1,v,m),
		(h0,v,m),
		(h0,v,m),

		-- fuenfzehnter Takt
		(c1,v,m),
		(e1,v,m),
		(a1,v,m),
		(a1,v,m),

		-- sechzehnter Takt
		(gis1,v,m),
		(gis1,v,m),
		(gis1,v,m),
		(gis1,v,m),

		-- Reset
		(res,z,o),
		others => (res, z, o)
		);

end melodie;


package body melodie is
end melodie;
