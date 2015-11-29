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
            .append('<input type="text" size="20" name="SearchName" id="SearchName" value="" placeholder="CI Suche" title="CISuche">')

        // populate the class dropdown
        $('#CIClassSelection').append($('<option>').text('-').attr('value', '-'));
        $.each(CIClasses, function (key, value) {
             $('#CIClassSelection').append($('<option>').text(value).attr('value', key));
        });

        // register change event to pass the value from fulltext search box to the hidden name field
        $("#SearchName").on("change paste keyup", function() {
           $("#CIName").val('*'+$(this).val()+'*')
        });

        // set classid from select box to the hidden classid text field
        $( "#CISearch" ).submit(function( event ) {
          $("#ClassID").val($("#CIClassSelection").val());
        });



        return true;
    }

    return TargetNS;
}(Core.Agent.Znuny4OTRSCISearch || {}));
