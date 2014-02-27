From: "Paul B. Henson" <henson@acm.org>
Subject: Re: dm-cache for Fedora 21?
Date: Thu, 27 Feb 2014 14:10:23 -0800
Message-ID: <027401cf3408$b88b66c0$29a23440$@acm.org>
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
> nobody confirmed Paul's idea).

Oh, just to clarify, dm-cache itself can be used to cache a pv, sitting
between the raw device and lvm; it's just that lvm will not support setting
that up, you would have to do that directly with dmsetup... I posted an
inquiry on that topic back in December:

https://www.redhat.com/archives/dm-devel/2013-December/msg00038.html

It was pretty much confirmed that it would work, it would just be a rather
manual process.
