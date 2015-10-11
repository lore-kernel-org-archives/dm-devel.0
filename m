From: Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
	READ FPDMA QUEUED errors since Linux 4.0
Date: Sun, 11 Oct 2015 14:23:15 +0200
Message-ID: <561A54B3.5000504@maya.org>
References: <20151006101356.GE12506@8bytes.org> <56141507.7040103@maya.org>
	<56148A1B.5060506@maya.org> <20151007161022.GI28811@8bytes.org>
	<56154DEA.5050901@maya.org> <20151008163957.GK28811@8bytes.org>
	<5616B436.1000802@maya.org> <5616C998.1010309@maya.org>
	<56174EA6.7000106@maya.org> <56178599.6010807@maya.org>
	<20151009145951.GC27420@8bytes.org> <5617FD6E.70802@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <5617FD6E.70802-YKS6W9RDU/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On 10/09/2015 at 07:46 PM, Andreas Hartmann wrote:
> Hello J=F6rg,
> =

> On 10/09/2015 at 04:59 PM, Joerg Roedel wrote:
>> On Fri, Oct 09, 2015 at 11:15:05AM +0200, Andreas Hartmann wrote:
>>> v4.3-rc4 isn't usable at all for me as long as is hangs the machine on
>>> the necessary PCI passthrough for VMs (I need them).
>>
>> If the fix I just sent you works, could you please test this again with
>> a (patched) v4.3-rc4 kernel?
> =

> Your IOMMU-patch works fine - but the ata-problem can be seen here, too.
> Same behavior as with 4.1.10.
> =


Ok, this patch seems to fix the ata errors (I did a lot of tests until
now w/ v4.1.10 - but anyway I'm cautious):

http://thread.gmane.org/gmane.linux.scsi/104141/focus=3D104267

Would be nice to have it in all kernels (as stable patch too in 4.1.x).


Regards,
Andreas
