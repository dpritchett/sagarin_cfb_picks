/*

   Intended to be used on a Yahoo College FB Pick 'Em selection screen
   after jQuery has been loaded to the page via bookmarklet.
   */

games = $(".matchup")

String.prototype.expand_text = function() {
  str = this.replace(" (OH)", "-Ohio")
    str = str.replace(" (FL)", "-Florida")
    str = str.replace("Coll.", "College")
    str = str.replace("St.", "State")
    str = str.replace(/^LA /, "Louisiana-")
    str = str.replace('USC', "Southern California")
    str = str.replace('UCF', "Central Florida")
    str = str.replace('Ill.', "Illinois")
    str = str.replace('Sou.', "Southern")
    str = str.replace('Cent.', "Central")
    str = str.replace('W.', "Western")
    str = str.replace('N.C.', "NC")

    str = str.replace(/@|\(\d+\)/gi, '')
    return str
}

parse_game = function (game) {
  results = new Object
    results.favorite = $(".favorite a", game).text().expand_text()
    results.underdog = $(".underdog a", game).text().expand_text()
    results.host = $("td :contains('@')", game).text().expand_text()
    results.home_underdog = false

    output = results.favorite + ':' + results.underdog + ':'

    if(results.favorite !== results.host) {
      output += '+'
    }

  return output
}

output = ''

$(games).each(function(i, el) { output += parse_game(el) + '\n' } )

pick_em = function() {
  var picks;
  var matchups = $(".matchup");

  make_pick = function(matchup) {
    var this_pick = picks.shift();
    if(!this_pick.upset){
      $(".favorite-win input:first", matchup).prop("checked", true);
    }
    else{
      $(".underdog-win input:first", matchup).prop("checked", true);
    }

    $("select", matchup).val(this_pick.confidence);

    return this_pick.confidence;
  }

  make_picks = function() {
    $.getJSON('http://dpritchett.xen.prgmr.com:8000/?callback=?', {data: output},function(data) {
        picks = data;
        $.each(matchups, function(i, matchup) { make_pick(matchup); }); });
  }
  make_picks();
}

pick_em();
