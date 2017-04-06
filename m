From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipathd: locks itself in udev trigger
Date: Thu, 6 Apr 2017 13:23:13 -0500
Message-ID: <20170406182313.GM19236@octiron.msp.redhat.com>
References: <1491481447.16787.2.camel@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1491481447.16787.2.camel@yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alban Browaeys <prahal@yahoo.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 06, 2017 at 02:24:07PM +0200, Alban Browaeys wrote:
> Bcache backing partition bcache0 triggers an udev add event that is handled by multipathd.
>  Somewhat the other "bare" paritions sda<n> do not.
> 
> The issue is when this event triggers the thread lock itself since commit
>  c6a18f4541d0a161e2f5fed8c67d9732bf512b37 "fix INIT_REQUESTED_UDEV code" .
> This change in "uev_update_path" moved "uev_add_path(uev, vecs);" under the fast lock (non recursive)
> "lock(&vecs->lock);".  As uev_add_path too calls "lock(&vecs->lock);" multipathd hangs in this second call
> in the same thread.

Oops. I'll post a fix for this shortly.

Thanks
-Ben
 
> Then "multipathd list paths" or other multipathd commands returns timeout.
> This also postpone systemd shutdown/reboot by a minute while it waits for multipathd service to stop.
>  
> The backtrace was:
> (gdb) t a a bt
> 
> Thread 6 (Thread 0x7f922663c700 (LWP 545)):
> #0  syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
> #1  0x00007f9228bd3602 in ?? () from /usr/lib/x86_64-linux-gnu/liburcu.so.4
> #2  0x00007f92289ba424 in start_thread (arg=0x7f922663c700) at pthread_create.c:333
> #3  0x00007f922825c9bf in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:105
> 
> Thread 5 (Thread 0x7f9229734700 (LWP 543)):
> #0  __lll_lock_wait () at ../sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:135
> #1  0x00007f92289bcb85 in __GI___pthread_mutex_lock (mutex=0x556fefc43080) at ../nptl/pthread_mutex_lock.c:80
> #2  0x0000556fedcbe42d in lock (a=0x556fefc43080) at ../libmultipath/lock.h:12
> #3  uev_add_path (vecs=0x556fefc43080, uev=<optimized out>, uev=<optimized out>) at main.c:627
> #4  0x0000556fedcbe9c9 in uev_update_path (uev=0x7f9220001510, vecs=0x556fefc43080) at main.c:998
> #5  0x0000556fedcbecdb in uev_trigger (uev=0x7f9220001510, trigger_data=0x556fefc43080) at main.c:1146
> #6  0x00007f92292091b2 in service_uevq (tmpq=tmpq@entry=0x7f9229733b10) at uevent.c:89
> #7  0x00007f9229209280 in uevent_dispatch (uev_trigger=<optimized out>, trigger_data=<optimized out>) at uevent.c:145
> #8  0x0000556fedcbc2cc in uevqloop (ap=0x556fefc43080) at main.c:1177
> #9  0x00007f92289ba424 in start_thread (arg=0x7f9229734700) at pthread_create.c:333
> #10 0x00007f922825c9bf in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:105
> 
> Thread 4 (Thread 0x7f9229745700 (LWP 542)):
> #0  __lll_lock_wait () at ../sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:135
> #1  0x00007f92289bcb85 in __GI___pthread_mutex_lock (mutex=0x556fefc43080) at ../nptl/pthread_mutex_lock.c:80
> #2  0x0000556fedcbfb45 in lock (a=0x556fefc43080) at ../libmultipath/lock.h:12
> #3  checkerloop (ap=0x556fefc43080) at main.c:1827
> #4  0x00007f92289ba424 in start_thread (arg=0x7f9229745700) at pthread_create.c:333
> #5  0x00007f922825c9bf in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:105
> 
> Thread 3 (Thread 0x7f9229810700 (LWP 541)):
> #0  0x00007f9228253611 in __GI_ppoll (fds=0x7f92180021e0, nfds=nfds@entry=1, timeout=<optimized out>, timeout@entry=0x556fedecc020 <sleep_time>, sigmask=sigmask@entry=0x7f922980fa60) at ../sysdeps/unix/sysv/linux/ppoll.c:39
> #1  0x0000556fedcc13ba in ppoll (__ss=0x7f922980fa60, __timeout=0x556fedecc020 <sleep_time>, __nfds=1, __fds=<optimized out>) at /usr/include/x86_64-linux-gnu/bits/poll2.h:77
> #2  uxsock_listen (uxsock_trigger=0x556fedcbb520 <uxsock_trigger>, trigger_data=0x556fefc43080) at uxlsnr.c:204
> #3  0x0000556fedcbbd5a in uxlsnrloop (ap=0x556fefc43080) at main.c:1239
> #4  0x00007f92289ba424 in start_thread (arg=0x7f9229810700) at pthread_create.c:333
> #5  0x00007f922825c9bf in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:105
> 
> Thread 2 (Thread 0x7f9229851700 (LWP 540)):
> #0  0x00007f922825354d in poll () at ../sysdeps/unix/syscall-template.S:84
> #1  0x00007f9229209f3a in poll (__timeout=<optimized out>, __nfds=1, __fds=0x7f9229850a88) at /usr/include/x86_64-linux-gnu/bits/poll2.h:46
> #2  uevent_listen (udev=0x556fefbec040) at uevent.c:515
> #3  0x0000556fedcbc235 in ueventloop (ap=0x556fefbec040) at main.c:1166
> #4  0x00007f92289ba424 in start_thread (arg=0x7f9229851700) at pthread_create.c:333
> #5  0x00007f922825c9bf in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:105
> 
> Thread 1 (Thread 0x7f9229746f00 (LWP 537)):
> #0  pthread_cond_wait@@GLIBC_2.3.2 () at ../sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S:185
> #1  0x0000556fedcc0aba in child (param=<optimized out>) at main.c:2407
> #2  0x0000556fedcbb0df in main (argc=<optimized out>, argv=0x7fff81f9a0d8) at main.c:2664
> 
> As a local workaround I moved "uev_add_path" in "uev_update_path" back out of the lock umbrella
>  while I keep it under pp->initialized check.
> https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=859157;filename=fix_uev_update_path_udevadd_recursive_lock_deadlock.diff;msg=5
> This change fixes the reboot delay but I have no multipath setup thus cannot detect any regressions.
> 
> -Alban
