From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Tue, 9 Feb 2016 09:55:47 -0500
Message-ID: <20160209145547.GA21623@redhat.com>
References: <20160204135420.GA18227@redhat.com>
	<20160205151334.GA82754@redhat.com>
	<20160205180515.GA25808@redhat.com>
	<20160205191909.GA25982@redhat.com>
	<56B7659C.8040601@dev.mellanox.co.il>
	<56B772D6.2090403@sandisk.com>
	<56B77444.3030106@dev.mellanox.co.il>
	<56B776DE.30101@dev.mellanox.co.il>
	<20160207172055.GA6477@redhat.com> <56B99A49.5050400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56B99A49.5050400@suse.de>
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "keith.busch@intel.com" <keith.busch@intel.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Tue, Feb 09 2016 at  2:50am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/07/2016 06:20 PM, Mike Snitzer wrote:
> > On Sun, Feb 07 2016 at 11:54am -0500,
> > Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> > 
> >>
> >>>> If so, can you check with e.g.
> >>>> perf record -ags -e LLC-load-misses sleep 10 && perf report whether this
> >>>> workload triggers perhaps lock contention ? What you need to look for in
> >>>> the perf output is whether any functions occupy more than 10% CPU time.
> >>>
> >>> I will, thanks for the tip!
> >>
> >> The perf report is very similar to the one that started this effort..
> >>
> >> I'm afraid we'll need to resolve the per-target m->lock in order
> >> to scale with NUMA...
> > 
> > Could be.  Just for testing, you can try the 2 topmost commits I've put
> > here (once applied both __multipath_map and multipath_busy won't have
> > _any_ locking.. again, very much test-only):
> > 
> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel2
> > 
> So, I gave those patches a spin.
> Sad to say, they do _not_ resolve the issue fully.
>
> My testbed (2 paths per LUN, 40 CPUs, 4 cores) yields 505k IOPs with
> those patches.

That isn't a surprise.  We knew the m->lock spinlock contention to be a
problem.  And NUMA makes it even worse.

> Using a single path (without those patches, but still running
> multipath on top of that path) the same testbed yields 550k IOPs.
> Which very much smells like a lock contention ...
> We do get a slight improvement, though; without those patches I
> could only get about 350k IOPs. But still, I would somehow expect 2
> paths to be faster than just one ..

https://www.redhat.com/archives/dm-devel/2016-February/msg00036.html

hint hint...
