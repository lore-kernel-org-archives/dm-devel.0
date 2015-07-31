From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Fri, 31 Jul 2015 09:23:48 +0200
Message-ID: <55BB2284.1060706@redhat.com>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com> <55B7C800.2070702@maya.org>
 <20150728185811.GA25060@redhat.com> <55B7D6BE.5010203@maya.org>
 <20150728193101.GB25264@redhat.com> <55B7E14A.4050500@maya.org>
 <20150728212441.GA25761@redhat.com> <55B87005.7010409@redhat.com>
 <55B8759B.8070400@redhat.com> <55B90C25.8030502@maya.org>
 <55BA895D.30509@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <55BA895D.30509@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andreas Hartmann <andihartmann@freenet.de>, device-mapper development <dm-devel@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Mike Snitzer <msnitzer@redhat.com>, mpatocka@redhat.com
List-Id: dm-devel.ids

On 07/30/2015 10:30 PM, Andreas Hartmann wrote:
...

> Next tests:
> I didn't mount any filesystem on bootup located on the ssd (only the
> rotational based mounts) -> no problem.
> 
> Next: I tried to add the partitions from the ssd to be mounted on boot -
> one by one. As there where 4 partitions to be mounted from the ssd, the
> errors came up again.

This is strange... Do I understand it correctly that this bug appears only
if you mount more than 3 encrypted partitions? (IOW if you mount only 2 or 3
there is no problem?)

> Next: You suspect the ssd as being bad. Therefore, I changed the ssd and
> tested with KINGSTON SV300S37A240G. Result: Same as above - errors are
> coming up if there are mounted more than 3 partitions at the same time.

ok. I guess it was just image of the same disk on different hw, correct?

> 
> Summary:
> - --perf-submit_from_crypt_cpus --perf-same_cpu_crypt -> broken anyway

That is even more interesting because these should effectively disable
the parralel submit code in dmcrypt.

Could you please verify that these flags are really applied when you used
them? (I am just trying to eliminate possible cryptsetup bug, the code is new).
(Run dmsetup table, you should see submit_from_crypt_cpus/same_cpu_crypt
on the dmcrypt mappping table line according to commandline.)

> - rotational disks alone: it's ok
> - more than 3 partitions on ssd Corsair Force GT -> broken
> - more than 3 partitions on ssd KINGSTON SV300S37A240G -> broken

- if you disable NCQ, the problems goes away?

Could you please post "lsblk" and dmesg output from the situation which fails,
(with mounted >3 partition on boot)?
I think someone should defititely try to reproduce it on some development hw here,
configured storage stack should be visible from the lsblk output.

Thanks for for the info & tests!

Milan
