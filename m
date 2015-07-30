From: Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Thu, 30 Jul 2015 22:30:21 +0200
Message-ID: <55BA895D.30509@maya.org>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com> <55B7C800.2070702@maya.org>
 <20150728185811.GA25060@redhat.com> <55B7D6BE.5010203@maya.org>
 <20150728193101.GB25264@redhat.com> <55B7E14A.4050500@maya.org>
 <20150728212441.GA25761@redhat.com> <55B87005.7010409@redhat.com>
 <55B8759B.8070400@redhat.com> <55B90C25.8030502@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <55B90C25.8030502@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Mike Snitzer <msnitzer@redhat.com>, mpatocka@redhat.com
List-Id: dm-devel.ids

On 07/29/2015 at 07:23 PM Andreas Hartmann wrote:
> On 07/29/2015 at 08:41 AM Milan Broz wrote:
>> On 07/29/2015 08:17 AM, Ondrej Kozina wrote:
>>> On 07/28/2015 11:24 PM, Mike Snitzer wrote:
>>>>>
>>>>> I am willing to do tests if you have any idea to be tested - I can
>>>>> reproduce it quite easily.
>>>>
>>>> You can try disabling dm-crypt's parallelization by specifying these 2
>>>> features: same_cpu_crypt submit_from_crypt_cpus
>>>>
>>>
>>> Hi,
>>>
>>> please try adding follwoing cryptsetup perf. options while unlocking 
>>> your LUKS containers: --perf-submit_from_crypt_cpus and 
>>> --perf-same_cpu_crypt.
>>>
>>> Perhaps focus on SSD disk as previous unresolved report mentioned SSD too
> 
> I'll next try to just boot from the rotational disk. If the problem
> doesn't show up here, it could be SSD related, too.
> 
>>
>> Just you need to use cryptsetup 1.6.7 version (older versions do not have this options yet).
> 
> Thanks for this hint.
> 
> I compiled this version and applied it and verified it, if it's really
> in initrd. It was in initrd and the additional options where applied, too.
> 
> But: nothing changed with enabled ncq - exactly same problem as before
> (w/ linux 3.19.8 + additional patches and Linux 4.1 - no difference in
> behavior).


Next tests:
I didn't mount any filesystem on bootup located on the ssd (only the
rotational based mounts) -> no problem.

Next: I tried to add the partitions from the ssd to be mounted on boot -
one by one. As there where 4 partitions to be mounted from the ssd, the
errors came up again.

Next: You suspect the ssd as being bad. Therefore, I changed the ssd and
tested with KINGSTON SV300S37A240G. Result: Same as above - errors are
coming up if there are mounted more than 3 partitions at the same time.


Summary:
- --perf-submit_from_crypt_cpus --perf-same_cpu_crypt -> broken anyway
- rotational disks alone: it's ok
- more than 3 partitions on ssd Corsair Force GT -> broken
- more than 3 partitions on ssd KINGSTON SV300S37A240G -> broken



Regards,
Andreas
