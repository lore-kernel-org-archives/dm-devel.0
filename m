From: Alexander Nyberg <alexn-auIyqT/O9BSzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [dm-devel] possible dm-crypt leak over loop
Date: Thu, 10 Mar 2005 15:55:11 +0100
Message-ID: <1110466511.2301.10.camel@boxen>
References: <1110147738.2266.26.camel@boxen>
	 <1110461058.14581.3.camel@leto.cs.pocnet.net>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <1110461058.14581.3.camel-Mk5Mb1HmSTpKDq6iQazPa6xOck334EZe@public.gmane.org>
To: Christophe Saout <christophe-4q3lyFh4P1g@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org, Steffen Michalke <StMichalke-S0/GAf8tV78@public.gmane.org>
List-Id: dm-devel.ids

> > I think this is more related to dm-crypt and not to loop. However - this
> > only seems to happen when dm-crypt is on top of loop, something I cannot
> > explain, how do they differ?. Sysrq-t trace at the bottom. My belief
> > after looking at this is that dm-crypt leaks memory somewhere but I
> > couldn't get around the dm code so here it is. This is 2.6.11, but this
> > bug has been present forever (easier to trigger now though).
> > 
> > =================================================
> > 
> > Testcase:
> > #!/bin/sh
> > losetup /dev/loop7 loopbackfile
> > echo 0 `blockdev --getsize /dev/loop7` crypt aes-plain 0123456789abcdef0123456789abcdef 0 /dev/loop7 0 | dmsetup create volume1
> > mkfs.ext3 /dev/mapper/volume1
> > mount /dev/mapper/volume1 mnt
> > cd mnt
> > dbench 20
> 
> How do you see there's a memory leak? Does your machine lock up? I just
> ran your testcase several times and I don't see anything unusual. Total
> system memory consumption doesn't change before and afterwards.
> 
> Can anybody else confirm this?

The original report came from Steffen Michalke (CC'd), but I find it
very weird that you can't trigger the lockup. It takes about a second
here on a UP non-preempt box to lock up.

Why I think it's a memory leak is due to the sysrq-Meminfo trace
and the call-trace showing 
crypt_alloc_buffer => mempool_alloc => io_schedule

It doesn't happen on normal block devices nor does loop cause this by
itself, it's the combination. Some binary searching showed that this bug
goes long back although it's easier to trigger now.

I'm kind of out of ideas, I've tried to look at the code myself but I
found it difficult to follow :(
