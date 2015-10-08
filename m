From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Thu, 8 Oct 2015 18:39:58 +0200
Message-ID: <20151008163957.GK28811@8bytes.org>
References: <55FE5740.2060701@maya.org>
 <20150929152100.GL3036@8bytes.org>
 <alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
 <20150929162042.GR3036@8bytes.org>
 <560BF73F.8000008@maya.org>
 <20151006101356.GE12506@8bytes.org>
 <56141507.7040103@maya.org>
 <56148A1B.5060506@maya.org>
 <20151007161022.GI28811@8bytes.org>
 <56154DEA.5050901@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56154DEA.5050901@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@fb.com>, linux-pci <linux-pci@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Wed, Oct 07, 2015 at 06:52:58PM +0200, Andreas Hartmann wrote:
> To reproduce the error:
> First I mounted /daten2, afterwards /raid/mt, which produces the errors.
> The ssd mounts have been already active (during boot by fstab).

Okay, I spent the day on that problem, and managed to reproduce it here
on one of my AMD IOMMU boxes. I wasn't an easy journey, as I can only
reproduce it if I setup the crypto partition and everything above that
(like mounting the lvm volumes) _after_ the system has finished booting.
If everything is setup during system boot it works fine and I don't see
any IO_PAGE_FAULTS.

I also tried kernel v4.3-rc4 first, to have it tested with a
self-compiled kernel. It didn't show up there, so I built a 4.1.0, where
it showed up again. Something seems to have fixed the issue in the
latest kernels.

So I looked a little bit around at the commits that were merged into the
respective parts involved here, and found this one:

	586b286 dm crypt: constrain crypt device's max_segment_size to PAGE_SIZE

The problem fixed with this commit looks quite similar to what you have
seen (execpt that there was no IOMMU involved). So I cherry-picked that
commit on 4.1.0 and tested that. The problem was gone.

So it looks like it was a dm-crypt issue, the patch went into v4.3-rc3,
either this kernel of rc4 should fix the problem for you too. Can you
please verify this is fixed for you too with v4.3-rc4?


Thanks,

	Joerg
