From: Andrew Morton <akpm@osdl.org>
Subject: Re: Disk output lockup 2.6.12_rc2 2.6.11.7
Date: Wed, 25 May 2005 23:38:38 -0700
Message-ID: <20050525233838.744af094.akpm@osdl.org>
References: <4266CEED.3010108@karett.se>
	<42676D02.3070201@karett.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42676D02.3070201@karett.se>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikael Andersson <mikael@karett.se>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Mikeal, this smells like a devicemapper lockup.  Could you please test
2.6.12-rc5 and provide us with a status update?

Thanks.


Mikael Andersson <mikael@karett.se> wrote:
>
> Mikael Andersson wrote:
> > During heavy io-load a lockup occurs that appears to prevent any disk
> > output from taking place. fs is reiserfs on two device-mapper mirrored
> > 200G maxtor disks. After the lockup occurs you can to things like 'ls',
> > but echo > test.txt will hang.
> 
> fs is now ext3
> 
> > 
> > A typical workload producing the error is doing:
> > rsync of large (1GB) over 100Mbit ethernet
> > simultaneous compilation / gunzip
> 
> Or almost anything that writes something to the disk.
> 
> > 
> > I've disabled preemption, and tried with and without acpi enabled, with
> > and without smp support (it was smp by default so i switched it off).
> > Also tried with another nic (rtl8139) since i got an nv_stop_tx:
> > TransmitterStatus remained busy<6> in the logs. I also tried 2.6.11.7
> > with the same result.
> 
>  Tried converting to ext3, some problem, albeit the lockups are less
> severe. More of the locked processes can be killed and echo > test.txt
> works. So _some_ io gets through.
>  The output from sysrq-T is somewhat less confusing though, it appears
> then hung processes is somehow being hung in __generic_unplug_device,  i
> had a look at the assembler, but couldn't make heads or tails of it. the
> code at __generic_unplug_device+19 was test %eax,%eax immediately
> preceded by a callq to the test instruction. Obviously something magic
> (by my eyes) is going on here.
> 
>  Also tried 2.6.12_rc3-mm3
> 
>  I'd really like to find a solution to this since it kinda borks the
> nice an shiny machine if it can't handle large files without getting
> into trouble.
> 
>  I've been working on this for two days, have been trying to find
> similar bug reports, trying a lot of different kernels and kernel
> options to no avail.
>  I'm a little out of options right now, any ideas for something to try,
> patches to test, or some help in understanding what's happening ?
> 
> 
> kmirrord/0 D ffff81003f1bccd8 0 978 9 1731 977 (L-TLB)
> Call Trace:
> <ffffffff8016a2d6>{cache_alloc_refill+1222}
> <ffffffff804a2f9f>{io_schedule+15}
> --
> kjournald D ffff81003e94bcd8 0 1748 1 2060 953 (L-TLB)
> Call Trace:
> <ffffffff802e9c13>{__generic_unplug_device+19}
> <ffffffff802e9cfd>{generic_unplug_device+189}
> --
> rsync D 000000701553dccf 0 6903 6901 (NOTLB)
> Call Trace:
> <ffffffff802e9c13>{__generic_unplug_device+19}
> <ffffffff802e9cfd>{generic_unplug_device+189}
> --
> x86_64-pc-lin D 0000006dc7d23e49 0 13785 13742 (NOTLB)
> Call Trace:
> <ffffffff802e9cfd>{generic_unplug_device+189}
> <ffffffff8040e3ad>{dm_unplug_all+29}
> 
> /Mikael Andersson
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
