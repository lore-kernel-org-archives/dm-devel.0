From: Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
	READ FPDMA QUEUED errors since Linux 4.0
Date: Thu, 8 Oct 2015 21:47:28 +0200
Message-ID: <5616C850.2000906@maya.org>
References: <alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
	<55FE5740.2060701@maya.org> <20150929152100.GL3036@8bytes.org>
	<alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
	<20150929162042.GR3036@8bytes.org> <560BF73F.8000008@maya.org>
	<20151006101356.GE12506@8bytes.org> <56141507.7040103@maya.org>
	<20151007154005.GH28811@8bytes.org> <56155028.7060906@maya.org>
	<20151008173007.GL28811@8bytes.org> <5616BCF4.10104@maya.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030809040104060803000702"
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <5616BCF4.10104-YKS6W9RDU/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030809040104060803000702
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/08/2015 at 08:59 PM, Andreas Hartmann wrote:
> On 10/08/2015 at 07:30 PM Joerg Roedel wrote:
>> On Wed, Oct 07, 2015 at 07:02:32PM +0200, Andreas Hartmann wrote:
>>> Binding the device to vfio isn't a problem (it's done before the vm i=
s
>>> started). The problem occurs during start of qemu-system-x86_64 (2.3.=
0).
>>>
>>> The attached dmesg.out doesn't show the trace, but the desired iommu =
dump.
>>>
>>>> Also, which device are you trying to attach to the guest (pci
>>>> bus/device/function)?
>>>
>>> See attached ath9k.device.
>>
>> Hmm, can you also test this again with the v4.3-rc4 please? The device
>> you are attaching has its own group and no aliases, so I really can't
>> see how the trace could happen, and I can't reproduce it here either.
>=20
> Unchanged - this time hard locked machine and no trace at all because o=
f
> data loss after reboot :-(.
>=20
> Btw: Linux 4.2 doesn't show this problem.
>=20
> Nevertheless I'll try to get a trace - maybe I'm lucky and the machine
> doesn't lock up completely another time :-).

Got it. I attached the complete oops and the output of objdump.

Kernel was linux 4.3-rc4


This time, the oops was caused by the second PCI card I'm passing
through to another VM (the ath9k card worked fine this time - chance?).
I added the lspci output to the attached file, too.


Thanks,
regards,
Andreas

--------------030809040104060803000702
Content-Type: application/x-gzip;
 name="oops.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="oops.gz"

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
bRs4v3fZsvar26D5PNLr/QdnR5lKFR0AAA==
--------------030809040104060803000702
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030809040104060803000702--
