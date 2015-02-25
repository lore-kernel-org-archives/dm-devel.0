From: Mike Snitzer <snitzer@redhat.com>
Subject: awful request merge results while simulating high IOPS
	multipath
Date: Tue, 24 Feb 2015 19:56:08 -0500
Message-ID: <20150225005608.GA13348@redhat.com>
References: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
	<1424796250-38553-5-git-send-email-snitzer@redhat.com>
	<54ECAC08.7040603@kernel.dk> <20150224172259.GA39226@redhat.com>
	<54ECBA78.6020204@kernel.dk> <20150224181257.GA11444@redhat.com>
	<54ECC000.40604@kernel.dk> <20150224183256.GA11566@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150224183256.GA11566@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, jmoyer@redhat.com, shivakrishna.merla@netapp.com, dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On Tue, Feb 24 2015 at  1:32pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Feb 24 2015 at  1:16pm -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
> > >>
> > >>So all of this needs to be tested and performance vetted. But my
> > >>original suggestion was something like:
> > >>
> > >>if (run_queue && !md->queue->nr_pending)
> > >>	blk_run_queue_async(md->queue);
> > >>
> > >>which might be a bit extreme, but if we hit 0, that's the only case
> > >>where you truly do need to run the queue. So that kind of logic
> > >>would give you the highest chance of merge success, potentially at
> > >>the cost of reduced performance for other cases.
> > >
> > >Yeah, I was wondering about not running the queue at all when discussing
> > >with Jeff earlier today.  Seemed extreme, and Jeff thought it could
> > >cause performance to really take a hit.
> > 
> > Whether you have to or not depends on how you break out of queueing
> > loops. But you definitely don't have to run it on every single
> > request completion...
> 
> OK, thanks for clarifying.
> 
> Will see how the initial RFC patch I shared works for Netapp's testcase
> but based on those results will work to arrive at a more
> generic/intelligent solution.

That initial RFC didn't do well.  And given my results below, I'm not
holding out any hope for this io completion change, which we already
discussed as being more sane, having any impact:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=9068f2f15d5fc7a5c9dc6e6963913216ede0c745
 
Here is the sorry state of affairs:

Summary:
========

Request-based DM is somehow breaking the block layer's ability to properly merge requests.
Only good news is I seem to have a testbed that I can use to chase this issue down.

Test kernel is v4.0-rc1 with a few DM patches, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next


baseline:
=========

Writing to an STEC PCIe SSD using 64 threads, each using 4K sequentional IOs.
There are clearly merges happening.

fio job:
--------
[64_seq_write]
filename=/dev/skd0
rw=write
rwmixread=0
blocksize=4k
iodepth=16
direct=1
numjobs=64
#nrfiles=1
runtime=100
ioengine=libaio
time_based

deadline:
---------
Run status group 0 (all jobs):
  WRITE: io=33356MB, aggrb=341513KB/s, minb=4082KB/s, maxb=5463KB/s, mint=100001msec, maxt=100014msec

Disk stats (read/write):
  skd0: ios=0/638099, merge=0/7483318, ticks=0/8015451, in_queue=8073672, util=100.00%

cfq:
----
rotational=0
------------
Run status group 0 (all jobs):
  WRITE: io=20970MB, aggrb=214663KB/s, minb=3202KB/s, maxb=3620KB/s, mint=100001msec, maxt=100030msec

Disk stats (read/write):
  skd0: ios=47/390277, merge=0/4939075, ticks=0/7082618, in_queue=7109995, util=100.00%

rotational=1
------------
Run status group 0 (all jobs):
  WRITE: io=30075MB, aggrb=307130KB/s, minb=2613KB/s, maxb=10247KB/s, mint=100001msec, maxt=100271msec

Disk stats (read/write):
  skd0: ios=57/2217835, merge=0/5414906, ticks=0/6110715, in_queue=6120362, util=99.97%


multipath:
==========

Same workload as above, but this time through a request-based DM multipath target.
There are clearly _no_ merges happening.

echo "0 1563037696 multipath 0 0 1 1 service-time 0 1 2 /dev/skd0 1000 1" | dmsetup create skd_mpath

[64_seq_write]
#filename=/dev/mapper/skd_mpath
filename=/dev/dm-9
rw=write
rwmixread=0
blocksize=4k
iodepth=16
direct=1
numjobs=64
#nrfiles=1
runtime=100
ioengine=libaio
time_based

deadline:
---------
Run status group 0 (all jobs):
  WRITE: io=22559MB, aggrb=230976KB/s, minb=3565KB/s, maxb=3659KB/s, mint=100001msec, maxt=100011msec

Disk stats (read/write):
    dm-9: ios=71/5772755, merge=0/0, ticks=3/15309410, in_queue=15360084, util=100.00%, aggrios=164/5775057, aggrmerge=0/0, aggrticks=16/14960469, aggrin_queue=14956943, aggrutil=99.92%
  skd0: ios=164/5775057, merge=0/0, ticks=16/14960469, in_queue=14956943, util=99.92%

cfq:
----
rotational=0
------------
Run status group 0 (all jobs):
  WRITE: io=19477MB, aggrb=199424KB/s, minb=3001KB/s, maxb=3268KB/s, mint=100001msec, maxt=100010msec

Disk stats (read/write):
    dm-9: ios=40/4811814, merge=0/159762, ticks=0/14866276, in_queue=14912510, util=100.00%, aggrios=224/4814462, aggrmerge=0/0, aggrticks=13/14399688, aggrin_queue=14396342, aggrutil=99.92%
  skd0: ios=224/4814462, merge=0/0, ticks=13/14399688, in_queue=14396342, util=99.92%

rotational=1
------------
Run status group 0 (all jobs):
  WRITE: io=21051MB, aggrb=215188KB/s, minb=2147KB/s, maxb=8671KB/s, mint=100001msec, maxt=100175msec

Disk stats (read/write):
    dm-9: ios=59/1468500, merge=0/3836597, ticks=2/5928782, in_queue=5959348, util=100.00%, aggrios=152/1469016, aggrmerge=0/0, aggrticks=5/395471, aggrin_queue=395287, aggrutil=71.17%
  skd0: ios=152/1469016, merge=0/0, ticks=5/395471, in_queue=395287, util=71.17%
