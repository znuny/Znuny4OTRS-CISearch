// --
// Copyright (C) 2012 Znuny GmbH, https://znuny.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --
// nofilter(TidyAll::Plugin::Znuny::JavaScript::ESLint)
"use strict";

var Core   = Core || {};

Core.Agent = Core.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.ZnunyCISearch
 * @description
 *      This namespace contains the special functions for ZnunyCISearch.
 */
Core.Agent.ZnunyCISearch = (function (TargetNS) {

    TargetNS.Init = function (Param) {

        var ParamCheckSuccess = true;
        $.each([ 'CIClasses' ], function (Index, ParameterName) {
            if (typeof Param[ ParameterName ] === 'undefined') {
                ParamCheckSuccess = false;
            }
        });
        if (!ParamCheckSuccess){
            return false;
        }

        // Create observer to check if InitToolbarOverview ToolbarRefreshTime is running
        var targetNode = document.body;
        var config = { childList: true, subtree: true };

        var callback = function(mutationsList, observer) {
            for(let mutation of mutationsList) {
                if (mutation.type === 'childList' && mutation.target.id === 'ToolBar') {

                    // Elements have changed
                    TargetNS.InitForm(Param);
                }
            }
        };

        var observer = new MutationObserver(callback);
        observer.observe(targetNode, config);

        TargetNS.InitForm(Param);

        return true;
    }

    TargetNS.InitForm = function (Param) {

        if ($('#CISearch').length > 0)return;

        // get default class, if given
        var CISearchLabel = Param.Label        || ' CI Search';
        var DefaultClass  = Param.DefaultClass || '';
        var DefaultClassKey;

        // ugly but most performant

        var CISearchForm = '<div class="component-wrapper component-ci-search">';
        CISearchForm    += '<div class="search-bar-container">';
        CISearchForm    += '<label>'+CISearchLabel+'</label>';
        CISearchForm    += '<form id="CISearch" action="'+ Core.Config.Get('Baselink') +'" method="post" style="width:auto; gap: unset;">';
        CISearchForm    += '<select id="ClassID" name="ClassID" class="Modernize" title="Class Selection">';

        Object.keys(Param.CIClasses)
        .map(function (k) { return [k, Param.CIClasses[k]]; })
        .sort(function (a, b) {
            if (a[1] < b[1]) return -1;
            if (a[1] > b[1]) return 1;
            return 0;
        })
        .forEach(function (d) {
            var Key   = d[0];
            var Value = d[1];

            var Selected = '';
            if(Value === DefaultClass) {
                Selected = 'selected="selected"';

                // get key of DefaultClass
                DefaultClassKey = Key;
            }

            CISearchForm += '<option value="'+ Key +'" '+ Selected +'>'+ Value +'</option>';
        });

        CISearchForm += '</select>';
        CISearchForm += '<input type="text" size="20" name="SearchName" id="SearchName" value="" placeholder="'+CISearchLabel+'" title="'+CISearchLabel+'" style="width:auto;">';
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
        CISearchForm += '</div>';
        CISearchForm += '</div>';

        $('.component-search').after(CISearchForm);

        Core.App.Subscribe('Event.App.Responsive.ScreenXL', function () {

            // resize navigationbar after adding new inputfield
            Core.Agent.ResizeNavigationBar(1);
        });

        // initialising modernize and add margin-right to inputfield
        if (Core.Config.Get('InputFieldsActivated') == 1) {
            Core.UI.InputFields.Activate();
        }
        $("#CISearch > div > div").css("margin-right","10px");

        // get config values for pre and suffix
        var Prefix = Param.Prefix || '';
        var Suffix = Param.Suffix || '';

        // register change event to pass the value from fulltext search box to the hidden name field
        $('#SearchName').on("change paste keyup", function() {
           $('#CIName').val(Prefix + $(this).val() + Suffix);
        });

        // submit function via 'enter'
        $('#CISearch').keypress(function (Event) {
            if (Event.which != 13) return;

            // if no ClassID is selected use default value
            if($("#ClassID").val() === '') {
                $("#ClassID").val(DefaultClassKey);
            }

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

            $('#CISearch').trigger('submit');
        });

        return false;

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
}(Core.Agent.ZnunyCISearch || {}));
