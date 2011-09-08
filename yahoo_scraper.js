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
  results.home_underdog = false

  output = results.visitor + ':' + results.host 
  

  if(results.favorite !== results.host) {
    output += ':+'
  }

  return output
}

output = ''

$(games).each(function(i, el) { output += parse_game(el) + '\n' } )
