From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Thu, 1 Sep 2016 11:50:51 -0400
Message-ID: <20160901155051.GA11353@redhat.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<82ff8574-8b73-8ba3-9098-741060f38fca@sandisk.com>
	<20160901031355.GB4741@redhat.com>
	<BLUPR02MB1683D3D8F604FEB429143A4381E20@BLUPR02MB1683.namprd02.prod.outlook.com>
	<20160901150503.GA11074@redhat.com>
	<ca45a2b1-99bc-1779-3b4f-a03343ccbd9a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ca45a2b1-99bc-1779-3b4f-a03343ccbd9a@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Sep 01 2016 at 11:31am -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 09/01/2016 08:05 AM, Mike Snitzer wrote:
> >I've staged most of your changes (with slight tweaks), see:
> >https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.9
> >
> >Only remaining issue is the queue dying race(s) in dm-multipath.
> 
> Thanks Mike! Two minor comments though:
> * In dm_start_queue(), I think that the queue_flag_clear_unlocked()
>   call should be converted into queue_flag_clear() and that it should
>   be protected by the block layer queue lock. Every call of
>   queue_flag_clear_unlocked() after block device initialization has
>   finished is wrong if blk_cleanup_queue() can be called concurrently.

OK, I'll have a look.

> * I think that adding blk_mq_{freeze,unfreeze}_queue() calls in
>   dm_stop_queue() not only allows to remove the "queue stopped" test
>   from dm_mq_queue_rq() but also that it allows to remove that test
>   from dm_mq_requeue_request().

I'm aware you think that but I need to circle back to
dm_mq_requeue_request() vs blk_queue_stopped().  The code as is isn't a
problem, just might be an extra check that isn't needed any more.
