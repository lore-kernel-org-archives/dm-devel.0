From: Hubert <hubgor@poczta.fm>
Subject: Page allocation failure: dm+lvm2+xfs+samba
Date: Thu, 07 Jul 2005 19:33:24 +0200
Message-ID: <42CD6764.8000002@poczta.fm>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I'm using Linux/GNU Debian, 512MB, kernel 2.6.12 (2.6.13-rc2 tested 
too), dm developmnet patches (and without tested too), 
libdevmapper1.01.03, lvm2-2.01.12.

LV size is 15GB (20GB tested too) and snpashot size is 256MB (2GB tested 
too).

I met below problem and debug message from dmesg when copying data from 
another host to smb share on my server with lvm2 and executing lvcreate 
or lvremove snapshot foo LV under XFS fs at same time:

kjournald starting. Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
XFS quotacheck dm-1: Please wait.
XFS quotacheck dm-1: Done.
XFS mounting filesystem dm-4
Ending clean XFS mount for filesystem: dm-4
XFS mounting filesystem dm-4
Ending clean XFS mount for filesystem: dm-4
XFS mounting filesystem dm-6
Ending clean XFS mount for filesystem: dm-6
device-mapper: snapshot is marked invalid
XFS mounting filesystem dm-6
Ending clean XFS mount for filesystem: dm-6
come here (1) with no 2nd level
device-mapper: snapshot is marked invalid
XFS mounting filesystem dm-8
Ending clean XFS mount for filesystem: dm-8
device-mapper: snapshot is marked invalid
device-mapper: snapshot is marked invalid
XFS mounting filesystem dm-10
Ending clean XFS mount for filesystem: dm-10
I/O error in filesystem ("dm-4") meta-data dev dm-4 block 0xf00332
("xlog_iodone") error 5 buf count 1024
xfs_force_shutdown(dm-4,0x2) called from line 952 of file
fs/xfs/xfs_log.c. Return address = 0xc02931bb
Filesystem "dm-4": Log I/O Error Detected. Shutting down filesystem: dm-4
Please umount the filesystem, and rectify the problem(s)
xfs_force_shutdown(dm-4,0x1) called from line 353 of file
fs/xfs/xfs_rw.c. Return address = 0xc02931bb
device-mapper: snapshot is marked invalid
device-mapper: snapshot is marked invalid
device-mapper: snapshot is marked invalid
XFS mounting filesystem dm-4
Ending clean XFS mount for filesystem: dm-4
come here (2) with no 2nd level
lvcreate: page allocation failure. order:0, mode:0x8d0
[<c0139e33>] __alloc_pages+0x2b3/0x430
[<c0368ee4>] alloc_pl+0x34/0x60
[<c0369025>] client_alloc_pages+0x25/0x60
[<c0363cbd>] dm_vcalloc+0x2d/0x60
[<c0369a7d>] kcopyd_client_create+0x6d/0xc0
[<c036cd35>] snapshot_ctr+0x2d5/0x3b0
[<c0364a69>] dm_table_add_target+0x149/0x200
[<c0367530>] populate_table+0x90/0xf0
[<c03675f8>] table_load+0x68/0x170
[<c03681b9>] ctl_ioctl+0xf9/0x160
[<c0367590>] table_load+0x0/0x170
[<c01661a8>] do_ioctl+0x58/0x80
[<c0166335>] vfs_ioctl+0x65/0x1e0
[<c0166517>] sys_ioctl+0x67/0x90
[<c01029e9>] syscall_call+0x7/0xb
device-mapper: Could not create kcopyd client
device-mapper: error adding target to table

It occures when are created and removed 3-4 snapshots :(

What is last dm status about reating snapshots?

Maybe I should to use other version lvm2 or dm ?


Best regards,
Hubert
hubgor@poczta.fm


----------------------------------------------------------------------
Najnowsze wiadomosci!!! >>> http://link.interia.pl/f18a0
