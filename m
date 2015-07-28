From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: add a bi_error field to struct bio
Date: Tue, 28 Jul 2015 13:12:49 +0200
Message-ID: <20150728111249.GA19647@lst.de>
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de> <55AFE643.5000704@kernel.dk> <55B01252.90004@kernel.dk> <20150724104946.GA25145@lst.de> <55B2699D.6010400@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55B2699D.6010400@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Jul 24, 2015 at 10:36:45AM -0600, Jens Axboe wrote:
> Right, I don't think we need to do that though. If you look at the flags 
> usage, it's all over the map. Some use test/set_bit, some set it just by 
> OR'ing the mask. There's no reason we can't make this work without relying 
> on set/test_bit, and then shrink it to an unsigned int.

Yes, the current mess doesn't look kosher.  The bvec pool bits don't
really make it better.

But do we really need the cmpxchg hack? Seems like most flags aren't
exposed to concurrency at all, althugh this would need a careful audit.
