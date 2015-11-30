// --
// Core.Agent.Znuny4OTRSCISearch.js - special functions for Znuny4OTRSCISearch
// Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
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

    TargetNS.Init = function ( CIClasses ) {

        // get default class, if given
        var CISearchLabel = Core.Config.Get('CISearch.Label')            || ' CI Search';
        var DefaultClass  = Core.Config.Get('CISearch.DefaultClassName') || '';

        // ugly but most performant
        var CISearchForm = '<li class="Extended SearchProfile">';
        CISearchForm    += '<form id="CISearch" action="'+ OTRS.Config.Get('Baselink') +'" method="post">';
        CISearchForm    += '<select id="ClassID" name="ClassID" title="Class Selection" style="margin-right: 10px;">';
        CISearchForm    += '<option value="">-</option>';

        $.each(CIClasses, function (Key, Value) {

            var $Selected = '';
            if(Value === DefaultClass) {
                var $Selected = 'selected="selected"';
            }

            CISearchForm += '<option value="'+ Value +'" '+ selected +'>'+ Key +'</option>';
        });

        CISearchForm    += '</select>';
        CISearchForm    += '<input type="text" size="20" name="SearchName" id="SearchName" value="" placeholder="'+CISearchLabel+'" title="'+CISearchLabel+'">';
        CISearchForm    += '<input type="hidden" name="Action" value="AgentITSMConfigItemSearch">';
        CISearchForm    += '<input type="hidden" name="Subaction" value="Search">';
        CISearchForm    += '<input type="hidden" name="SearchDialog" value="1">';
        CISearchForm    += '<input type="hidden" name="EmptySearch" value="">';
        CISearchForm    += '<input type="hidden" name="Profile" value="last-search">';
        CISearchForm    += '<input type="hidden" name="ProfileName" value="">';
        CISearchForm    += '<input type="hidden" name="AttributeOrig" value="Name">';
        CISearchForm    += '<input type="hidden" name="PreviousVersionSearch" value="0">';
        CISearchForm    += '<input type="hidden" name="ResultForm" value="Normal">';
        CISearchForm    += '<input type="hidden" name="Name" id="CIName" value="">';
        CISearchForm    += '</form>';
        CISearchForm    += '</li>';

        $("#ToolBar").append(CISearchForm);

        // get config values for pre and suffix
        var Prefix = Core.Config.Get('CISearch.Prefix') || '';
        var Suffix = Core.Config.Get('CISearch.Suffix') || '';

        // register change event to pass the value from fulltext search box to the hidden name field
        $("#SearchName").on("change paste keyup", function() {
           $("#CIName").val(Prefix + $(this).val() + Suffix);
        });

        $("#CISearch").submit(function( Event ) {

            //Don't submit if no class is selected
            if (
                !$("#CIClassSelection").val()
                $("#CIClassSelection").val().length <= 0
            ){
                Event.preventDefault;
            }
        });

        return true;
    }

    return TargetNS;
}(Core.Agent.Znuny4OTRSCISearch || {}));
