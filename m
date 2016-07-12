From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: poor thin performance, relative to thick
Date: Tue, 12 Jul 2016 14:46:26 -0400
Message-ID: <20160712184625.GA3691@redhat.com>
References: <20160711204454.GA24378@helmut>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160711204454.GA24378@helmut>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jon Bernard <jbernard@tuxion.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 11 2016 at  4:44pm -0400,
Jon Bernard <jbernard@tuxion.com> wrote:

> Greetings,
> 
> I have recently noticed a large difference in performance between thick
> and thin LVM volumes and I'm trying to understand why that it the case.
> 
> In summary, for the same FIO test (attached), I'm seeing 560k iops on a
> thick volume vs. 200k iops for a thin volume and these results are
> pretty consistent across different runs.
> 
> I noticed that if I run two FIO tests simultaneously on 2 separate thin
> pools, I net nearly double the performance of a single pool.  And two
> tests on thin volumes within the same pool will split the maximum iops
> of the single pool (essentially half).  And I see similar results from
> linux 3.10 and 4.6.
> 
> I understand that thin must track metadata as part of its design and so
> some additional overhead is to be expected, but I'm wondering if we can
> narrow the gap a bit.
> 
> In case it helps, I also enabled LOCK_STAT and gathered locking
> statistics for both thick and thin runs (attached).
> 
> I'm curious to know whether this is a know issue, and if I can do
> anything the help improve the situation.  I wonder if the use of the
> primary spinlock in the pool structure could be improved - the lock
> statistics appear to indicate a significant amount of time contending
> with that one.  Or maybe it's something else entirely, and in that case
> please enlighten me.
> 
> If there are any specific questions or tests I can run, I'm happy to do
> so.  Let me know how I can help.
> 
> -- 
> Jon

I personally put a significant amount of time into thick vs thin
performance comparisons and improvements a few years ago.  But the focus
of that work was to ensure Gluster -- as deployed by Red Hat (which is
layered ontop of DM-thinp + XFS) -- performed comparably to thick
volumes for: multi-threaded sequential writes followed by reads.

At that time there was significant slowdown from thin when reading back
the writen data (due to multithreaded writes httting FIFO block
allocation in DM thinp).

Here are the related commits I worked on:
http://git.kernel.org/linus/c140e1c4e23b
http://git.kernel.org/linus/67324ea18812

And one that Joe later did based on the same idea (sorting):
http://git.kernel.org/linus/ac4c3f34a9af

> [random]
> direct=1 
> rw=randrw 
> zero_buffers 
> norandommap 
> randrepeat=0 
> ioengine=libaio
> group_reporting
> rwmixread=100 
> bs=4k 
> iodepth=32 
> numjobs=16 
> runtime=600

But you're focusing on multithreaded small random reads (4K).  AFAICT
this test will never actually allocate the block in the thin device
first, maybe I'm missing something but all I see is read stats.

But I'm also not sure what "thin-thick" means (vs "thin-thindisk1"
below).

Is the "thick" LV just a normal linear LV?
And "thindisk1" LV is a thin LV?

Oddly, below the lockstats even shows pmd->root_lock being hit during
the thick test.. guess it could just be noise.

But in general I'll need to circle back to re-read the lockstats output
sense I don't understand what all the metrics/columns are saying.

