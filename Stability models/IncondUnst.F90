!
!
!****************************************************************************
!
!  SUBROUTINE: IncondUnst
!
!  PURPOSE:  Compute unconditionally instable cells.
!
!****************************************************************************
subroutine IncondUnst()
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
!	Unconditionally unstable cells
!
!	Variables
    REAL*8  :: normMean
    REAL*8  :: NormalCDF


!   Initial condition dry
    h_wt(:,:) = 0.d0

!   Update FS parameters
    CALL UpdateFsGaussian()
    
!   Compute probability of failure
    !$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,j,normMean) 
    !$OMP DO SCHEDULE(DYNAMIC)
!
	DO j=1,my
		DO i=1,mx
! 
!           Check nodata
            IF (FS_mu(i,j) .NE. nodata) THEN
!
!               Normalize variable            
                normMean = (1 - FS_mu(i,j)) / FS_std(i,j)
!
!               Compute cumulative probability for FS = 1            
                UncIns(i,j) = NormalCDF(normMean)
!
            ELSE
                UncIns(i,j) = nodata
            ENDIF
!
        ENDDO
    ENDDO
!    
    !$OMP END DO NOWAIT
    !$OMP END PARALLEL
!    
!   Write results
    CALL WriteGrid(UncIns, './res/PROB_uncond_unst.txt')
!
!
!	Log file
    write(6,'("Computed unconditionally unstable cells probability")')
	open(unit=100,file='./res/Log.txt',access='append')
	write(100,'("Computed unconditionally unstable cells probability")')
	close(100)

end subroutine