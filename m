From: Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
	READ FPDMA QUEUED errors since Linux 4.0
Date: Wed, 30 Sep 2015 16:52:47 +0200
Message-ID: <560BF73F.8000008@maya.org>
References: <55B7BEA2.30205@01019freenet.de>
	<20150728175054.GB24782@redhat.com> <55B7D054.4070308@maya.org>
	<20150728192908.GA25264@redhat.com> <55BCD5A7.2080708@maya.org>
	<55BE1D5E.6020709@maya.org>
	<alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
	<55FE5740.2060701@maya.org> <20150929152100.GL3036@8bytes.org>
	<alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
	<20150929162042.GR3036@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150929162042.GR3036-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On 09/29/2015 at 06:20 PM, Joerg Roedel wrote:
> On Tue, Sep 29, 2015 at 11:58:10AM -0400, Mikulas Patocka wrote:
>> On Tue, 29 Sep 2015, Joerg Roedel wrote:
>> There was a patch (34b48db66e08ca1c1bc07cf305d672ac940268dc) that 
>> increased default block request size. That patch triggers AMD-Vi page 
>> faults. The bug may be in ATA driver, in ATA controller on in AMD-Vi 
>> driver or hardware. I didn't see anything in that thread that proves that 
>> the bug in not in AMD-Vi IOMMU.
>>
>> The bug probably existed even before kernel 3.19, but it was masked by the 
>> fact that I/O request size was artifically capped. Bisecting probably 
>> won't find it, as it may have existed since ever.
> 
> Okay, I see. But as long as the request-size is not bigger than 128MB
> (the biggest chunk the AMD IOMMU driver can map at once), I don't see
> how the IOMMU driver could be at fault.
> 
> Which ATA driver is in use when this happens and are there instructions
> on how to reproduce the issue?
> 
> Alternativly someone who can reproduce it should trace the calls to
> __map_single and __unmap_single in the AMD IOMMU driver to find out
> whether the addresses which the faults happen on are really mapped, or
> at least requested from the AMD IOMMU driver.

How can I trace it?


Thanks,
Andreas
