package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class TimerBar extends MovieClip {
		private var loaderSettings:URLLoader = new URLLoader();
		private var settings:XML;
		private var startAllowed:Boolean = true;
		private var currentDate:Date = new Date();
		private var eventStarted:String = "The event started!" 
		
		var daysLeftF:Number;
		var hoursLeftF:Number;
		var minutesLeftF:Number;
		var secondsLeftF:Number;
		
		
		public function TimerBar():void {
			trace("Loaded");
			loadSettings();
			
			
		}
		
		private function loadSettings():void {
			var reqestXML:URLRequest = new URLRequest("http://alexstarov-maps.narod.ru/new_blog/settings.xml");
			loaderSettings.addEventListener(Event.COMPLETE, onSettingsLoaded);
			loaderSettings.load(reqestXML);
		}
		
		private function onSettingsLoaded(e:Event):void {
			trace("XML Loaded");
			settings = new XML(loaderSettings.data);
			setEventName(settings.label);
			countTimeDifference();
			//setDigits();
			//startTimer();
			
		}
		
		private function setEventName(string:String):void {
			if (string.length < 3) {
				string = "The Event Name Too Short! Use loger one";
				startAllowed = false;
			}
			if (string.length > 39) {
				string = "The Event Name Too Long! Use other one";
				startAllowed = false;
			}
			eventName.text = string;
			if (startAllowed == false) trace("StartNotAllowed");
			
		}
		
		private function countTimeDifference():void {
			var targetYear:Number = Number(settings.date.year);
			var targetMonth:Number = Number(settings.date.month);
			var targetDay:Number = Number(settings.date.day);
			var targetHour:Number =  Number(settings.date.hour);
			
			var yearsLeft:Number = 0;
			var monthesLeft:Number = 0;
			var daysLeft:Number = 0;
			var hoursLeft:Number = 0;
			var minutesLeft:Number = 0;
			var secondsLeft:Number = 0;
			
			if (targetYear == NaN || targetYear.toString().length != 4 || currentDate.fullYear > targetYear) {
				startAllowed = false;
				setEventName(eventStarted);
			}else {
				if (targetMonth == NaN || targetMonth.toString().length > 2 || (currentDate.month > targetMonth - 1  && currentDate.fullYear == targetYear )) {
					startAllowed = false;
					setEventName(eventStarted);
				}else {
					if (targetDay == NaN || targetDay.toString().length > 2 || (currentDate.date > targetDay  && currentDate.month == targetMonth - 1 && currentDate.fullYear == targetYear )) {
						startAllowed = false;
						
						setEventName(eventStarted);
					}else {
						if (targetHour == NaN || targetHour.toString().length > 2 || (currentDate.hours > targetHour  && currentDate.date == targetDay )) {
							startAllowed = false;
							setEventName(eventStarted);
						}else {
							// TODO!check 366 days years
							
							var extraDays:Number = 0;
							
							if (targetYear != currentDate.fullYear) {
								yearsLeft = targetYear - currentDate.fullYear;
								for (var i = yearsLeft; i > 1; i-- ) {
									if ((targetYear - i) % 4 == 0) extraDays++;
								}
							}
							
							if (targetMonth != currentDate.month + 1) {
								monthesLeft = targetMonth - (currentDate.month + 1);
								if (monthesLeft < 0) {
									monthesLeft = monthesLeft + 12;
									yearsLeft--;
								}
							}
							
							
							if (targetDay != currentDate.date) {
								daysLeft = targetDay - currentDate.date;
								if (daysLeft < 0) {
									daysLeft = daysLeft + thisMonthLenght(currentDate.month + 1);
									monthesLeft--;
								}
							}
							
							if (targetHour != currentDate.hours) {
								hoursLeft = targetHour - currentDate.hours;
								if (hoursLeft < 0) {
									hoursLeft = hoursLeft + 24;
									daysLeft--;
								}
								
							}
							
							minutesLeft = 60 - currentDate.minutes;
							hoursLeft--;
							
							secondsLeft = 60 - currentDate.seconds;
							minutesLeft--;
							//^^^up to here we count the @naturel@ difference between date we need and date we have^^^
							daysLeft = daysLeft + yearsLeft * 365 + extraDays;
							daysLeft = daysLeft + monthCounter(targetMonth, currentDate.month + 1);
							
							setDigits(daysLeft, hoursLeft, minutesLeft, secondsLeft);
							
						}
					}
				}
			}
			
		}
		
		private function monthCounter(target:Number, current:Number):Number {
			var daysSumm:Number = 0;
			for (var i = 0; i < target - (current + 1); i++ ) {
				trace(i + " vvv")
				daysSumm = daysSumm + thisMonthLenght(current + i);
				trace(thisMonthLenght(current + i));
				trace(daysSumm + " daysSumm");
			}
			return daysSumm;
		}
		
		
		private function thisMonthLenght(requestedMonth:Number):Number {
			var days = 0;
			switch(requestedMonth) {
				case 1:
				return days = 31;
				break;
				
				case 2:
				
				if (currentDate.fullYear%4 == 0) { 
					return days = 29;
					trace("!!!")
				}else {
					return days = 28;
				}
				break;
				
				case 3:
				return days = 31;
				break;
				
				case 4:
				return days = 30;
				break;
				
				case 5:
				return days = 31;
				break;
				
				case 6:
				return days = 30;
				break;
				
				case 7:
				return days = 31;
				break;
				
				case 8:
				return days = 31;
				break;
				
				case 9:
				return days = 30;
				break;
				
				case 10:
				return days = 31;
				break;
				
				case 11:
				return days = 30;
				break;
				
				case 12:
				return days = 31;
				break;
				
			}
			
			return days;
		}
		
		private function setDigits(days:Number, hours:Number, minutes:Number, seconds:Number):void {
			daysLeftF = days;
			hoursLeftF = hours;
			minutesLeftF = minutes;
			secondsLeftF = seconds;
			
			
			var daysToString:String = days.toString();
			var hoursToString:String = hours.toString();
			var minutesToString:String = minutes.toString();
			var secondsToString:String = seconds.toString();
			
			if (days > 999) {
				days1.gotoAndStop(10);
				days2.gotoAndStop(10);
				days3.gotoAndStop(10);
			} else if(days == 0) {
				
			} else {
				if (daysToString.length == 1) {
					days3.gotoAndStop(days + 1);
				}
				if (daysToString.length == 2) {
					days2.gotoAndStop(Number(daysToString.charAt(0)) + 1);
					days3.gotoAndStop(Number(daysToString.charAt(1)) + 1);
				}
				if (daysToString.length == 3) {
					days1.gotoAndStop(Number(daysToString.charAt(0)) + 1);
					days2.gotoAndStop(Number(daysToString.charAt(1)) + 1);
					days3.gotoAndStop(Number(daysToString.charAt(2)) + 1);
				}
				if (daysToString.charAt(daysToString.length - 1) == "1") daysLabel.gotoAndStop(2);
				if (daysToString.charAt(daysToString.length - 1) != "1") daysLabel.gotoAndStop(1);
			}
			
			if (hours == 0) {
				
			}else {
				if (hoursToString.length == 1) {
					hours2.gotoAndStop(hours + 1);
				}else {
					hours1.gotoAndStop(Number(hoursToString.charAt(0)) + 1);
					hours2.gotoAndStop(Number(hoursToString.charAt(1)) + 1);
				}
			}
			
			if (minutes == 0) {
				
			}else {
				if (minutesToString.length == 1) {
					minutes2.gotoAndStop(minutes + 1);
				}else {
					minutes1.gotoAndStop(Number(minutesToString.charAt(0)) + 1);
					minutes2.gotoAndStop(Number(minutesToString.charAt(1)) + 1);
				}
			}
			
			if (seconds == 0) {
				
			}else {
				if (secondsToString.length == 1) {
					seconds2.gotoAndStop(seconds + 1);
				}else {
					seconds1.gotoAndStop(Number(secondsToString.charAt(0)) + 1);
					seconds2.gotoAndStop(Number(secondsToString.charAt(1)) + 1);
				}
			}
			startTimer();
		}
		
		private function startTimer():void {
			var timeTimer:Timer = new Timer(1000);
			timeTimer.addEventListener(TimerEvent.TIMER, updateScreen);
			timeTimer.start();
			
		}
		
		private function updateScreen(e:TimerEvent):void {
			countTimeChange();
			
			//hours1.gotoAndStop();
			//hours2.gotoAndStop();
			//minutes1.gotoAndStop();
			//minutes2.gotoAndStop();
			//seconds1.gotoAndStop();
			//seconds2.gotoAndStop();
		}
		
		private function countTimeChange():void {
			if (secondsLeftF == 0) {
				if (minutesLeftF > 0) {
					secondsLeftF = 60;
					minutesLeftF--;
					secondsLeftF--;
					updateMinutes();
				}else {
					if (hoursLeftF > 0) {
						secondsLeftF = 60;
						minutesLeftF = 60;
						hoursLeftF--;
						minutesLeftF--;
						secondsLeftF--;
						updateHours();
					}else {
						if (daysLeftF > 0) {
							secondsLeftF = 60;
							minutesLeftF = 60;
							hoursLeftF = 24;
							daysLeftF--;
							hoursLeftF--;
							minutesLeftF--;
							secondsLeftF--;
							updateDays();
						}else {
							setEventName(eventStarted + " End");
							//Time is out
						}
					}
				}
			}else {
				secondsLeftF--;
				updateSeconds();
			}
			//trace(daysLeftF + " days " + hoursLeftF + ":" + minutesLeftF  + ":" + secondsLeftF);
		}
		
		private function updateSeconds():void {
			var secondsToString:String = secondsLeftF.toString();
			if (secondsToString.length == 1) {
				seconds1.gotoAndStop(1);
				seconds2.gotoAndStop(secondsLeftF + 1);
			}else {
				seconds1.gotoAndStop(Number(secondsToString.charAt(0)) + 1);
				seconds2.gotoAndStop(Number(secondsToString.charAt(1)) + 1);
			}
		}
		
		private function updateMinutes():void {
			var minutesToString:String = minutesLeftF.toString();
			if (minutesToString.length == 1) {
				minutes1.gotoAndStop(1);
				minutes2.gotoAndStop(minutesLeftF + 1);
			}else {
				minutes1.gotoAndStop(Number(minutesToString.charAt(0)) + 1);
				minutes2.gotoAndStop(Number(minutesToString.charAt(1)) + 1);
			}
			updateSeconds();
		}
		
		private function updateHours():void {
			var hoursToString:String = hoursLeftF.toString();
			if (hoursToString.length == 1) {
				hours1.gotoAndStop(1);
				hours2.gotoAndStop(hoursLeftF + 1);
			}else {
				hours1.gotoAndStop(Number(hoursToString.charAt(0)) + 1);
				hours2.gotoAndStop(Number(hoursToString.charAt(1)) + 1);
			}
			updateMinutes();
		}
		
		private function updateDays():void {
			var daysToString:String = daysLeftF.toString();
			if (daysToString.length == 1) {
				days1.gotoAndStop(1);
				days2.gotoAndStop(daysLeftF + 1);
			}else {
				if(daysToString.length == 2){
					days1.gotoAndStop(Number(daysToString.charAt(0)) + 1);
					days2.gotoAndStop(Number(daysToString.charAt(1)) + 1);
				} else {
					days1.gotoAndStop(Number(daysToString.charAt(0)) + 1);
					days2.gotoAndStop(Number(daysToString.charAt(1)) + 1);
					days3.gotoAndStop(Number(daysToString.charAt(2)) + 1);
				}
			}
			if (daysToString.charAt(daysToString.length - 1) == "1") daysLabel.gotoAndStop(2);
			if (daysToString.charAt(daysToString.length - 1) != "1") daysLabel.gotoAndStop(1);
			updateHours();
		}
	}
}