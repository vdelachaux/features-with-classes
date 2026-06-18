//%attributes = {}
$feature:=cs:C1710.feature.new(2000)

$feature.unstable("DATA_EXPLORER")  // Display data explorer in the main toolbar (https://4dimension.visualstudio.com/4D/_workitems/edit/4387)

// MARK:-🫣 MAIN
$feature.main("designUserPreferences")

// [Package Manager] Graphic UI - https://github.com/orgs/4d/projects/298
$feature.main("packageManager")
$feature.dev("packageManagerAdd"; "vdl")
$feature.dev("packageManagerLocal"; "vdl")
$feature.dev("packageManagerDistant"; "vdl")
$feature.dev("packageManagerRemove"; "vdl")