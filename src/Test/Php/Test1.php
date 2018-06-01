<?php

//This file is just to test any arbitrary API without going through the whole suite

echo "Initializing web tier";
try {
    MgInitializeWebTier("C:\\Program Files\\OSGeo\\MapGuide\\Web\\www\\webconfig.ini");
    echo "Initialized";
} catch (MgException $ex) {
    echo "ERROR: " . $ex->GetExceptionMessage();
}

?>