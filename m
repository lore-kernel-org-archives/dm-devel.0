From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Wed, 3 Feb 2016 13:24:24 -0500
Message-ID: <20160203182423.GA12913@redhat.com>
References: <20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com>
	<56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160203180406.GA11591@redhat.com>
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
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Wed, Feb 03 2016 at  1:04pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> I'm still not clear on where the considerable performance loss is coming
> from (on null_blk device I see ~1900K read IOPs but I'm still only
> seeing ~1000K read IOPs when blk-mq DM-multipath is layered ontop).
> What is very much apparent is: layering dm-mq multipath ontop of null_blk
> results in a HUGE amount of additional context switches.  I can only
> infer that the request completion for this stacked device (blk-mq queue
> ontop of blk-mq queue, with 2 completions: 1 for clone completing on
> underlying device and 1 for original request completing) is the reason
> for all the extra context switches.

Starts to explain, certainly not the "reason"; that is still very much
TBD...

> Here are pictures of 'perf report' for perf datat collected using
> 'perf record -ag -e cs'.
> 
> Against null_blk:
> http://people.redhat.com/msnitzer/perf-report-cs-null_blk.png

if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
  cpu          : usr=25.53%, sys=74.40%, ctx=1970, majf=0, minf=474
if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
  cpu          : usr=26.79%, sys=73.15%, ctx=2067, majf=0, minf=479

> Against dm-mpath ontop of the same null_blk:
> http://people.redhat.com/msnitzer/perf-report-cs-dm_mq.png

if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
  cpu          : usr=11.07%, sys=33.90%, ctx=667784, majf=0, minf=466
if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
  cpu          : usr=15.22%, sys=48.44%, ctx=2314901, majf=0, minf=466

So yeah, the percentages reflected in these respective images didn't do
the huge increase in context switches justice... we _must_ figure out
why we're seeing so many context switches with dm-mq.

The same fio job is ran to measure these context switches, e.g.:

fio --cpus_allowed_policy=split --group_reporting --rw=randread --bs=4k
--numjobs=12 --iodepth=32 --runtime=10 --time_based --loops=1
--ioengine=libaio --direct=1 --invalidate=1 --randrepeat=1 --norandommap
--exitall --name task_nullb0 --filename=/dev/nullb0

fio --cpus_allowed_policy=split --group_reporting --rw=randread --bs=4k
--numjobs=12 --iodepth=32 --runtime=10 --time_based --loops=1
--ioengine=libaio --direct=1 --invalidate=1 --randrepeat=1 --norandommap
--exitall --name task_dm_mq --filename=/dev/mapper/dm_mq
