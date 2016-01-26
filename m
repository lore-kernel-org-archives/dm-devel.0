From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Tue, 26 Jan 2016 11:03:24 -0500
Message-ID: <20160126160324.GA24665@redhat.com>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com>
	<20160125214016.GA10060@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160125214016.GA10060@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

On Mon, Jan 25 2016 at  4:40pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Jan 19 2016 at  5:45P -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Mon, Jan 18 2016 at  7:04am -0500,
> > Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> > 
> > > Hi All,
> > > 
> > > I've recently tried out dm-multipath over a "super-fast" nvme device
> > > and noticed a serious lock contention in dm-multipath that requires some
> > > extra attention. The nvme device is a simple loopback device emulation
> > > backed by null_blk device.
> > > 
> > > With this I've seen dm-multipath pushing around ~470K IOPs while
> > > the native (loopback) nvme performance can easily push up to 1500K+ IOPs.
> > > 
> > > perf output [1] reveals a huge lock contention on the multipath lock
> > > which is a per-dm_target contention point which seem to defeat the
> > > purpose of blk-mq i/O path.
> > > 
> > > The two current bottlenecks seem to come from multipath_busy and
> > > __multipath_map. Would it make better sense to move to a percpu_ref
> > > model with freeze/unfreeze logic for updates similar to what blk-mq
> > > is doing?
> > >
> > > Thoughts?
> > 
> > Your perf output clearly does identify the 'struct multipath' spinlock
> > as a bottleneck.
> > 
> > Is it fair to assume that implied in your test is that you increased
> > md->tag_set.nr_hw_queues to > 1 in dm_init_request_based_blk_mq_queue()?
> > 
> > I'd like to start by replicating your testbed.  So I'll see about
> > setting up the nvme loop driver you referenced in earlier mail.
> > Can you share your fio job file and fio commandline for your test?
> 
> Would still appreciate answers to my 2 questions above (did you modify
> md->tag_set.nr_hw_queues and can you share your fio job?)
> 
> I've yet to reproduce your config (using hch's nvme loop driver) or

Christoph, any chance you could rebase your 'nvme-loop.2' on v4.5-rc1?

Or point me to a branch that is more current...
