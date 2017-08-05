From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Sat, 05 Aug 2017 16:25:47 -0400
Message-ID: <yq1y3qxdano.fsf@oracle.com>
References: <20170802122750.12216-1-gmazyland@gmail.com>
        <20170802125509.GA18977@lst.de>
        <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com>
        <20170805134418.GB17694@lst.de>
        <alpine.LRH.2.02.1708051038550.25961@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1708051038550.25961@file01.intranet.prod.int.rdu2.redhat.com>
        (Mikulas Patocka's message of "Sat, 5 Aug 2017 10:46:04 -0400 (EDT)")
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids


Mikulas,

> The sector number in the integrity tag must match the physical sector 
> number. So, it must be verified at the bottom.

The ref tag seed matches the submitter block number (typically block
layer sector for the top device) and is remapped to and from the LBA by
the SCSI disk driver or HBA firmware.

So the verification is designed to be done by the top level entity that
attaches the protection information to the bio. In this case
bio_integrity_prep().

-- 
Martin K. Petersen	Oracle Linux Engineering
