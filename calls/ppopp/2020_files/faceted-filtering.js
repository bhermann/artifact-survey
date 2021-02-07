var facetContexts = []

function enableFacetingContext($elem) {
  var hidableElems, facetPlaceholderElems;
  var fc = {};
  var contextElem;
  var initialFilters = {};

  fc.initFacets = function() {
    if (!contextElem) {
      contextElem = $elem;
    }
    if (!hidableElems) {
      hidableElems = contextElem.find('.hidable');
      facetPlaceholderElems = contextElem.find('.facet-placeholder');
      fc.initSelectionFromUrl()
      fc.updateFacets();
    }
  }

  fc.initSelectionFromUrl = function() {
    var queryString = window.location.search;
    if (queryString.length) {
      facetPlaceholderElems.each(function() {
        var facetType = $(this).data('facet-type');
        var key = encodeURIComponent(facetType);
        var r = new RegExp("(&|\\?)" + key + "=([^\&]*)");
        match = r.exec(queryString);
        if (match != null) {
          hasFiltersInURL = true;
          var val = decodeURIComponent(match[2]);
          var selections = '%%' + val.split('+').join('%%%%') + '%%';
          $(this).attr('data-selected-facets', searchStringUnEscape(selections));
        }
      });
      fc.filterFacets();
    }
  }

  fc.toggleFacet = function(event) {
    var facetValue = event.currentTarget.textContent;
    var facetPlaceholder = $(event.currentTarget).parent('.facet-placeholder');
    fc.doToggleFacet(facetPlaceholder, facetValue);
  }
  fc.doToggleFacet = function(facetPlaceholder, facetValue) {
    var facetType = facetPlaceholder.data('facet-type');
    var currentSel = facetPlaceholder.attr('data-selected-facets');
    var ident = '%%' + facetValue + '%%';
    var isInitToggle = fc.isInitialFilter(facetType, facetValue);
    if (!currentSel) {
      currentSel = ""
    }
    if (currentSel.indexOf(ident) > -1) {
      if (!isInitToggle) { //don't remove filter if this is an initial filter value
        facetPlaceholder.attr('data-selected-facets', currentSel.replace(ident, ''));
      }
    } else {
      var newVal = currentSel + ident;
      facetPlaceholder.attr('data-selected-facets', newVal);
    }
    fc.filterFacets();
    fc.updateFacets();
    if (isInitToggle) {
      fc.removeInitialFilter(facetType, facetValue)
    }
  }

  fc.reloadFacets = function() {
    hidableElems = contextElem.find('.hidable');
    facetPlaceholderElems = contextElem.find('.facet-placeholder');
    updateFacets();
  }
  fc.updateFacets = function() {
    facetPlaceholderElems.each(function() {
      var current = $(this);
      var sel = current.attr('data-selected-facets');
      var hasSel = typeof(sel) !== 'undefined' && sel.length > 0;
      var facetType = current.data('facet-type');
      var dataAttr = 'data-facet-' + facetType;
      var s = fc.facetRetrievalClasses(facetType);

      //scrape all values, prefixed with optional order (contain duplicates)
      var x = contextElem.find(s + ' [' + dataAttr + ']');
      if (s != '*') {
        var parents = contextElem.find(s).parents('[' + dataAttr + ']').addBack('[' + dataAttr + ']');
        x = $.merge(parents, x);
      }
      var valArray = x
        .map(function() {
          return this.getAttribute(dataAttr + '-order') + '%%' + this.getAttribute(dataAttr)
        });
      //sort values and remove order info
      valArraySorted = $(valArray.sort())
        .map(function() {
          return this.replace(/([^%]*%%)?(.*)/, '$2');
        });

      //For already selected facets, assure they get displayed even when they do not exist in the scraped values
      if (hasSel) {
        var x = $(sel.split('%%%%'))
          .map(function() {
            return this.replace(/%%/g, '')
          });
        $.merge(valArraySorted, x);
      }
      var htmlArr = $(unique(valArraySorted)).map(function() {
        if (this.length < 1) {
          return "";
        }
        var ident = '%%' + this + '%%';
        var btnClass = facetButtonClass + ' facet-' + (hasSel && sel.indexOf(ident) > -1);
        return '<div class="' + btnClass + '">' + this + '</div>'
      });
      var html = htmlArr.get().join('');
      if (html.length < 1) {
        html = '<span class="no-facets">Nothing to filter</span>';
      }
      $(this).html(html);
      $(this).children('.facet-true, .facet-false').click(fc.toggleFacet);
    });

    if (typeof postUpdateFacets === "function") {
      postUpdateFacets();
    }
  }
  fc.facetRetrievalClasses = function(facettype) {
    var filtered = facetPlaceholderElems.filter('[data-selected-facets*="%%"][data-facet-type!="' + facettype + '"]');
    var mapped = filtered.map(function() {
      return '.facet-selected-' + $(this).data('facet-type')
    });
    return '*' + mapped.get().join('');
  }


  fc.filterFacets = function() {
    var newSearchString = document.location.search;
    var classSelector = '*';
    facetPlaceholderElems.filter('[data-selected-facets]').each(function() {
      var type = $(this).data('facet-type');
      var dataSelector = 'data-facet-' + type;
      var myRegexp = /%%([^%]+)%%/g;
      var selectedStr = $(this).attr('data-selected-facets');
      match = myRegexp.exec(selectedStr);
      var selectors = [];
      var matches = []
      if (selectedStr.length > 0) {
        while (match != null) {
          if (!fc.isInitialFilter(type, match[1])) {
            matches.push(searchStringEscape(match[1]));
          }
          selectors.push('[' + dataSelector + '="' + match[1].replace('"', '\\"') + '"]');
          match = myRegexp.exec(selectedStr);
        }
      }
      newSearchString = insertParam2(newSearchString, type, matches.join('+'));

      var cl = 'facet-selected-' + type
      hidableElems.removeClass(cl);
      if (selectors.length) {
        var selectorsStr = selectors.join(',');
        var valueHolders = $(selectorsStr);
        valueHolders.closest('.hidable').addClass(cl);
        valueHolders.find('.hidable:not(:has(.hidable))').addClass(cl);
        classSelector += '.' + cl;
      }
    });
    if (newSearchString != document.location.search) {
      var newUrl = window.location.protocol +
        "//" +
        window.location.host +
        window.location.pathname +
        newSearchString +
        window.location.hash;
      history.replaceState(null, document.title + " - filtered", newUrl);
    }
    hidableElems.attr('data-is-visible', false);
    if (classSelector != "*") {
      hidableElems.filter(classSelector).attr('data-is-visible', true)
        .parents('.hidable').attr('data-is-visible', true);
    } else {
      hidableElems.filter(classSelector).attr('data-is-visible', true);
    }
    hidableElems.filter('[data-is-visible!=true]').hide();
    hidableElems.filter('[data-is-visible=true]').show();
  }

  fc.addInitialFilter = function(facetType, facetValue) {
    if (!hasFiltersInURL) {
      initialFilters[filterKey(facetType, facetValue)] = true;
      fc.doToggleFacet(facetPlaceholderElems.filter('[data-facet-type=' + facetType + ']').first(), facetValue);
    }
  }
  fc.removeInitialFilter = function(facetType, facetValue) {
    initialFilters[filterKey(facetType, facetValue)] = false;
  }
  fc.isInitialFilter = function(facetType, facetValue) {
    return initialFilters[filterKey(facetType, facetValue)] === true; //.some(fil => fil.facetType === facetType && fil.facetValue === facetValue));
  }

  return fc;

}