> # fio --filename=/dev/mapper/thin-thick read_rand.fio                                      
> random: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> ...
> fio-2.2.8
> Starting 16 processes
> Jobs: 16 (f=16): [r(16)] [100.0% done] [863.4MB/0KB/0KB /s] [221K/0/0 iops] [eta 00m:00s]
> random: (groupid=0, jobs=16): err= 0: pid=8912: Wed Jun 22 14:53:39 2016
>   read : io=529123MB, bw=903035KB/s, iops=225758, runt=600001msec
>     slat (usec): min=6, max=53714, avg=64.57, stdev=93.39
>     clat (usec): min=2, max=113018, avg=2201.86, stdev=974.65
>      lat (usec): min=51, max=113057, avg=2266.66, stdev=995.55
>     clat percentiles (usec):
>      |  1.00th=[ 1020],  5.00th=[ 1240], 10.00th=[ 1480], 20.00th=[ 1736],
>      | 30.00th=[ 1864], 40.00th=[ 1976], 50.00th=[ 2096], 60.00th=[ 2192],
>      | 70.00th=[ 2320], 80.00th=[ 2512], 90.00th=[ 2800], 95.00th=[ 3216],
>      | 99.00th=[ 5792], 99.50th=[ 7520], 99.90th=[13248], 99.95th=[16064],
>      | 99.99th=[23424]
>     bw (KB  /s): min= 3258, max=133280, per=6.25%, avg=56450.27, stdev=10373.47
>     lat (usec) : 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%
>     lat (usec) : 250=0.01%, 500=0.02%, 750=0.02%, 1000=0.77%
>     lat (msec) : 2=41.23%, 4=55.40%, 10=2.32%, 20=0.21%, 50=0.02%
>     lat (msec) : 100=0.01%, 250=0.01%
>   cpu          : usr=2.16%, sys=95.78%, ctx=1049239, majf=0, minf=18932
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>      issued    : total=r=135455419/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
> 
> Run status group 0 (all jobs):
>    READ: io=529123MB, aggrb=903034KB/s, minb=903034KB/s, maxb=903034KB/s, mint=600001msec, maxt=600001msec

> lock_stat version 0.4
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
>         &(&ioc->scsi_lookup_lock)->rlock:     323309477      354021096           0.08        1219.27  5755299178.37          16.26      396179743      406370664           0.05          19.51   330766679.12           0.81
>         --------------------------------
>         &(&ioc->scsi_lookup_lock)->rlock      117750632          [<ffffffffa01ada2a>] mpt3sas_base_get_smid_scsiio+0x2a/0xa0 [mpt3sas]
>         &(&ioc->scsi_lookup_lock)->rlock      117934146          [<ffffffffa01b8400>] _scsih_io_done+0x40/0x9f0 [mpt3sas]
>         &(&ioc->scsi_lookup_lock)->rlock      118336318          [<ffffffffa01adb3e>] mpt3sas_base_free_smid+0x2e/0x230 [mpt3sas]
>         --------------------------------
>         &(&ioc->scsi_lookup_lock)->rlock      106315683          [<ffffffffa01ada2a>] mpt3sas_base_get_smid_scsiio+0x2a/0xa0 [mpt3sas]
>         &(&ioc->scsi_lookup_lock)->rlock      117493014          [<ffffffffa01b8400>] _scsih_io_done+0x40/0x9f0 [mpt3sas]
>         &(&ioc->scsi_lookup_lock)->rlock      130212399          [<ffffffffa01adb3e>] mpt3sas_base_free_smid+0x2e/0x230 [mpt3sas]
> 
> .............................................................................................................................................................................................................................
> 
>               &(&q->__queue_lock)->rlock:     164901352      164973127           0.07         228.68   337677482.74           2.05      479757372      677287100           0.06          39.06   752383611.73           1.11
>               --------------------------
>               &(&q->__queue_lock)->rlock       32326526          [<ffffffff81331caf>] blk_queue_bio+0x9f/0x3d0
>               &(&q->__queue_lock)->rlock       33711083          [<ffffffff814e70dd>] scsi_request_fn+0x49d/0x640
>               &(&q->__queue_lock)->rlock       31251091          [<ffffffff81331b85>] blk_flush_plug_list+0x175/0x200
>               &(&q->__queue_lock)->rlock       31915411          [<ffffffff814e5dae>] scsi_end_request+0x10e/0x1e0
>               --------------------------
>               &(&q->__queue_lock)->rlock       66075480          [<ffffffff81331b85>] blk_flush_plug_list+0x175/0x200
>               &(&q->__queue_lock)->rlock       24384772          [<ffffffff81331caf>] blk_queue_bio+0x9f/0x3d0
>               &(&q->__queue_lock)->rlock       12263113          [<ffffffff814e70dd>] scsi_request_fn+0x49d/0x640
>               &(&q->__queue_lock)->rlock       52494314          [<ffffffff814e5dae>] scsi_end_request+0x10e/0x1e0
> 
>
...........................................................................................................................................

