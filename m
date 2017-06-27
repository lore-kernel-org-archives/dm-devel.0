From: Jens Axboe <axboe@kernel.dk>
Subject: Re: move bounce limits settings into the drivers
Date: Tue, 27 Jun 2017 12:10:46 -0600
Message-ID: <393234a3-3c36-46ca-fa23-29f79faf04a1@kernel.dk>
References: <20170619072628.12894-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-1-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/19/2017 01:26 AM, Christoph Hellwig wrote:
> Currently we still default to a bounce all highmem setting for block
> drivers.  This series defaults to no bouncing and instead adds call
> to blk_queue_bounce_limit to those drivers that need it.   It also
> has a few cleanups in that area.

Looks straight forward and trivial to me, I'll pull it in for
4.13.

-- 
Jens Axboe
