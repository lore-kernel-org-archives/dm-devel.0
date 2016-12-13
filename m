From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] dm: Avoid sleeping while holding the dm_bufio lock
Date: Tue, 13 Dec 2016 14:01:40 -0800
Message-ID: <CAD=FV=WJN8DaY5NAFwMvO7rfir9BJ38OxKJtG5Q3W8TCg_sNPg@mail.gmail.com>
References: <1479410660-31408-1-git-send-email-dianders@chromium.org>
 <alpine.LRH.2.02.1611231543020.31481@file01.intranet.prod.int.rdu2.redhat.com>
 <CAD=FV=V85=ZTXURVZ3Xo1gS80rqA8gOhr+Xm47axrwVUpjQFuw@mail.gmail.com>
 <alpine.LRH.2.02.1612081758250.25149@file01.intranet.prod.int.rdu2.redhat.com>
 <CAD=FV=U+1VA23s1WMn4srH5U3Cjuz+0OLhq1qD5qw0oTE34xFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD=FV=U+1VA23s1WMn4srH5U3Cjuz+0OLhq1qD5qw0oTE34xFQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Sonny Rao <sonnyrao@chromium.org>, Guenter Roeck <linux@roeck-us.net>
List-Id: dm-devel.ids

Hi,

On Mon, Dec 12, 2016 at 4:08 PM, Doug Anderson <dianders@chromium.org> wrote:
> OK, so I just put a printk in wait_iff_congested() and it didn't show
> me waiting for the timeout (!).  I know that I saw
> wait_iff_congested() in the originally reproduction of this problem,
> but it appears that in my little "balloon" reproduction it's not
> actually involved...
>
>
> ...I dug further and it appears that __alloc_pages_direct_reclaim() is
> actually what's slow.  Specifically it looks as if shrink_zone() can
> actually take quite a while.  As I've said, I'm not an expert on the
> memory manager but I'm not convinced that it's wrong for the direct
> reclaim path to be pretty slow at times, especially when I'm putting
> an abnormally high amount of stress on it.
>
> I'm going to take this as further evidence that the patch being
> discussed in this thread is a good one (AKA don't hold the dm bufio
> lock while allocating memory).  :)  If it's unexpected that
> shrink_zone() might take several seconds when under extreme memory
> pressure then I can do some additional digging.  Do note that I am
> running with "zram" and remember that I'm on an ancient 4.4-based
> kernel, so perhaps one of those two factors causes problems.

Sadly, I couldn't get this go as just "the way things were" in case
there was some major speedup to be had here.  :-P

I tracked this down to shrink_list() taking 1 ms per call (perhaps
because I have HZ=1000?) and in shrink_lruvec() the outer loop ran
many thousands of times.  Thus the total time taken by shrink_lruvec()
could easily be many seconds.

Wow, interesting, when I change HZ to 100 instead of 1000 then the
behavior changes quite a bit.  I can still get my bufio lock warning
easily, but all of a sudden shrink_lruvec() isn't slow.  :-P

OK, really truly going to stop digging further now...  ;)  Presumably
reporting weird behaviors with old kernels doesn't help anyone in
mainline, and I can buy the whole "memory accesses are slow when you
start thrashing the system" argument.

-Doug
