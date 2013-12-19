From: Daniel Wheeler <dwheeler@ewheeler.net>
Subject: Trying to us dmcache with zram block device
Date: Wed, 18 Dec 2013 16:31:09 -0800
Message-ID: <1387413069.4019.17.camel@daniel.ewheeler.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

I am trying to use zram for the dmcache meta and dmcache caching device
to cache a local logical volume.

It works just fine if I use logical volumes from a disk as the caching
device, but using a zram block device as the cache sets up properly but
fails to boot a virtual machine on the resulting volume. Interestingly,
I can use zram as a meta cache device without error, but using zram as
the cache itself is when this fails. 

This is how I'm setting up my device map:

0 20758528 cache /dev/zram0 /dev/zram1 /dev/c0v0/vdb 64 1 writethrough mq 6 sequential_threshold 5120 random_threshold 2 migration_threshold 819200

zram0 and zram1 are both 1GB in size so plenty of space here.
I am booting linux 3.11.4 with that version of dmcache.

When I try and boot a VM off of the resulting cache, the VM fails to
write to it's disk (I think), and displays the following error when
booting CentOS 6:

mount: wrong fs type, bad option, bad superblock on /dev/mapper/VM_NAME,
	missing codepage or helper program, or other error
	In some cases useful info is found in syslog - try
	dmesg | tail or so


Kernel Panic - not syncing: Attempting to kill init!
Pid: 1, comm: init Not tainted 2.6.32-279.e16.x86_64 #1
Call Trace:
 [<ffffffff814fd11a>] ? panic+0xa0/0x168
 [<ffffffff81070bd2>] ? do_exit+0x862/0x870
 [<ffffffff8117ca75>] ? fput+0x25/0x30
 [<ffffffff81070c38>] ? do_group_exit+0x58/0xd0
 [<ffffffff81070cc7>] ? sys_exit_group+0x17/0x20
 [<ffffffff8100b0f2>] ? system_call_fastpath+0x16/0x1b

Can you think of any reason that zram cannot be a cache for dmcache devices?

If this is a bug, does it reside in dmcache or in zram?

How can I test this further?

-Daniel
