From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Wed, 3 Feb 2016 14:22:57 -0500
Message-ID: <20160203192257.GA13076@redhat.com>
References: <20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com>
	<56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com>
	<20160203182423.GA12913@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160203182423.GA12913@redhat.com>
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
Cc: axboe@kernel.dk, "keith.busch@intel.com" <keith.busch@intel.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids


On Wed, Feb 03 2016 at  1:24pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> > Here are pictures of 'perf report' for perf datat collected using
> > 'perf record -ag -e cs'.
> > 
> > Against null_blk:
> > http://people.redhat.com/msnitzer/perf-report-cs-null_blk.png
> 
> if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
>   cpu          : usr=25.53%, sys=74.40%, ctx=1970, majf=0, minf=474
> if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
>   cpu          : usr=26.79%, sys=73.15%, ctx=2067, majf=0, minf=479
> 
> > Against dm-mpath ontop of the same null_blk:
> > http://people.redhat.com/msnitzer/perf-report-cs-dm_mq.png
> 
> if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
>   cpu          : usr=11.07%, sys=33.90%, ctx=667784, majf=0, minf=466
> if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
>   cpu          : usr=15.22%, sys=48.44%, ctx=2314901, majf=0, minf=466

I promise, this is my last reply to myself ;)

The above dm-mq results were _without_ using this commit:
"dm: don't blk_mq_run_hw_queues in blk-mq request completion"
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=cc6ca783e8f0669112c5f4154f51a7cb17b76006

But with that commit I'm still seeing the high context switches:

if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
   cpu          : usr=11.78%, sys=36.11%, ctx=690262, majf=0, minf=470
if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
  cpu          : usr=15.62%, sys=49.95%, ctx=2425084, majf=0, minf=466

So running blk_mq_run_hw_queues (async to punt to kblockd) on dm-mq
request completion isn't the source of any of the accounted context
switches...
