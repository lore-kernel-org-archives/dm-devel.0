From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: Re: mpathpersist
Date: Wed, 4 Jan 2012 17:12:53 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D07A58501@BTCMVEXC2-PRD.hq.netapp.com>
References: <4EFEA631.3020902@internyc.net><1325340015.6564.18.camel@lapoo.opensvc.com>	<4EFF4BF1.2070608@internyc.net>
	<EE2129A8E578DC4E94D643D6C1C1C67D07A5804B@BTCMVEXC2-PRD.hq.netapp.com>
	<4F0276E2.4070708@internyc.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4F0276E2.4070708@internyc.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Fil <lists@internyc.net>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On January 03, 2012 9:03 AM, Fil wrote:
> Vijay,
> 
> I tried applying patches over that commit and it almost applied. There
is still
> one reject.
> 
> cat ./multipathd/cli.h.rej
> --- multipathd/cli.h	2011-12-18 02:25:43.000000000 -0500
> +++ multipathd/cli.h	2011-12-18 02:26:09.000000000 -0500
> @@ -65,9 +65,9 @@
>  #define WILDCARDS	(1 << __WILDCARDS)
>  #define QUIT		(1 << __QUIT)
>  #define SHUTDOWN	(1 << __SHUTDOWN)
> -#define GETPRSTATUS    (1 << __GETPRSTATUS)
> -#define SETPRSTATUS    (1 << __SETPRSTATUS)
> -#define UNSETPRSTATUS  (1 << __UNSETPRSTATUS)
> +#define GETPRSTATUS	(1 << __GETPRSTATUS)
> +#define SETPRSTATUS	(1 << __SETPRSTATUS)
> +#define UNSETPRSTATUS	(1UL << __UNSETPRSTATUS)
> 
>  #define INITIAL_REPLY_LEN 1000
> 
This is unexpected though I will recheck it.

> It looks like those definitions already exist. The really bad news is
once you
> compile it  and run it, it still breaks multipathd cli.
> 
> ./mpathpersist/mpathpersist --out --register --param-sark=123abc
> --prout-type=8 /dev/mapper/blah -v 4
> Jan 02 22:31:27 | alias = blah
> Jan 02 22:31:27 | params = 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1 Jan
02 22:31:27
> | status = 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 A 0 Jan 02 22:31:27 |
blah: disassemble
> map [0 0 1 1 round-robin 0 2 1 8:0 1
> 8:16 1 ]
> Jan 02 22:31:27 | 8:0: not found in pathvec Jan 02 22:31:27 | 8:16:
not found in
> pathvec Jan 02 22:31:27 | No device found for 8:0
> 
> Jan 02 22:31:27 | No device found for 8:16

Looks like this is due to sysfs changes in latest kernel. I will fix it.
Thanks for reporting.

> 
> Jan 02 22:31:27 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0 A
0
> 8:16 A 0 ]
> Jan 02 22:31:27 | blah: reservation_key  = 0x123abc (config file
default) Jan 02
> 22:31:27 | 36001405c55fc03cd8193d491eda0d4d7: no path available PR
out:
> command failed
> 
> 
> multipathd -k
> multipathd> help
> 
> Jan 02 22:29:15 | Got request [help]
> Jan 02 22:29:15 | Reply [1033 bytes]

I will look into it and will fix it. 

> *** glibc detected *** ./multipathd/multipathd: free(): invalid next
size
> (normal): 0x00007fe77c001d40 *** ======= Backtrace: =========
> /lib64/libc.so.6[0x366b47c2d6] /lib64/libc.so.6[0x366b47d5be]
> ./multipathd/multipathd[0x40abe7] ./multipathd/multipathd[0x4076eb]
> /lib64/libpthread.so.0[0x366bc07d90]
> /lib64/libc.so.6(clone+0x6d)[0x366b4ef48d]
> ======= Memory map: ========
> 00400000-00412000 r-xp 00000000 fd:02 134411  /root/vlah/multipath-
> tools/multipathd/multipathd
> 00612000-00613000 rw-p 00012000 fd:02 134411  /root/vlah/multipath-
> tools/multipathd/multipathd
> 012a0000-012c1000 rw-p 00000000 00:00 0
>  [heap]
> 366b000000-366b022000 r-xp 00000000 fd:02 129841  /lib64/ld-2.14.90.so
> 366b221000-366b222000 r--p 00021000 fd:02 129841  /lib64/ld-2.14.90.so
> 366b222000-366b223000 rw-p 00022000 fd:02 129841  /lib64/ld-2.14.90.so
> 366b223000-366b224000 rw-p 00000000 00:00 0


Thanks,
Vijay
