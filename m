From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC PATCH 1/8] rqbased-dm: allow blk_get_request()
 to be called from interrupt context
Date: Wed, 20 Dec 2006 12:50:02 -0500 (EST)
Message-ID: <20061220.125002.71083198.k-ueda@ct.jp.nec.com>
References: <20061219.171119.18572687.k-ueda@ct.jp.nec.com>
	<20061220134848.GF10535@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061220134848.GF10535@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, mchristi@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Jens,

Thank you for the comment.

On Wed, 20 Dec 2006 14:48:49 +0100, Jens Axboe <jens.axboe@oracle.com> wrote:
> >  static struct request *get_request(request_queue_t *q, int rw, struct bio *bio,
> > -				   gfp_t gfp_mask)
> > +				   gfp_t gfp_mask, unsigned long *flags)
> >  {
> >  	struct request *rq = NULL;
> >  	struct request_list *rl = &q->rq;
> > @@ -2119,7 +2120,10 @@ static struct request *get_request(reque
> >  	if (priv)
> >  		rl->elvpriv++;
> >  
> > -	spin_unlock_irq(q->queue_lock);
> > +	if (flags)
> > +		spin_unlock_irqrestore(q->queue_lock, *flags);
> > +	else
> > +		spin_unlock_irq(q->queue_lock);
> 
> Big NACK on this - it's not only really ugly, it's also buggy to pass
> interrupt flags as function arguments. As you also mention in the 0/1
> mail, this also breaks CFQ.
> 
> Why do you need in-interrupt request allocation?
 
Because I'd like to use blk_get_request() in q->request_fn()
which can be called from interrupt context like below:
  scsi_io_completion -> scsi_end_request -> scsi_next_command
  -> scsi_run_queue -> blk_run_queue -> q->request_fn

Generally, device-mapper (dm) clones an original I/O and dispatches
the clones to underlying destination devices.
In the request-based dm patch, the clone creation and the dispatch
are done in q->request_fn().  To create the clone, blk_get_request()
is used to get a request from underlying destination device's queue.
By doing that in q->request_fn(), dm can deal with struct request
after bios are merged by __make_request().

Do you think creating another function like blk_get_request_nowait()
is acceptable?
Or request should not be allocated in q->request_fn() anyway?
Do you have any other ideas?

> -- 
> Jens Axboe

Thanks,
Kiyoshi Ueda
