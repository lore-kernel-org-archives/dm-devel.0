From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] dm-mpath: Improve handling of busy paths
Date: Thu, 21 Sep 2017 15:53:45 +0000
Message-ID: <1506009224.2521.12.camel@wdc.com>
References: <20170920181212.5532-1-bart.vanassche@wdc.com>
	<20170920223605.GC5105@ming.t460p> <1505949968.2509.32.camel@wdc.com>
	<20170921014102.GA6854@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170921014102.GA6854@ming.t460p>
Content-Language: en-US
Content-ID: <D9FBB625612F5E4AAE8F329F78A5B6B3@namprd04.prod.outlook.com>
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

On Thu, 2017-09-21 at 09:41 +0800, Ming Lei wrote:
> On Wed, Sep 20, 2017 at 11:26:09PM +0000, Bart Van Assche wrote:
> > dm-mpath request submission latency if the underlying driver returns
> > "busy" frequently without touching the "return DM_MAPIO_DELAY_REQUEUE"
> 
> I already explained, the DM_MAPIO_DELAY_REQUEUE can be changed
> to DM_MAPIO_REQUEUE at least for dm-rq-mq via SCHED_RESTART, even
> for dm-rq-sq, it should be possible but need to make sure there
> is in-flight requests because we run queue in rq_completed().

Sorry but I think that would be wrong because it would result in the dm-mpath
driver to busy-wait for a request if blk_get_request(..., GFP_ATOMIC) fails
either due to all tags having been allocated or because the path is dying.
Have you had a look at commit 1c23484c355e ("dm-mpath: do not lock up a CPU
with requeuing activity")? Do you understand the purpose of that change?

> As I explained, this patch can't fix the I/O merge issue since it is easy
> to trigger queue busy before running out of requests, that is why I
> changes the 'nr_request' in the patch 5 of 'dm-mpath: improve I/O schedule'.

Sorry but I don't think that *any* value of nr_requests can prevent that the
dm-mpath driver submits requests against a busy path. If multiple LUNs are
associated with the same SCSI host and I/O is ongoing against multiple LUNs
concurrently then it is not possible to choose a value for nr_requests that
prevents that a request is queued against a busy SCSI device. How about using
something like the (untested) patch below to prevent that requests are queued
against a busy SCSI path?


[PATCH] scsi_lld_busy(): Improve busy detection

To achieve optimal I/O scheduling it is important that the
dm-mpath driver returns "busy" if the path it will submit a
request to is busy. Hence also check whether the target and
the host are busy from inside scsi_lld_busy(). Note:
dm_mq_queue_rq() calls scsi_lld_busy() as follows:

	if (ti->type->busy && ti->type->busy(ti))
		return BLK_STS_RESOURCE;

---
 drivers/scsi/scsi_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f6097b89d5d3..db68605f98ea 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1534,7 +1534,9 @@ static int scsi_lld_busy(struct request_queue *q)
 	 * multiple queues, congestion of host/starget needs to be handled
 	 * in SCSI layer.
 	 */
-	if (scsi_host_in_recovery(shost) || scsi_device_is_busy(sdev))
+	if (scsi_host_in_recovery(shost) || scsi_device_is_busy(sdev) ||
+	    scsi_target_is_busy(scsi_target(sdev)) ||
+	    scsi_host_is_busy(shost))
 		return 1;
 
 	return 0;
