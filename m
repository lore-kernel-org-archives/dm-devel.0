From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Sun, 7 Feb 2016 12:20:56 -0500
Message-ID: <20160207172055.GA6477@redhat.com>
References: <20160203182423.GA12913@redhat.com> <56B2F5BC.1010700@suse.de>
	<20160204135420.GA18227@redhat.com>
	<20160205151334.GA82754@redhat.com>
	<20160205180515.GA25808@redhat.com>
	<20160205191909.GA25982@redhat.com>
	<56B7659C.8040601@dev.mellanox.co.il>
	<56B772D6.2090403@sandisk.com>
	<56B77444.3030106@dev.mellanox.co.il>
	<56B776DE.30101@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56B776DE.30101@dev.mellanox.co.il>
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

On Sun, Feb 07 2016 at 11:54am -0500,
Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:

> 
> >>If so, can you check with e.g.
> >>perf record -ags -e LLC-load-misses sleep 10 && perf report whether this
> >>workload triggers perhaps lock contention ? What you need to look for in
> >>the perf output is whether any functions occupy more than 10% CPU time.
> >
> >I will, thanks for the tip!
> 
> The perf report is very similar to the one that started this effort..
> 
> I'm afraid we'll need to resolve the per-target m->lock in order
> to scale with NUMA...

Could be.  Just for testing, you can try the 2 topmost commits I've put
here (once applied both __multipath_map and multipath_busy won't have
_any_ locking.. again, very much test-only):

http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel2
