From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Mon, 12 Oct 2015 08:34:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510120833390.8783@file01.intranet.prod.int.rdu2.redhat.com>
References: <20151006101356.GE12506@8bytes.org> <56141507.7040103@maya.org> <56148A1B.5060506@maya.org> <20151007161022.GI28811@8bytes.org> <56154DEA.5050901@maya.org> <20151008163957.GK28811@8bytes.org> <5616B436.1000802@maya.org> <5616C998.1010309@maya.org>
 <56174EA6.7000106@maya.org> <56178599.6010807@maya.org> <20151009145951.GC27420@8bytes.org> <5617FD6E.70802@maya.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-397221843-1444653267=:8783"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <5617FD6E.70802@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@fb.com>, linux-pci <linux-pci@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-397221843-1444653267=:8783
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT



On Fri, 9 Oct 2015, Andreas Hartmann wrote:

> Hello Jörg,
> 
> On 10/09/2015 at 04:59 PM, Joerg Roedel wrote:
> > On Fri, Oct 09, 2015 at 11:15:05AM +0200, Andreas Hartmann wrote:
> >> v4.3-rc4 isn't usable at all for me as long as is hangs the machine on
> >> the necessary PCI passthrough for VMs (I need them).
> > 
> > If the fix I just sent you works, could you please test this again with
> > a (patched) v4.3-rc4 kernel?
> 
> Your IOMMU-patch works fine - but the ata-problem can be seen here, too.
> Same behavior as with 4.1.10.

Could you try another ata disk? (copy the whole filesystem to it and run 
the same test)

It may be bug in disk's firmware.

Mikulas
--185206533-397221843-1444653267=:8783--
