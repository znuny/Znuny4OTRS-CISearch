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
        var ciSearchLabel = Core.Config.Get('CISearch.Label') || ' CI Search';
        var defaultClass = Core.Config.Get('CISearch.DefaultClassName') || '';

        $("#ToolBar").append('<li class="Extended SearchProfile"><form id="CISearch"></form></li>');
        $('#CISearch')
            .attr("action","/wgz/index.pl").attr("method","post")
            .append('<select id="CIClassSelection" name="CIClassSelection" title="Class Selection" style="margin-right: 10px;"></select></li>')
            .append('<input type="hidden" name="Action" value="AgentITSMConfigItemSearch">')
            .append('<input type="hidden" name="Subaction" value="Search">')
            .append('<input type="hidden" name="ClassID" value="" id="ClassID">')
            .append('<input type="hidden" name="SearchDialog" value="1">')
            .append('<input type="hidden" name="EmptySearch" value="">')
            .append('<input type="hidden" name="Profile" value="last-search">')
            .append('<input type="hidden" name="ProfileName" value="">')
            .append('<input type="hidden" name="AttributeOrig" value="Name">')
            .append('<input type="hidden" name="PreviousVersionSearch" value="0">')
            .append('<input type="hidden" name="ResultForm" value="Normal">')
            .append('<input type="hidden" name="Name" id="CIName" value="">')
            .append('<input type="text" size="20" name="SearchName" id="SearchName" value="" placeholder="'+ciSearchLabel+'" title="'+ciSearchLabel+'">')

        // populate the class dropdown and select the default class
        $('#CIClassSelection').append($('<option>').text('-').attr('value', '-'));
        $.each(CIClasses, function (key, value) {
            if(value === defaultClass){
             $('#CIClassSelection').append($('<option>').text(value).attr('value', key).attr('selected', 'selected'));
            }else{
             $('#CIClassSelection').append($('<option>').text(value).attr('value', key));
            }
        });

        // get config values for pre and suffix
        var prefix = Core.Config.Get('CISearch.Prefix')||'';
        var suffix = Core.Config.Get('CISearch.Suffix')||'';
        // register change event to pass the value from fulltext search box to the hidden name field
        $("#SearchName").on("change paste keyup", function() {
           $("#CIName").val(prefix+$(this).val()+suffix)
        });

        // set classid from select box to the hidden classid text field
        $( "#CISearch" ).submit(function( event ) {

            //Don't submit if no class is selected
            if ($("#CIClassSelection").val()==='-'){
                event.preventDefault;
            }

          $("#ClassID").val($("#CIClassSelection").val());
        });



        return true;
    }

    return TargetNS;
}(Core.Agent.Znuny4OTRSCISearch || {}));
