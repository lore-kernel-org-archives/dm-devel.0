From: Juergen Kreileder <jk@blackdown.de>
Subject: SLUB problems (was Re: lvcreate on 2.6.22.1: kernel
 tried to execute NX-protected page)
Date: Thu, 16 Aug 2007 20:45:27 +0200
Message-ID: <46C49B47.8000805@blackdown.de>
References: <87y7gperd1.fsf@blackdown.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87y7gperd1.fsf@blackdown.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

I got a few more oopses like the one in the original message (see below)
and one with a different call trace but that happened while creating a
snapshot too.

After that I rebuilt the kernel with SLAB instead of SLUB.  The system
is running fine for a week now.


BUG: unable to handle kernel NULL pointer dereference at virtual address
00000013
 printing eip:
c0118ef5
*pdpt = 000000001d044001
*pde = 0000000020946067
*pte = 0000000000000000
Oops: 0002 [#1]
CPU:    0
EIP:    0060:[dup_fd+181/432]    Not tainted VLI
EFLAGS: 00010286   (2.6.22.1-jk1-exec-shield #1)
EIP is at dup_fd+0xb5/0x1b0
eax: f0f30128   ebx: 00000013   ecx: ffffffff   edx: 0000000c
esi: f0f300ec   edi: f537b7ac   ebp: f537b7e4   esp: d94cbef8
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process udev (pid: 9491, ti=d94ca000 task=f6b36a00 task.ti=d94ca000)
Stack: 00000001 f537b788 00000020 f0f30128 f537b780 f5784f00 00000000
c18e5370
       01200011 c0119034 fffffff4 f5784f00 c0119360 dd044270 de5469a0
f2b82a80
       0000251a f5784fbc d94cbfb8 bfb1bbe8 c040d0d0 c18e5370 01200011
b7f734a8
Call Trace:
 [copy_files+68/96] copy_files+0x44/0x60
 [copy_process+624/2752] copy_process+0x270/0xac0
 [do_fork+100/496] do_fork+0x64/0x1f0
 [sys_clone+50/64] sys_clone+0x32/0x40
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 =======================
Code: 08 f3 a5 89 c1 83 e1 03 74 02 f3 a4 8b 5c 24 08 85 db 74 23 89 f6
8b 44 24 0c 8b 08 83 c0 04 89 44 24 0c 85 c9 0f 84 a1 00 00 00 <ff> 41
14 89 4d 00 83 c5 04 4b 75 df 8b 4c 24 04 31 f6 89 ef 8b
EIP: [dup_fd+181/432] dup_fd+0xb5/0x1b0 SS:ESP 0068:d94cbef8


Juergen Kreileder wrote:
> I got the appended BUG from a 32-bit 2.6.22.1 kernel (with exec-shield
> patch and PAE enabled) on an Athlon64 with dmsetup 1.02.03 and lvm2
> v2.02.02.
> (Note, the message comes from the vanilla kernel, not from the
> exec-shiled patch.)
>
> I wasn't able to reproduce the problem so far.  The machine creates
> several snapshot volumes every 4 hours and worked fine with the new
> kernel for several days.  It had 2.6.16.12+exec-shield before and ran
> flawlessy for over a year.
>
>
> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> BUG: unable to handle kernel paging request at virtual address f551df78
>  printing eip:
> f551df78
> *pdpt = 0000000000001001
> *pde = 80000000354001e3
> *pte = 9293396c5d22e546
> Oops: 0011 [#1]
> CPU:    0
> EIP:    0060:[<f551df78>]    Not tainted VLI
> EFLAGS: 00010286   (2.6.22.1-jk1-exec-shield #1)
> EIP is at 0xf551df78
> eax: f551df4c   ebx: f551df4c   ecx: 00000000   edx: f551df78
> esi: f551df78   edi: 00000000   ebp: 00000000   esp: e8ee5db4
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process lvcreate (pid: 25916, ti=e8ee4000 task=f7358a00 task.ti=e8ee4000)
> Stack: c02088c4 f551df64 c02088d0 c03dd95e c64ccf00 c0209118 00000287 c03dd95e
>        00000287 c018e38b c03dd952 d3e460e8 c018e393 c192a90c 00000000 c192b900
>        c03dd952 f557a600 f59bbcc0 00000000 c0157664 f557a64c f557a600 c01575be
> Call Trace:
>  [kobject_cleanup+116/128] kobject_cleanup+0x74/0x80
>  [kobject_release+0/16] kobject_release+0x0/0x10
>  [kref_put+56/160] kref_put+0x38/0xa0
>  [sysfs_hash_and_remove+267/320] sysfs_hash_and_remove+0x10b/0x140
>  [sysfs_hash_and_remove+275/320] sysfs_hash_and_remove+0x113/0x140
>  [sysfs_slab_alias+100/128] sysfs_slab_alias+0x64/0x80
>  [sysfs_slab_add+174/208] sysfs_slab_add+0xae/0xd0
>  [kmem_cache_create+236/320] kmem_cache_create+0xec/0x140
>  [jobs_init+46/128] jobs_init+0x2e/0x80
>  [kcopyd_init+45/176] kcopyd_init+0x2d/0xb0
>  [kcopyd_client_create+28/208] kcopyd_client_create+0x1c/0xd0
>  [init_hash_tables+142/192] init_hash_tables+0x8e/0xc0
>  [snapshot_ctr+506/752] snapshot_ctr+0x1fa/0x2f0
>  [dm_split_args+47/272] dm_split_args+0x2f/0x110
>  [dm_table_add_target+252/400] dm_table_add_target+0xfc/0x190
>  [vmalloc+32/48] vmalloc+0x20/0x30
>  [populate_table+98/192] populate_table+0x62/0xc0
>  [table_load+82/240] table_load+0x52/0xf0
>  [table_load+0/240] table_load+0x0/0xf0
>  [ctl_ioctl+209/288] ctl_ioctl+0xd1/0x120
>  [ctl_ioctl+0/288] ctl_ioctl+0x0/0x120
>  [do_ioctl+59/96] do_ioctl+0x3b/0x60
>  [vfs_ioctl+94/416] vfs_ioctl+0x5e/0x1a0
>  [sys_ioctl+61/128] sys_ioctl+0x3d/0x80
>  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
>  =======================
> Code: 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00 00 00 00 00 20 00 00 00 00 00 00 \
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <78> df 51 f5 78 df 51 f5 74 1b 8b \
>                 f7 00 00 00 00 00 00 00 00 32
> EIP: [<f551df78>] 0xf551df78 SS:ESP 0068:e8ee5db4

	Juergen

-- 
Juergen Kreileder, Blackdown Java-Linux Team
http://blog.blackdown.de/
