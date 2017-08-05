From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Sat, 5 Aug 2017 15:44:18 +0200
Message-ID: <20170805134418.GB17694@lst.de>
References: <20170802122750.12216-1-gmazyland@gmail.com> <20170802125509.GA18977@lst.de> <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids


On Thu, Aug 03, 2017 at 10:10:55AM -0400, Mikulas Patocka wrote:
> That dm-crypt commit that uses bio integrity payload came 3 months before 
> 7c20f11680a441df09de7235206f70115fbf6290 and it was already present in 
> 4.12.

And on it's own that isn't an argument if your usage is indeed wrong,
and that's why we are having this discussion.

> The patch 7c20f11680a441df09de7235206f70115fbf6290 changes it so that 
> bio->bi_end_io is not changed and bio_integrity_endio is called directly 
> from bio_endio if the bio has integrity payload. The unintended 
> consequence of this change is that when a request with integrity payload 
> is finished and bio_endio is called for each cloned bio, the verification 
> routine bio_integrity_verify_fn is called for every level in the stack (it 
> used to be called only for the lowest level in 4.12). At different levels 
> in the stack, the bio may have different bi_sector value, so the repeated 
> verification can't succeed.

We can simply add another bio flag to get back to the previous
behavior.  That being said thing to do in the end is to verify it
at the top of the stack, and not the bottom eventuall.  I can cook
up a patch for that.

> I think the patch 7c20f11680a441df09de7235206f70115fbf6290 should be 
> reverted and it should be reworked for the next merge window, so that it 
> calls bio_integrity_verify_fn only for the lowest level.

And with this you will just reintroduce the memory leak for
on-stack bios we've fixed.

I'll take a look at not calling the verify function for every level,
which is wrong, and in the meantime we can discuss the uses and abuses
of the bio integrity code by dm in the separate subthread.
