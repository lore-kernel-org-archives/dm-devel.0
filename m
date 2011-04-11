From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Mon, 11 Apr 2011 18:59:30 -0400
Message-ID: <20110411225930.GB32310@infradead.org>
References: <20110303221353.GA10366@redhat.com>
 <4D761E0D.8050200@fusionio.com>
 <20110308202100.GA31744@redhat.com>
 <4D76912C.9040705@fusionio.com>
 <20110308220526.GA393@redhat.com>
 <20110310005810.GA17911@redhat.com>
 <20110405130541.6c2b5f86@notabene.brown>
 <20110411145022.710c30e9@notabene.brown>
 <20110411165923.GA15442@infradead.org>
 <20110412071428.4aa92c6e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110412071428.4aa92c6e@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "hch@infradead.org" <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Apr 12, 2011 at 07:14:28AM +1000, NeilBrown wrote:
> 
> My understanding of that was that the calling requirement of
> __elv_add_request is that the queue spinlock is held and that interrupts are
> disabled.
> So rather than possible enabling and disabling interrupts several times as
> different queue are handled, the code just disabled interrupts once, and
> then just take the spinlock once for each different queue.
> 
> The whole point of the change to plugging was to take locks less often.
> Disabling interrupts less often is presumably an analogous goal.
> 
> Though I agree that a comment would help.
> 
> 	q = NULL;
> +	/* Disable interrupts just once rather than using spin_lock_irq/sin_unlock_irq
> 	 * variants
> 	 */
> 	local_irq_save(flags);
> 
> 
> assuming my analysis is correct.

Your explanation does make sense to be now that you explain it.  I
didn't even thing of that variant before.
