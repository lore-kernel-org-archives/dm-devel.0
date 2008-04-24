From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] 10-times slower dm-raid1 O_SYNC
Date: Thu, 24 Apr 2008 13:20:40 +0200
Message-ID: <20080424112040.GA12774@kernel.dk>
References: <Pine.LNX.4.64.0804172328070.10556@porkchop.devel.redhat.com>
	<20080418120459.GQ18935@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804211754510.19735@porkchop.devel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804211754510.19735@porkchop.devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 21 2008, Mikulas Patocka wrote:
> Hi
> 
> Here is the patch to fix 10-times slower dm-raid1.
> 
> I realized that conditional unplug when someone is waiting on any IO (that 
> I proposed on the phone call) is not correct --- it would leave the same 
> problem with asynchronous IO (io_submit functions, etc.). So when kmirrord 
> finishes all work, it unplugs the queue unconditionally.
> 
> The same bug exists with kcopyd, I fixed it to always use BIO_RW_SYNC bit. 
> In kcopyd work routine it is not possible to find all devices that were 
> involved in copying, so we don't know which queue to unplug. So the only 
> way to fix it is to use synchronous submit.
> 
> Look at it and if you don't find any issues, I will post the patch to the 
> customer for his testing.
> 
> Mikulas

> Avoid 3ms delay in dm-raid and kcopyd.
> 
> It is specified that any submitted bio without BIO_RW_SYNC flag may plug the
> queue (i.e. block the requests from being dispatched to the physical device).
> 
> The queue is unplugged when the caller calls blk_unplug() function. Usually, the
> sequence is that someone calls submit_bh to submit IO on a buffer. The IO plugs
> the queue and waits (to be possibly joined with other adjacent bios). Then, when
> the caller calls wait_on_buffer(), it unplugs the queue and submits the IOs to
> the disk.
> 
> This was happenning:
> 
> When doing O_SYNC writes, function fsync_buffers_list() submits a list of
> bios to dm_raid1, the bios are added to dm_raid1 write queue and kmirrord is
> woken up.
> 
> fsync_buffers_list() calls wait_on_buffer() --- that unplugs the queue, but
> there are no bios on the device queue (they are still in dm_raid1 queue)
> 
> wait_on_buffer() starts waiting until the IO is finished.
> 
> kmirrord is scheduled, kmirrord takes bios and submits them to the devices.
> 
> the submitted bio plugs the harddisk queue, there is no one to unplug it
> (the process that called wait_on_buffer() is already sleeping)
> 
> So there is 3ms timeout, after which the queues on the harddisks are
> unplugged, and requests are processed.
> 
> This 3ms timeout caused that in certain workloads (O_SYNC, 8kb writes), dm-raid1
> is 10 times slower than md-raid1.
> 
> 
> Every time we submit something asynchronously via dm_io, we must unplug the
> queue to actually put the request to the device.
> 
> This patch adds unplug call to kmirrord --- while processing requests, it keeps
> the queue plugged (so that adjacent bios can be merged), when it finishes
> processing all bios, it unplugs the queue to submit the bios.
> 
> It also fixes kcopyd, that has the same potential problem. All kcopyd requests
> are submitted with BIO_RW_SYNC.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-io.c     |   10 ++++++++--
>  drivers/md/dm-kcopyd.c |    2 +-
>  drivers/md/dm-raid1.c  |    2 ++
>  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.25-rc8/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-2.6.25-rc8.orig/drivers/md/dm-raid1.c	2008-04-03 18:45:09.000000000 +0200
> +++ linux-2.6.25-rc8/drivers/md/dm-raid1.c	2008-04-21 21:55:34.000000000 +0200
> @@ -1297,6 +1297,8 @@ static void do_mirror(struct work_struct
>  	do_reads(ms, &reads);
>  	do_writes(ms, &writes);
>  	do_failures(ms, &failures);
> +
> +	dm_table_unplug_all(ms->ti->table);
>  }
>  
>  
> Index: linux-2.6.25-rc8/drivers/md/dm-io.c
> ===================================================================
> --- linux-2.6.25-rc8.orig/drivers/md/dm-io.c	2008-04-21 22:32:21.000000000 +0200
> +++ linux-2.6.25-rc8/drivers/md/dm-io.c	2008-04-21 22:43:14.000000000 +0200
> @@ -353,7 +353,7 @@ static int sync_io(struct dm_io_client *
>  {
>  	struct io io;
>  
> -	if (num_regions > 1 && rw != WRITE) {
> +	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
>  		WARN_ON(1);
>  		return -EIO;
>  	}
> @@ -390,7 +390,7 @@ static int async_io(struct dm_io_client 
>  {
>  	struct io *io;
>  
> -	if (num_regions > 1 && rw != WRITE) {
> +	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
>  		WARN_ON(1);
>  		fn(1, context);
>  		return -EIO;
> @@ -437,6 +437,12 @@ static int dp_init(struct dm_io_request 
>  
>  /*
>   * New collapsed (a)synchronous interface
> + *
> + * Attention:
> + * If the IO is asynchronous (i.e. it has notify.fn), you must either unplug the
> + * queue with blk_unplug() some times later or you must set BIO_RW_SYNC bit in
> + * io_req->bi_rw. If you fail to do one of these, the IO will be submitted to
> + * the disk with 3ms delay.
>   */
>  int dm_io(struct dm_io_request *io_req, unsigned num_regions,
>  	  struct dm_io_region *where, unsigned long *sync_error_bits)
> Index: linux-2.6.25-rc8/drivers/md/dm-kcopyd.c
> ===================================================================
> --- linux-2.6.25-rc8.orig/drivers/md/dm-kcopyd.c	2008-04-03 18:45:08.000000000 +0200
> +++ linux-2.6.25-rc8/drivers/md/dm-kcopyd.c	2008-04-21 22:34:41.000000000 +0200
> @@ -333,7 +333,7 @@ static int run_io_job(struct kcopyd_job 
>  {
>  	int r;
>  	struct dm_io_request io_req = {
> -		.bi_rw = job->rw,
> +		.bi_rw = job->rw | (1 << BIO_RW_SYNC),
>  		.mem.type = DM_IO_PAGE_LIST,
>  		.mem.ptr.pl = job->pages,
>  		.mem.offset = job->offset,

Looks ok to me.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe
