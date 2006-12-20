From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC PATCH 1/8] rqbased-dm: allow blk_get_request()
 to be called from interrupt context
Date: Wed, 20 Dec 2006 16:55:49 -0500 (EST)
Message-ID: <20061220.165549.39151582.k-ueda@ct.jp.nec.com>
References: <20061220134848.GF10535@kernel.dk>
	<20061220.125002.71083198.k-ueda@ct.jp.nec.com>
	<20061220184917.GJ10535@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061220184917.GJ10535@kernel.dk>
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

On Wed, 20 Dec 2006 19:49:17 +0100, Jens Axboe <jens.axboe@oracle.com> wrote:
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
> > Generally, device-mapper (dm) clones an original I/O and dispatches
> > the clones to underlying destination devices.
> > In the request-based dm patch, the clone creation and the dispatch
> > are done in q->request_fn().  To create the clone, blk_get_request()
> > is used to get a request from underlying destination device's queue.
> > By doing that in q->request_fn(), dm can deal with struct request
> > after bios are merged by __make_request().
> > 
> > Do you think creating another function like blk_get_request_nowait()
> > is acceptable?
> > Or request should not be allocated in q->request_fn() anyway?
> 
> You should not be allocating requests from that path, for a number of
> reasons.

Could I hear the reasons for my further work if possible?
Because of breaking current CFQ?  And is there any reason?


> The design isn't very nice either.
> 
> The easy way out would be to punt to a workqueue to handle the requests.
> 
> An alternative way would be to set aside some requests that you can get
> at without allocation (maintain a little freelist of manually allocated
> requests), and retrieve a free one from there when inside request_fn. If
> you run out, just bail out of request_fn and make sure to reinvoke it
> when some of your previously issued requests complete and are added back
> to that freelist.

Thank you for the suggestions.
OK, I'll think other designs based on your suggestions.
 
Thanks,
Kiyoshi Ueda
