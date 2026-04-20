// =============================================================================
// KFPS Hengsten Platform — Shared Mare Configuration
// Used by merrie-toevoegen.html and merrie-detail.html
// =============================================================================

var MARE_CONFIG = (function() {

  var PREDICATES = [
    'Ster', 'Kroon', 'Model', 'Preferent', 'Prestatie', 'Sport', 'Elite'
  ];

  var SCORE_SOURCES = [
    { value: 'kfps',         label: 'KFPS Officieel' },
    { value: 'eigen_meting', label: 'Eigen meting'   },
    { value: 'keuring',      label: 'Keuring'        }
  ];

  var SCORE_CATEGORIES = {
    exterieur: {
      label: 'Exterieur',
      min: 0, max: 100,
      categories: [
        'Rastype',
        'Bouw',
        'Beenwerk',
        'Stap',
        'Draf'
      ]
    },
    sport: {
      label: 'Sport aanleg',
      min: 0, max: 100,
      categories: [
        'Aanleg dressuur',
        'Aanleg mennen',
        'Aanleg tuig'
      ]
    },
    lineair: {
      label: 'Lineair',
      min: 1, max: 9,
      categories: [
        'Hoofd',
        'Hals',
        'Schoft',
        'Bovenlijn',
        'Croupe',
        'Voorbeen',
        'Achterbeen',
        'Hoefstand'
      ]
    }
  };

  function sourceLabel(value) {
    var match = SCORE_SOURCES.find(function(s) { return s.value === value; });
    return match ? match.label : value;
  }

  return {
    PREDICATES: PREDICATES,
    SCORE_SOURCES: SCORE_SOURCES,
    SCORE_CATEGORIES: SCORE_CATEGORIES,
    sourceLabel: sourceLabel
  };

})();
