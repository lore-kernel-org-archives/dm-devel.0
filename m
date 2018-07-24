From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: allow max_discard_segments to be
	stacked
Date: Tue, 24 Jul 2018 13:47:11 -0700
Message-ID: <ba30bcde-3d3c-f1ea-ac61-cf483073f999@kernel.dk>
References: <20180720185738.11646-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180720185738.11646-1-snitzer@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

On 7/20/18 11:57 AM, Mike Snitzer wrote:
> Set max_discard_segments to USHRT_MAX in blk_set_stacking_limits() so
> that blk_stack_limits() can stack up this limit for stacked devices.
> 
> before:
> 
> $ cat /sys/block/nvme0n1/queue/max_discard_segments
> 256
> $ cat /sys/block/dm-0/queue/max_discard_segments
> 1
> 
> after:
> 
> $ cat /sys/block/nvme0n1/queue/max_discard_segments
> 256
> $ cat /sys/block/dm-0/queue/max_discard_segments
> 256

Applied, thanks Mike.

-- 
Jens Axboe
