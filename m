From: Masatake YAMATO <yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device mapper ioctl
Date: Fri, 11 Nov 2016 12:13:35 +0900 (JST)
Message-ID: <20161111.121335.2066742280452520368.yamato@redhat.com>
References: <20161011223803.GA30714@obsidian>
	<alpine.LRH.2.02.1610191626360.628@file01.intranet.prod.int.rdu2.redhat.com>
	<CACGkJdts9AKHnXb+b6J2kfpDNZJZW12WaNaYukrA11PHtAydag@mail.gmail.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CACGkJdts9AKHnXb+b6J2kfpDNZJZW12WaNaYukrA11PHtAydag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

>>
>> Here I'm sending the device mapper ioctl patch with these changes merged.
> 
> Hello.
> 
> Thank you for your contribution. The implementation of DM_* ioctl
> decoding is now in strace's master, you can check it out at
> https://github.com/strace/strace/commit/a507a0bb777c552e43e1e45f302703a09ffea1b8
> Could you please review it and let us know if there are any issues?


It works fine on my Fedora 24(x86_64).
"make check" says "PASS" about ioctl_dm.test and  ioctl_dm-v.test.

Very useful. Thank you.

Masatake YAMATO

> 
>> In this piece of code:
>> +       dm_arg_open3->target3.next = 0xdeadbeef;
>> +       dm_arg_open3->param3[0] = '\1';
>> +       dm_arg_open3->param3[1] = '\2';
>> +       dm_arg_open3->param1[2] = '\0';
>> there should be "dm_arg_open3->param3[2]" instead of
>> "dm_arg_open3->param1[2]". "dm_arg_open3->param1[2]" produces a warning
>> about access beyond the end of array.
> Thank you for noticing, it was an oversight on my part.
> 
>> Mikulas
> 
> 
> -- 
> Eugene "eSyr" Syromyatnikov
> mailto:evgSyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> xmpp:eSyr@jabber.{ru|org}

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
