From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Mon, 07 Aug 2017 11:48:55 -0400
Message-ID: <yq1valzbcpk.fsf@oracle.com>
References: <20170802122750.12216-1-gmazyland@gmail.com>
        <20170802125509.GA18977@lst.de>
        <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com>
        <20170805134418.GB17694@lst.de>
        <alpine.LRH.2.02.1708051038550.25961@file01.intranet.prod.int.rdu2.redhat.com>
        <yq1y3qxdano.fsf@oracle.com>
        <alpine.LRH.2.02.1708061441120.9109@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1708061441120.9109@file01.intranet.prod.int.rdu2.redhat.com>
        (Mikulas Patocka's message of "Sun, 6 Aug 2017 14:49:23 -0400 (EDT)")
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com
List-Id: dm-devel.ids


Mikulas,

> If you create the integrity tag at or above device mapper level, you
> will run into problems because the same device can be accessed using
> device mapper and using physical volume /dev/sd*. If you create
> integrity tags at device mapper level, they will contain device
> mapper's logical sector number and the sector number won't match if
> you access the device directly using /dev/sd*.

For writes, the bip seed value is adjusted every time a bio is cloned,
sliced and diced as it traverses partitioning/MD/DM. And then at the
bottom of the stack, the ref tag values in the protection information
buffer are verified against the adjusted seed value and remapped
according to the starting logical block number. The reverse is taking
place for reads.

This is much faster than doing a remapping of the actual protection
buffer values every time the I/O transitions from one address space to
the other. In addition, some HBA hardware allows us to program the PI
engine with the seed value. So the submitter value to LBA conversion can
be done on the fly in hardware.

-- 
Martin K. Petersen	Oracle Linux Engineering
