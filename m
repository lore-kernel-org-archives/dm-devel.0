From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH v2] dm mpath: add a queue_if_no_path
	timeout
Date: Wed, 30 Oct 2013 11:09:25 -0700
Message-ID: <1383156565.17572.8.camel@bobble.lax.corp.google.com>
References: <20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
	<1382036590.1980.32.camel@bobble.lax.corp.google.com>
	<20131017191511.GA30452@redhat.com>
	<1382042759.1980.40.camel@bobble.lax.corp.google.com>
	<20131017211338.GB30993@redhat.com>
	<1382129515.1980.46.camel@bobble.lax.corp.google.com>
	<20131018225350.GB7553@redhat.com> <20131030010246.GA3611@redhat.com>
	<1383145687.6677.49.camel@bobble.lax.corp.google.com>
	<20131030154259.GA8206@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131030154259.GA8206@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, 2013-10-30 at 11:43 -0400, Mike Snitzer wrote:
> On Wed, Oct 30 2013 at 11:08am -0400,
> Frank Mayhar <fmayhar@google.com> wrote:
> 
> > On Tue, 2013-10-29 at 21:02 -0400, Mike Snitzer wrote:
> > > Any interest in this or should I just table it for >= v3.14?
> > 
> > Sorry, I've been busy putting out another fire.  Yes, there's definitely
> > still interest.  I grabbed your revised patch and tested with it.
> > Unfortunately the timeout doesn't actually fire when requests are queued
> > due to queue_if_no_path; IIRC the block request queue timeout logic
> > wasn't triggering.  I planned to look into it more deeply figure out why
> > but I had to spend all last week fixing a nasty race and hadn't gotten
> > back to it yet.
> 
> OK, Hannes, any idea why this might be happening?  The patch in question
> is here: https://patchwork.kernel.org/patch/3070391/

I got to this today and so far the most interesting I see is that the
cloned request that's queued in multipath has no queue associated with
it when it's queued; a printk reveals:

[  517.610042] map_io: queueing rq ffff8801150e0070 q           (null)

When it's eventually dequeued, it gets a queue from the destination
device (in the pgpath) via bdev_get_queue().

Because of this and from just looking at the code, blk_start_request()
(and therefore blk_add_timer()) isn't being called for those requests,
so there's never a chance that the timeout would happen.

Does this make sense?  Or am I totally off-base?
-- 
Frank Mayhar
310-460-4042
