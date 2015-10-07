From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Wed, 7 Oct 2015 17:40:05 +0200
Message-ID: <20151007154005.GH28811@8bytes.org>
References: <55BCD5A7.2080708@maya.org>
 <55BE1D5E.6020709@maya.org>
 <alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
 <55FE5740.2060701@maya.org>
 <20150929152100.GL3036@8bytes.org>
 <alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
 <20150929162042.GR3036@8bytes.org>
 <560BF73F.8000008@maya.org>
 <20151006101356.GE12506@8bytes.org>
 <56141507.7040103@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56141507.7040103@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@fb.com>, linux-pci <linux-pci@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Tue, Oct 06, 2015 at 08:37:59PM +0200, Andreas Hartmann wrote:
> But there is another problem w/ 4.3-rc2: Starting a VM w/ PCIe
> passthrough doesn't work any more. I'm getting the attached null pointer
> dereference and the machine hangs.

Weird, probably a do_detach call for a device that is already detached.
Anyway, I can't reproduce this here on my two AMD IOMMU machines.  Can
you please boot the machine with amd_iommu_dump on the kernel command
line and send me dmesg after boot?

Also, which device are you trying to attach to the guest (pci
bus/device/function)?

Output of lspci might also be helpful.


Thanks,

	Joerg
