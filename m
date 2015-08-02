From: Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
	READ FPDMA QUEUED errors since Linux 4.0
Date: Sun, 2 Aug 2015 20:48:06 +0200
Message-ID: <55BE65E6.7060901@maya.org>
References: <55B7BEA2.30205@01019freenet.de>
	<20150728175054.GB24782@redhat.com> <55B7D054.4070308@maya.org>
	<20150728192908.GA25264@redhat.com> <55BCD5A7.2080708@maya.org>
	<55BE1D5E.6020709@maya.org>
	<alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1508021347480.17729-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Leo Duran <leo.duran-5C7GfCeVMHo@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On 08/01/2015 at 19:57, Mikulas Patocka wrote:
>
>
> On Sun, 2 Aug 2015, Andreas Hartmann wrote:
>
>> On 08/01/2015 at 04:20 PM Andreas Hartmann wrote:
>>> On 07/28/2015 at 09:29 PM, Mike Snitzer wrote:
>>> [...]
>>>> Mikulas was saying to biect what is causing ATA to fail.
>>>
>>> Some good news and some bad news. The good news first:
>>>
>>> Your patchset
>>>
>>> f3396c58fd8442850e759843457d78b6ec3a9589,
>>> cf2f1abfbd0dba701f7f16ef619e4d2485de3366,
>>> 7145c241a1bf2841952c3e297c4080b357b3e52d,
>>> 94f5e0243c48aa01441c987743dc468e2d6eaca2,
>>> dc2676210c425ee8e5cb1bec5bc84d004ddf4179,
>>> 0f5d8e6ee758f7023e4353cca75d785b2d4f6abe,
>>> b3c5fd3052492f1b8d060799d4f18be5a5438add
>>>
>>> seems to work fine w/ 3.18.19 !!
>>>
>>> Why did I test it with 3.18.x now? Because I suddenly got two ata errors
>>> (ata1 and ata2) with clean 3.19.8 (w/o the AMD-Vi IO_PAGE_FAULTs) during
>>> normal operation. This means: 3.19 must already be broken, too.
>>>
>>> Therefore, I applied your patchset to 3.18.x and it seems to work like a
>>> charme - I don't get any AMD-Vi IO_PAGE_FAULTs on boot and no ata errors
>>> (until now).
>>>
>>>
>>> Next I did: I tried to bisect between 3.18 and 3.19 with your patchset
>>> applied, because w/ this patchset applied, the problem can be seen
>>> easily and directly on boot. Unfortunately, this does work only a few
>>> git bisect rounds until I got stuck because of interferences with your
>>> extra patches applied:
>>
>> [Resolved the problems written at the last post.]
>>
>> Bisecting ended here:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=34b48db66e08ca1c1bc07cf305d672ac940268dc
>>
>> block: remove artifical max_hw_sectors cap
>>
>>
>> Removing this patch on 3.19 and 4.1 make things working again. Didn't
>> test 4.0, but I think it's the same. No more AMD-Vi IO_PAGE_FAULTS  with
>> that patch reverted.
>>
>>
>> Please check why this patch triggers AMD-Vi IO_PAGE_FAULTS.
>>
>>
>> Thanks,
>> kind regards,
>> Andreas Hartmann
>
> I would submit this bug to maintainers of AMD-Vi. They understand the
> hardware, so they should tell why do large I/O requests result in
> IO_PAGE_FAULTs.

You forgot the ata errors ... . They are gone, too. I got these ata 
errors on 3.19 w/o your patchset and w/o AMD-Vi IO_PAGES_FAULTs, too.



Regards,
Andreas
