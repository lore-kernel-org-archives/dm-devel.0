From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Thu, 1 Sep 2016 14:23:31 +0000
Message-ID: <BLUPR02MB1683D3D8F604FEB429143A4381E20@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<82ff8574-8b73-8ba3-9098-741060f38fca@sandisk.com>
	<20160901031355.GB4741@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On 08/31/16 20:14, Mike Snitzer wrote:
> On Wed, Aug 31 2016 at  6:18pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>
>> Ensure that all ongoing dm_mq_queue_rq() and dm_mq_requeue_request()
>> calls have stopped before setting the "queue stopped" flag. This
>> allows to remove the "queue stopped" test from dm_mq_queue_rq() and
>> dm_mq_requeue_request(). Use BLK_MQ_S_STOPPED instead of
>> QUEUE_FLAG_STOPPED.
>
> At first glance, at a minimum this patch needs a better header.  It
> seems you're doing 2 things:
>
> 1) using blk_mq_{freeze,unfreeze}_queue() actually makes dm_stop_queue()
>    work for blk-mq?  Whereby fixing blk-mq race(s)?
>
> 2) switching away from QUEUE_FLAG_STOPPED to BLK_MQ_S_STOPPED (via
>    blk_mq_queue_stopped)
>    - not clear to me that dm-mq's use of QUEUE_FLAG_STOPPED wasn't fine;
>      NVMe also uses it for blk-mq

Hello Mike,

Adding the blk_mq_{freeze,unfreeze}_queue() calls is indeed what fixes 
the race conditions related to stopping dm queues and what makes 
dm_stop_queue() work.

If other blk-mq users and developers agree that QUEUE_FLAG_STOPPED 
should be set for stopped blk-mq queues then I think the code to set 
that flag should be moved into the blk-mq core. However, setting that 
flag for blk-mq queues seems redundant to me. Hence my proposal to 
introduce blk_mq_queue_stopped() instead.

Bart.
