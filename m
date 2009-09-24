From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: circular locking dependency in dm
Date: Thu, 24 Sep 2009 10:11:28 +0200
Message-ID: <20090924081127.GA6387@schmichrtp.de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

While testing some zfcp patches with the current linux-2.6 git
checkout i got this:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-08358-g94a8d5c-dirty #2
-------------------------------------------------------
multipathd/2409 is trying to acquire lock:
 (_event_lock){+.+.+.}, at: [<00000000002e5efc>] dm_table_event+0x50/0x80

but task is already holding lock:
 (_hash_lock){++++..}, at: [<00000000002e9d84>] dev_remove+0x2c/0xf0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (_hash_lock){++++..}:
       [<0000000000086d92>] __lock_acquire+0xe2e/0x19cc
       [<00000000000879a0>] lock_acquire+0x70/0x98
       [<00000000004eb486>] down_read+0x5e/0x9c
       [<00000000002e81ba>] dm_copy_name_and_uuid+0x3e/0xec
       [<00000000002e131a>] dm_send_uevents+0x9a/0x180
       [<00000000002e1eee>] event_callback+0xae/0xf8
       [<00000000002e5f12>] dm_table_event+0x66/0x80
       [<000000000006b0a4>] worker_thread+0x24c/0x308
       [<0000000000071302>] kthread+0x9a/0xa4
       [<000000000001c5de>] kernel_thread_starter+0x6/0xc
       [<000000000001c5d8>] kernel_thread_starter+0x0/0xc

-> #0 (_event_lock){+.+.+.}:
       [<00000000000877e2>] __lock_acquire+0x187e/0x19cc
       [<00000000000879a0>] lock_acquire+0x70/0x98
       [<00000000004ea7a0>] mutex_lock_nested+0x78/0x3f0
       [<00000000002e5efc>] dm_table_event+0x50/0x80
       [<00000000002e9d1a>] __hash_remove+0xaa/0xe8
       [<00000000002e9db6>] dev_remove+0x5e/0xf0
       [<00000000002ea5e4>] ctl_ioctl+0x20c/0x288
       [<00000000002ea68a>] dm_ctl_ioctl+0x2a/0x38
       [<00000000000fc6cc>] vfs_ioctl+0x4c/0xdc
       [<00000000000fcbdc>] do_vfs_ioctl+0x3a8/0x5c8
       [<00000000000fce4c>] SyS_ioctl+0x50/0x8c
       [<0000000000029cf6>] sysc_noemu+0x10/0x16
       [<0000020000264286>] 0x20000264286

other info that might help us debug this:

1 lock held by multipathd/2409:
 #0:  (_hash_lock){++++..}, at: [<00000000002e9d84>] dev_remove+0x2c/0xf0

stack backtrace:
CPU: 0 Not tainted 2.6.31-08358-g94a8d5c-dirty #2
Process multipathd (pid: 2409, task: 000000002f6c6038, ksp: 000000002c8c7aa8)
       0000000000000000 000000002c8c7998 0000000000000002 0000000000000000 
       000000002c8c7a38 000000002c8c79b0 000000002c8c79b0 00000000004e8582 
       0000000000000000 0000000000000001 0000000000000000 0000000000000000 
       000000000000000d 0000000000000000 000000002c8c7a00 000000000000000e 
       00000000004faf90 00000000000179e0 000000002c8c7998 000000002c8c79e0 
Call Trace:
([<00000000000178e2>] show_trace+0xee/0x144)
 [<00000000000858ca>] print_circular_bug+0x112/0x124
 [<00000000000877e2>] __lock_acquire+0x187e/0x19cc
 [<00000000000879a0>] lock_acquire+0x70/0x98
 [<00000000004ea7a0>] mutex_lock_nested+0x78/0x3f0
 [<00000000002e5efc>] dm_table_event+0x50/0x80
 [<00000000002e9d1a>] __hash_remove+0xaa/0xe8
 [<00000000002e9db6>] dev_remove+0x5e/0xf0
 [<00000000002ea5e4>] ctl_ioctl+0x20c/0x288
 [<00000000002ea68a>] dm_ctl_ioctl+0x2a/0x38
 [<00000000000fc6cc>] vfs_ioctl+0x4c/0xdc
 [<00000000000fcbdc>] do_vfs_ioctl+0x3a8/0x5c8
 [<00000000000fce4c>] SyS_ioctl+0x50/0x8c
 [<0000000000029cf6>] sysc_noemu+0x10/0x16
 [<0000020000264286>] 0x20000264286
INFO: lockdep is turned off.
