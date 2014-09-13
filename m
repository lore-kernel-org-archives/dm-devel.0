From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [BUG] dm-writeboost: Don't pass __GFP_ZERO to
	mempool_alloc()
Date: Sun, 14 Sep 2014 08:38:33 +0900
Message-ID: <5414D579.3040502@gmail.com>
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
Cc: akpm@linux-foundation.org
List-Id: dm-devel.ids

Hi,

A user reported me that the current Writeboost in Joe's tree
(https://github.com/jthornber/linux-2.6)
screams on his environment.

With CONFIG_DEBUG_VM (n->y),
it reproduces on my environment, too.

d  245.865224] device-mapper: writeboost: Superblock Header: Magic number invalid
[  245.892588] ------------[ cut here ]------------
[  245.892601] WARNING: CPU: 7 PID: 3463 at mm/mempool.c:205 mempool_alloc+0xc3/0x1b0()
[  245.892602] Modules linked in: binfmt_misc nfsd joydev psmouse snd_hda_codec_generic serio_raw pcspkr parport_pc parport snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd virtio_balloon i2c_piix4 evbug soundcore hid_generic usbhid hid floppy
[  245.892617] CPU: 7 PID: 3463 Comm: dmsetup Not tainted 3.16.0+ #146
[  245.892618] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  245.892619]  0000000000000009 ffff8800301639e8 ffffffff818002e0 0000000000000006
[  245.892621]  0000000000000000 ffff880030163a28 ffffffff810529fc ffffffff8114cbd7
[  245.892622]  00000000000080d0 ffff880211742000 ffff8802117b0638 0000000000000000
[  245.892624] Call Trace:
[  245.892630]  [<ffffffff818002e0>] dump_stack+0x4e/0x68
[  245.892634]  [<ffffffff810529fc>] warn_slowpath_common+0x8c/0xc0
[  245.892636]  [<ffffffff8114cbd7>] ? mempool_free_slab+0x17/0x20
[  245.892638]  [<ffffffff81052a4a>] warn_slowpath_null+0x1a/0x20
[  245.892639]  [<ffffffff8114d153>] mempool_alloc+0xc3/0x1b0
[  245.892641]  [<ffffffff8114cbd7>] ? mempool_free_slab+0x17/0x20
[  245.892645]  [<ffffffff81676cdd>] resume_cache+0x17ad/0x1a10
[  245.892651]  [<ffffffff8143e118>] ? sscanf+0x38/0x40
[  245.892654]  [<ffffffff8167337e>] writeboost_ctr+0x2fe/0x6f0
[  245.892659]  [<ffffffff81640824>] dm_table_add_target+0x194/0x440
[  245.892661]  [<ffffffff81643aed>] table_load+0xdd/0x350
[  245.892663]  [<ffffffff81643a10>] ? table_clear+0xe0/0xe0
[  245.892665]  [<ffffffff81644d9d>] ctl_ioctl+0x25d/0x500
[  245.892671]  [<ffffffff8117c300>] ? __remove_shared_vm_struct+0x30/0x60
[  245.892673]  [<ffffffff81645053>] dm_ctl_ioctl+0x13/0x20
[  245.892681]  [<ffffffff811c1f08>] do_vfs_ioctl+0x88/0x570
[  245.892682]  [<ffffffff8117e55c>] ? vm_munmap+0x5c/0x80
[  245.892688]  [<ffffffff81809877>] ? sysret_check+0x1b/0x56
[  245.892690]  [<ffffffff811c2481>] SyS_ioctl+0x91/0xb0
[  245.892692]  [<ffffffff81809852>] system_call_fastpath+0x16/0x1b
[  245.892701] ---[ end trace 9ec34fde0329cc22 ]---

Obviously, mempool_alloc() is in trouble.

The reason is a line VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO) was inserted in mempool_alloc().
The related discussion is https://lkml.org/lkml/2014/4/14/525

Yes, Writeboost passes __GFP_ZERO to mempool_alloc() at two locations.
I will fix this by adding memset after each and send Joe a pull request.

I checked through other DM targets and found no target needs this fix. It is good.

- Akira
