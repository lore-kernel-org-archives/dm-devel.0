From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 3/5] dm-rq: return BLK_STS_* from map_request()
Date: Mon, 22 Jan 2018 13:35:45 +0800
Message-ID: <20180122053544.GB1570@ming.t460p>
References: <20180122033550.27855-1-ming.lei@redhat.com>
 <20180122033550.27855-4-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180122033550.27855-4-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Mon, Jan 22, 2018 at 11:35:48AM +0800, Ming Lei wrote:
> Except for DM_MAPIO_REQUEUE, map_request() handles other dispatch exception
> already, so return BLK_STS_* from map_request() directly.
> 
> Another change is that if dm_dispatch_clone_request() returns
> BLK_STS_DEV_RESOURCE from underlying queue, this status is returned
> to blk-mq too, since underlying queue's RESTART can handle dm-rq's
> RESTART in this case.

Hammm, this is obvious wrong, :-(

-- 
Ming
