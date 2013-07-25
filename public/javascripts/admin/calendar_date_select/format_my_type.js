// my type Format: 2010/1/31 5:00 pm
// by xzh
Date.prototype.toFormattedString = function(include_time){
  str = this.getFullYear() + '-' + Date.padded2(this.getMonth() + 1) + '-' +Date.padded2(this.getDate());

  if (include_time) { hour=this.getHours(); str += " " + this.getAMPMHour() + ":" + this.getPaddedMinutes() + " " + this.getAMPM() }
  return str;
}

Date.parseFormattedString = function (string) {
  /*var regexp = '([0-9]{4})-(([0-9]{1,2})-(([0-9]{1,2})( ([0-9]{1,2}):([0-9]{2})? *)?)?)?';
  var d = string.match(new RegExp(regexp, "i"));
  if (d==null) {
    return Date.parse(string); // Give javascript a chance to parse it.
  }
  mdy = d[1].split('-');
  hrs = 0;
  mts = 0;
  if(d[3] != null) {
    hrs = parseInt(d[3].split('')[0], 10);
    if(d[5].toLowerCase() == 'pm') { hrs += 12; } // Add 12 more to hrs
    mts = d[4].split(':')[1];
  }
  // console.log(mdy)
  select_date = new Date(mdy[0], parseInt(mdy[1], 10)-1, mdy[2]);
  // console.log(select_date.stripTime())
  return select_date;*/
  var regexp = '([0-9]{4})-(([0-9]{1,2})-(([0-9]{1,2})( ([0-9]{1,2}):([0-9]{2})? *)?)?)?';
 var d = string.match(new RegExp(regexp, "i"));
 if (d==null) return Date.parse(string); // at least give javascript a crack at it.
 var offset = 0;
 var date = new Date(d[1], 0, 1);
 if (d[3]) { date.setMonth(d[3] - 1); }
 if (d[5]) { date.setDate(d[5]); }
 if (d[7]) {
   date.setHours(parseInt(d[7], 10));    
 }
 if (d[8]) { date.setMinutes(d[8]); }
 if (d[10]) { date.setSeconds(d[10]); }
 return date;
}


//Date.padded2 = function(hour) { padded2 = hour.toString(); if ((parseInt(hour) < 10) || (parseInt(hour) == null)) padded2="0" + padded2; return padded2; }
//Date.prototype.getAMPMHour = function() { hour=Date.padded2(this.getHours()); return (hour == null) ? 00 : (hour > 24 ? hour - 24 : hour ) }
//Date.prototype.getAMPM = function() { return (this.getHours() < 12) ? "" : ""; }
//
//Date.prototype.toFormattedString = function(include_time){
////  str = this.getDate() + "." + (this.getMonth() + 1) + "." + this.getFullYear();
//  str = this.getFullYear() + "." + (this.getMonth() + 1) + "." + this.getDate();
//  if (include_time) { hour=this.getHours(); str += " " + this.getAMPMHour() + ":" + this.getPaddedMinutes() }
//  return str;
//}
//Date.parseFormattedString = function (string) {
//  var regexp = '([0-9]{1,2})\.(([0-9]{1,2})\.(([0-9]{2,4})( ([0-9]{1,2}):([0-9]{2})? *)?)?)?';
//  var d = string.match(new RegExp(regexp, "i"));
//  if (d==null) return Date.parse(string); // at least give javascript a crack at it.
//  var offset = 0;
//  if (d[5] && d[5].length == 2) {
//    // we got only two digits for the year...
//    d[5] = Number(d[5]);
//    if (d[5] > 30)
//      d[5] += 1900;
//    else
//      d[5] += 2000;
//  }
//  var date = new Date(d[5], 0, 1);
//  if (d[3]) { date.setMonth(d[3] - 1); }
//  if (d[5]) { date.setDate(d[1]); }
//  if (d[7]) {
//    date.setHours(parseInt(d[7], 10));    
//  }
//  if (d[8]) { date.setMinutes(d[8]); }
//  if (d[10]) { date.setSeconds(d[10]); }
//  return date;
//}
