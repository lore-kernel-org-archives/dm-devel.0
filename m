From: Mikael Andersson <mikael@karett.se>
Subject: Re: Fw: Disk output lockup 2.6.12_rc2 2.6.11.7
Date: Fri, 29 Apr 2005 13:45:06 +0200
Message-ID: <42721E42.3040604@karett.se>
References: <20050429033353.1873f739.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050429033353.1873f739.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Andrew Morton wrote:

>Mikael, have you made any progress on this?
>  
>
No, but i haven't but unfortunately i haven't had much time to look at
it either since i've had to finalize a delivery to one of my customers.

>Looks like a device-mapper bug to me.
>  
>
To my , albeit untrained, eye it does so too, especially considering
that i've been running the same setup (hardware wise) rock solidly on
md-raid1 for several days transferring hundreds of GB int the same
manner. But as soon as i get my paid project done i'll try to setup
another pair of discs and see if i can reproduce it on a PATA dm-mirror
as well as on a SATA dm-mirror. But i've also got some learning to do as
i'm quite unexperienced in kernel matters, so it will probably take some
time.

I've also posted some additional information on dm-devel with the subject:
'Disk io deadlocks during large-file io'

>
>Begin forwarded message:
>
>Date: Thu, 21 Apr 2005 11:06:10 +0200
>From: Mikael Andersson <mikael@karett.se>
>To: linux-kernel@vger.kernel.org
>Subject: Re: Disk output lockup 2.6.12_rc2 2.6.11.7
>
>
>Mikael Andersson wrote:
>  
>
>>During heavy io-load a lockup occurs that appears to prevent any disk
>>output from taking place. fs is reiserfs on two device-mapper mirrored
>>200G maxtor disks. After the lockup occurs you can to things like 'ls',
>>but echo > test.txt will hang.
>>    
>>
>
>fs is now ext3
>
>  
>
>>A typical workload producing the error is doing:
>>rsync of large (1GB) over 100Mbit ethernet
>>simultaneous compilation / gunzip
>>    
>>
>
>Or almost anything that writes something to the disk.
>
>  
>
>>I've disabled preemption, and tried with and without acpi enabled, with
>>and without smp support (it was smp by default so i switched it off).
>>Also tried with another nic (rtl8139) since i got an nv_stop_tx:
>>TransmitterStatus remained busy<6> in the logs. I also tried 2.6.11.7
>>with the same result.
>>    
>>
>
> Tried converting to ext3, some problem, albeit the lockups are less
>severe. More of the locked processes can be killed and echo > test.txt
>works. So _some_ io gets through.
> The output from sysrq-T is somewhat less confusing though, it appears
>then hung processes is somehow being hung in __generic_unplug_device,  i
>had a look at the assembler, but couldn't make heads or tails of it. the
>code at __generic_unplug_device+19 was test %eax,%eax immediately
>preceded by a callq to the test instruction. Obviously something magic
>(by my eyes) is going on here.
>
> Also tried 2.6.12_rc3-mm3
>
> I'd really like to find a solution to this since it kinda borks the
>nice an shiny machine if it can't handle large files without getting
>into trouble.
>
> I've been working on this for two days, have been trying to find
>similar bug reports, trying a lot of different kernels and kernel
>options to no avail.
> I'm a little out of options right now, any ideas for something to try,
>patches to test, or some help in understanding what's happening ?
>
>
>kmirrord/0 D ffff81003f1bccd8 0 978 9 1731 977 (L-TLB)
>Call Trace:
><ffffffff8016a2d6>{cache_alloc_refill+1222}
><ffffffff804a2f9f>{io_schedule+15}
>--
>kjournald D ffff81003e94bcd8 0 1748 1 2060 953 (L-TLB)
>Call Trace:
><ffffffff802e9c13>{__generic_unplug_device+19}
><ffffffff802e9cfd>{generic_unplug_device+189}
>--
>rsync D 000000701553dccf 0 6903 6901 (NOTLB)
>Call Trace:
><ffffffff802e9c13>{__generic_unplug_device+19}
><ffffffff802e9cfd>{generic_unplug_device+189}
>--
>x86_64-pc-lin D 0000006dc7d23e49 0 13785 13742 (NOTLB)
>Call Trace:
><ffffffff802e9cfd>{generic_unplug_device+189}
><ffffffff8040e3ad>{dm_unplug_all+29}
>
>/Mikael Andersson
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
