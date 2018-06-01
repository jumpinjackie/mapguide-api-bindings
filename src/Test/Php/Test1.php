<?php

//This file is just to test any arbitrary API without going through the whole suite
require_once("master.php");

echo "Initializing web tier";
try {
    MgInitializeWebTier("C:\\Program Files\\OSGeo\\MapGuide\\Web\\www\\webconfig.ini");
    echo "Initialized\n";
    $user = new MgUserInformation("Anonymous", "");
    $conn = new MgSiteConnection();
    $conn->Open($user);
    // Create a session repository
    $site = $conn->GetSite();
    $sessionID = $site->CreateSession();
    echo "Created session: $sessionID\n";
    $user->SetMgSessionId($sessionID);
    // Get an instance of the required services.
    $resourceService = $conn->CreateService(MgServiceType::ResourceService);
    echo "Created Resource Service\n";
    $mappingService = $conn->CreateService(MgServiceType::MappingService);
    echo "Created Mapping Service\n";
    var_dump($resourceService);
    var_dump($mappingService);
} catch (MgException $ex) {
    echo "ERROR: " . $ex->GetExceptionMessage();
}

?>