Given you aren't using blk-mq (via scsi-mq) you're clearly hammering the
q->queue_lock.

...

..................................................................................
> 
>                        &pmd->root_lock-W:             0              0           0.00           0.00           0.00           0.00             63             67        5059.46       27647.39      650602.46        9710.48
>                        &pmd->root_lock-R:             2              2        6002.03        7582.72       13584.75        6792.37            474           3165           0.10        4542.03       14844.84           4.69
>                        -----------------
>                          &pmd->root_lock              2          [<ffffffffa087efde>] dm_pool_issue_prefetches+0x1e/0x40 [dm_thin_pool]
>                        -----------------
>                          &pmd->root_lock              2          [<ffffffffa087e9a6>] dm_pool_commit_metadata+0x26/0x60 [dm_thin_pool]
> 
>
...........................................................................................................................................

Against, strange that is lock is even registering in the "thick" test.
Must just be the DM thinp's periodic commit (but that shouldn't run if
nothing is wiriting to a thin device).

> # fio --filename=/dev/mapper/thin-thindisk1 read_rand.fio
> random: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> ...
> fio-2.2.8
> Starting 16 processes
> Jobs: 16 (f=16): [r(16)] [100.0% done] [130.8MB/0KB/0KB /s] [33.5K/0/0 iops] [eta 00m:00s]
> random: (groupid=0, jobs=16): err= 0: pid=9025: Wed Jun 22 15:23:34 2016
>   read : io=68948MB, bw=117670KB/s, iops=29417, runt=600010msec
>     slat (usec): min=5, max=971, avg=43.86, stdev=15.38
>     clat (usec): min=98, max=39439, avg=17359.36, stdev=7273.99
>      lat (usec): min=110, max=39477, avg=17403.39, stdev=7275.71
>     clat percentiles (usec):
>      |  1.00th=[ 2512],  5.00th=[ 5472], 10.00th=[ 7712], 20.00th=[10816],
>      | 30.00th=[13248], 40.00th=[15296], 50.00th=[17280], 60.00th=[19072],
>      | 70.00th=[21120], 80.00th=[23680], 90.00th=[27008], 95.00th=[29824],
>      | 99.00th=[34048], 99.50th=[35072], 99.90th=[36608], 99.95th=[37120],
>      | 99.99th=[37632]
>     bw (KB  /s): min= 6539, max= 8512, per=6.25%, avg=7358.80, stdev=737.53
>     lat (usec) : 100=0.01%, 250=0.01%, 500=0.02%, 750=0.04%, 1000=0.07%
>     lat (msec) : 2=0.47%, 4=2.00%, 10=14.31%, 20=47.53%, 50=35.56%
>   cpu          : usr=0.44%, sys=8.88%, ctx=26831806, majf=0, minf=6972
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>      issued    : total=r=17650755/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
> 
> Run status group 0 (all jobs):
>    READ: io=68948MB, aggrb=117669KB/s, minb=117669KB/s, maxb=117669KB/s, mint=600010msec, maxt=600010msec

Ok, with this "thin" run I can clearly see IOPs are definitely lower.

But by not first writing the blocks I'm curious how DM thinp is handling
this, e.g.: is it provisioning on read!?

thin_bio_map() is getting an -ENODATA return from dm_thin_find_block().
Which results in thin_bio_map() calling thin_defer_cell().
process_thin_deferred_cells() will eventually process the
deferred_cells.  Finally arriving at process_cell() -- whose
dm_thin_find_block() will _also_ get -ENODATA.. which sure enough _does_
call provision_block().. gross!

That pretty much explains why your read performance absolutely sucks.
Trying writing the blocks first (you know like a real app would do!).

