From: Christoph Hellwig <hch@lst.de>
Subject: Re: [for-4.16 PATCH v2 2/3] block: cope with gendisk's 'queue'
        being added later
Date: Wed, 10 Jan 2018 09:32:31 +0100
Message-ID: <20180110083231.GC10185@lst.de>
References: <20180110024104.34885-1-snitzer@redhat.com> <20180110024104.34885-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110024104.34885-3-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Jan 09, 2018 at 09:41:03PM -0500, Mike Snitzer wrote:
> Since I can remember DM has forced the block layer to allow the
> allocation and initialization of the request_queue to be distinct
> operations.  Reason for this was block/genhd.c:add_disk() has required
> that the request_queue (and associated bdi) be tied to the gendisk
> before add_disk() is called -- because add_disk() also deals with
> exposing the request_queue via blk_register_queue().

Hmm.  I don't even know how that could be safe given that the disk
is live and visible to userspace once added..
