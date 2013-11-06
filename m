From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH v3] dm mpath: add a queue_if_no_path
 timeout
Date: Wed, 06 Nov 2013 07:43:59 -0800
Message-ID: <1383752639.4504.23.camel@bobble.lax.corp.google.com>
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
	<1383156565.17572.8.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EDC2C1@BPXM12GP.gisp.nec.co.jp>
	<1383229011.17572.12.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EE0B3F@BPXM12GP.gisp.nec.co.jp>
	<11AF7C027C4C02408624617A49860784EE0F5E@BPXM12GP.gisp.nec.co.jp>
	<1383664708.4504.4.camel@bobble.lax.corp.google.com>
	<1383667332.4504.8.camel@bobble.lax.corp.google.com>
	<5279E79C.8010509@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5279E79C.8010509@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mike@redhat.com, Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, 2013-11-06 at 07:54 +0100, Hannes Reinecke wrote:
> On 11/05/2013 05:02 PM, Frank Mayhar wrote:
> > This is the patch submitted by Jun'ichi Nomura, originally based on
> > Mike's patch with some small changes by me.  Jun'ichi's description
> > follows, along with my changes:
> > 
> > On Tue, 2013-11-05 at 07:18 -0800, Frank Mayhar wrote:
> >> On Fri, 2013-11-01 at 04:17 +0000, Junichi Nomura wrote:
> >>> I slightly modified the patch:
> >>>   - fixed the timeout handler to correctly find
> >>>     clone request and "struct multipath"
> >>>   - the timeout handler just disables "queue_if_no_path"
> >>>     instead of killing the request directly
> >>>   - "dmsetup status" to show the parameter
> >>>   - changed an interface between dm core and target
> >>>   - added some debugging printk (you can remove them)
> >>> and checked the timeout occurs, at least.
> >>>
> >>> I'm not sure if this feature is good or not though.
> >>> (The timer behavior is not intuitive, I think)
> >> Thanks!  I integrated your new patch and tested it.  Sure enough, it
> >> seems to work.  I've made a few tweaks (added a module tunable and
> >> support for setting the timer in multipath_message(), removed your debug
> >> printks) and will submit the modified patch for discussion shortly.
> > 
> > Comments?
> > 
> Yeah. Seems to be my eternal fate; initiating fixes and not getting
> mentioned at all.
> Sigh.
> 
> I dimly remember having sent the original patch for the blk timeout
> function ... hence a short notice would've been nice.

Sorry, I did ding you early on (and I think Mike dinged you as well),
but you were apparently busy with other things at the time.

I also sent email last Thursday, quoted below:


On Wed, 2013-10-30 at 11:43 -0400, Mike Snitzer wrote:
> On Wed, Oct 30 2013 at 11:08am -0400,
> Frank Mayhar <fmayhar@google.com> wrote:
> 
> > On Tue, 2013-10-29 at 21:02 -0400, Mike Snitzer wrote:
> > > Any interest in this or should I just table it for >= v3.14?
> > 
> > Sorry, I've been busy putting out another fire.  Yes, there's
definitely
> > still interest.  I grabbed your revised patch and tested with it.
> > Unfortunately the timeout doesn't actually fire when requests are
queued
> > due to queue_if_no_path; IIRC the block request queue timeout logic
> > wasn't triggering.  I planned to look into it more deeply figure out
why
> > but I had to spend all last week fixing a nasty race and hadn't
gotten
> > back to it yet.
> 
> OK, Hannes, any idea why this might be happening?  The patch in
question
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
