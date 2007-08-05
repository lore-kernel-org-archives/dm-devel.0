From: Juergen Kreileder <jk@blackdown.de>
Subject: Re: lvcreate on 2.6.22.1: kernel tried to execute
	NX-protected page
Date: Sun, 05 Aug 2007 21:03:22 +0200
Message-ID: <87y7gperd1.fsf@blackdown.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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


I've upgraded devmapper to 1.02.20 and lvm2 to 2.02.26.  Didn't help much,
I just got a the same BUG again:

kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle kernel paging request at virtual address f492c1f8
 printing eip:
f492c1f8
*pdpt = 0000000000001001
*pde = 80000000348001e3
*pte = ec1c7da0ec1c7da0
Oops: 0011 [#1]
CPU:    0
EIP:    0060:[<f492c1f8>]    Not tainted VLI
EFLAGS: 00010282   (2.6.22.1-jk1-exec-shield #1)
EIP is at 0xf492c1f8
eax: f492c1cc   ebx: f492c1cc   ecx: 00000000   edx: f492c1f8
esi: f492c1f8   edi: 00000000   ebp: 00000000   esp: d4177db4
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process lvcreate (pid: 2303, ti=d4176000 task=d1c88a00 task.ti=d4176000)
Stack: c02088c4 f492c1e4 c02088d0 c03dd95e c2969f60 c0209118 ce684800 e5436280 
       00000287 c03dd952 c03dd952 f6a44548 c018e393 c19ea90c 00000000 c19eb900 
       c03dd952 c18f9780 f45cb300 00000000 c0157664 c18f97cc c18f9780 c01575be 
Call Trace:
 [kobject_cleanup+116/128] kobject_cleanup+0x74/0x80
 [kobject_release+0/16] kobject_release+0x0/0x10
 [kref_put+56/160] kref_put+0x38/0xa0
 [sysfs_hash_and_remove+275/320] sysfs_hash_and_remove+0x113/0x140
 [sysfs_slab_alias+100/128] sysfs_slab_alias+0x64/0x80
 [sysfs_slab_add+174/208] sysfs_slab_add+0xae/0xd0
 [kmem_cache_create+236/320] kmem_cache_create+0xec/0x140
 [jobs_init+46/128] jobs_init+0x2e/0x80
 [kcopyd_init+45/176] kcopyd_init+0x2d/0xb0
 [kcopyd_client_create+28/208] kcopyd_client_create+0x1c/0xd0
 [init_hash_tables+142/192] init_hash_tables+0x8e/0xc0
 [snapshot_ctr+506/752] snapshot_ctr+0x1fa/0x2f0
 [dm_split_args+47/272] dm_split_args+0x2f/0x110
 [dm_table_add_target+252/400] dm_table_add_target+0xfc/0x190
 [vmalloc+32/48] vmalloc+0x20/0x30
 [populate_table+98/192] populate_table+0x62/0xc0
 [table_load+82/240] table_load+0x52/0xf0
 [table_load+0/240] table_load+0x0/0xf0
 [ctl_ioctl+209/288] ctl_ioctl+0xd1/0x120
 [ctl_ioctl+0/288] ctl_ioctl+0x0/0x120
 [do_ioctl+59/96] do_ioctl+0x3b/0x60
 [vfs_ioctl+94/416] vfs_ioctl+0x5e/0x1a0
 [sys_ioctl+61/128] sys_ioctl+0x3d/0x80
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 =======================
Code: 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00 00 00 00 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <f8> c1 92 f4 f8 c1 92 f4 4c 16 b6 f5 00 00 00 00 00 00 00 00 00 
EIP: [<f492c1f8>] 0xf492c1f8 SS:ESP 0068:d4177db4


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
