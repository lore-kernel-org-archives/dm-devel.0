From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH 1/8] rqbased-dm: allow blk_get_request()
	to be called from interrupt context
Date: Fri, 22 Dec 2006 18:32:22 +0100
Message-ID: <20061222173220.GU17199@kernel.dk>
References: <20061219.171119.18572687.k-ueda@ct.jp.nec.com>
	<20061220134848.GF10535@kernel.dk>
	<20061220.125002.71083198.k-ueda@ct.jp.nec.com>
	<20061222140139.GA26033@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061222140139.GA26033@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, agk@redhat.com, mchristi@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Fri, Dec 22 2006, Christoph Hellwig wrote:
> On Wed, Dec 20, 2006 at 12:50:02PM -0500, Kiyoshi Ueda wrote:
> > Because I'd like to use blk_get_request() in q->request_fn()
> > which can be called from interrupt context like below:
> >   scsi_io_completion -> scsi_end_request -> scsi_next_command
> >   -> scsi_run_queue -> blk_run_queue -> q->request_fn
> 
> > Or request should not be allocated in q->request_fn() anyway?
> > Do you have any other ideas?
> 
> The right long-term fix is to make sure request_fn is only ever called
> from process context.  This means moving retry handling to a thread instead
> of a softirq, but this will need careful performance testing and tweaking.

It's a lot more than just retry handling. Most driver reinvoke queueing
from the completion handling, so basically most of the time request_fn
is run from either softirq (like SCSI) or interrupt context (like IDE).

-- 
Jens Axboe
