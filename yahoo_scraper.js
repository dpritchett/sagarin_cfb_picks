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

  str = str.replace(/@|\(\d+\)/gi, '')
  return str
}

parse_game = function (game) {
  results = new Object
  results.favorite = $(".favorite a", game).text().expand_text()
  results.underdog = $(".underdog a", game).text().expand_text()
  results.host = $("td :contains('@')", game).text().expand_text()

  if(results.favorite === results.host) {
    results.visitor = results.underdog;
  }
  else {
    results.visitor = results.favorite;
  }

  return results.visitor + '@' + results.host
}

output = ''

$(games).each(function(i, el) { output += parse_game(el) + '\n' } )
