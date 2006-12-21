From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH 1/8] rqbased-dm: allow blk_get_request()
	to be called from interrupt context
Date: Thu, 21 Dec 2006 19:21:47 +0100
Message-ID: <20061221182147.GY17199@kernel.dk>
References: <20061220184917.GJ10535@kernel.dk>
	<20061220.165549.39151582.k-ueda@ct.jp.nec.com>
	<20061221075305.GD17199@kernel.dk>
	<20061221.131118.39151032.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061221.131118.39151032.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, mchristi@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 21 2006, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> OK, I understand that.
> But I think that the block layer assumption (depending on "current")
> is not ideal.
> Anyway, thank you for the information.

(don't top post)

Well, how else would you throttle request allocations on a process
basis? IO priorities don't extend to request allocation yet, but if/when
they do, this will extend it. It may not be ideal for your situation,
but it is for a host of other uses.

It's relatively easy to do this in the driver - you need one request
allocated at init time, as a backup. Then instead of using
blk_get_request(), you use use kmalloc or kmem_cache_alloc from the
block dev rq pool. If the allocation fails and you have nothing in
flight, you grab the request you allocated at init time and use that.
Export the rq initialization as needed from ll_rw_blk.c.

And that's it, really. Without uglification to ll_rw_blk.c or stripping
features from that.

-- 
Jens Axboe
