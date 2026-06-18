<!-- Type your summary here -->
# feature

This class manages feature enablement and disablement in 4D code.

## Definitions

* **version** `Integer` is the version number in 4D format (for example, 1980 for 19R8 or 1904 for 19.4).
* **feature** `Text` is the feature flag name (you can also use an `Integer` to reference a Redmine or Azure feature number).

## Constructor

> **cs**.feature.new (version : `Integer` {; file : `4D.File`})

* The class constructor must be called with at least a `version` parameter, which is the current branch version number.

```4d
var $feature : cs.feature
$feature:=cs.feature.new(1980)
```

* The second optional parameter is a `file` containing local directives to enable or disable one or more features for development or testing purposes.

```4d
var $feature : cs.feature
$feature:=cs.feature.new(1980; Folder(fk user preferences folder).file("4d.mobile"))
```

## <a name="define">Defining a feature flag</a>

|Function|Action|
|--------|------|   
|.**unstable** ( `feature` ) | Store a feature as unstable (enabled when component version ≥ 4D version)
|.**delivered** ( `feature` ; `version` ) | Store a feature as delivered for the given version
|.**debug** ( `feature` ) | Store a feature as debug (available only in dev mode / Matrix database)
|.**wip** ( `feature` ) | Alias of **debug**
|.**main** ( `feature` ) | Store a feature as available only in the main branch (Alpha)
|.**pending** ( `feature` ) | Store a feature as pending (not available)
|.**dev** ( `feature` ; user : `Text` \| `Collection` ) | Store a feature as available only for a specific system user
|.**alias** ( name : `Text` ; `feature` ) | Store an alias value for a feature (copy at declaration time)

## <a name="testing">Testing a feature flag</a>

|Function|Action|
|--------|------|   
|.**with** ( `feature` ) | Returns True if the feature is enabled
|.**enabled** ( `feature` ) | Alias of **with**
|.**disabled** ( `feature` ) | Returns True if the feature is NOT enabled

## <a name="tools">Tools</a>

|Function|Action|
|--------|------|   
|.**loadLocal** () | Overrides feature activation with local preferences, if any. See [below](#localPreferences).
|.**log** ( logger : `4D.Function`) | Logs the status (enabled/disabled) of all declared features<br>using the database logging function passed as a formula.

## <a name="localPreferences">Format of the local preferences file</a>

The preference file is a JSON object with a `features` collection.

Each item in `features` must define:

* `id` (Integer) or `name` (Text)
* `enabled` as either a Boolean or a conditions object

Example:

```json
{
	"features": [
		{
			"name": "theFeature",
			"enabled": true
		},
		{
			"id": 129953,
			"enabled": false
		},
		{
			"name": "mac64Feature",
			"enabled": {
				"version": 1980,
				"bitness": 64,
				"os": 2
			}
		}
	]
}
```

When `enabled` is an object, all keys must match for the feature to be enabled.

|key|Value|Action|
|--------|------|------|
| **os** | 1 = Windows, 2 = macOS | Activation only on the designated OS |
| **matrix** | Any value | Activation if code runs in the matrix database |
| **debug** | True \| False | Interpreted mode if **True**, compiled mode if **False** |
| **bitness** | 32 \| 64 | Legacy condition. Kept for backward compatibility; modern 4D versions are 64-bit only. |
| **version** | `Integer` | Activation if current 4D version is ≥ value |
| **type** | `Integer` | Activation if Application type equals value |

Notes:

* Unknown keys trigger an `ASSERT`.
* If both `id` and `name` are present, `id` is used.
* Integer feature ids are internally stored with a leading underscore.
* `bitness` is effectively obsolete for current 4D releases (64-bit only).

## Examples

### Delivery strategy

When preparing a release without some in-progress features:

* Remove the related declaration line(s) from your feature declarations.
* Or keep the declaration and mark it as pending with `.pending(...)`.

If you use Git branches, feature declarations should follow the branch lifecycle:

* Production branch: do not declare in-progress features.
* Development branches: declare and test in-progress features.

### Declaration of flags

```4d
// Create the class for the 19R8 version of the component and with a local file
Feature:=cs.feature.new(1980; Folder(fk user preferences folder).file("4d.mobile"))

// Mark:R6
Feature.delivered("alias"; 1960)  // [MOBILE] Use aliases
Feature.delivered("androidDataSet"; 1960)  // [ANDROID] Data set

// Mark:R7
Feature.unstable("openURLAction")  // azure:3625 [MOBILE] Execute an action that opens a web area

// Mark:-🚧 MAIN
Feature.main("inputControlArchive")  // azure:5424 The mobile project shall support a zip format for input control with Android and iOS.

// Mark:-🚧 WIP
Feature.wip("DataSourceClass")  // Work with DataSource class to test the data source

// Mark:-👴🏻 Vincent
Feature.dev("vdl"; New collection("vdelachaux"; "Vincent de LACHAUX"))

// Mark:-⛔ PENDING
Feature.pending(129953)  // [MOBILE] Handle Many-one-Many relations

// Mark:-→ Local preferences
Feature.loadLocal()

// Mark:-→ Alias
Feature.alias("many-one-many"; 129953)

// Important: alias copies the current value of the original feature
// at this moment. Declare aliases after the original state is set.

// Logs the status (enabled/disabled) of all features
Logger:=cs.logger.new()
Feature.log(Formula(Logger.log($1)))

SET ASSERT ENABLED(Feature.with("debug"); *)
```

### Usage in the code

```4d
Function showFormatOnDisk
	
	If (Feature.with("inputControlArchive"))  //🚧
		
		var $format : Text
		var $item : Object
		var $file : 4D.File
		var $folder : 4D.Folder
		
		$format:=Delete string(This.current.format; 1; 1)
		$folder:=This.path.hostInputControls()
		
		For each ($item; $folder.folders().combine($folder.files().query("extension = :1"; SHARED.archiveExtension)))
			
			$folder:=This._source($item)
			$file:=$folder.file("manifest.json")
			
			If ($file.exists)
				
				If (JSON Parse($file.getText()).name=$format)
					
					SHOW ON DISK($item.platformPath)
					break
					
				End if 
			End if 
		End for each 
		
	Else 
		
		SHOW ON DISK(This.sourceFolder(Delete string(This.current.format; 1; 1)).platformPath)
		
	End if
```

