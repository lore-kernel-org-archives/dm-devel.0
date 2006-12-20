From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH 0/8] rqbased-dm: request-based
	device-mapper
Date: Wed, 20 Dec 2006 19:51:43 +0100
Message-ID: <20061220185143.GK10535@kernel.dk>
References: <20061219.171026.115904158.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061219.171026.115904158.k-ueda@ct.jp.nec.com>
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

On Tue, Dec 19 2006, Kiyoshi Ueda wrote:
> For block layer maintainer and developers:
>   This patch set has 2 block layer changes below.
>     - Changed blk_get_request() to allow calls from interrupt context
>       so that queue's request_fn can use it.  (PATCH 1/8)
>       (*) The behaviour of CFQ (or other scheduler which depends on
>           "current") may be affected when blk_get_request() is called
>           in interrupt context, because "current" is not the process
>           which issue the original request.

This we already covered.

>     - Added new "end_io_first" hook to __end_that_request_first()
>       and struct request.  (PATCH 2/8)

This I still need an explanation for.

>   And I'm thinking about:
>     - Moving blk_clone_rq() to ll_rw_blk.c from dm.c. (PATCH 7/8)

That definitely should be core code. I see no problem in that.

-- 
Jens Axboe
