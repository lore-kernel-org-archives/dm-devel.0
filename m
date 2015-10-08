From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Thu, 8 Oct 2015 19:30:07 +0200
Message-ID: <20151008173007.GL28811@8bytes.org>
References: <alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
 <55FE5740.2060701@maya.org>
 <20150929152100.GL3036@8bytes.org>
 <alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
 <20150929162042.GR3036@8bytes.org>
 <560BF73F.8000008@maya.org>
 <20151006101356.GE12506@8bytes.org>
 <56141507.7040103@maya.org>
 <20151007154005.GH28811@8bytes.org>
 <56155028.7060906@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56155028.7060906@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@fb.com>, linux-pci <linux-pci@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Wed, Oct 07, 2015 at 07:02:32PM +0200, Andreas Hartmann wrote:
> Binding the device to vfio isn't a problem (it's done before the vm is
> started). The problem occurs during start of qemu-system-x86_64 (2.3.0).
> 
> The attached dmesg.out doesn't show the trace, but the desired iommu dump.
> 
> > Also, which device are you trying to attach to the guest (pci
> > bus/device/function)?
> 
> See attached ath9k.device.

Hmm, can you also test this again with the v4.3-rc4 please? The device
you are attaching has its own group and no aliases, so I really can't
see how the trace could happen, and I can't reproduce it here either.

So I just want to make sure it is not a follow-on bug from the previous
problem.


Thanks,

	Joerg

P.S.: When you build the kernel with debug symbols and the problem
      occurs again, you can find out the source file and line where the
      bug happened with

      	$ objdump -Dlz --start-address=<rip> vmlinux | head

      Replace <rip> with the RIP from the kernel oops and the output
      should show you where in the source the bug comes from. The
      vmlinux file is in the kernels build directory.
