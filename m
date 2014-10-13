From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: A patchset to limit the number of outstanding bios
Date: Mon, 13 Oct 2014 16:52:31 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410131643100.11699@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410131113450.3569@file01.intranet.prod.int.rdu2.redhat.com>
	<20141013162026.GA4631@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141013162026.GA4631@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 13 Oct 2014, Mike Snitzer wrote:

> On Mon, Oct 13 2014 at 11:27am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > I'm announcing the release of a patchset that limits the number of 
> > outstanding bios in the device mapper.
> > 
> > The patchset is at 
> > http://people.redhat.com/~mpatocka/patches/kernel/dm-limit-outstanding-bios/
> 
> You should probably just send the patchset to the list (and cc Jens on
> the block changes).
> 
> Patch 1 looks good as is.  But Jens suggested that Patch 2 should hook
> off the on stack plugging rather than adding yet another hook to
> kernel/sched/core.c

I think that adding some generic schedule callbacks because of *two* hooks 
is overengineering. If there were five schedule hooks, it would be 
justified to generalize that.

> And I agree with Joe, we want this DM-only limit to be opt-in per-target
> (so disabled by default).

... if it were opt-in, people will still get out of memory dm-crypt 
crashes (like bug 1010466) or tasks stuck in "D" state for too long time, 
because they don't know that they need to this knob to avoid this problem.

I'd select the default value high enough so that it doesn't degrade any 
benchmarks.

Mikulas

> Mike
