From: Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Wed, 29 Jul 2015 19:23:49 +0200
Message-ID: <55B90C25.8030502@maya.org>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com> <55B7C800.2070702@maya.org>
 <20150728185811.GA25060@redhat.com> <55B7D6BE.5010203@maya.org>
 <20150728193101.GB25264@redhat.com> <55B7E14A.4050500@maya.org>
 <20150728212441.GA25761@redhat.com> <55B87005.7010409@redhat.com>
 <55B8759B.8070400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <55B8759B.8070400@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, mpatocka@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On 07/29/2015 at 08:41 AM Milan Broz wrote:
> On 07/29/2015 08:17 AM, Ondrej Kozina wrote:
>> On 07/28/2015 11:24 PM, Mike Snitzer wrote:
>>>>
>>>> I am willing to do tests if you have any idea to be tested - I can
>>>> reproduce it quite easily.
>>>
>>> You can try disabling dm-crypt's parallelization by specifying these 2
>>> features: same_cpu_crypt submit_from_crypt_cpus
>>>
>>
>> Hi,
>>
>> please try adding follwoing cryptsetup perf. options while unlocking 
>> your LUKS containers: --perf-submit_from_crypt_cpus and 
>> --perf-same_cpu_crypt.
>>
>> Perhaps focus on SSD disk as previous unresolved report mentioned SSD too

I'll next try to just boot from the rotational disk. If the problem
doesn't show up here, it could be SSD related, too.

> 
> Just you need to use cryptsetup 1.6.7 version (older versions do not have this options yet).

Thanks for this hint.

I compiled this version and applied it and verified it, if it's really
in initrd. It was in initrd and the additional options where applied, too.

But: nothing changed with enabled ncq - exactly same problem as before
(w/ linux 3.19.8 + additional patches and Linux 4.1 - no difference in
behavior).

> Anyway, it seems strange that one patch triggers such a problem (leading to a conclusion
> that the patch is wrong) but dm-crypt is know to reveal many problems in other systems
> exactly this way...

Maybe - maybe not.

> The patches were tested on so many systems without problem that I really believe
> the dmcrypt patch is just trigger for a bug elsewhere.

I'm having another machine, which doesn't show the problem - but this
machine can't be compared w/ the failing machine, because the other
machine does have a totally different and easy setup (1 ssd crypted lvm
and 3 or 4 logical filesystems - that's it) - and it's much slower :-).

Here I'm  having: 3 disks (1 ssd, 2 x 3 TB rotational), 1 crypted SW
Raid 1 w/ LVM on the rotational disks, another LVM on the ssd and 29 (!)
logical volumes each with xfs and 8 CPU cores, which guarantee high
degree of parallelism. I'm not sure if this is a "usual" setup which is
tested heavily. The error always comes up while mounting the partitions
on boot. Reducing the amount of mounted partitions reduced the amount of
errors (AMD-Vi IO_PAGE_FAULTs).

> 
> Anyway, if we can find configuration which fails here, I would like to help to find
> the core problem... Papering here just means it will break data later elsewhere.
> 
> Thanks for testing it!

I hope we can find the problem.


Regards,
Andreas
