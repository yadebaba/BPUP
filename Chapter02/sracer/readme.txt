(C) Oleg Tsodikov, 2001,2002

Surface Racer (surfrace) is distributed free of charge only for academic use. 

System requirements: Windows 95/98/NT/2000/XP


INSTALLATON

After the download, use the EXtract All  command (in the WinZip utility, which should start
automatically after clicking on sracer.zip) to extract fastsurf.exe, surfrace.exe, radii.txt
and readme.txt from the archive sracer.zip into the same directory as the file beeing analyzed. 
The program surfraceX_0.exe is now ready to be used. 

INPUT AND OUTPUT

Surface Racer 1.0 uses files in the Protein Data Bank format. No hydrogen atoms are allowed in the structures! 
Delete hydrogens from NMR structure files prior to use. 
Any name could be used, but the suffix needs to be typed explicitly. There is no
limit on the number of atoms in the structure; side chains need to be included for meaningful results.
Water molecules are discarded during calculation. 

There are 3 output files.

1.  The first output file has the same name with the ".txt" suffix and contains 
only ATOM records in the original format, with van der Waals radius, accessible 
(from OUTSIDE ONLY) surface area (outside ASA), molecular surface area (outside MSA), 
average curvature of molecular surface for each atom listed at the end of each 
line in this particular order, the curvature being the last entry. The same 
information for the cavities in the protein interior is recorded at the end 
of the file (when using surfrace). Note that sometimes the same atom can be 
accessible from both outside and a cavity if this cavity is sufficiently close 
to the surface. These two surfaces are topologically distinct and are treated 
accordingly by the program.   

2.  Secondly  the file result.txt is created. This file contains the probe radius, 
total accessible and molecular surface areas and their breakdown into polar, 
nonpolar, charged etc parts.These results are added to the file after each new calculation.

3. The third file filename_residue.txt contains the last three parameters 
(accessible surface area, molecular surface area, average curvature of molecular 
surface) for each amino acid residue in the protein.


File radii.txt contains two van der Waals radus sets, commonly used in macromolecular 
surface area calculations. The radius values can be changed by the user provided that the
file format is fully preserved.


CALCULATION

The program runs as a console application. The user chooses between the first 
and the second radus sets from radii.txt (by pressing 1 or 2), inputs the name 
of the PDB file (the input file should be in the same directory as the program 
and should include the suffix), probe radius in Angstroms and the calculation 
mode. The calculation is performed only for atoms with the ATOM record. If the 
file contains disconnected structures (where "disconnected" means that they 
cannot be bridged by the probe sphere), only one of these structures will be 
included in the calculation. The safest way to proceed in this case is to leave 
only the structure of interest in the file before running Surface Racer.

REFERENCE

The algorithm employed in this program has been described in detail in the following 
paper:

Tsodikov, O. V., Record, M. T. Jr. and Sergeev, Y. V. (2002). A novel computer program 
for fast exact calculation of accessible and molecular surface areas and average surface 
curvature. J. Comput. Chem., 23, 600-609. 


