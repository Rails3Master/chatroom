// DB No Seconds Format: 2007-12-05 12:00

Date.padded2 = function(hour) { padded2 = hour.toString(); if ((parseInt(hour) < 10) || (parseInt(hour) == null)) padded2="0" + padded2; return padded2; }
Date.prototype.getAMPMHour = function() { hour=Date.padded2(this.getHours()); return (hour == null) ? 00 : (hour > 24 ? hour - 24 : hour ) }
Date.prototype.getAMPM = function() { return (this.getHours() < 12) ? "" : ""; }

Date.prototype.toFormattedString = function(include_time){
//  by wll 把日期格式2009-2-03改为2009-05-06
  var m = "0"
  if((this.getMonth() + 1) < 10){
  	m = m + (this.getMonth() + 1);
  }else{
  	m = this.getMonth() + 1;
  }
  
  str = this.getFullYear() + "-" + m + "-" + Date.padded2(this.getDate());
  if (include_time) { hour=this.getHours(); str += " " + this.getAMPMHour() + ":" + this.getPaddedMinutes() }
  return str;
}

Date.parseFormattedString = function (string) {
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
