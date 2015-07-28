From: Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command: READ FPDMA
 QUEUED errors since Linux 4.0
Date: Tue, 28 Jul 2015 21:23:42 +0200
Message-ID: <55B7D6BE.5010203@maya.org>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com> <55B7C800.2070702@maya.org>
 <20150728185811.GA25060@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150728185811.GA25060@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-pci <linux-pci@vger.kernel.org>
List-Id: dm-devel.ids

On 07/28/2015 at 08:58 PM, Mike Snitzer wrote:
> On Tue, Jul 28 2015 at  2:20pm -0400,
> Andreas Hartmann <andihartmann@freenet.de> wrote:
> 
>> On 07/28/2015 at 07:50 PM, Mike Snitzer wrote:
>> [..]
>>> Are your SATA devcies using NCQ?
>>
>> Yes. It's enabled:
>>
>> dmesg| grep -i ncq
>> ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
>> ata2.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
>> ata3.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
>> ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>>
>> As the errors already come up on boot (during mount of partitions or
>> even before the password for the disk has been provided): How can I
>> disable NCQ during boot of the kernel? Is there a kernel option?
> 
> See:
> https://ata.wiki.kernel.org/index.php/Libata_FAQ#Enabling.2C_disabling_and_checking_NCQ
> 
> alternatively, and likely easier, set this on the kernel commandline:
>  libata.force=noncq

ata2.00: FORCE: horkage modified (noncq)
ata2.00: 5860533168 sectors, multi 0: LBA48 NCQ (not used)
ata3.00: FORCE: horkage modified (noncq)
ata3.00: 5860533168 sectors, multi 0: LBA48 NCQ (not used)
ata5.00: FORCE: horkage modified (noncq)
ata1.00: FORCE: horkage modified (noncq)
ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (not used)


Perfectly. Seems to work w/ 3.19.8 and your mentioned patches. But now,
I'm getting another error, which I didn't see before w/ 3.x-kernels:

[drm:btc_dpm_set_power_state [radeon]] *ERROR*
rv770_restrict_performance_levels_before_switch failed

It seams that your patches do have some unwanted side effects :-).

Could you please reexamine your patch "dm crypt: don't allocate
pages for a partial request" - after applying this patch all the
problems are coming up here.



Thanks,
regards,
Andreas
