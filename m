From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: add QUEUE_FLAG_NOWAIT
Date: Thu, 24 Sep 2020 15:40:39 +0200
Message-ID: <20200924134039.GA4882@lst.de>
References: <20200923200652.11082-1-snitzer@redhat.com> <20200923200652.11082-2-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200923200652.11082-2-snitzer@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Sep 23, 2020 at 04:06:51PM -0400, Mike Snitzer wrote:
> Add QUEUE_FLAG_NOWAIT to allow a block device to advertise support for
> REQ_NOWAIT. Bio-based devices may set QUEUE_FLAG_NOWAIT where
> applicable.
> 
> Update QUEUE_FLAG_MQ_DEFAULT to include QUEUE_FLAG_NOWAIT.  Also
> update submit_bio_checks() to verify it is set for REQ_NOWAIT bios.
> 
> Reported-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
