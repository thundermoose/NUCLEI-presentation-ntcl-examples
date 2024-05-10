program Gemm_Interface
    use, intrinsic :: iso_fortran_env, only : real64
    use :: algorithms_initializer, only : algorithms_initialize, algorithms_finalize
    use :: algorithms_api, only :  dgemm=>ntcl_gemm_real64

    implicit none

    integer, parameter :: m = 10
    integer, parameter :: n = 10
    integer, parameter :: k = 10
    real(real64), dimension(m,k) :: A
    real(real64), dimension(k,n) :: B
    real(real64), dimension(m,n) :: C

    call algorithms_initialize()
    call random_number(A)
    call random_number(B)
    C(:,:) = 0.0

    call dgemm('N', 'N', m, n, k, 1.0D0, A, m, B, k, 0.0D0, C, m)
    write (*,*) 'A = '
    call print_matrix(A)
    write (*,*) 'B = '
    call print_matrix(B)
    write (*,*) 'C = '
    call print_matrix(C)
    call algorithms_finalize()
contains
    subroutine print_matrix(matrix)
        real(real64), dimension(:, :), intent(in) :: matrix

        integer :: row

        do row = 1, size(matrix, 1)
            write (*,*) matrix(row,:)
        end do
    end subroutine print_matrix
end program Gemm_Interface
