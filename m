From: Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command: READ FPDMA
 QUEUED errors since Linux 4.0
Date: Tue, 28 Jul 2015 20:20:48 +0200
Message-ID: <55B7C800.2070702@maya.org>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150728175054.GB24782@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Andreas Hartmann <andihartmann@01019freenet.de>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-pci <linux-pci@vger.kernel.org>
List-Id: dm-devel.ids

On 07/28/2015 at 07:50 PM, Mike Snitzer wrote:
[..]
> Are your SATA devcies using NCQ?

Yes. It's enabled:

dmesg| grep -i ncq
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
ata2.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata3.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA

As the errors already come up on boot (during mount of partitions or
even before the password for the disk has been provided): How can I
disable NCQ during boot of the kernel? Is there a kernel option?

I'm trying to apply your mentioned patches to 3.19 and report back.

> 
> Please see this dm-devl thread (and this post in particular):
> https://www.redhat.com/archives/dm-devel/2015-June/msg00005.html
> 

Thanks,
Andreas
