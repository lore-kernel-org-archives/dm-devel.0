From: Milan Broz <mbroz@redhat.com>
Subject: Re: AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command: READ FPDMA
 QUEUED errors since Linux 4.0
Date: Wed, 29 Jul 2015 12:37:34 +0200
Message-ID: <55B8ACEE.5080104@redhat.com>
References: <55B7BEA2.30205@01019freenet.de> <20150728175054.GB24782@redhat.com> <55B7C800.2070702@maya.org> <20150728185811.GA25060@redhat.com> <55B7D6BE.5010203@maya.org> <20150728193101.GB25264@redhat.com> <55B7E14A.4050500@maya.org> <20150728212441.GA25761@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150728212441.GA25761@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Andreas Hartmann <andihartmann@freenet.de>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-pci <linux-pci@vger.kernel.org>
List-Id: dm-devel.ids

On 07/28/2015 11:24 PM, Mike Snitzer wrote:
> On Tue, Jul 28 2015 at  4:08pm -0400,
> Andreas Hartmann <andihartmann@freenet.de> wrote:
> 
>> On 07/28/2015 at 21:31 PM, Mike Snitzer wrote:
>>> On Tue, Jul 28 2015 at  3:23pm -0400,
>>> Andreas Hartmann <andihartmann@freenet.de> wrote:
>>>
>>>> On 07/28/2015 at 08:58 PM, Mike Snitzer wrote:
>>>>> On Tue, Jul 28 2015 at  2:20pm -0400,
>>>>> Andreas Hartmann <andihartmann@freenet.de> wrote:
>>>>>
>>>>>> On 07/28/2015 at 07:50 PM, Mike Snitzer wrote:
>>>>>> [..]
>>>>>>> Are your SATA devcies using NCQ?
>>>>>>
>>>>>> Yes. It's enabled:
>>>>>>
>>>>>> dmesg| grep -i ncq
>>>>>> ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
>>>>>> ata2.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
>>>>>> ata3.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
>>>>>> ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>>>>>>
>>>>>> As the errors already come up on boot (during mount of partitions or
>>>>>> even before the password for the disk has been provided): How can I
>>>>>> disable NCQ during boot of the kernel? Is there a kernel option?
>>>>>
>>>>> See:
>>>>> https://ata.wiki.kernel.org/index.php/Libata_FAQ#Enabling.2C_disabling_and_checking_NCQ
>>>>>
>>>>> alternatively, and likely easier, set this on the kernel commandline:
>>>>>  libata.force=noncq
>>>>
>>>> ata2.00: FORCE: horkage modified (noncq)
>>>> ata2.00: 5860533168 sectors, multi 0: LBA48 NCQ (not used)
>>>> ata3.00: FORCE: horkage modified (noncq)
>>>> ata3.00: 5860533168 sectors, multi 0: LBA48 NCQ (not used)
>>>> ata5.00: FORCE: horkage modified (noncq)
>>>> ata1.00: FORCE: horkage modified (noncq)
>>>> ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (not used)
>>>>
>>>>
>>>> Perfectly. Seems to work w/ 3.19.8 and your mentioned patches. But now,
>>>> I'm getting another error, which I didn't see before w/ 3.x-kernels:
>>>>
>>>> [drm:btc_dpm_set_power_state [radeon]] *ERROR*
>>>> rv770_restrict_performance_levels_before_switch failed
>>>>
>>>> It seams that your patches do have some unwanted side effects :-).
>>>
>>> That is a completely different issue.  drm and radeon is a graphics
>>> issue.
>>
>> Nothing changed on radeon code. I just applied your patches. Nothing
>> more. Why should radeon been suddenly broken if I apply your patches
>> to a stable 3.19.8 code?
>>
>> These patches trigger tons of AMD-Vi IO_PAGE_FAULTs w/ ncq enabled
>> and the IOMMU developers say, that it is not a problem of the iommu
>> code.
>>
>>>> Could you please reexamine your patch "dm crypt: don't allocate
>>>> pages for a partial request" - after applying this patch all the
>>>> problems are coming up here.
>>>
>>> More likely than not your hardware isn't very good.
>>
>> Maybe - maybe not. The only thing I know for sure, is: with these
>> patches applied, the machine doesn't work reliably any more. W/ ncq
>> disabled, the AMD-Vi IO_PAGE_FAULTs are gone, but a radeon error
>> never seen before came instead. Most probably chance. Most probably,
>> it could have been risen any other error, too.
>>
>> I am willing to do tests if you have any idea to be tested - I can
>> reproduce it quite easily.
> 
> You can try disabling dm-crypt's parallelization by specifying these 2
> features: same_cpu_crypt submit_from_crypt_cpus
> 
> It is my understanding that these can be set using the cryptsetup tool.
> Milan can you clarify how these features can be set from a high-level
> (on an existing crypt device)?

Just one note - for me it seems that you are hitting an firmware problem
related to NCQ implementation in your SSD see.

Similar page what Mike already mentioned:
https://wiki.archlinux.org/index.php/Solid_State_Drives#Resolving_NCQ_errors

Anyway, I have myself SSD drive with NCQ active and I have never seen this problem
(I am using these dmcrypt patches backported since 3.16 kernel or so).
(And my system is very intensively used with this config.)

Perhaps you could also check if there a new firmware for your SSD?
(From log I see it is Corsair Force GT and there were some known problems.)

Thanks,
Milan
