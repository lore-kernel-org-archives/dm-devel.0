From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Sun, 6 Aug 2017 14:49:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1708061441120.9109@file01.intranet.prod.int.rdu2.redhat.com>
References: <20170802122750.12216-1-gmazyland@gmail.com> <20170802125509.GA18977@lst.de> <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com> <20170805134418.GB17694@lst.de> <alpine.LRH.2.02.1708051038550.25961@file01.intranet.prod.int.rdu2.redhat.com>
 <yq1y3qxdano.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1y3qxdano.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com
List-Id: dm-devel.ids



On Sat, 5 Aug 2017, Martin K. Petersen wrote:

> Mikulas,
> 
> > The sector number in the integrity tag must match the physical sector 
> > number. So, it must be verified at the bottom.
> 
> The ref tag seed matches the submitter block number (typically block
> layer sector for the top device) and is remapped to and from the LBA by
> the SCSI disk driver or HBA firmware.
> 
> So the verification is designed to be done by the top level entity that
> attaches the protection information to the bio. In this case
> bio_integrity_prep().

bio_integrity_prep is called by blk_queue_bio - that is the lowest level 
physical disk, not the top level. It is not called by device mapper.

Documentation/block/data-integrity.txt says that bio_integrity_prep() can 
be called by integrity-aware filesystem, but it seems that no such 
filesystem exists.

If you create the integrity tag at or above device mapper level, you will 
run into problems because the same device can be accessed using device 
mapper and using physical volume /dev/sd*. If you create integrity tags at 
device mapper level, they will contain device mapper's logical sector 
number and the sector number won't match if you access the device directly 
using /dev/sd*.

> -- 
> Martin K. Petersen	Oracle Linux Engineering

Mikulas