> lock_stat version 0.4
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
>         &(&ioc->scsi_lookup_lock)->rlock:     323309477      354021096           0.08        1219.27  5755299178.37          16.26      396180159      406374144           0.05          19.51   330767253.12           0.81
>         --------------------------------
>         &(&ioc->scsi_lookup_lock)->rlock      117750632          [<ffffffffa01ada2a>] mpt3sas_base_get_smid_scsiio+0x2a/0xa0 [mpt3sas]
>         &(&ioc->scsi_lookup_lock)->rlock      117934146          [<ffffffffa01b8400>] _scsih_io_done+0x40/0x9f0 [mpt3sas]
>         &(&ioc->scsi_lookup_lock)->rlock      118336318          [<ffffffffa01adb3e>] mpt3sas_base_free_smid+0x2e/0x230 [mpt3sas]
>         --------------------------------
>         &(&ioc->scsi_lookup_lock)->rlock      106315683          [<ffffffffa01ada2a>] mpt3sas_base_get_smid_scsiio+0x2a/0xa0 [mpt3sas]
>         &(&ioc->scsi_lookup_lock)->rlock      117493014          [<ffffffffa01b8400>] _scsih_io_done+0x40/0x9f0 [mpt3sas]
>         &(&ioc->scsi_lookup_lock)->rlock      130212399          [<ffffffffa01adb3e>] mpt3sas_base_free_smid+0x2e/0x230 [mpt3sas]
> 
> .............................................................................................................................................................................................................................
> 
>               &(&q->__queue_lock)->rlock:     164901371      164973146           0.07         228.68   337677521.18           2.05      479759336      677293951           0.06          39.06   752391861.03           1.11
>               --------------------------
>               &(&q->__queue_lock)->rlock       32326526          [<ffffffff81331caf>] blk_queue_bio+0x9f/0x3d0
>               &(&q->__queue_lock)->rlock       33711086          [<ffffffff814e70dd>] scsi_request_fn+0x49d/0x640
>               &(&q->__queue_lock)->rlock       31251091          [<ffffffff81331b85>] blk_flush_plug_list+0x175/0x200
>               &(&q->__queue_lock)->rlock       31915415          [<ffffffff814e5dae>] scsi_end_request+0x10e/0x1e0
>               --------------------------
>               &(&q->__queue_lock)->rlock       66075480          [<ffffffff81331b85>] blk_flush_plug_list+0x175/0x200
>               &(&q->__queue_lock)->rlock       24384772          [<ffffffff81331caf>] blk_queue_bio+0x9f/0x3d0
>               &(&q->__queue_lock)->rlock       12263117          [<ffffffff814e70dd>] scsi_request_fn+0x49d/0x640
>               &(&q->__queue_lock)->rlock       52494321          [<ffffffff814e5dae>] scsi_end_request+0x10e/0x1e0
> 
> .............................................................................................................................................................................................................................

Again, you're hammering the old .request_fn q->queue_lock.  Might be
worth testing scsi-mq like someone else suggested.  The traditional IO
schedulers aren't helping this test so no loss there from switching to
blk-mq.

> .............................................................................................................................................................................................................................
> 
>                  &(&prison->lock)->rlock:       1082605        1090480           0.08          16.95      840597.12           0.77       31440843       35307485           0.06          18.39    15958473.29           0.45
>                  -----------------------
>                  &(&prison->lock)->rlock         391448          [<ffffffffa08552eb>] dm_bio_detain+0x2b/0x70 [dm_bio_prison]
>                  &(&prison->lock)->rlock         699032          [<ffffffffa08553ee>] dm_cell_release_no_holder+0x1e/0x70 [dm_bio_prison]
>                  -----------------------
>                  &(&prison->lock)->rlock         196897          [<ffffffffa08553ee>] dm_cell_release_no_holder+0x1e/0x70 [dm_bio_prison]
>                  &(&prison->lock)->rlock         893583          [<ffffffffa08552eb>] dm_bio_detain+0x2b/0x70 [dm_bio_prison]
> 
> .............................................................................................................................................................................................................................
> 
>                      &(&tc->lock)->rlock:        125095         125095           0.10          16.52      104491.32           0.84       31528256       35370273           0.06          25.28    23655883.11           0.67
>                      -------------------
>                      &(&tc->lock)->rlock           9001          [<ffffffffa0877888>] cell_defer_no_holder+0x28/0x80 [dm_thin_pool]
>                      &(&tc->lock)->rlock         115673          [<ffffffffa0876c19>] thin_defer_cell+0x39/0x90 [dm_thin_pool]
>                      &(&tc->lock)->rlock            153          [<ffffffffa087b090>] do_worker+0x100/0x850 [dm_thin_pool]
>                      &(&tc->lock)->rlock            268          [<ffffffffa087b3ca>] do_worker+0x43a/0x850 [dm_thin_pool]
>                      -------------------
>                      &(&tc->lock)->rlock          28599          [<ffffffffa0876c19>] thin_defer_cell+0x39/0x90 [dm_thin_pool]
>                      &(&tc->lock)->rlock          96219          [<ffffffffa0877888>] cell_defer_no_holder+0x28/0x80 [dm_thin_pool]
>                      &(&tc->lock)->rlock            175          [<ffffffffa087b090>] do_worker+0x100/0x850 [dm_thin_pool]
>                      &(&tc->lock)->rlock            102          [<ffffffffa087b3ca>] do_worker+0x43a/0x850 [dm_thin_pool]
> 
> .............................................................................................................................................................................................................................

