$(document).ready(function () {

    $('.deadline-past')
        .wrapInner('<span style="color: #474747;">')
        .wrapInner('<span style="color: #940004;text-decoration:line-through">')
        .after('<b>, Deadline is Past!</b>');

    $('.postponed')
        .wrapInner('<span style="color: #474747;">')
        .wrapInner('<span style="color: #940004;text-decoration:line-through">')
        .after('<b>, Postponed!</b>');

    $(function () {

        if ($(".sidebar")[0]) {
            var $sidebar = $(".sidebar"),
                $window = $(window),
                offset = $sidebar.offset(),
                sHeight = $sidebar.height(),
                topPadding = 40,
                containerHeight = $("div.container").height();
            $window.scroll(function () {
                if ($window.scrollTop() > offset.top) {
                    $sidebar.stop().animate({
                        marginTop: Math.min($window.scrollTop() - offset.top + topPadding, containerHeight - sHeight - topPadding)
                    });
                } else {
                    $sidebar.stop().animate({
                        marginTop: 0
                    });
                }
            });
        }

    });

    $(function () {
        $('a[href*=#]:not([href=#])').click(function () {
            if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
                var target = $(this.hash);
                target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
                if (target.length) {
                    $('html,body').animate({
                        scrollTop: target.offset().top
                    }, 1000);
                    return false;
                }
            }
        });
        $('a[href=#]').click(function () {
            if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {

                $('html,body').animate({
                    scrollTop: 0
                }, 1000);
                return false;
            }
        });
    });

    $(function () {
        var header = $("#nav");
        $(window).scroll(function () {
            var scroll = $(window).scrollTop();
            if (scroll >= 98) {
                header.addClass('affix');
            } else {
                header.removeClass("affix");
            }
        });
    });
});

function toDate(day) {
    var dayArray = day.split("-");
    return new Date(dayArray[0], dayArray[1] - 1, dayArray[2]);
}

function toDateString(day) {
    var monthNames = [
        "January", "February", "March",
        "April", "May", "June", "July",
        "August", "September", "October",
        "November", "December"
    ];
    var date = toDate(day);
    return monthNames[date.getMonth()] + " " + date.getDate();
}