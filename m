From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/13] block_dev: propagate bio_iov_iter_get_pages
        error in __blkdev_direct_IO
Date: Sun, 28 May 2017 11:49:38 +0200
Message-ID: <20170528094938.GD14199@lst.de>
References: <20170526085620.3113-1-hch@lst.de> <20170526085620.3113-8-hch@lst.de> <b5bc89a2-a17f-7e98-a767-bfa0c90afaac@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b5bc89a2-a17f-7e98-a767-bfa0c90afaac@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Fri, May 26, 2017 at 11:12:31AM +0200, Johannes Thumshirn wrote:
> On 05/26/2017 10:56 AM, Christoph Hellwig wrote:
> > Once we move the block layer to its own status code we'll still want to
> > propagate the bio_iov_iter_get_pages, so restructure __blkdev_direct_IO
> > to take ret into account when returning the errno.
> > ---
> 
> 
> -ENOSIGNOFF?

Fixed.
