%typemap(imtype) STRINGPARAM "[global::System.Runtime.InteropServices.MarshalAs(global::System.Runtime.InteropServices.UnmanagedType.LPWStr)] System.String"
%typemap(imtype) STRING      "global::System.IntPtr"

%typemap(cstype) STRINGPARAM "string"
%typemap(cstype) STRING      "string"

%typemap(in)  STRINGPARAM    %{ $1 = $input; %}
%typemap(out) STRING         %{ $result = $1; %}

%typecheck(SWIG_TYPECHECK_STRING)
    char *,
    wchar_t *,
    STRINGPARAM,
    STRING,
    char[ANY]
    ""
    
%typemap(csin) STRINGPARAM "$csinput"

%typemap(csout, excode=SWIGEXCODE) STRING {
    System.IntPtr cPtr = $imcall;$excode
    System.String str = global::System.Runtime.InteropServices.Marshal.PtrToStringUni(cPtr);
    global::System.Runtime.InteropServices.Marshal.FreeCoTaskMem(cPtr);
    return str;
}

%typemap(csvarout) STRINGPARAM, STRING %{
    get 
    {
        var result = $imcall;$excode
        return result;
    } 
%}