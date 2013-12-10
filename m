From: "Paul B. Henson" <henson@acm.org>
Subject: Re: dm-cache questions
Date: Tue, 10 Dec 2013 13:04:58 -0800
Message-ID: <0a9401cef5eb$7e32a110$7a97e330$@acm.org>
References: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
	<20131210095019.GB32555@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131210095019.GB32555@debian>
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

> From: Joe Thornber
> Sent: Tuesday, December 10, 2013 1:50 AM
>
> I've just found a serious bug that causes metadata space to be used up
> too quickly.  So hold off until I get a patch together later this week.

Ouch. Life on the bleeding edge ;). Do fixes like this get backported to
3.10LTS, or just to the latest mainline/stable kernel? One nice thing about
dm-cache is that it layers transparently on top of your origin device, so it
can be dropped in at any time. I've been kind of stalled moving forward
waiting to sort out caching, but I think I can go ahead and get everything
set up and then just drop dm-cache in on top of it later. I guess the other
side of that coin is you have to be careful to make sure nothing accesses
the origin device directly rather than through the cache once it's set up,
as that would be a sure recipe for corruption...

> The metadata is stored in btrees, damaging a high level node in this
> btree can lose an awful lot of mappings.  So I recommend mirroring it.

If the metadata device is an SSD, does there end up being a lot of write
amplifications due to the small updates being made to the metadata?

> spindle.  Your volume manage (eg, LVM2) should be doing this
> transparently for you.

Any idea when dm-cache support is going to show up in lvm2? Reviewing the
last few months of mailing list traffic on that list, I don't see any
mention of it. I found a message dating back to March 2013 that said "within
a few months", but perhaps that was optimistic :). Do you think lvm2 would
recognize and be able to manage a "handmade" dm-cache once it is released,
or would you need to clean out the cache, remove it, and then re-create it
with lvm2?

> Personally I'd use linear, since it allows you to resize easily.

After looking at it again, it is simpler than it appeared on first
impression.

> Use the normal suspend, reload, resume cycle.

Ah, ok, I thought suspend removed the device, but it just freezes I/O and
pauses applications until you bring it back.

> dm-cache both passes down trim messages, and keeps track of discarded
> origin blocks in it's metadata to avoid redundant io on
promotion/demotion.

So if your origin device supports trim, it will see them, but what about the
cache device, which is only being used by dm-cache? Does dm-cache
occasionally trim the cache device to free unused blocks?

> No problem, yell if you need more help.

Cool, thanks much.
