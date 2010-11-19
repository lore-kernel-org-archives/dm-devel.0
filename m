From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Remove BIO_RW_SYNCIO flag from kcopyd
Date: Fri, 19 Nov 2010 17:17:25 -0500
Message-ID: <20101119221725.GA25730@redhat.com>
References: <Pine.LNX.4.64.1010242101590.6231@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1010242101590.6231@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On Sun, Oct 24 2010 at  9:02pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Remove BIO_RW_SYNCIO flag from kcopyd
> 
> This improves write throughput twice when writing to the origin with snapshot
> on the same device.

Can you please be more specific on the performance improvement you
observed?  You're saying something like: baseline=10MB/s patched=20MB/s?

Did you use a larger chunk_size for the snapshot device (e.g. 512K)?

I can't reproduce such significant performance improvements but my testbed
may be overly constrained (I'm passing an entire disk from host into KVM
guest using virtio).  I can look to test on bare metal early next week
(unless you have more insight that would obviate the need to do so).

> This helps for CFQ I/O scheduler that has separate queues for sync and async
> I/O, async is optimized for throughput, sync for latency.
> Reallocations are triggered by writes that are usually async, so mark it
> as async as well.

This change is at odds with a previous patch you made to reduce latency
of SYNC IO, see linux-2.6 commit:
7ff14a36159d947872870  "dm: unplug queues in threads"

So we're now trading latency for throughput?  Given the concerns about
snapshot-origin throughput (on lvm-general) I think that is reasonable.
But I just want to make sure we're consciously favoring throughput over
latency (I'll likely update the patch header to explicitly say as much).

> Index: linux-2.6.36-rc7-fast/drivers/md/dm-kcopyd.c
> ===================================================================
> --- linux-2.6.36-rc7-fast.orig/drivers/md/dm-kcopyd.c	2010-10-07 16:09:13.000000000 +0200
> +++ linux-2.6.36-rc7-fast/drivers/md/dm-kcopyd.c	2010-10-15 03:18:52.000000000 +0200
> @@ -345,7 +345,7 @@ static int run_io_job(struct kcopyd_job 
>  {
>  	int r;
>  	struct dm_io_request io_req = {
> -		.bi_rw = job->rw | REQ_SYNC | REQ_UNPLUG,
> +		.bi_rw = job->rw | REQ_UNPLUG,
>  		.mem.type = DM_IO_PAGE_LIST,
>  		.mem.ptr.pl = job->pages,
>  		.mem.offset = job->offset,
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
