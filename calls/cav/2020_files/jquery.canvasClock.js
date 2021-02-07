/*
 * jquery.canvasClock.js : jQuery plugin to display graphical clock using canvas
 *
 * Copyright (c) 2013 HarishLabs
 * Licensed under the MIT license.
 * http://opensource.org/licenses/MIT
 *
 * Author: Harish Premkumar
 * Date: 20th Dec 2013
 *
 * Reference: http://www.dhtmlgoodies.com/tutorials/canvas-clock/
 */

(function ( $ ) {
  $.fn.canvasClock = function( options ) {
    var settings = $.extend({
      showSecondHand: true,
      showMinuteHand: true,
      showHourHand: true,
      bgImgUrl: 'clock-face1.png',
      time_zone: 'Europe/London',
      city_name: '',
      date_format: 24,
      digital_clock: false,
      lang: 'en-US',
      lang_for_date: 'ua',
      show_days: false
    }, options );

    var degreesToRadians = function(degrees) {
      return (Math.PI / 180) * degrees
    };

    var drawHand = function(context, size, thickness, shadowOffset) {
      thickness = thickness || 4;

      context.shadowColor = '#555';
      context.shadowBlur = 5;
      context.shadowOffsetX = shadowOffset;
      context.shadowOffsetY = shadowOffset;

      context.beginPath();
      context.moveTo(0,0); // center
      context.lineTo(thickness *-1, -10);
      context.lineTo(0, size * -1);
      context.lineTo(thickness,-10);
      context.lineTo(0,0);

      context.fill();
    };

    var drawHourHand = function(context, theDate, time_zone){

      var hours = theDate.getHours() + theDate.getMinutes() / 60;

      var bias = ( parseInt( theDate.getMinutes() * 100 / 60 ) ) / 100;

      if( time_zone !== undefined) {        

        hours = theDate.toLocaleString([], {timeZone: time_zone, hour: '2-digit' });

        bias = ( parseInt( theDate.toLocaleString([], { timeZone: time_zone, minute: '2-digit' } ) * 100 / 60 ) ) / 100;;

      }
      
      var degrees = ( ( parseInt( hours ) + bias ) * 360 / 12) % 360;

      context.save();
      context.fillStyle = 'black';
      context.rotate(degreesToRadians(degrees));
      drawHand(context, 28, 4, 5);
      context.restore();
    };

    var drawMinuteHand = function(context, theDate, time_zone){

      var minutes = theDate.getMinutes() + theDate.getSeconds() / 60;

      if( time_zone !== undefined) {

        minutes = theDate.toLocaleString([], {timeZone: time_zone, minute: '2-digit' });

      }

      // console.log( minutes );

      context.save();
      context.fillStyle = 'black';
      context.rotate(degreesToRadians(minutes * 6));
      drawHand(context, 42, 3, 3);
      context.restore();
    };

    var drawSecondHand = function(context, theDate, time_zone){
      context.save();
      context.fillStyle = 'red';
      var seconds = theDate.getSeconds();

      if( time_zone !== undefined) {

        var clock_obj = {
          timeZone: time_zone,
          second: '2-digit'
        }

        seconds = theDate.toLocaleString( [], clock_obj );

      }

      // console.log( seconds );

      context.rotate( degreesToRadians(seconds * 6));
      drawHand(context, 42, 2, 4);

      // Draw filled circle at the center
      context.moveTo(0,0); // center
      context.arc(0,0,5,0,2*Math.PI);
      context.fill();

      context.restore();
    };

    var addBackgroundImage = function(canvas, context, clockImage) {
      context.drawImage(clockImage, canvas.width/2 * -1, canvas.height/2 * -1, canvas.width, canvas.height);
    };

    var writeBrandName = function(context, brandName) {
      context.font = "20pt Helvetica";
      var brandNameSize = context.measureText(brandName);
      context.strokeText(brandName, 0 - brandNameSize.width / 2, -20);
    };

    var show_time = function( _this, time_zone, date_format, show_seconds ) {

      $( _this ).find( '.mx-current-time' ).remove();

      var element_date = $( '<div class="mx-current-time" />' );

      var date = new Date();

      var clock_obj = {
        timeZone: time_zone,
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      };

      if( show_seconds === false ) {

        clock_obj = {
          timeZone: time_zone,
          hour: '2-digit',
          minute: '2-digit'
        };

      }

      element_date.text( date.toLocaleString('uk', clock_obj ) );

      if( parseInt( date_format ) === 12 ) {

        clock_obj = {
          hour12: true,
          timeZone: time_zone,
          hour: '2-digit',
          minute: '2-digit',
          second: '2-digit'
        };

        if( show_seconds === false ) {

          clock_obj = {
            hour12: true,
            timeZone: time_zone,
            hour: '2-digit',
            minute: '2-digit'
          };

        }

        element_date.text( date.toLocaleString( 'en-US', clock_obj ) );

      }

      return element_date;

    };

    var mx_first_setter_up = function( string ) {

        return string.charAt(0).toUpperCase() + string.slice(1);

    };

    var mx_show_time_zone = function( _this, time_zone, city_name ) {

      $( _this ).find( '.mx-time-zone' ).remove();

      var element_date = $( '<div class="mx-time-zone" />' );

      var regex = /.*\/(.*)/gi;

      var match = regex.exec(time_zone);

      var time_zone_name = String( match[1] ).replace('_', ' ');

      if( city_name !== '' ) {

        time_zone_name = city_name;

      }   

      element_date.text( time_zone_name );

      return element_date;

    };

    // show days
    var mx_show_days = function( _this, time_zone, city_name, lang_for_date, date_format ) {

      var date = new Date();

      $( _this ).find( '.mx-elem-days' ).remove();

      var element_days = $( '<div class="mx-elem-days" />' );

      // weekday
      var weekday = date.toLocaleString(lang_for_date, {timeZone: time_zone, weekday: 'long' } );

      // month
      var month = date.toLocaleString(lang_for_date, {timeZone: time_zone, month: 'long' } );

      // day
      var day = date.toLocaleString(lang_for_date, {timeZone: time_zone, day: 'numeric' } );

      // year
      var year = date.toLocaleString(lang_for_date, {timeZone: time_zone, year: 'numeric' } );

      // weeks
      weekday = mx_first_setter_up( weekday );

      month = mx_first_setter_up( month ); 

      element_days.text( weekday + ', ' + month + ' ' + day + ', ' + year );     

      $( _this ).append( element_days );

    };

    // create colck
    var create_digital_clock = function( _this, time_zone, date_format, city_name, lang, lang_for_date, show_days, show_seconds ) {

      var date = new Date();

      _this.empty();

      var element_time_zone = $( '<div class="mx-elem-time_zone" />' );

      var element_time = $( '<div class="mx-elem-time" />' );

      var element_days = $( '<div class="mx-elem-days" />' );

      // weekday
      var weekday = date.toLocaleString(lang_for_date, {timeZone: time_zone, weekday: 'long' } );

      // month
      var month = date.toLocaleString(lang_for_date, {timeZone: time_zone, month: 'long' } );

      // day
      var day = date.toLocaleString(lang_for_date, {timeZone: time_zone, day: 'numeric' } );

      // year
      var year = date.toLocaleString(lang_for_date, {timeZone: time_zone, year: 'numeric' } );

      var clock_obj = {};

      if( parseInt( date_format ) === 24 ) {

        // show_seconds        
        clock_obj = {
          timeZone: time_zone,
          hour: '2-digit',
          minute: '2-digit',
          second: '2-digit'
        }

        if( show_seconds === false) {

          clock_obj = {
            timeZone: time_zone,
            hour: '2-digit',
            minute: '2-digit'
          }
          
        }

        element_time.text( date.toLocaleString( 'uk', clock_obj ) );

      } else {

        clock_obj = {
          hour12: true,
          timeZone: time_zone,
          hour: '2-digit',
          minute: '2-digit',
          second: '2-digit'
        };

        if( show_seconds === false) {

          clock_obj = {
            hour12: true,
            timeZone: time_zone,
            hour: '2-digit',
            minute: '2-digit'
          };

        }

        element_time.text( date.toLocaleString( 'en', clock_obj ) );

      }
     
      // weeks
      weekday = mx_first_setter_up( weekday );

      month = mx_first_setter_up( month );

      if( show_days === 'true' ) {

        element_days.text( weekday + ', ' + month + ' ' + day + ', ' + year );

      }            

      // time zone
      var regex = /.*\/(.*)/gi;

      var match = regex.exec( time_zone );

      var time_zone_name = String( match[1] ).replace('_', ' ');

      if( city_name !== '' ) {

        time_zone_name = city_name;

      }   

      element_time_zone.text( time_zone_name );

      // time zone      
      _this.append( element_time_zone );

      // create clock
      _this.append( element_time );

      // create months\weekday\days
      _this.append( element_days );

    };

    return this.each(function() {

      var _this = $(this);

      var canvasClock = $.extend($.extend({}, settings), $(this).data());

      if( Boolean( canvasClock.digital_clock ) ) {

        canvasClock.digital_clock = true;

      } else {

        canvasClock.digital_clock = false;

      }

      // create canvas
      if( canvasClock.digital_clock !== true ) {
      
        var clockImage = new Image();

        clockImage.src = canvasClock.bgImgUrl;

        canvasClock.canvas = $("<canvas />")[0];
        clockImage.onload = function() {
          canvasClock.canvas.setAttribute('width', clockImage.width);
          canvasClock.canvas.setAttribute('height', clockImage.height);
          canvasClock.context = canvasClock.canvas.getContext('2d');
          canvasClock.context.translate(canvasClock.canvas.width/2, canvasClock.canvas.height/2);

          window.setInterval( function() {
            var theDate = new Date();
          
            canvasClock.context.clearRect(-canvasClock.canvas.width/2, -canvasClock.canvas.height/2, canvasClock.canvas.width, canvasClock.canvas.height);
            addBackgroundImage(canvasClock.canvas, canvasClock.context, clockImage);

            if(canvasClock.brandName)
              writeBrandName(canvasClock.context, canvasClock.brandName);

            if(canvasClock.showHourHand)
              drawHourHand(canvasClock.context, theDate, canvasClock.time_zone);

            if(canvasClock.showMinuteHand)
              drawMinuteHand(canvasClock.context, theDate, canvasClock.time_zone);

            if(canvasClock.showSecondHand)
              drawSecondHand(canvasClock.context, theDate, canvasClock.time_zone);

            _this.append(show_time(_this, canvasClock.time_zone, canvasClock.date_format, canvasClock.showSecondHand));

            _this.append(mx_show_time_zone(_this, canvasClock.time_zone, canvasClock.city_name));

            // show days
            if( canvasClock.show_days === 'true' ) {

              _this.append(mx_show_days(_this, canvasClock.time_zone, canvasClock.city_name, canvasClock.lang_for_date, canvasClock.date_format));

            }
           
          }, 1000);
        }

        $( _this ).append(canvasClock.canvas);
        $( _this ).data().canvasClock = canvasClock;

      } else {

        window.setInterval( function() {

          create_digital_clock(
            _this,
            canvasClock.time_zone,
            canvasClock.date_format,
            canvasClock.city_name,
            canvasClock.lang,
            canvasClock.lang_for_date,
            canvasClock.show_days,
            canvasClock.showSecondHand // seconds arrow
          );

        },1000 );

      }
      
    });

  };
}( jQuery ));
