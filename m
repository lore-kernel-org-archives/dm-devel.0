From: Mikhail Klepachevskyy <mikhailk1@open-e.com>
Subject: Multisnapshot tests
Date: Fri, 19 Mar 2010 15:46:42 +0200
Message-ID: <20100319134642.GA2520@mick>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Sergey Tashkinov <sergeyt1@open-e.com>
List-Id: dm-devel.ids

Hello!

I continued tests of lvm-multisnapshots and possible found a bug.
Here is the sequence of my actions:

1. Built vanilla kernel 2.6.33.1 with patches from
   http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r16/
   applied. The next lines were added to the config:
   CONFIG_DM_MULTISNAPSHOT=m
   CONFIG_DM_MULTISNAPSHOT_MIKULAS=m
   CONFIG_DM_MULTISNAPSHOT_DANIEL=m
   Installed the new kernel on Debian Lenny and rebooted.


2. Origin and snapshot volumes were created on a 4-terabyte disk
   with RAID 0.
   The command was used:

# mdadm --create /dev/md0 --level=0 --raid-devices=4 /dev/sdb \
/dev/sdc /dev/sdd /dev/sde


3. The next commands were used to set up multisnapshots:
# modprobe dm-store-mikulas

# modprobe dm-multisnapshot

# pvcreate /dev/md0
Physical volume "/dev/md0" successfully created

# vgcreate vg1 /dev/md0
Volume group "vg1" successfully created

# lvcreate --size=1T --name=lv1 vg1
Logical volume "lv1" created

# lvcreate --size=1T --name=lv2 vg1
Logical volume "lv2" created

# dd if=/dev/zero of=/dev/mapper/vg1-lv2 bs=4096 count=1024
1024+0 records in
1024+0 records out
4194304 bytes (4,2 MB) copied, 0,00279046 s, 1,5 GB/s

# echo 0 `blockdev --getsz /dev/mapper/vg1-lv1` multisnapshot \
/dev/mapper/vg1-lv1 /dev/mapper/vg1-lv2 32 0 mikulas 0| dmsetup create ms

# dmsetup status /dev/mapper/ms
0 2147483648 multisnapshot 5 -1 - 4194304 128 128 0


How we can see the multisnapshot was created with the error -1 (EPERM)

dmesg info:

[71648.347171] device-mapper: multisnapshot: check_invalid: access to 
invalid part of the device: 1, size 20000
[71648.347228] Pid: 3810, comm: dmsetup Not tainted 
2.6.33.1-multisnapshot #1
[71648.347230] Call Trace:
[71648.347243]  [<f89c7070>] ? check_invalid+0x52/0x62 [dm_store_mikulas]
[71648.347248]  [<f89c71c9>] ? dm_multisnap_duplicate_block+0x2a/0x20b 
[dm_store_mikulas]
[71648.347252]  [<f89cbb6b>] ? dm_bufio_read+0xb/0x46 [dm_store_mikulas]
[71648.347255]  [<f89c6699>] ? dm_multisnap_alloc_blocks+0x36a/0x44a 
[dm_store_mikulas]
[71648.347259]  [<f89c678e>] ? dm_multisnap_alloc_make_block+0x15/0x32 
[dm_store_mikulas]
[71648.347263]  [<f89c6a80>] ? dm_multisnap_extend_bitmaps+0x63/0x380 
[dm_store_mikulas]
[71648.347269]  [<c10246f0>] ? __wake_up+0x29/0x39
[71648.347271]  [<c10246f0>] ? __wake_up+0x29/0x39
[71648.347275]  [<f89c5246>] ? 
dm_multisnap_mikulas_lock_acquired+0x17a/0x1b3 [dm_store_mikulas]
[71648.347279]  [<f89c5faa>] ? dm_multisnap_mikulas_init+0xab6/0xb34 
[dm_store_mikulas]
[71648.347283]  [<f89ab19d>] ? multisnap_origin_ctr+0x5dd/0x94d 
[dm_multisnapshot]
[71648.347295]  [<f854238e>] ? realloc_argv+0x4f/0x5b [dm_mod]
[71648.347300]  [<f85423e6>] ? dm_split_args+0x4c/0xd5 [dm_mod]
[71648.347305]  [<f8542cba>] ? dm_table_add_target+0x166/0x1dd [dm_mod]
[71648.347310]  [<f85445da>] ? table_load+0x1c5/0x1d7 [dm_mod]
[71648.347314]  [<f8545004>] ? dm_ctl_ioctl+0x189/0x1c9 [dm_mod]
[71648.347319]  [<f8544415>] ? table_load+0x0/0x1d7 [dm_mod]
[71648.347324]  [<f8544e7b>] ? dm_ctl_ioctl+0x0/0x1c9 [dm_mod]
[71648.347327]  [<c10bc079>] ? vfs_ioctl+0x1c/0x7d
[71648.347330]  [<c10bc5fd>] ? do_vfs_ioctl+0x46e/0x4a9
[71648.347333]  [<c11005e8>] ? security_file_permission+0xc/0xd
[71648.347336]  [<c10b12ba>] ? do_sync_read+0x0/0xe0
[71648.347340]  [<c101cb13>] ? do_page_fault+0x26a/0x280
[71648.347342]  [<c10bc679>] ? sys_ioctl+0x41/0x58
[71648.347345]  [<c1002e98>] ? sysenter_do_call+0x12/0x28


Important: creation of volumes of lesser size, 300 Mb each for
instance, caused no errors.


Also I'd like to ask: could anyone say where it is possible to find
the information and examples of using "lvm" tool for driving
multisnapshots?

-- 
Best wishes,
Mikhail Klepachevskyy
