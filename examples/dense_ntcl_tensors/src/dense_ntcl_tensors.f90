program Dense_NTCL_Tensors
    use, intrinsic :: iso_fortran_env, only : real64
    use :: algorithms_initializer, only : algorithms_initialize, algorithms_finalize
    use :: algorithms_api, only : tensor_contraction, tensor_contraction_factory
    use :: tensor_api, only : tensor, allocate_and_copy_tensor, &
            secure_fortran_pointer_from_tensor, &
            release_pointer_from_remote_tensor
    implicit none

    integer, parameter :: m = 10
    integer, parameter :: n = 10
    integer, parameter :: k = 10
    class(tensor_contraction), allocatable :: my_contraction
    class(tensor), allocatable :: tensor_A, tensor_B, tensor_C
    real(real64), dimension(m,k) :: A
    real(real64), dimension(k,n) :: B
    real(real64), dimension(m,n) :: C
    real(real64), dimension(:,:), contiguous, pointer :: C_ptr

    call algorithms_initialize()

    call random_number(A)
    call random_number(B)
    C(:,:) = 0.0


    ! Copying tensors to GPU
    call allocate_and_copy_tensor(tensor_A, A)
    call allocate_and_copy_tensor(tensor_B, B)
    call allocate_and_copy_tensor(tensor_C, C)

    
    ! Setting up the tensor contraction
    call tensor_contraction_factory%create(my_contraction, 'C(a,b)=A(a,c)*B(c,b)')

    ! Performing tensor contraction on GPU
    call my_contraction%contract(tensor_C, tensor_A, tensor_B)
    ! ... potentially many different contractions

    ! Copying tensor C from GPU to CPU
    call secure_fortran_pointer_from_tensor(C_ptr, tensor_C)
    C(:,:) = C_ptr(:,:)
    call release_pointer_from_remote_tensor(C_ptr, tensor_C)
    

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
end program Dense_NTCL_Tensors
