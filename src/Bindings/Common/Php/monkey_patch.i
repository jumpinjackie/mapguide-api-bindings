/**
 * monkey_patch.i
 *
 * Selective monkey patching of classes and/or APIs that we're currently finding difficulties wrapping through
 * vanilla SWIG
 *
 * Motivation:
 *
 * The current version of SWIG (3.0.12) is generating incorrect methods for certain overloads, this is most
 * prevalent on methods that have overloaded variations whose return type is some kind of abstract class.
 *
 * Due to insufficient resources, we cannot truly identify the cause and fix.
 *
 * However, we can workaround this by being leveraging SWIG facilities to "un-overload" a problematic method and hand-write
 * a fixed version of the orignal overloaded method on the PHP side to properly call into the correct signature
 *
 * Anatomy of a monkey-patched API:
 *
 *  1. Use %ignore to hide the problematic API
 *  2. Use %extend on the affected class to declare uniquely named "de-overloaded" variations of the API, these just call into
 *     original overload signature
 *  3. Insert a PHP trait implementation that provides the original problematic API that calls into the correct "de-overloaded" method
 *     based on the arguments passed into it
 *  4. A post-processor will then need to insert a trait usage statement into the affected PHP classes. SWIG cannot do this part currently as
 *     it does not provide sufficient augmentation points for generated PHP classes.
 */

%ignore MgConfigurationException::GetExceptionMessage;
%ignore MgResource::Save;
%ignore MgMapBase::Open;
%ignore MgLayerBase::MgLayerBase;

%ignore MgWktReaderWriter::Read;
%extend MgWktReaderWriter 
{
    MgGeometry* _Read_1(STRINGPARAM wkt)
    {
        return $self->Read(wkt, NULL);
    }

    MgGeometry* _Read_2(STRINGPARAM wkt, MgTransform* xform)
    {
        return $self->Read(wkt, xform);
    }
}

%pragma(php) code="
//======================= Begin PHP Traits ==========================//

//Trait that monkey-patches MgWktReaderWriter::Read
trait MgWktReaderWriterPatched {
    public function Read($wkt, $xform = NULL) {
        if ($xform != NULL) {
            return $this->_Read_2($wkt, $xform);
        } else {
            return $this->_Read_1($wkt, $xform);
        }
    }
}

//======================== End PHP Traits ===========================//"