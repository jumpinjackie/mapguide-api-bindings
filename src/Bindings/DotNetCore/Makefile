CPPFLAGS=-g -m64 -fPIC -Wno-write-strings -I$(MG_OEM_ACE_INCLUDE_DIR) -I$(MG_OEM_XERCES_INCLUDE_DIR) -I$(MG_HTTPHANDLER_INCLUDE_DIR) -I$(MG_WEBAPP_INCLUDE_DIR) -I$(MG_WEBSUPPORT_INCLUDE_DIR) -I$(MG_MDFMODEL_INCLUDE_DIR) -I$(MG_FOUNDATION_INCLUDE_DIR) -I$(MG_GEOMETRY_INCLUDE_DIR) -I$(MG_PLATFORMBASE_INCLUDE_DIR) -I$(MG_MAPGUIDECOMMON_INCLUDE_DIR)
LDFLAGS=-g -m64 -fPIC -shared
LDLIBS=-L/usr/local/mapguideopensource-$(MG_VER_FULL)/lib -L/usr/local/mapguideopensource-$(MG_VER_FULL)/webserverextensions/lib -lMgFoundation -lMgGeometry -lMgPlatformBase -lMgMapGuideCommon -lMgHttpHandler -lMgWebApp -lMgWebSupport

all: libMapGuideDotNetCoreUnmanagedApi.so

clean:
	rm -rf libMapGuideDotNetCoreUnmanagedApi.so
	rm -rf *.o
	rm -rf MgApi_wrap.cpp
	@rm -f MapGuideApi.i
	@rm -f MapGuideApi_Doc.i
	@rm -f MapGuideApi_Properties.i

install: libMapGuideDotNetCoreUnmanagedApi.so
	@cp libMapGuideDotNetCoreUnmanagedApi.so /usr/local/mapguideopensource-$(MG_VER_FULL)/webserverextensions/lib

libMapGuideDotNetCoreUnmanagedApi.so: MgApi_wrap.o
	g++ $(LDFLAGS) -o libMapGuideDotNetCoreUnmanagedApi.so MgApi_wrap.o $(LDLIBS)

MgApi_wrap.o: MgApi_wrap.cpp
	g++ $(CPPFLAGS) -c MgApi_wrap.cpp

MgApi_wrap.cpp:
	if [ -f MapGuideApi_Properties.i ]; then rm MapGuideApi_Properties.i; fi;
	../../IMake/Linux/IMake ../MapGuideApi/Constants.xml C# MapGuideDotNetCoreApi/Constants.cs
	cp dotnetcore.i language.i
	../../IMake/Linux/IMake ../MapGuideApi/MapGuideApiGen.xml C#
	$(SWIG_TOOL_PATH)/swig -c++ -csharp -DDOTNETCORE -DSWIG_CSHARP_NO_EXCEPTION_HELPER -DSWIG_CSHARP_NO_STRING_HELPER -DSWIG_CSHARP_NO_WSTRING_HELPER -namespace OSGeo.MapGuide -nodefaultctor -nodefaultdtor -module MapGuideDotNetCoreUnmanagedApi -o MgApi_wrap.cpp -outdir ./MapGuideDotNetCoreApi MapGuideApi.i