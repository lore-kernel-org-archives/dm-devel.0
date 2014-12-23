From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Tue, 23 Dec 2014 17:24:54 +0100
Message-ID: <54999756.70303@acm.org>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>	<5491F906.1090004@kernel.dk>
	<20141217230622.GC15390@redhat.com>	<54943714.2040704@acm.org>
	<20141219153801.GA8697@redhat.com>	<20141219171438.GA6347@redhat.com>
	<5498389D.6070909@acm.org> <20141222184910.GB8054@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141222184910.GB8054@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, hch@infradead.org, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On 12/22/14 19:49, Mike Snitzer wrote:
> On Mon, Dec 22 2014 at 10:28am -0500,
> Bart Van Assche <bvanassche@acm.org> wrote:
>> Good news: with this patch my standard SRP multipath test ran fine for
>> several hours, after which I stopped the test.
> 
> Great, thanks for testing!  Did you happen to look at the performance of
> your testing?  If so, is it comparable/better/worse?

Hello Mike,

I have tried to run a performance comparison but after I had finished
the measurements without multipath and when I started multipathd I ran
into the following (typed over from the console):

BUG: unable to handle kernel NULL pointer dereference at 0000318
IP: scsi_setup_cmnd+0xe8 [scsi_mod]
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
scsi_queue_rq+0x5a5
__blk_mq_run_hw_queue+0x1cb
blk_mq_run_work_fn+0xd
process_one_work+0x133
worker_thread+0x11b
kthread+0xcd

gdb translates the above address as follows:

(gdb) list *(scsi_setup_cmnd+0xe8)
0x9568 is in scsi_setup_cmnd (include/scsi/scsi_cmnd.h:155).
150     }
151
152     /* make sure not to use it with REQ_TYPE_BLOCK_PC commands */
153     static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
154     {
155             return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
156     }
157
158     extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
159     extern void scsi_put_command(struct scsi_cmnd *);

Bart.
