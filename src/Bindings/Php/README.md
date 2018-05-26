# PHP wrapper notes

This document describes the PHP language binding for the MapGuide API

# Supported PHP version

This binding targets PHP 7.2.6, the current PHP version in the 7.2 series

# Differences from the official PHP binding

 * Usage
   * You will need to include `MapGuideApi.php` to access the MapGuide API. This will load the MapGuide PHP extension on-demand.
 * API
   * `MgInitializeWebTier` is now `MapGuideApi.MgInitializeWebTier`