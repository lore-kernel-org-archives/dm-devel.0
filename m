From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Sat, 5 Aug 2017 10:46:04 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1708051038550.25961@file01.intranet.prod.int.rdu2.redhat.com>
References: <20170802122750.12216-1-gmazyland@gmail.com> <20170802125509.GA18977@lst.de> <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com> <20170805134418.GB17694@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170805134418.GB17694@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids



On Sat, 5 Aug 2017, Christoph Hellwig wrote:

> 
> On Thu, Aug 03, 2017 at 10:10:55AM -0400, Mikulas Patocka wrote:
> > That dm-crypt commit that uses bio integrity payload came 3 months before 
> > 7c20f11680a441df09de7235206f70115fbf6290 and it was already present in 
> > 4.12.
> 
> And on it's own that isn't an argument if your usage is indeed wrong,
> and that's why we are having this discussion.
> 
> > The patch 7c20f11680a441df09de7235206f70115fbf6290 changes it so that 
> > bio->bi_end_io is not changed and bio_integrity_endio is called directly 
> > from bio_endio if the bio has integrity payload. The unintended 
> > consequence of this change is that when a request with integrity payload 
> > is finished and bio_endio is called for each cloned bio, the verification 
> > routine bio_integrity_verify_fn is called for every level in the stack (it 
> > used to be called only for the lowest level in 4.12). At different levels 
> > in the stack, the bio may have different bi_sector value, so the repeated 
> > verification can't succeed.
> 
> We can simply add another bio flag to get back to the previous
> behavior.  That being said thing to do in the end is to verify it
> at the top of the stack, and not the bottom eventuall.  I can cook
> up a patch for that.

The sector number in the integrity tag must match the physical sector 
number. So, it must be verified at the bottom.

If the sector number in the integrity tag matched the logical sector 
number in the logical volume, it would create a lot of problems - for 
example, it would be impossible to move the logical volume and it would be 
impossible to copy the full physical volume.

> > I think the patch 7c20f11680a441df09de7235206f70115fbf6290 should be 
> > reverted and it should be reworked for the next merge window, so that it 
> > calls bio_integrity_verify_fn only for the lowest level.
> 
> And with this you will just reintroduce the memory leak for
> on-stack bios we've fixed.
> 
> I'll take a look at not calling the verify function for every level,
> which is wrong, and in the meantime we can discuss the uses and abuses
> of the bio integrity code by dm in the separate subthread.

It would be usefull if dm-crypt can put the autenticated tag directly into 
the integrity data. But for that usage, the lowest level physical driver 
must not generate or verify the integrity data - it must just read them 
and write them.

Mikulas
