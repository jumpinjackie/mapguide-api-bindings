<?php

//This file is just to test any arbitrary API without going through the whole suite
require_once("master.php");

echo "Initializing web tier";
try {
    MgInitializeWebTier("C:\\Program Files\\OSGeo\\MapGuide\\Web\\www\\webconfig.ini");
    echo "[php]: Initialized\n";
    $user = new MgUserInformation("Anonymous", "");
    $conn = new MgSiteConnection();
    $conn->Open($user);
    // Create a session repository
    $site = $conn->GetSite();
    $sessionID = $site->CreateSession();
    echo "[php]: Created session: $sessionID\n";
    $user->SetMgSessionId($sessionID);
    // Get an instance of the required services.
    $resourceService = $conn->CreateService(MgServiceType::ResourceService);
    echo "[php]: Created Resource Service\n";
    $mappingService = $conn->CreateService(MgServiceType::MappingService);
    echo "[php]: Created Mapping Service\n";
    $resId = new MgResourceIdentifier("Library://UnitTest/");
    echo "[php]: Enumeratin'\n";
    $resources = $resourceService->EnumerateResources($resId, -1, "");
    echo $resources->ToString() . "\n";
    echo "[php]: Coordinate System\n";
    $csFactory = new MgCoordinateSystemFactory();
    echo "[php]: CS Catalog\n";
    $catalog = $csFactory->GetCatalog();
    echo "[php]: Category Dictionary\n";
    $catDict = $catalog->GetCategoryDictionary();
    echo "[php]: CS Dictionary\n";
    $csDict = $catalog->GetCoordinateSystemDictionary();
    echo "[php]: Datum Dictionary\n";
    $datumDict = $catalog->GetDatumDictionary();
    echo "[php]: Coordinate System - LL84\n";
    $cs1 = $csFactory->CreateFromCode("LL84");
    echo "[php]: Coordinate System - WGS84.PseudoMercator\n";
    $cs2 = $csFactory->CreateFromCode("WGS84.PseudoMercator");
    echo "[php]: Make xform\n";
    $xform = $csFactory->GetTransform($cs1, $cs2);
    echo "[php]: WKT Reader\n";
    $wktRw = new MgWktReaderWriter();
    echo "[php]: WKT Point\n";
    $pt = $wktRw->Read("POINT (1 2)");
    $coord = $pt->GetCoordinate();
    echo "[php]: X: ".$coord->GetX().", Y: ".$coord->GetY()."\n";
    $site->DestroySession($sessionID);
    echo "[php]: Destroyed session $sessionID";
    echo "[php]: Test byte reader\n";
    $bs = new MgByteSource("abcd1234", 8);
    $content = "";
    $br = $bs->GetReader();
    $buf = "";
    while ($br->Read($buf, 2) > 0) {
        echo "Buffer: $buf\n";
        $content .= $buf;
    }
    $agfRw = new MgAgfReaderWriter();
    echo "[php]: Trigger an exception\n";
    $agfRw->Read(NULL);
} catch (MgException $ex) {
    echo "[php]: MgException\n";
    echo "[php]: MgException - Message: ".$ex->GetExceptionMessage()."\n";
    echo "[php]: MgException - Details: ".$ex->GetDetails()."\n";
    echo "[php]: MgException - Stack: ".$ex->GetStackTrace()."\n";
} catch (Exception $ex) {
    echo "[php]: Exception: " . $ex->getMessage() . "\n";
}

?>