## Table of Contents

* [Description](#Description)
* [Requirements](#Requirements)
* [Pre Configuration](#Pre-Configuration)
* [Limitations](#Limitations)
* [Error Messages](#Errors)
* [Revision History](#Revision-History)

<a name="Description"></a>
## Description
The library mappCfg allows you to read and write mapp configuration from the PLC during runtime. To use the library in your project, add the [dependencies](#Requirements) and import the library from the sample project.

![image](https://user-images.githubusercontent.com/2972703/147233085-25b92c7d-92ae-4741-a929-c457c7f1f531.png)

### Inputs
| Name | Description |
|---|---|
| MpLink | mapp Link of the mapp configuration |
| Enable | The function block is active as long as this input is set |
| ReadWrite | Input selects read (MpCfgRead) or write (MpCfgWrite) operation |
| ErrorReset | Resets funtion block errors |
| ParaName | [Parameter name that is used with read or write operation](#ParameterName) |
| ParaValue | New value used with write operation |
| GroupArray | [If parameter name (ParaName) is not unique the group array is used to identify the correct parameter](#GroupName) |

### Outputs
| Name | Description |
|---|---|
| Active | Function block is active |
| Error | Error occurred during execution |
| StatusID | [Status information](#Errors) |
| CommandDone | Function block is finished |
| DataType | Data type of the parameter |
| Value | Result from read operation |
| Info | Internal function block structure |

<a name="ParameterName"></a>
### How to find the parameter name
The parameter name is not directly visible in Automation Studio. To find the internal name go to the mapp configuration, right click on the file and select open. Use a text editor to show the XML content of the configuration.

![image](https://user-images.githubusercontent.com/2972703/147235309-60d255fc-218d-4620-996d-df7663b72fa1.png)

Look for the property name next to the value and use this text as parameter name. This is all the information that is needed if the parameter name only exists once in the configuration file. [Use the group list array to identfy not unique parameters.](#GroupName)

![image](https://user-images.githubusercontent.com/2972703/147235654-93c8bec2-609f-412c-9af6-b3fa91105046.png)

<a name="GroupName"></a>
### How to find the group name array list
In some cases the parameter name is not unique and exist multiple times in the configuration file. The group array can be used to identify these parameters. In the following example we want change the value 'product_name' in the 'RecipeSave' query.

![image](https://user-images.githubusercontent.com/2972703/147236731-f5b186ee-214a-45bf-a100-778e82ac2de0.png)

The easiest way to generate the group list is to work your way backwards in the configuration file. First we have to find the value that we want to read or write (red arrow). Then we work our way back to the top of the configuration and write down the group name (green arrow) every time we move up one level.

![image](https://user-images.githubusercontent.com/2972703/147236884-38f3483b-cb57-4c0f-a6bd-21881acd397f.png)

The corresponding group array list would then look like this
```
GroupArray.Item[0] := 'mapp.Database.Core';
GroupArray.Item[1] := 'DBQueries';
GroupArray.Item[2] := '[1]';
GroupArray.Item[3] := 'Where';
GroupArray.Item[4] := '[0]';
```
<a name="Requirements"></a>
## Requirements
The library was developed and tested with the following versions. Older versions may work as well.

* Automation Studio 4.9
* Automation Runtime D4.90
* Library dependencies, MpCom, MpBase, FileIO, AsBrStr

Recommended task class is #8 with a 10ms cycle time.

<a name="Limitations"></a>
## Limitations
* The library can only write existing parameters. It is not possible to create additional parameters or groups.

<a name="Pre-Configuration"></a>
## Pre-Configuration
The library uses several constants to define internal buffers and paraemter name length. In some cases it can be neccessary to adjust the values in MpCfg->Constans.var

| Constant | Default | Text |
|---|---|---|
| MpCfgMaxBufferSize | 20000 | Maximum size of the configuration file |
| MpCfgMaxNameSize | 200 | Maximum length of the parameter name |
| MpCfgMaxValueSize | 200 | Maximum length of the value information |

<a name="Errors"></a>
## Error messages
The library generates the following list of error messages. All other error numbers are generated from included libraries that can be found in the Automation Studio help.

| No | Constant | Text | Solution
|---|---|---|---|
| 10001 | MpCfgBufferSizeExceeded | Configuration file is larger than MpCfgMaxBufferSize | Increase value of MpCfgMaxBufferSize |
| 10002 | MpCfgDataTypeSizeExceeded | Data type information is larger than MpCfgMaxNameSize | Increase value of MpCfgMaxNameSize |
| 10002 | MpCfgValueSizeExceeded | Value length is larger than MpCfgMaxNameSize | Increase value of MpCfgMaxNameSize |
| 1001x | MpCfgGroupNotFoundx | Group name does not exist | Check group array data at index x |
| 10020 | MpCfgParaNotFound | Parameter name does not exist in configuration | Double check parameter name |
| 10021 | MpCfgTypeNotFound | Data type information was not found | Shouldnt happen but just in case it does |
| 10022 | MpCfgValueNotFound | Value information was not found | Shouldnt happen but just in case it does |
| 10030 | MpCfgParaNameEmpty | Parameter name is empty | |
| 10031 | MpCfgMpLinkEmpty | mapp Link is missing | |

<a name="Revision-History"></a>
## Revision History

#### Version 1.0
First public release
