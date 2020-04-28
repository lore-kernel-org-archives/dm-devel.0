From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] block: bypass ->make_request_fn for
	blk-mq drivers
Date: Tue, 28 Apr 2020 14:40:47 -0400
Message-ID: <20200428184047.GB17609@redhat.com>
References: <20200425075336.721021-1-hch@lst.de>
	<20200425075336.721021-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200425075336.721021-4-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-bcache@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Apr 25 2020 at  3:53am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Call blk_mq_make_request when no ->make_request_fn is set.  This is
> safe now that blk_alloc_queue always sets up the pointer for make_request
> based drivers.  This avoids an indirect call in the blk-mq driver I/O
> fast path, which is rather expensive due to spectre mitigations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes me cringe thinking about all the indirect calls sprinkled
throughout DM...

Acked-by: Mike Snitzer <snitzer@redhat.com>
