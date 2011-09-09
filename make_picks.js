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
//            console.log(data);
        $.each(matchups, function(i, matchup) { make_pick(matchup); });
                    });
}

make_picks();