var facetButtonClass = "btn-xs btn btn-default";
var hasFiltersInURL = false;

function initFacets() {
  $('.faceted-filtering').each(function() {
    var fc = enableFacetingContext($(this));
    fc.initFacets()
    facetContexts.push(fc);
  })
}

function reloadFacets() {
  var index, len;
  for (index = 0, len = facetContexts.length; index < len; ++index) {
    facetContexts[index].reloadFacets();
  }
}

function updateFacets() {
  var index, len;
  for (index = 0, len = facetContexts.length; index < len; ++index) {
    facetContexts[index].updateFacets();
  }
}

function addInitialFilter(facetType, facetValue) {
  var index, len;
  for (index = 0, len = facetContexts.length; index < len; ++index) {
    facetContexts[index].addInitialFilter(facetType, facetValue);
  }
}



function unique(array) {
  return $.grep(array, function(el, index) {
    return index === $.inArray(el, array);
  });
}


function searchStringEscape(str) {
  return str.replace("+", "\\plus");
}

function searchStringUnEscape(str) {
  return str.replace("\\plus,", "+");
}


function filterKey(facetType, facetValue) {
  return "filtered-" + facetType + "-" + facetValue;
}


function insertParam2(searchString, key, value) {
  key = encodeURIComponent(key);
  value = encodeURIComponent(value);
  var s = searchString.length ? searchString.substring(1, searchString.length) : "";
  var kvp = value.length ? key + "=" + value : "";
  var r = new RegExp("(^|&)" + key + "=[^\&]*");
  s = kvp.length ? s.replace(r, "$1" + kvp) : s.replace(r, "");
  if (kvp.length && s.indexOf(kvp) < 0) {
    s += (s.length > 0 ? '&' : '') + kvp;
  };

  return "?" + s;
}

$('document').ready(initFacets);