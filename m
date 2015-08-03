From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Mon, 3 Aug 2015 10:12:49 +0200
Message-ID: <20150803081249.GF14980@8bytes.org>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com>
 <55B7D054.4070308@maya.org>
 <20150728192908.GA25264@redhat.com>
 <55BCD5A7.2080708@maya.org>
 <55BE1D5E.6020709@maya.org>
 <alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
 <55BE65E6.7060901@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55BE65E6.7060901@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@fb.com>, linux-pci <linux-pci@vger.kernel.org>
List-Id: dm-devel.ids

On Sun, Aug 02, 2015 at 08:48:06PM +0200, Andreas Hartmann wrote:
> >>https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=34b48db66e08ca1c1bc07cf305d672ac940268dc
> >>
> >>block: remove artifical max_hw_sectors cap

Looking at the patch, it seems to me that it just uncovered a bug
elsewhere. It looks like an underlying driver doesn't expect the
big io-requests that the patch enables and does not dma-map the whole
target buffer, causing the IO_PAGE_FAULTs later.


	Joerg
