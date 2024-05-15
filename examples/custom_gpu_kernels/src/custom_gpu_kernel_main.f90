module Custom_GPU_Kernel_module
    use, intrinsic :: iso_fortran_env, only : real64
    use :: iso_c_binding, only : c_ptr, c_int64_t, c_null_ptr
    use :: data_api, only : stream
    use :: tensor_api, only : &
            tensor, &
            tensor_converter_factory, &
            tensor_c_pointer_converter, &
            dt_r64
    implicit none
    private
    public :: call_gpu_callback
    interface 
        subroutine my_gpu_callback(dst, src, num_elements, stream) &
            bind(C, name="my_gpu_callback")
            import :: c_ptr
            import :: c_int64_t

            type(c_ptr), value :: dst, src
            integer(c_int64_t), value :: num_elements
            type(c_ptr), value :: stream
        end subroutine my_gpu_callback
    end interface
contains
    subroutine call_gpu_callback(dst, src, astream)
        class(tensor), intent(inout) :: dst
        class(tensor), intent(in) :: src
        type(stream), intent(in), optional :: astream

        type(tensor_converter_factory) :: converter_factory
        type(tensor_c_pointer_converter) :: converter
        type(c_ptr) :: dst_ptr, src_ptr
        type(c_ptr) :: actual_stream
        
        if (src%get_datatype() /= dt_r64 .or. src%get_datatype() /= dst%get_datatype()) then
            error stop 'Only real64 is supported'
        end if
        if (src%get_number_of_elements() /= dst%get_number_of_elements()) then
            error stop 'The number of elements must be the same'
        end if
        actual_stream = c_null_ptr
        if (present(astream)) actual_stream = astream%sid
        converter = converter_factory%get_c_pointer_converter("device")
        call converter%secure_pointer(dst, dst_ptr, astream)
        call converter%secure_pointer(src, src_ptr, astream)
        call my_gpu_callback(dst_ptr, src_ptr, src%get_number_of_elements(), actual_stream)
        call converter%release(src, src_ptr, astream)
        call converter%update_and_release(dst, dst_ptr, astream)
        call converter%cleanup()
    end subroutine call_gpu_callback
end module Custom_GPU_Kernel_module

program Custom_GPU_Kernel_Main
    use, intrinsic :: iso_fortran_env, only : real64
    use :: tensor_initializer, only : tensor_initialize, tensor_finalize
    use :: tensor_api, only : tensor, &
            allocate_and_copy_tensor, &
            allocate_and_create_tensor, &
            secure_fortran_pointer_from_tensor, &
            release_pointer_from_remote_tensor
    use :: Custom_GPU_Kernel_module, only : call_gpu_callback
    implicit none

    integer, parameter :: side = 1000
    class(tensor), allocatable :: tensor_dst, tensor_src
    real(real64), dimension(side,side) :: src
    real(real64), dimension(:,:), contiguous, pointer :: dst_data
    integer :: row_idx, col_idx

    call tensor_initialize()
    do row_idx = 1, side
        do col_idx = 1, side
            src(row_idx,col_idx) = 1.0*((row_idx-1)*side + col_idx-1) 
        end do
    end do
    
    call allocate_and_copy_tensor(tensor_src, src, memory_type='device')
    call allocate_and_create_tensor(tensor_dst, [side, side], memory_type='device')

    call call_gpu_callback(tensor_dst, tensor_src)

    call secure_fortran_pointer_from_tensor(dst_data, tensor_dst)
    write (*,*) 'Pi: ', sqrt(6*sum(dst_data))
    call release_pointer_from_remote_tensor(dst_data, tensor_dst)
    call tensor_src%cleanup()
    call tensor_dst%cleanup()
    deallocate(tensor_src)
    deallocate(tensor_dst)
    call tensor_finalize()
end program Custom_GPU_Kernel_Main
