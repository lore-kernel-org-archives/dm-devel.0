From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Wed, 29 Aug 2012 20:51:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1208292038560.17228@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
	<Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
	<20120821163329.GA21395@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1208212026500.1653@file.rdu.redhat.com>
	<20120824181444.GC27819@freewill.lab.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120824181444.GC27819@freewill.lab.equallogic.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim Ramsay <jim_ramsay@dell.com>
Cc: dm-devel@redhat.com, Jason_Shamberger@dell.com, agk@redhat.com, Kevin_OKelley@dell.com
List-Id: dm-devel.ids



On Fri, 24 Aug 2012, Jim Ramsay wrote:

> I'm also not that familiar with what other devices use vmalloc space in
> the kernel - With a limited resource like this we must make sure we can
> properly contend with other consumers of the space.
> 
> So in conclusion, I think we're converging on something that we're all
> going to be happy with - We just need to ensure that the performance of
> the proposed changes are acceptable compared to our existing code.
> 
> To that end I will be devoting some time next week to getting your
> driver working with our userland to test page table uploading and actual
> IO performance.  Would you mind taking some time to give a try to the
> latest 'v4' version of this driver, and doing an independent comparison?
> 
> v4 driver code is here:
>   http://www.redhat.com/archives/dm-devel/2012-August/msg00299.html
> v4 userland example code is here:
>   http://www.redhat.com/archives/dm-devel/2012-August/msg00300.html
> 
> -- 
> Jim Ramsay

Hi

I tested your and my dm-switch implementation. I created 3 1GB ramdisk 
devices, filled them with data (so that alloc-on-demand in the ramdisk 
driver doesn't influence the benchmark). Then I placed dm-switch device on 
these ramdisks, with page size 3 sectors and page table of repetitive 
pattern 012012012...

I ran fio command performing 8 parallel I/O threads (on two quad-core 
Opterons), each reading or writing 512-bytes with direct I/O: "fio 
--rw=randrw --size=1G --bs=512 --filename=/dev/mapper/switch2 --direct=1 
--name=job1 --name=job2 --name=job3 --name=job4 --name=job5 --name=job6 
--name=job7 --name=job8"

Basically, the worst performance brake is the spinlock in your code, 
otherwise there is not much difference. vmalloc doesn't slow it down 
(actually it was slightly faster with vmalloc than with kmalloc).

Your original code
15.15s, stdev 0.05

Your code (with spinlock removed):
14.33s, stdev 0.17

Your code (with spinlock and RCU removed):
14.38s, stdev 0.16

My code (with kmalloc):
14.45s, stdev 0.17

My code (with vmalloc):
14.31s, stdev 0.11

Mikulas
