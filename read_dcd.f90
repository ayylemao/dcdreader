program read_header
use m_npy
! Data declarations
INTEGER*4 NTITL, ICNTRL(20),NATOM
CHARACTER(100) :: filename, outfile, max_at_str
CHARACTER*4 HDR
CHARACTER*80 TITLE(2) !(NTITL)
INTEGER :: i, dir, iframe, iatom, max_at
REAL*4, allocatable :: coord_x(:), coord_y(:), coord_z(:)
REAL*4, allocatable :: coor(:,:,:)

IF(COMMAND_ARGUMENT_COUNT().NE. 3) THEN
    write(*,*) "No max_at supplied, all atoms will be considered" 
end if

call get_command_argument(1, filename)
call get_command_argument(2, outfile)
call get_command_argument(3, max_at_str)

open(unit=56, file=filename, form='unformatted')
read(56) HDR,icntrl
 
read(56) NTITL, (TITLE(i), i=1,NTITL)


read(56) natom

WRITE(*,*) "TYPE OF FILE: ", HDR
WRITE(*,*) "NUMBER OF FRAMES IN FILE:", ICNTRL(1)
write(*,*) "NUMBER OF ATOMS IN SYS:", natom

if (ICNTRL(11).EQ.1) then
write(*,*) "CRYSTAL LATTICE INFO PRESENT"
end if
if (COMMAND_ARGUMENT_COUNT().EQ.3) then
    READ(max_at_str,*) max_at
    natom = max_at    
    write(*,*)
    write(*,*) "Only the first", max_at, "atoms will be considered!"
else
    max_at = natom
end if
!ICNTRL(1) = 750000.0 IF HEADER DOES NOT CONTAIN THE CORRECT # OF FRAMES
allocate(coor(ICNTRL(1), 3, natom))
allocate(coord_x(natom))
allocate(coord_y(natom))
allocate(coord_z(natom))

if (ICNTRL(9).EQ.1) then
    read(56) ! fixed atom adds another header line (?)
end if

do iframe=1, ICNTRL(1)
    if (ICNTRL(11).EQ.1) then
    read(56) ! CELL DATA (?)
    end if
    read(56) coord_x 
    read(56) coord_y
    read(56) coord_z

    coor(iframe, 1, :) = coord_x(1:max_at)
    coor(iframe, 2, :) = coord_y(1:max_at)
    coor(iframe, 3, :) = coord_z(1:max_at)
end do
call save_npy(outfile, coor)
write(*,*) 
write(*,*) "COORDINATES WRITTEN TO ", outfile

end program read_header
