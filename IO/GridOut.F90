!
!
!****************************************************************************
!
!  SUBROUTINE: GridOut
!
!  PURPOSE:  Write results.
!
!****************************************************************************
subroutine GridOut()
!
!
!
!	Variables globales
	use fslamGlobals_structures
	use fslamGlobals_shared
	use fslamGlobals_private
!
!
	implicit double precision (a-h,o-z)
!
!
!
!	Salida de resultados velocidad mediante GRID Arcview
	write(6,'("Topo output",/)')
!   
!	Escribimos resultados
    fname = './res/topo.txt'
!
	open(unit=100,file=fname,status='unknown',form='formatted')
!
!	Keywords de la GRID
	write(100,1000) 'ncols         ', mx
	write(100,1000) 'nrows         ', my  
!
	write(100,1001) 'xllcorner     ', xcorner
	write(100,1001) 'yllcorner     ', ycorner
!    
	write(100,1001) 'cellsize      ', dx
	write(100,1000) 'NODATA_value  ', -9999
!
!	Escribimos la malla
	do j = 1,my
		write(100,1002) (topoIni(i,j), i =1,mx-1)
		write(100,1004) topoIni(mx,j)
	end do
!    
!	Cerramos fichero
	close(100)
!
!
!
!	Salida de resultados velocidad mediante GRID Arcview
	write(6,'("Fill topo output",/)')   
!
!	Escribimos resultados
    fname = './res/fill.txt'
!
	open(unit=100,file=fname,status='unknown',form='formatted')
!
!	Keywords de la GRID
	write(100,1000) 'ncols         ', mx
	write(100,1000) 'nrows         ', my  
!
	write(100,1001) 'xllcorner     ', xcorner
	write(100,1001) 'yllcorner     ', ycorner
!    
	write(100,1001) 'cellsize      ', dx
	write(100,1000) 'NODATA_value  ', -9999
!
!	Escribimos la malla
	do j = 1,my
		write(100,1002) (topo(i,j), i =1,mx-1)
		write(100,1004) topo(mx,j)
	end do
!    
!	Cerramos fichero
	close(100)
!
!
!
!	Salida de resultados velocidad mediante GRID Arcview
	write(6,'("Slopes output",/)')
!   
!	Escribimos resultados
    fname = './res/Slopes.txt'
!
	open(unit=100,file=fname,status='unknown',form='formatted')
!
!	Keywords de la GRID
	write(100,1000) 'ncols         ', mx
	write(100,1000) 'nrows         ', my  
!
	write(100,1001) 'xllcorner     ', xcorner
	write(100,1001) 'yllcorner     ', ycorner
!    
	write(100,1001) 'cellsize      ', dx
	write(100,1000) 'NODATA_value  ', -9999
!
!	Escribimos la malla
	do j = 1,my
		write(100,1002) (slopeGrid(i,j), i =1,mx-1)
		write(100,1004) slopeGrid(mx,j)
	end do
!    
!	Cerramos fichero
	close(100)
!
!
!
!	Salida de resultados mediante GRID Arcview
	write(6,'("Flow accumulation output",/,/,/)')
!   
!	Escribimos resultados
    fname = './res/cumflow.txt'
!
	open(unit=100,file=fname,status='unknown',form='formatted')
!
!	Keywords de la GRID
	write(100,1000) 'ncols         ', mx
	write(100,1000) 'nrows         ', my  
!
	write(100,1001) 'xllcorner     ', xcorner
	write(100,1001) 'yllcorner     ', ycorner
!    
	write(100,1001) 'cellsize      ', dx
	write(100,1000) 'NODATA_value  ', -9999
!
!	Escribimos la malla
	do j = 1,my
		write(100,1002) (cumflow(i,j), i =1,mx-1)
		write(100,1004) cumflow(mx,j)
	end do
!    
!	Cerramos fichero
	close(100)
!
!
!
!	Formatos de Keyword
1000 format(A14, I10)
1001 format(A14, F14.6)
1002 format(F15.4, $)
1003 format(/)    
1004 format(F15.4)
!
!
!
end subroutine