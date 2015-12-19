%typemap(imtype) STRINGPARAM "[MarshalAs(UnmanagedType.LPWStr)] String"
%typemap(imtype) STRING      "IntPtr"

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

%typemap(csout) STRING {
    System.IntPtr cPtr = $imcall;
    $excode;
    String str = global::System.Runtime.InteropServices.Marshal.PtrToStringUni(cPtr);
    global::System.Runtime.InteropServices.Marshal.FreeCoTaskMem(cPtr);
    return str;
}

%typemap(csvarout) STRINGPARAM, STRING %{
    get 
    {
        return $imcall;
    } 
%}