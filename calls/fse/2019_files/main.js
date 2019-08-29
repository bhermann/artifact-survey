
var mpl_front = (function ($) {

	$(document).ready(function ($) {

		mpl_front.init($);

	});

	return {
		init: function () {

			//carousel posts
			//$.mpl_owl_carousel();

			mpl_front.carousel();
			mpl_front.isotope();
			mpl_front.skills_circle();
			mpl_front.video_background();
			mpl_front.counter();
			mpl_front.full_height();
			mpl_front.title_font_responsive();
			mpl_front.portfolio();
			mpl_front.contact();
			mpl_front.animate();
			mpl_front.parallax_scrolling();

			$(".site-nav-toggle").click(function () {
				$(".site-nav").animate({
					right: "0"
				});
				$(this).hide();
			})
			$(".site-nav .close").click(function () {
				$(".site-nav").animate({
					right: "-300px"
				});
				$(".site-nav-toggle").show();
			});
			$(".site-nav li.parent a").click(function () {
				$(this).closest("li").children("ul").slideToggle();
			});			
			//prettyPhoto
			$("a[rel^='prettyPhoto']").prettyPhoto();
		},

		refresh: function(selector) {
			if (!selector)
				selector = '';

			mpl_front.full_height(selector);
			mpl_front.title_font_responsive(selector);
			mpl_front.animate(selector);
			mpl_front.carousel(selector);
			mpl_front.isotope(selector);
			mpl_front.video_background(selector);
			mpl_front.skills_circle(selector);
			mpl_front.counter(selector);
			mpl_front.portfolio(selector);
			mpl_front.contact(selector);
			mpl_front.parallax_scrolling(selector);
		},

		//isotope
		isotope: function(selector) {
			if (selector && selector !== '')
				selector += ' .mpl-isotope';
			else 
				selector = '.mpl-isotope';
			
			$(selector).each(function () {
				$(this).isotope({
					itemSelector: '.mpl-isotope-item',
				});
			});
		},

		//skills circle
		skills_circle: function(selector) {
			if (selector && selector !== '')
				selector += ' .mpl-skill-circle';
			else
				selector = '.mpl-skill-circle';

			$(selector).each(function () {
				var barcolor = $(this).data('barcolor');
				if (barcolor == '') {
					barcolor = "#f33b3d";
				}
				$(this).easyPieChart({
					barColor: barcolor,
					trackColor: "#fff",
					scaleColor: false,
					lineCap: 'scale',
					lineWidth: 10,
					animate: 1000,
					size: 110
				});
			});
		},

		//video background
		video_background: function(selector) {
			var youtube_selector = '.mpl-youtube-video',
				vimeo_selector = '.mpl-vimeo-video',
				html5_selector = '.mpl-html5-video';

			if (selector && selector !== '') {
				youtube_selector = selector + " .mpl-youtube-video";
				vimeo_selector = selector + " .mpl-vimeo-video";
				html5_selector = selector + ' .mpl-html5-video';
			}
			if ($(youtube_selector).get(0) !== undefined) {
				$(youtube_selector).on("YTPReady", function (e) {
					$(this).parent().css('background', 'none');
					$(this).parent().find("section").css('background', 'none');
					$(this).parent().find("#video-controls").show();
					$(this).parent().find(".mpl-banner-bgimage").css('background', 'none');
				});
				$(youtube_selector).mb_YTPlayer();
			}
			if ($(vimeo_selector).get(0) !== undefined) {
				$(vimeo_selector).on("VPReady", function (e) {
					$(this).parent().css('background', 'none');
					$(this).parent().find("section").css('background', 'none');
					$(this).parent().find("#video-controls").show();
					$(this).parent().find(".mpl-banner-bgimage").css('background', 'none');
				});
				
				//if ( typeof $(vimeo_selector).vimeo_player == 'function' ) 
				$(vimeo_selector).vimeo_player();
			}
			if ($(html5_selector).get(0) !== undefined) {
				$(html5_selector).on("HVPReady", function (e) {
					$(this).parent().css('background', 'none');
					$(this).parent().find("section").css('background', 'none');
					$(this).parent().find("#video-controls").show();
					$(this).parent().find(".mpl-banner-bgimage").css('background', 'none');
				});
				
			if ( typeof $(html5_selector).html5_video_player == 'function' ) 
				$(html5_selector).html5_video_player();
			}
		},
		
		//counter
		counter: function(selector) {
			if (selector && selector !== '')
				selector += ' .mpl-counter-box';
			else
				selector = '.mpl-counter-box';

			$(selector).each(function () {
				$(this).find('span.mpl-counter-num').counterUp({
					delay: 10,
					time: 1000
				});
			});
		},

		//Full height
		full_height: function(selector) {
			if (selector && selector !== '')
				selector += ' .mpl-fullheight';
			else
				selector = '.mpl-fullheight';

			$(selector).each(function () {
				var fullheight = $(window).height();
				$(this).css('height', fullheight);
			});
		},

		//section title font responsive
		title_font_responsive: function(selector) {
			if (selector && selector !== '')
				selector += ' .mpl-section .section-title,' + selector + ' .mpl-section .section-subtitle';
			else
				selector += '.mpl-section .section-title,.mpl-section .section-subtitle';

			$(selector).each(function () {
				var Fontsize = parseInt($(this).css('font-size'), 10),
					Lineheight = parseInt($(this).css('line-height'), 10);
				if (Fontsize > 0) $(this).attr("data-fontsize", Fontsize);
				if (Lineheight > 0) $(this).attr("data-lineheight", Lineheight);
				fusionCalculateResponsiveTypeValues($(this));
			});

		},
		//section animate
		animate: function(selector) {
			if (selector && selector !== '')
				selector += ' .mpl-animated';
			else
				selector = '.mpl-animated';
				
			if( !$(selector).length )
				return;
				
			if(jQuery().waypoint) {
				$(selector).each(function () {
					$(this).waypoint(function() {

					var el = $(this.element);
					var clazz = el.attr('class'),
						delay = 0,
						speed = '2s',
						timeout = 0;

					if( typeof clazz == 'undefined' )
						return;

					if (clazz.indexOf('mpl-animate-delay-') > -1) {
						delay = clazz.split('mpl-animate-delay-')[1].split(' ')[0];

						el.find(".mpl-section-content").css({
							'animation-delay': delay + 'ms'
						});
						el.removeClass('mpl-animate-delay-' + delay);

						timeout += parseInt(delay, 10);
					}

					if (clazz.indexOf('mpl-animate-speed-') > -1) {
						speed = clazz.split('mpl-animate-speed-')[1].split(' ')[0];

						el.find(".mpl-section-content").css({
							'animation-duration': speed
						});
						el.removeClass('mpl-animate-speed-' + speed);
					}

					if (clazz.indexOf('mpl-animate-eff-') > -1) {
						var eff = clazz.split('mpl-animate-eff-')[1].split(' ')[0];

						timeout += parseFloat(speed) * 1000;

						el.removeClass('mpl-animated');
						el.find(".mpl-section-content").addClass('animated ' + eff);

						setTimeout(function (el, eff) {

							el.removeClass('mpl-animated mpl-animate-eff-' + eff);
							el.find(".mpl-section-content").removeClass('animated ' + eff);
							el.find(".mpl-section-content").css({
								'animation-delay': '',
								'animation-duration': ''
							});
						}, timeout, el, eff);
					}
					}, { triggerOnce: true, offset: '90%' });
				});	
			}
		},

		//carousel
		carousel: function (selector) {
			if (selector && selector !== '')
				selector += ' .mpl-carousel';
			else
				selector = '.mpl-carousel';

			if (typeof $().owlCarousel != 'function')
				return;

			$(selector).each(function (index) {
				var options = $(this).data('owl-options');
				if (typeof options !== 'object')
					return;

				if ($(this).data('loaded') === true) {
					return;
				} else {
					$(this).data({'loaded': true});
				}

				$(this).attr({'data-owl-options': null});

				var _autoplay = ('yes' === options.autoplay) ? true : false,
					_navigation = ('yes' === options.navigation) ? true : false,
					_pagination = ('yes' === options.pagination) ? true : false,
					_speed = (options.speed !== undefined) ? parseInt(options.speed, 10) : 450,
					_items = (options.items !== undefined) ? parseInt(options.items, 10) : 1,
					_tablet = (options.tablet !== undefined) ? parseInt(options.tablet, 10) : 1,
					_mobile = (options.mobile !== undefined) ? parseInt(options.mobile, 10) : 1,
					_autoheight = ('yes' === options.autoheight) ? true : false,
					_showthumb = ('yes' === options.showthumb) ? true : false,
					_singleItem = false;

				if (_autoheight === true) {
					_singleItem = true;
					_items = 1;
				}
				
				$(this).owlCarousel({
					autoplay: _autoplay,
					nav: _navigation,
					dots: _pagination,
					showthumb: _showthumb,
					slideSpeed: _speed,
					paginationSpeed: _speed,
					singleItem: _singleItem,
					autoHeight: _autoheight,
					items: _items,
					loop: true,
					itemsCustom: false,
					lazyLoad: true,
					responsive: {
						0: {
							items: 1,
							dots: true
						},
						768: {
							items: 1,
							dots: true
						},
						992: {
							items: 1,
							dots: true
						},
						1200: {
							items: _items,
							dots: true
						},
					}
				});
			});
		},
		
		//portfolio filter
		portfolio: function(selector) {
			if (selector && selector !== '')
				selector += ' .mpl-portfolio-list-wrap';
			else
				selector = '.mpl-portfolio-list-wrap';

			$(selector).each(function () {
				//init Isotope
				var $portfolio = $(this).isotope({
					itemSelector: '.mpl-portfolio-box-wrap',
				});

				$portfolio.imagesLoaded( function() {
					$portfolio.isotope('layout');
				});
				// bind filter button click
				$(this).prev(".mpl-portfolio-list-filter").on('click', '.mpl-filter', function () {
					 var filterValue = $(this).attr('data-filter');
					  //filterValue = filterValue === '*' ? filterValue : '.' + filterValue;
					  filterValue = '.' + filterValue;
					// use filterFn if matches value
					$portfolio.isotope({
						filter: filterValue
					});
				}).on('click', 'ul>li', function () {
					$(this).addClass('active').siblings().removeClass('active');
				});
			});
		},

		//contact
		contact: function(selector) {
			var submit_selector = 'form.mpl-contact-form #submit',
				info_selector = '.mpl-contact .mpl-contact-info';

			if (selector && selector !== '') {
				submit_selector = selector + ' form.mpl-contact-form #submit';
				info_selector = selector + ' .mpl-contact .mpl-contact-info';
			}

			$(submit_selector).click(function () {
				var form = $(this).parents(".mpl-contact-form");
				form.find(".mpl-contact-failed").text("");
				var receiver = form.find("input#receiver").val();
				var email = form.find("input#email").val();
				var name = form.find("input#name").val();
				var subject = form.find("input#subject").val();
				var message = form.find("textarea#message").val();

				form.find(".mpl-contact-failed").append("<img alt='loading' class='mpl-loading' src='" + mpl_params.plugin_url + "/assets/frontend/images/AjaxLoader.gif' />");

				$.ajax({
					type: "POST",
					dataType: "json",
					url: mpl_params.ajaxurl,
					data: {
						"name": name,
						"email": email,
						"subject": subject,
						"receiver": receiver,
						"message": message,
						"action": "mpl_contact"
					},
					success: function (data) {
						if (data.error == 0) {
							form.find(".mpl-contact-failed").addClass("notice-success");
							form.find(".mpl-contact-failed").html(data.msg);
							$('.loading').remove();
							form[0].reset();
						} else {
							form.find(".mpl-contact-failed").removeClass("notice-success");
							form.find(".mpl-contact-failed").html(data.msg);
						}

						return false;
					}, error: function () {
						form.find(".mpl-contact-failed").html("Error.");
						form.find('.mpl-loading').remove();
						return false;
					}
				});

				return false;
			});

			$(info_selector).each(function () {
				height = $(this).parent().next().height();
				$(this).parent().css("height", height);
			});
		},
		
		//parallax scrolling
		parallax_scrolling:function(selector){
			if( jQuery(window).width() > 919 ){
				if (!selector || selector == ''){
					selector = '.mpl-parallax-scrolling';
					}
				if ($(selector).hasClass('mpl-parallax-scrolling')){
					
					$(selector).parallax("50%", 0.1);
					
					}
				}
			}
	}
}(jQuery));

