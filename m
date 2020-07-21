From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] block: inherit the zoned characteristics in
 blk_stack_limits
Date: Tue, 21 Jul 2020 13:32:40 -0400
Message-ID: <20200721173240.GA21963@redhat.com>
References: <20200720061251.652457-1-hch@lst.de>
 <20200720061251.652457-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200720061251.652457-2-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, Damien.LeMoal@wdc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 20 2020 at  2:12am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Lift the code from device mapper into blk_stack_limits to inherity
> the stacking limitations.  This ensures we do the right thing for
> all stacked zoned block devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>