...

> .............................................................................................................................................................................................................................
> 
>                          &pool->lock#2/1:           392            394           0.20           9.57         408.67           1.04         125366         225137           0.11          26.22      377948.92           1.68
>                          ---------------
>                          &pool->lock#2/1            150          [<ffffffff8109d980>] process_one_work+0x2a0/0x570
>                          &pool->lock#2/1              1          [<ffffffff8109c47b>] flush_work+0x9b/0x280
>                          &pool->lock#2/1            108          [<ffffffff8109c0e8>] __queue_work+0x278/0x3c0
>                          &pool->lock#2/1            134          [<ffffffff8109dde5>] worker_thread+0x195/0x460
>                          ---------------
>                          &pool->lock#2/1              5          [<ffffffff8109c47b>] flush_work+0x9b/0x280
>                          &pool->lock#2/1            175          [<ffffffff8109dde5>] worker_thread+0x195/0x460
>                          &pool->lock#2/1            175          [<ffffffff8109c0e8>] __queue_work+0x278/0x3c0
>                          &pool->lock#2/1             39          [<ffffffff8109d980>] process_one_work+0x2a0/0x570
> 
> .............................................................................................................................................................................................................................

Definitely DM thinp related spinlocks.  Could be there is more efficient
locking possible.  Focus for locking was on correctness; may be worth
digging deeper to see if switching the locking primatives helps.

...

> .............................................................................................................................................................................................................................
> 
>                               &p->lock#2:             1              1          11.03          11.03          11.03          11.03           6926          45601           0.15         781.27       23154.14           0.51
>                               ----------
>                               &p->lock#2              1          [<ffffffffa0862d2c>] dm_tm_read_lock+0x7c/0xa0 [dm_persistent_data]
>                               ----------
>                               &p->lock#2              1          [<ffffffffa0862d2c>] dm_tm_read_lock+0x7c/0xa0 [dm_persistent_data]
> 
> .............................................................................................................................................................................................................................
> 
>                  &(&pool->lock)->rlock#4:             1              1           0.71           0.71           0.71           0.71            684         110917           0.10          19.81       15459.42           0.14
>                  -----------------------
>                  &(&pool->lock)->rlock#4              1          [<ffffffffa0876539>] pool_map+0x29/0x50 [dm_thin_pool]
>                  -----------------------
>                  &(&pool->lock)->rlock#4              1          [<ffffffffa08765a4>] process_prepared+0x44/0xc0 [dm_thin_pool]
> 
> .............................................................................................................................................................................................................................
> 
>                  &(&pool->lock)->rlock#2:             1              1           1.29           1.29           1.29           1.29           7902          78897           0.11          24.72      109733.46           1.39
>                  -----------------------
>                  &(&pool->lock)->rlock#2              1          [<ffffffff8109d980>] process_one_work+0x2a0/0x570
>                  -----------------------
>                  &(&pool->lock)->rlock#2              1          [<ffffffff8109c0e8>] __queue_work+0x278/0x3c0
> 
> .............................................................................................................................................................................................................................