fusionCalculateResponsiveTypeValues = function (d) {
	var e,
		f,
		g = 0.6,
		h = 1.5,
		i = parseInt(jQuery("body").css("font-size"), 10),
		j = i * h,
		k = 800,
		l = function () {
			var a;
			a = jQuery(window).width() >= k ? 1100 : k,
				e = jQuery(window).width() / a,
				f = 1 - (1 - e) * g,
				jQuery(window).width() <= a ? jQuery(d).each(function () {
					jQuery(this).data("fontsize") * f > j ? jQuery(this).css({
						"font-size": Math.round(jQuery(this).data("fontsize") * f * 1e3) / 1e3,
						"line-height": Math.round(jQuery(this).data("lineheight") * f * 1e3) / 1e3 + "px"
					}) : jQuery(this).data("fontsize") > j && jQuery(this).css({
						"font-size": j,
						"line-height": Math.round(jQuery(this).data("lineheight") * j / jQuery(this).data("fontsize") * 1e3) / 1e3 + "px"
					})
				}) :
				jQuery(d).each(function () {
					jQuery(this).css("font-size", jQuery(this).data("fontsize")),
						jQuery(this).css("line-height", jQuery(this).data("lineheight") + "px")
				})
		};
	l(),
		jQuery(window).on("resize orientationchange", l)
};