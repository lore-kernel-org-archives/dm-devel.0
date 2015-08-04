From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command: READ FPDMA
 QUEUED errors since Linux 4.0
Date: Tue, 4 Aug 2015 10:47:11 -0400
Message-ID: <20150804144711.GB24716@redhat.com>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com>
 <55B7D054.4070308@maya.org>
 <20150728192908.GA25264@redhat.com>
 <55BCD5A7.2080708@maya.org>
 <55BE1D5E.6020709@maya.org>
 <alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
 <55BE65E6.7060901@maya.org>
 <20150803081249.GF14980@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150803081249.GF14980@8bytes.org>
Sender: linux-pci-owner@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>
Cc: Andreas Hartmann <andihartmann@freenet.de>, linux-pci <linux-pci@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@fb.com>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>, Milan Broz <mbroz@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On Mon, Aug 03 2015 at  4:12am -0400,
Joerg Roedel <joro@8bytes.org> wrote:

> On Sun, Aug 02, 2015 at 08:48:06PM +0200, Andreas Hartmann wrote:
> > >>https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=34b48db66e08ca1c1bc07cf305d672ac940268dc
> > >>
> > >>block: remove artifical max_hw_sectors cap
> 
> Looking at the patch, it seems to me that it just uncovered a bug
> elsewhere. It looks like an underlying driver doesn't expect the
> big io-requests that the patch enables and does not dma-map the whole
> target buffer, causing the IO_PAGE_FAULTs later.

That patch has caused issues elsewhere too, see this 'Revert "block:
remove artifical max_hw_sectors cap"' thread (if/when lkml.org
cooperates): https://lkml.org/lkml/2015/7/20/572

But it could be that there is a need for a horkage fix for this specific
hardware? something comparable to this?:
http://git.kernel.org/linus/af34d637637eabaf49406eb35c948cd51ba262a6

We are running out of time to fix these whack-a-mole issues in 4.2
though.
