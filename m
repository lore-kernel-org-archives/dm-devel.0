From: Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
	READ FPDMA QUEUED errors since Linux 4.0
Date: Thu, 8 Oct 2015 20:59:00 +0200
Message-ID: <5616BCF4.10104@maya.org>
References: <alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
	<55FE5740.2060701@maya.org> <20150929152100.GL3036@8bytes.org>
	<alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
	<20150929162042.GR3036@8bytes.org> <560BF73F.8000008@maya.org>
	<20151006101356.GE12506@8bytes.org> <56141507.7040103@maya.org>
	<20151007154005.GH28811@8bytes.org> <56155028.7060906@maya.org>
	<20151008173007.GL28811@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20151008173007.GL28811-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
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

On 10/08/2015 at 07:30 PM Joerg Roedel wrote:
> On Wed, Oct 07, 2015 at 07:02:32PM +0200, Andreas Hartmann wrote:
>> Binding the device to vfio isn't a problem (it's done before the vm is
>> started). The problem occurs during start of qemu-system-x86_64 (2.3.0).
>>
>> The attached dmesg.out doesn't show the trace, but the desired iommu dump.
>>
>>> Also, which device are you trying to attach to the guest (pci
>>> bus/device/function)?
>>
>> See attached ath9k.device.
> 
> Hmm, can you also test this again with the v4.3-rc4 please? The device
> you are attaching has its own group and no aliases, so I really can't
> see how the trace could happen, and I can't reproduce it here either.

Unchanged - this time hard locked machine and no trace at all because of
data loss after reboot :-(.

Btw: Linux 4.2 doesn't show this problem.

Nevertheless I'll try to get a trace - maybe I'm lucky and the machine
doesn't lock up completely another time :-).


Regards,
Andreas
