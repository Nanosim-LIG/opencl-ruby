using OpenCLRefinements if RUBY_VERSION.scan(/\d+/).collect(&:to_i).first >= 2

module OpenCL

  PLATFORM_NOT_FOUND_KHR = -1001

  PLATFORM_ICD_SUFFIX_KHR = 0x0920

  class Error

    eval error_class_constructor( :PLATFORM_NOT_FOUND_KHR, :PlatformNotFoundKHR )

  end

  class Platform
    ICD_SUFFIX_KHR = 0x0920

    module KHRICD
      extend InnerGenerator

      get_info("Platform", :string, "icd_suffix_khr")

    end

    register_extension( :cl_khr_icd,  KHRICD, "extensions.include?(\"cl_khr_icd\")" )

  end

end
