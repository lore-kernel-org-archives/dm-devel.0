From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Remove BIO_RW_SYNCIO flag from kcopyd
Date: Mon, 22 Nov 2010 08:45:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1011220836001.14802@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1010242101590.6231@hs20-bc2-1.build.redhat.com>
	<20101119221725.GA25730@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101119221725.GA25730@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

On Fri, 19 Nov 2010, Mike Snitzer wrote:

> Hi Mikulas,
> 
> On Sun, Oct 24 2010 at  9:02pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Remove BIO_RW_SYNCIO flag from kcopyd
> > 
> > This improves write throughput twice when writing to the origin with snapshot
> > on the same device.
> 
> Can you please be more specific on the performance improvement you
> observed?  You're saying something like: baseline=10MB/s patched=20MB/s?

Yes. I rechecked it now, and it is approximatelly so:
(for chunk size 4k, 32k, 512k)
unpatched: 8.5, 8.6, 9.3 MB/s
this patch: 15.2, 18.5, 17.5 MB/s

> Did you use a larger chunk_size for the snapshot device (e.g. 512K)?

It has effect for all chunk sizes.

> I can't reproduce such significant performance improvements but my testbed
> may be overly constrained (I'm passing an entire disk from host into KVM
> guest using virtio).  I can look to test on bare metal early next week
> (unless you have more insight that would obviate the need to do so).

My scenario is: LSI MPT controller, U320 15k SCSI disk, 64GiB file mapped 
with dm-loop, volume group on dm-loop, with both snapshot and origin in 
it.

> > This helps for CFQ I/O scheduler that has separate queues for sync and async
> > I/O, async is optimized for throughput, sync for latency.
> > Reallocations are triggered by writes that are usually async, so mark it
> > as async as well.
> 
> This change is at odds with a previous patch you made to reduce latency
> of SYNC IO, see linux-2.6 commit:
> 7ff14a36159d947872870  "dm: unplug queues in threads"
> 
> So we're now trading latency for throughput?

Yes. I think throughput matters more than latency for writes.

> Given the concerns about
> snapshot-origin throughput (on lvm-general) I think that is reasonable.
> But I just want to make sure we're consciously favoring throughput over
> latency (I'll likely update the patch header to explicitly say as much).

Yes. Write it there.

If someone need latency for writes, we could propagate the SYNC flag from 
the original write bio here. But if no one needs it, it would be needless 
complication.

Mikulas

> > Index: linux-2.6.36-rc7-fast/drivers/md/dm-kcopyd.c
> > ===================================================================
> > --- linux-2.6.36-rc7-fast.orig/drivers/md/dm-kcopyd.c	2010-10-07 16:09:13.000000000 +0200
> > +++ linux-2.6.36-rc7-fast/drivers/md/dm-kcopyd.c	2010-10-15 03:18:52.000000000 +0200
> > @@ -345,7 +345,7 @@ static int run_io_job(struct kcopyd_job 
> >  {
> >  	int r;
> >  	struct dm_io_request io_req = {
> > -		.bi_rw = job->rw | REQ_SYNC | REQ_UNPLUG,
> > +		.bi_rw = job->rw | REQ_UNPLUG,
> >  		.mem.type = DM_IO_PAGE_LIST,
> >  		.mem.ptr.pl = job->pages,
> >  		.mem.offset = job->offset,
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
