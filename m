From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm: zoned block device fixes
Date: Thu, 1 Jun 2017 20:36:18 -0400
Message-ID: <20170602003617.GB25647@redhat.com>
References: <20170529102307.19814-1-damien.lemoal@wdc.com>
	<20170530202031.GA52190@redhat.com>
	<46ec84af-0700-70f9-f990-d87a63cc18b0@wdc.com>
	<20170531143910.GA16671@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170531143910.GA16671@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 31 2017 at 10:39am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> FYI: my review of dm-zoned will be focused on DM target correctness
> (suspend/resume quirks, no allocations in the IO path that aren't backed
> by a mempool, coding style nits, etc).  I don't know enough about zoned
> block devices to weigh-in on those details.  Ultimately I'll be
> deferring to you, others on your team, and others in the community that
> are more invested in zoned block devices to steer and stabilize this
> target.
> 
> Anyway, hopefully my review will be fairly quick and I can get dm-zoned
> staged for 4.13 by end of day tomorrow.

I made a go of it but I'm getting hung up on quite a lot of code that
doesn't conform to, what I'd like to think is, the cleaner nature of how
DM targets that are split across multiple files should be.

You basically slammed everything into 'struct dmz_target' and passed dmz
everywhere.  I tried to split out a 'struct dmz_metadata' (and got quite
far!) but finally gave up because affecting that churn was killing me
slowly.  Anyway, here is where I left off:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-zoned

In hindsight, maybe I should've just responded with the laundry list of
things I saw so that you could fix them.  But if you see changes that
you like in that branch feel free to pull them in to a new version of
dm-zoned that you resubmit.

As for splitting out a 'struct dmz_metadata'.. I'd really prefer _some_
separation but there is little point with doing so if we're going to
just half-ass it and add in a back-pointer to the 'struct dmz_target' to
access certain members.  I was left unhappy with my attempt.. again, was
a shit-show of churn.

I think this target needs a more critical eye on the various places IO
is being submitted and where allocations are occuring.  I allowed myself
to get hung up on code movement when I should've focused on more
constructive design choices you made.

Mike
