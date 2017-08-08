From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Tue, 8 Aug 2017 08:47:06 +0200
Message-ID: <184e07d0-0d93-dca4-8719-37e5c9c90c89@gmail.com>
References: <20170802122750.12216-1-gmazyland@gmail.com>
 <20170802125509.GA18977@lst.de>
 <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com>
 <20170805134418.GB17694@lst.de>
 <alpine.LRH.2.02.1708051038550.25961@file01.intranet.prod.int.rdu2.redhat.com>
 <yq1y3qxdano.fsf@oracle.com>
 <alpine.LRH.2.02.1708061441120.9109@file01.intranet.prod.int.rdu2.redhat.com>
 <yq1valzbcpk.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1valzbcpk.fsf@oracle.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

On 08/07/2017 05:48 PM, Martin K. Petersen wrote:
> 
>> If you create the integrity tag at or above device mapper level, you
>> will run into problems because the same device can be accessed using
>> device mapper and using physical volume /dev/sd*. If you create
>> integrity tags at device mapper level, they will contain device
>> mapper's logical sector number and the sector number won't match if
>> you access the device directly using /dev/sd*.
> 
> For writes, the bip seed value is adjusted every time a bio is cloned,
> sliced and diced as it traverses partitioning/MD/DM. And then at the
> bottom of the stack, the ref tag values in the protection information
> buffer are verified against the adjusted seed value and remapped
> according to the starting logical block number. The reverse is taking
> place for reads.
> 
> This is much faster than doing a remapping of the actual protection
> buffer values every time the I/O transitions from one address space to
> the other. In addition, some HBA hardware allows us to program the PI
> engine with the seed value. So the submitter value to LBA conversion can
> be done on the fly in hardware.

Yes, this is how enterprise storage works and how the PI was designed.

For authenticated encryption with additional data (AEAD) we have to authenticate
the sector number as well (as part or additional data - authenticated
but not encrypted part).

Unfortunately the whole design cannot work this way if the AEAD is implemented
on some higher layer. (Higher layer has a big advantage that you do not need to trust
underlying storage stack because you will detect even intentional tampering with data.)
 So, only the layer that own the keys (here dmcrypt) can calculate or verify auth. tags
(and then decrypt data). Nobody else can "remap" this sector in tag - without the key
you cannot recalculate auth. tags.

In other words, we just treat the whole additional data (delivered in bio-integrity)
as "Application tag" (if using DIF terminology...)


Anyway, could we please fix the 4.13 kernel now to not crash with that
dm-integrity use? This is urgent for people that already play with dm-integrity from 4.12.


If you want a following discussion, I would really welcome to see what exactly
is wrong because I think we used the bio-integrity interface through existing
API and according to doc.
Just we are unfortunately the first user for own profile (different than
these defined in T10).
And I think it can help in future to people that will try to implement
bio-integrity-aware filesystem as well.

Thanks,
Milan
