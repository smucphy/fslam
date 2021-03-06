!
!
!****************************************************************************
!
!  SUBROUTINE: FinalSaturation
!
!  PURPOSE:  Compute probability of unstable.
!
!****************************************************************************
subroutine FinalSaturation()
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
!	FS for initial saturation
!
!	Variables
    REAL*8  :: normMean
    REAL*8  :: NormalCDF
!
    write(6,'("Initiating event rainfall FS")')
	open(unit=100,file=(trim(fname_res) // '\Log.txt'),access='append')
	write(100,'("Initiating event rainfall FS")')
	close(100)    
!
!
!   Parallel loop
    !$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,j) 
    !$OMP DO SCHEDULE(DYNAMIC)
!
	do j=1,my
		do i=1,mx
!
!           Static cell values
            iZone = zones(i,j)
!
!           Check null
            IF (iZone .NE. INT(nodata)) THEN
!
!               Get porosity
                Porosity = GaussPor(iZone)%mean
                Zmax = Gaussh(iZone)%mean
!            
!			    Water table depth rising (rainfall in mm)
    		    h_wt(i,j) = DMIN1(h_wt(i,j) + Infiltration(i,j) / 1000.d0 / Porosity, Zmax)
!
            ELSE
                h_wt(i,j) = nodata
            ENDIF
!	
!
        enddo
!
    enddo
!
    !$OMP END DO NOWAIT
    !$OMP END PARALLEL
!			
!    
!   Update FS parameters
    CALL UpdateFsGaussian()
    
!   Comput probability of failure
    !$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,j,normMean) 
    !$OMP DO SCHEDULE(DYNAMIC)
!
	do j=1,my
		do i=1,mx
! 
!           Check nodata
            IF (FS_mu(i,j) .NE. nodata) THEN
! 
!               Normalize variable
                normMean = (1 - FS_mu(i,j)) / FS_std(i,j)
!
!               Compute cumulative probability for FS = 1
                PFGrid(i,j) = NormalCDF(normMean)
!
            ELSE
                PFGrid(i,j) = nodata
            ENDIF
!
        enddo
    enddo
!    
    !$OMP END DO NOWAIT
    !$OMP END PARALLEL
!
!
!	Log file
    write(6,'("Computed probability of failure under event rainfall")')
	open(unit=100,file=(trim(fname_res) // '\Log.txt'),access='append')
	write(100,'("Computed probability of failure under event rainfall")')
	close(100)
!
!
end subroutine
