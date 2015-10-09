From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Fri, 9 Oct 2015 12:40:23 +0200
Message-ID: <20151009104023.GN28811@8bytes.org>
References: <alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
 <20150929162042.GR3036@8bytes.org>
 <560BF73F.8000008@maya.org>
 <20151006101356.GE12506@8bytes.org>
 <56141507.7040103@maya.org>
 <20151007154005.GH28811@8bytes.org>
 <56155028.7060906@maya.org>
 <20151008173007.GL28811@8bytes.org>
 <5616BCF4.10104@maya.org>
 <5616C850.2000906@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5616C850.2000906@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@fb.com>, linux-pci <linux-pci@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Thu, Oct 08, 2015 at 09:47:28PM +0200, Andreas Hartmann wrote:
> Got it. I attached the complete oops and the output of objdump.
> 
> Kernel was linux 4.3-rc4
> 
> 
> This time, the oops was caused by the second PCI card I'm passing
> through to another VM (the ath9k card worked fine this time - chance?).
> I added the lspci output to the attached file, too.

Okay, thanks, this makes more sense to me. It looks like you are
attaching a 32bit PCI device, which has an alias. This is definitly a
bug in the AMD IOMMU driver and I have an idea how to fix it. I'll look
into this after lunch.



	Joerg
