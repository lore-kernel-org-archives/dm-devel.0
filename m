From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Mon, 8 Feb 2016 09:34:00 -0500
Message-ID: <20160208143359.GA12132@redhat.com>
References: <20160204135420.GA18227@redhat.com>
	<20160205151334.GA82754@redhat.com>
	<20160205180515.GA25808@redhat.com>
	<20160205191909.GA25982@redhat.com>
	<56B7659C.8040601@dev.mellanox.co.il>
	<56B772D6.2090403@sandisk.com>
	<56B77444.3030106@dev.mellanox.co.il>
	<56B776DE.30101@dev.mellanox.co.il>
	<20160207172055.GA6477@redhat.com>
	<56B88867.4060308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56B88867.4060308@dev.mellanox.co.il>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Mon, Feb 08 2016 at  7:21am -0500,
Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:

> 
> >>The perf report is very similar to the one that started this effort..
> >>
> >>I'm afraid we'll need to resolve the per-target m->lock in order
> >>to scale with NUMA...
> >
> >Could be.  Just for testing, you can try the 2 topmost commits I've put
> >here (once applied both __multipath_map and multipath_busy won't have
> >_any_ locking.. again, very much test-only):
> >
> >http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel2
> 
> Hi Mike,
> 
> So I still don't see the IOPs scale like I expected. With these two
> patches applied I see ~670K IOPs while the perf output is different
> and does not indicate a clear lock contention.

Right, perf (with default events) isn't the right tool to track this down.

But I'm seeing something that speaks to you not running with the first
context switching fix (which seems odd):

> -   2.07%      ksoftirqd/6  [kernel.kallsyms]        [k]
> blk_mq_run_hw_queues
>    - blk_mq_run_hw_queues
>       - 99.70% rq_completed
>            dm_done
>            dm_softirq_done
>            blk_done_softirq
>          + __do_softirq

As you can see here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=a5b835282422ec41991c1dbdb88daa4af7d166d2

rq_completed() shouldn't be calling blk_mq_run_hw_queues() with the
latest code.

Please triple check you have the latest code, e.g.:
git diff snitzer/devel2
