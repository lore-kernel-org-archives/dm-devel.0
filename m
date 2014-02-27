From: "Paul B. Henson" <henson@acm.org>
Subject: Re: dm-cache for Fedora 21?
Date: Thu, 27 Feb 2014 14:06:07 -0800
Message-ID: <027301cf3408$1f916a00$5eb43e00$@acm.org>
References: <52D15B93.8000500@rolffokkens.nl>	<20140113101800.GC4984@debian>	<061301cf10a2$b58b37e0$20a1a7a0$@acm.org>	<20140114102148.GC6450@debian>	<52D5C739.1070504@rolffokkens.nl>	<20140115103446.GA7943@debian>	<20140115132133.GA31790@agk-dp.fab.redhat.com>	<084501cf125c$c8fdc840$5af958c0$@acm.org>
	<530FB2DE.3090208@rolffokkens.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <530FB2DE.3090208@rolffokkens.nl>
Content-Language: en-us
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> From: Rolf Fokkens
> Sent: Thursday, February 27, 2014 1:49 PM
>
> For the moment I assume dm-cache is a per LV caching system (since
> nobody confirmed Paul's idea). This leaves me wondering if the cache
> (device) can be shared by multiple LV's. I would really like this, is
> this the case?

I followed up on this question on the lvm development list; they pretty much
confirmed that based on the layering and api of lvm, they did not plan to
support using a dm-cache for a pv or vg, only for an lv.

However, one of the developers did give an interesting suggestion combining
the use of dm-cache and thin provisioning, effectively allowing you to use a
single cache for a number of lv's, as long as they are all allocated out of
the same thin pool:

	
https://www.redhat.com/archives/lvm-devel/2014-February/msg00067.html

This looks interesting, while it's not exactly what I was originally
considering, I think it potentially will achieve the same effective goal. I
could create a single thin pool lv the size of the entire backing pv, and
then create thin lv's out of it for my actual production needs, all of which
would be cached by the single ssd pv.

I'm not very familiar with thin provisioning at this time though, so I
really need to do quite a bit of homework on that to make sure there aren't
going to be any issues problematic for my deployment. And, of course, lvm
support for cache devices is still only available in git head and changing
on an almost daily basis :).

I would be interested in any feedback or thoughts anyone might have on this
proposal and its viability and performance, thanks.
