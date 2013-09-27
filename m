From: Frank Mayhar <fmayhar@google.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Fri, 27 Sep 2013 09:27:53 -0700
Message-ID: <1380299273.25252.74.camel@bobble.lax.corp.google.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130926232241.GC31328@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2013-09-27 at 00:22 +0100, Alasdair G Kergon wrote:
> On Thu, Sep 26, 2013 at 10:47:13AM -0700, Frank Mayhar wrote:
> > Launching it from ramdisk won't help, particularly, since it still goes
> > through the block layer.  The other stuff won't help if a (potentially
> > unrelated) bug in the daemon happens to be being tickled at the same
> > time, or if some dependency happens to be broken and _that's_ what's
> > preventing the daemon from making progress.
>  
> Then put more effort into debugging your daemon so it doesn't have
> bugs that make it die?  Implement the timeout in a robust independent
> daemon if it's other code there that's unreliable?

I'm not sure how to respond to this.  Some fifty years of people
programming computers appears to show unequivocally that you can't rely
on code not having bugs no matter _how_ much effort you put into it.
It's just the nature of the beast.

> > And as far as lvm2 and multipath-tools, yeah, they cope okay in the kind
> > of environments most people have, but that's not the kind of environment
> > (or scale) we have to deal with.
> In what way are your requirements so different that a locked-into-memory
> monitoring daemon cannot implement this timeout?

If we could _have_ an independent, locked-into-memory monitoring daemon
just for this purpose, we might be able to get by.  It would still be
iffy, for the reason I mention above; at our scale anything that _can_
fail _will_ fail, at least occasionally and often many times per day.
Unfortunately, that's a non-starter for a number of reasons, including
but not limited to the fact that the environment the daemon is running
in is memory-constrained.  Add to that the fact that the daemon we
actually have depends on stuff that my team has no direct control over
and we end up really needing an in-kernel way to deal with this.
-- 
Frank Mayhar
310-460-4042
