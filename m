From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 05/24] io-controller: Modify cfq to make use
	of flat elevator fair queuing
Date: Thu, 30 Jul 2009 14:30:14 -0400
Message-ID: <20090730183014.GA6067@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
	<1248467274-32073-6-git-send-email-vgoyal@redhat.com>
	<4A71BF76.6040709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A71BF76.6040709@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jerome Marchand <jmarchan@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Thu, Jul 30, 2009 at 05:42:46PM +0200, Jerome Marchand wrote:
> Vivek Goyal wrote:
> > @@ -1616,11 +1234,12 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
> >  	struct cfq_data *cfqd = cic->key;
> >  	struct cfq_queue *cfqq;
> >  	unsigned long flags;
> > +	struct request_queue *q = cfqd->queue;
> 
> cfqd may be NULL here. We'd better test it before using it.
> 

Thanks Jerome. 

Actually I will drop this chage altogether. This is not required. I don't
know why did I change original code to introduce another local variable. 

Thanks
Vivek

> >  
> >  	if (unlikely(!cfqd))
> >  		return;
> >  
> > -	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
> > +	spin_lock_irqsave(q->queue_lock, flags);
> >  
> >  	cfqq = cic->cfqq[BLK_RW_ASYNC];
> >  	if (cfqq) {
> > @@ -1637,7 +1256,7 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
> >  	if (cfqq)
> >  		cfq_mark_cfqq_prio_changed(cfqq);
> >  
> > -	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> >  }
> >  
> >  static void cfq_ioc_set_ioprio(struct io_context *ioc)
> 
> 
> --- block/cfq-iosched.c.orig	2009-07-29 10:22:08.000000000 +0200
> +++ block/cfq-iosched.c	2009-07-30 17:25:05.000000000 +0200
> @@ -1271,11 +1271,12 @@ static void changed_ioprio(struct io_con
>  	struct cfq_data *cfqd = cic->key;
>  	struct cfq_queue *cfqq;
>  	unsigned long flags;
> -	struct request_queue *q = cfqd->queue;
> +	struct request_queue *q;
>  
>  	if (unlikely(!cfqd))
>  		return;
>  
> +	q = cfqd->queue;
>  	spin_lock_irqsave(q->queue_lock, flags);
>  
>  	cfqq = cic->cfqq[BLK_RW_ASYNC];
