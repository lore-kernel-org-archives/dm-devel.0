From: Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
	READ FPDMA QUEUED errors since Linux 4.0
Date: Fri, 9 Oct 2015 11:15:05 +0200
Message-ID: <56178599.6010807@maya.org>
References: <55FE5740.2060701@maya.org> <20150929152100.GL3036@8bytes.org>
	<alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
	<20150929162042.GR3036@8bytes.org> <560BF73F.8000008@maya.org>
	<20151006101356.GE12506@8bytes.org> <56141507.7040103@maya.org>
	<56148A1B.5060506@maya.org> <20151007161022.GI28811@8bytes.org>
	<56154DEA.5050901@maya.org> <20151008163957.GK28811@8bytes.org>
	<5616B436.1000802@maya.org> <5616C998.1010309@maya.org>
	<56174EA6.7000106@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <56174EA6.7000106-YKS6W9RDU/w@public.gmane.org>
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

On 10/09/2015 at 07:20 AM, Andreas Hartmann wrote:
> On 10/08/2015 at 09:52 PM, Andreas Hartmann wrote:
>> On 10/08/2015 at 08:21 PM, Andreas Hartmann wrote:
>>> Am 08.10.2015 um 18:39 schrieb Joerg Roedel:
>>>> On Wed, Oct 07, 2015 at 06:52:58PM +0200, Andreas Hartmann wrote:
>>>>> To reproduce the error:
>>>>> First I mounted /daten2, afterwards /raid/mt, which produces the errors.
>>>>> The ssd mounts have been already active (during boot by fstab).
>>>>
>>>> Okay, I spent the day on that problem, and managed to reproduce it here
>>>> on one of my AMD IOMMU boxes. I wasn't an easy journey, as I can only
>>>> reproduce it if I setup the crypto partition and everything above that
>>>> (like mounting the lvm volumes) _after_ the system has finished booting.
>>>> If everything is setup during system boot it works fine and I don't see
>>>> any IO_PAGE_FAULTS.
>>>
>>> Thank you very much for spending so much of your time to reproduce the
>>> problem!
>>>
>>>> I also tried kernel v4.3-rc4 first, to have it tested with a
>>>> self-compiled kernel. It didn't show up there, so I built a 4.1.0, where
>>>> it showed up again. Something seems to have fixed the issue in the
>>>> latest kernels.
>>>>
>>>> So I looked a little bit around at the commits that were merged into the
>>>> respective parts involved here, and found this one:
>>>>
>>>>     586b286 dm crypt: constrain crypt device's max_segment_size to
>>>> PAGE_SIZE
>>>>
>>>> The problem fixed with this commit looks quite similar to what you have
>>>> seen (execpt that there was no IOMMU involved). So I cherry-picked that
>>>> commit on 4.1.0 and tested that. The problem was gone.
>>>
>>> That's true - I already knew this patch and tested it some weeks ago -
>>> unfortunately it doesn't fix the problem here.
>>>
>>> To be really sure, I just retested it now again. I couldn't see any
>>> IO_PAGE_FAULTS errors today (unfortunately I can't remember anymore if I
>>> didn't see them too a few weeks ago) - but the ata errors remain.
>>> Therefore, this patch isn't a solution for the problem I encounter here.
>>>
>>>> So it looks like it was a dm-crypt issue, the patch went into v4.3-rc3,
>>>> either this kernel of rc4 should fix the problem for you too. Can you
>>>> please verify this is fixed for you too with v4.3-rc4?
>>>
>>> As I already wrote, I even couldn't see the problem with v4.3-rc2 any
>>> more (as far as I was able to test because of the other problem). I have
>>> to do some more tests now with this kernel to be really sure.
>>
>> I now tested w/ v4.3-rc4. I couldn't see any IO_PAGE_FAULTS but the ata
>> errors remain. The ata errors can be easily activated by copying a large
>> file (> 4 GB) from one partition on the raid to another partition on the
>> raid.
> 
> Hmmm, I retested this morning w/ v4.3-rc4 and 4.1.10 (with the above
> mentioned patch applied) - and now, I didn't get any more ata errors.
> 
> I'm confused now. The only difference between yesterday evening and this
> morning was, that the machine was over night completely powerless (via
> socket outlet switch). Could this really be the reason? Let's wait and
> see if this is a persistent state ... .

No - it is not a persistent state. The ata errors are back again (in
3.1.10 w/ the above mentioned patch applied). It just isn't that easy
any more to trigger them. After a short time of intermission w/ power
off / on cycle, the error came up up again doing the first test copy.
This means: there must be something more broken.

If I revert the original culprit of all of the problems (block: remove
artifical max_hw_sectors cap), it is possible to increase max_sectors_kb
to 1024 - any higher value leads to ata or IO_PAGE_FAULTS sooner or later.

v4.3-rc4 isn't usable at all for me as long as is hangs the machine on
the necessary PCI passthrough for VMs (I need them).


Regards,
Andreas
