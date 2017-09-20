From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] dm-mpath: Improve handling of busy paths
Date: Wed, 20 Sep 2017 23:26:09 +0000
Message-ID: <1505949968.2509.32.camel@wdc.com>
References: <20170920181212.5532-1-bart.vanassche@wdc.com>
	<20170920223605.GC5105@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170920223605.GC5105@ming.t460p>
Content-Language: en-US
Content-ID: <B4ECC233F4BB104BB23FC262D196FC5D@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.com" <hare@suse.com>
List-Id: dm-devel.ids

On Thu, 2017-09-21 at 06:36 +0800, Ming Lei wrote:
> Actually with GFP_ATOMIC, dispatch in dm-rq can't move on and no request
> will be dequeued from IO scheduler queue if this allocation fails, that
> means IO merge is still working at that time if the patchset of
> 'blk-mq-sched: improve SCSI-MQ performance' is applied.
> 
> As my test done, the sequential I/O performance is still not good
> even though the patchset is applied.
> 
> That isn't strange because queue depth of IO scheduler queue can be
> much bigger than either q->queue_depth or .cmd_per_lun, that means
> the underlying queue has been busy for a while before the allocation
> fails.

Hello Ming,

This patch is intended as an alternative for your patch series "dm-mpath:
improve I/O schedule". I wanted to show that it is possible to reduce
dm-mpath request submission latency if the underlying driver returns
"busy" frequently without touching the "return DM_MAPIO_DELAY_REQUEUE"
statement in multipath_clone_and_map(). I will provide measurement data as
soon as I have the time to run more measurements.

Bart.
