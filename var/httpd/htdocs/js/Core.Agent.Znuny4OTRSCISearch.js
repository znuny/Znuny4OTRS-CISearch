// --
// Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core   = Core || {};

Core.Agent = Core.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Znuny4OTRSCISearch
 * @description
 *      This namespace contains the special functions for Znuny4OTRSCISearch.
 */
Core.Agent.Znuny4OTRSCISearch = (function (TargetNS) {

    TargetNS.Init = function (Param) {

        var ParamCheckSuccess = true;
        $.each([ 'CIClasses' ], function (Index, ParameterName) {
            if (typeof Param[ ParameterName ] === 'undefined') {
                ParamCheckSuccess = false;
                // console.log("ERROR: Parameter '"+ ParameterName +"' is missing in Init call.");
            }
        });
        if (!ParamCheckSuccess){
            return false;
        }

        // get default class, if given
        var CISearchLabel = Param.Label        || ' CI Search';
        var DefaultClass  = Param.DefaultClass || '';

        // ugly but most performant
        var CISearchForm = '<li class="Extended SearchProfile">';
        CISearchForm    += '<form id="CISearch" action="'+ Core.Config.Get('Baselink') +'" method="post">';
        CISearchForm    += '<select id="ClassID" name="ClassID" title="Class Selection" style="margin-right: 10px;">';
        CISearchForm    += '<option value="">-</option>';

        $.each(Param.CIClasses, function (Key, Value) {

            var Selected = '';
            if(Value === DefaultClass) {
                Selected = 'selected="selected"';
            }

            CISearchForm += '<option value="'+ Key +'" '+ Selected +'>'+ Value +'</option>';
        });

        CISearchForm += '</select>';
        CISearchForm += '<input type="text" size="20" name="SearchName" id="SearchName" value="" placeholder="'+CISearchLabel+'" title="'+CISearchLabel+'">';
        CISearchForm += '<input type="hidden" name="Action" value="AgentITSMConfigItemSearch">';
        CISearchForm += '<input type="hidden" name="Subaction" value="Search">';
        CISearchForm += '<input type="hidden" name="SearchDialog" value="1">';
        CISearchForm += '<input type="hidden" name="EmptySearch" value="">';
        CISearchForm += '<input type="hidden" name="Profile" value="last-search">';
        CISearchForm += '<input type="hidden" name="ProfileName" value="">';
        CISearchForm += '<input type="hidden" name="AttributeOrig" value="Name">';
        CISearchForm += '<input type="hidden" name="PreviousVersionSearch" value="0">';
        CISearchForm += '<input type="hidden" name="ResultForm" value="Normal">';
        CISearchForm += '<input type="hidden" name="Name" id="CIName" value="">';

        var SessionInformation = GetSessionInformation();
         $.each(SessionInformation, function (Key, Value) {
            CISearchForm += '<input type="hidden" name="' + Key + '" id="' + Key + '" value="' + Value + '">';
        });

        CISearchForm += '</form>';
        CISearchForm += '</li>';

        $('#ToolBar').append(CISearchForm);
        Core.Agent.ResizeNavigationBar(1);

        // get config values for pre and suffix
        var Prefix = Param.Prefix || '';
        var Suffix = Param.Suffix || '';

        // register change event to pass the value from fulltext search box to the hidden name field
        $('#SearchName').on("change paste keyup", function() {
           $('#CIName').val(Prefix + $(this).val() + Suffix);
        });

        $('#CISearch').submit(function(Event) {

            //Don't submit if no class is selected
            if (
                !$('#ClassID').val()
                || $('#ClassID').val().length <= 0
            ){
                if (Event.preventDefault) {
                    Event.preventDefault();
                }
                else {
                    Event.returnValue = false;
                }
            }
        });

        return true;
    }

    function GetSessionInformation() {
        var Data = {};
        if (!Core.Config.Get('SessionIDCookie')) {
            Data[Core.Config.Get('SessionName')] = Core.Config.Get('SessionID');
            Data[Core.Config.Get('CustomerPanelSessionName')] = Core.Config.Get('SessionID');
        }
        Data.ChallengeToken = Core.Config.Get('ChallengeToken');
        return Data;
    }

    return TargetNS;
}(Core.Agent.Znuny4OTRSCISearch || {}));
