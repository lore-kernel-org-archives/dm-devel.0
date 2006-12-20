From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH 1/8] rqbased-dm: allow blk_get_request()
	to be called from interrupt context
Date: Wed, 20 Dec 2006 20:17:33 +0100
Message-ID: <20061220191730.GL10535@kernel.dk>
References: <20061220.125002.71083198.k-ueda@ct.jp.nec.com>
	<000001c7246a$ae31c8a0$ff0da8c0@amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <000001c7246a$ae31c8a0$ff0da8c0@amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, mchristi@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 20 2006, Chen, Kenneth W wrote:
> Kiyoshi Ueda wrote on Wednesday, December 20, 2006 9:50 AM
> > On Wed, 20 Dec 2006 14:48:49 +0100, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > Big NACK on this - it's not only really ugly, it's also buggy to pass
> > > interrupt flags as function arguments. As you also mention in the 0/1
> > > mail, this also breaks CFQ.
> > > 
> > > Why do you need in-interrupt request allocation?
> >  
> > Because I'd like to use blk_get_request() in q->request_fn()
> > which can be called from interrupt context like below:
> >   scsi_io_completion -> scsi_end_request -> scsi_next_command
> >   -> scsi_run_queue -> blk_run_queue -> q->request_fn
> > 
> > [ ...]
> > 
> > Do you think creating another function like blk_get_request_nowait()
> > is acceptable?
> 
> You don't need to create another function.  blk_get_request already
> have both wait and nowait semantics via gfp_mask argument. If you can
> not block, then clear __GFP_WAIT bit in the mask before calling
> blk_get_request.

Doesn't work, get_request() assumes that the caller grabbed the queue
lock and disabled interrupts, and does an unconditionaly

        spin_unlock_irq()

inside it. So you can NEVER use get_request() for even GFP_ATOMIC
allocations, as it assumes the original context was a process context.

-- 
Jens Axboe
