From: Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Mon, 12 Oct 2015 14:07:20 +0200
Message-ID: <561BA278.4010702@maya.org>
References: <20151006101356.GE12506@8bytes.org> <56141507.7040103@maya.org>
 <56148A1B.5060506@maya.org> <20151007161022.GI28811@8bytes.org>
 <56154DEA.5050901@maya.org> <20151008163957.GK28811@8bytes.org>
 <5616B436.1000802@maya.org> <5616C998.1010309@maya.org>
 <56174EA6.7000106@maya.org> <56178599.6010807@maya.org>
 <20151009145951.GC27420@8bytes.org> <5617FD6E.70802@maya.org>
 <561A54B3.5000504@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <561A54B3.5000504@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>, James.Bottomley@HansenPartnership.com, Hannes Reinecke <hare@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, iommu@lists.linux-foundation.org, Leo Duran <leo.duran@amd.com>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@fb.com>, linux-pci <linux-pci@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On 10/11/2015 at 02:23 PM, Andreas Hartmann wrote:
> On 10/09/2015 at 07:46 PM, Andreas Hartmann wrote:
>> Hello J=F6rg,
>>
>> On 10/09/2015 at 04:59 PM, Joerg Roedel wrote:
>>> On Fri, Oct 09, 2015 at 11:15:05AM +0200, Andreas Hartmann wrote:
>>>> v4.3-rc4 isn't usable at all for me as long as is hangs the machin=
e on
>>>> the necessary PCI passthrough for VMs (I need them).
>>>
>>> If the fix I just sent you works, could you please test this again =
with
>>> a (patched) v4.3-rc4 kernel?
>>
>> Your IOMMU-patch works fine - but the ata-problem can be seen here, =
too.
>> Same behavior as with 4.1.10.
>>
>=20
> Ok, this patch seems to fix the ata errors (I did a lot of tests unti=
l
> now w/ v4.1.10 - but anyway I'm cautious):
>=20
> http://thread.gmane.org/gmane.linux.scsi/104141/focus=3D104267

-> Forget it - doesn't fix it.


Regards,
Andreas
