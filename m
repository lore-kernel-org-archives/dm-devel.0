From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Wed, 9 Aug 2017 16:07:23 +0200
Message-ID: <20170809140723.GA26843@lst.de>
References: <20170802122750.12216-1-gmazyland@gmail.com> <20170802125509.GA18977@lst.de> <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com> <20170805134418.GB17694@lst.de> <yq13795epil.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq13795epil.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Aug 05, 2017 at 04:19:30PM -0400, Martin K. Petersen wrote:
> A bio flag is probably the path of least resistance. It already exists,
> actually: BIP_BLOCK_INTEGRITY. But we'll need to make sure it gets
> masked out when a bio is cloned. And then we can key off of that and
> REQ_OP_READ in the endio function.

bio_integrity_clone doesn't even clone it - it allocates a new
bip and then only copies over bip_vec, bip_vcnt and bit_iter.

I'll preparate a patch for this and will send it out together with
the orginal hotfix for the verify_fn, which also needs a trivial
line length fix anyway.
