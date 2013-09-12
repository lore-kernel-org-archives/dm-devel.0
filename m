From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt parallelization patches
Date: Thu, 12 Sep 2013 05:51:00 +0200
Message-ID: <52313A24.1000802@gmail.com>
References: <alpine.LRH.2.02.1309031457480.28146@file01.intranet.prod.int.rdu2.redhat.com>
	<20130903200702.GJ16724@tassilo.jf.intel.com>
	<alpine.LRH.2.02.1309101947440.30003@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1309101947440.30003@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, Andi Kleen <ak@linux.intel.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 09/12/2013 01:03 AM, Mikulas Patocka wrote:
> 
> Tests were done on two six-core Istanbul-class Opterons.
> 
> I don't have a computer with AES-NI, so I can't test that.

AES-NI is used almost in all systems where is dmcrypt currently
deployed (notebooks typically)... so I think it must be tested there.

Also ramdisk tests are good baseline but this is not real world scenario.

I would really like to see the same test with RAID5 (over fast rotational disks)
with various stripe size and for SSDs (and RAID0 with SSDs).
(These were reported problematic scenarios in recent years I know about.)

Can you also show how the sorting patch influences performance?
(IOW how it performs without it.)

Another problematic part was latency (e.g. sql database over dmcrypt doesn't
perform well). Isn't it even worse with these patches?
(I am not sure if anyone have fio script to simulate such workload.)

I would like to test it myself but I have no usable fast-enough test systems
at all currently. But there are surely some in RH.
(Added cc to Ondra, he has some test scripts I used.)

I also remember I tried your patches (year ago) with limited CPU workqueues
(I mean using e.g. only 3 of 6 cores) and it performed better in some tests.
This support Andi's suggestion to limit it to smaller groups of cpus.

Also I think we discussed this should be configurable through optional dmcrypt
per-device parameters (e.g. I would like to set up some dmcrypt device
to use only one CPU). Think about backend for virtual machines etc, it should not
eat all available CPUs power on host...
Do you plan to add such patch as well?

Milan
