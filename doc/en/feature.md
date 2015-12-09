# Toolbar CI Suche

A default OTRS setup does not allow you to search for configuration items with an inmput field in the toolbar.
This addon adds such an input field and enables you to search for CIs. Choose the CI class where to search from a select field and enter a search term into the input field. Both fields are avaiable in all views of the agent interface.

## SysConfig settings

There are three SysConfig settings available:

### Znuny4OTRSCISearch::SearchParams###Prefix

This SysConfig defines an optional prefix which is used for every search.

### Znuny4OTRSCISearch::SearchParams###Suffix

This SysConfig defines an optional suffix which is used for every search.

### Znuny4OTRSCISearch::SearchParams###DefaultClassName

Defines a default CI class where to search.

Hint: CI class names can be translated by OTRS!
