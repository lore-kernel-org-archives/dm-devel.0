From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] block: fix an integer overflow in logical block size
Date: Thu, 16 Jan 2020 11:02:44 +0800
Message-ID: <20200116030244.GB24105@ming.t460p>
References: <alpine.LRH.2.02.2001150833180.31494@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2001150833180.31494@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-block@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 15, 2020 at 08:35:25AM -0500, Mikulas Patocka wrote:
> Logical block size has type unsigned short. That means that it can be at
> most 32768. However, there are architectures that can run with 64k pages
> (for example arm64) and on these architectures, it may be possible to
> create block devices with 64k block size.

The patch looks fine, and other drivers(loop, nbd, virtio_blk, ...) allow
user to pass customized logical block size, and the passed size can be > 32k.

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming
