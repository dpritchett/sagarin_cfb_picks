NCAA Football win picker.  Uses [power rankings pulled from Jeff Sagarin / USA Today](http://www.usatoday.com/sports/sagarin/fbt11.htm) to pick winners for ~30 games per week.  Sorts winners by confidence as determined by the projected win margin.

External interface is provided by a sinatra application which receives a "slate" of this week's games and returns a JSON object containing the picks and their respective confidence scores.  End user hooks into the web service via a bookmarklet activated on a Yahoo CFB Pick 'em page.

Copyrights for Sagarin Ratings, USA Today, NCAAF, and Yahoo CFB Pick Em belong to their respective owners.
