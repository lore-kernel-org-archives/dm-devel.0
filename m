From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm-mpath: Work with blk multi-queue drivers
Date: Wed, 24 Sep 2014 07:27:13 -0700
Message-ID: <20140924142713.GB3858@infradead.org>
References: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
	<542288A6.3010606@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <542288A6.3010606@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 24, 2014 at 11:02:30AM +0200, Hannes Reinecke wrote:
> The resistance wasn't so much for enabling multipath for block-mq,
> it was _how_ multipath should be modelled on top of block-mq.

As well as finding someone to do the work..  We now found Keith, so
thanks on that already!
> 
> With a simple enabling we actually have two layers of I/O
> scheduling; once in multipathing to select between the individual
> queues, and once in block-mq to select the correct hardware context.
> So we end up with a four-tiered hierarchy:

Assuming we have multiple queues in the low level driver..

> However, this looks like a good starting point.
> I'll give it a go and see how far I'll be getting with it.

Yes, the first priority should be to make dm-mpath to work on a blk-mq
device at all, which is very important for scsi-mq adoption, which
will include a lot of single queue devices.  After that come various
levels of efficiency optimizations.  The first priority should be
to get rid of the horrible bio clones by hooking into the right place
in the I/O completion, second one would be to revamp the I/O submission
path, for example by hooking into ->map_queue.  With fairly limited work
that does sound doable as long as all paths use the same HBA/driver
which is not an unusual limitation in other multipathing
implementations.
