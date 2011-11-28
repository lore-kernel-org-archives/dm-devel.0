From: Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [PATCH] deadlock with suspend and quotas
Date: Mon, 28 Nov 2011 14:00:14 -0700
Message-ID: <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
	<20111128150400.GE6366@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111128150400.GE6366@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Christopher Chaltain <christopher.chaltain@canonical.com>
List-Id: dm-devel.ids

On Mon, Nov 28, 2011 at 8:04 AM, Jan Kara <jack@suse.cz> wrote:
> =A0Hello,
>
> On Fri 25-11-11 15:25:16, Mikulas Patocka wrote:
>> This script causes a kernel deadlock:
>> #!/bin/sh
>> set -e
>> DEVICE=3D/dev/vg1/linear
>> lvchange -ay $DEVICE
>> mkfs.ext3 $DEVICE
>> mount -t ext3 -o usrquota,grpquota $DEVICE /mnt/test
>> quotacheck -gu /mnt/test
>> umount /mnt/test
>> mount -t ext3 -o usrquota,grpquota $DEVICE /mnt/test
>> quotaon /mnt/test
>> dmsetup suspend $DEVICE
>> setquota -u root 1 2 3 4 /mnt/test &
>> sleep 1
>> dmsetup resume $DEVICE
>>
>> setquota acquired semaphore s_umount for read and then tried to perf=
orm
>> a transaction (and waits because the device is suspended).
>> dmsetup resume tries to acquire s_umount for write before resuming t=
he device
>> (and waits for setquota).
>>
>> Here are stacktraces:
>> setquota:
>> [ =A0 67.524456] =A0[<ffffffff810aa84e>] ? get_page_from_freelist+0x=
31e/0x790
>> [ =A0 67.524529] =A0[<ffffffffa0250265>] ? start_this_handle.isra.9+=
0x265/0x3b0 [jbd]
>> [ =A0 67.524604] =A0[<ffffffff8105bc00>] ? add_wait_queue+0x60/0x60
>> [ =A0 67.524675] =A0[<ffffffffa02505a1>] ? journal_start+0xc1/0x100 =
[jbd]
>> [ =A0 67.524742] =A0[<ffffffff810e62d6>] ? kmem_cache_alloc+0xf6/0x1=
b0
>> [ =A0 67.524808] =A0[<ffffffffa028018d>] ? ext3_acquire_dquot+0x3d/0=
x80 [ext3]
>> [ =A0 67.524872] =A0[<ffffffff81143749>] ? dqget+0x359/0x3b0
>> [ =A0 67.524916] =A0[<ffffffff81143ad4>] ? dquot_get_dqblk+0x14/0x1b=
0
>> [ =A0 67.524985] =A0[<ffffffff81147c34>] ? quota_getquota+0x24/0xd0
>> [ =A0 67.525048] =A0[<ffffffff810ff3db>] ? do_path_lookup+0x2b/0x90
>> [ =A0 67.525082] =A0[<ffffffff810ff8cd>] ? kern_path+0x1d/0x40
>> [ =A0 67.525134] =A0[<ffffffff81148311>] ? do_quotactl+0x421/0x540
>> [ =A0 67.525191] =A0[<ffffffff811073f0>] ? dput+0x20/0x230
>> [ =A0 67.525234] =A0[<ffffffff81148507>] ? sys_quotactl+0xd7/0x1a0
>> [ =A0 67.525304] =A0[<ffffffff8130a03b>] ? system_call_fastpath+0x16=
/0x1b
>>
>> dmsetup resume:
>> [ =A0 67.525887] =A0[<ffffffffa0238280>] ? dev_wait+0xc0/0xc0 [dm_mo=
d]
>> [ =A0 67.525948] =A0[<ffffffff81309225>] ? rwsem_down_failed_common+=
0xc5/0x160
>> [ =A0 67.526013] =A0[<ffffffff81198a43>] ? call_rwsem_down_write_fai=
led+0x13/0x20
>> [ =A0 67.526058] =A0[<ffffffff81308adc>] ? down_write+0x1c/0x1d
>> [ =A0 67.526103] =A0[<ffffffff810f3a91>] ? thaw_super+0x21/0xc0
>> [ =A0 67.526166] =A0[<ffffffff81124d4d>] ? thaw_bdev+0x6d/0x90
>> [ =A0 67.526223] =A0[<ffffffff8105583e>] ? queue_work+0x4e/0x60
>> [ =A0 67.526269] =A0[<ffffffffa0230e63>] ? unlock_fs+0x23/0x40 [dm_m=
od]
>> [ =A0 67.526341] =A0[<ffffffffa02336d0>] ? dm_resume+0xb0/0xd0 [dm_m=
od]
>> [ =A0 67.526388] =A0[<ffffffffa0238420>] ? dev_suspend+0x1a0/0x230 [=
dm_mod]
>> [ =A0 67.526441] =A0[<ffffffffa0238a59>] ? ctl_ioctl+0x159/0x2a0 [dm=
_mod]
>> [ =A0 67.526510] =A0[<ffffffff8116c4ee>] ? ipc_addid+0x4e/0xd0
>> [ =A0 67.526555] =A0[<ffffffffa0238bae>] ? dm_ctl_ioctl+0xe/0x20 [dm=
_mod]
>> [ =A0 67.526620] =A0[<ffffffff811025de>] ? do_vfs_ioctl+0x8e/0x4e0
>> [ =A0 67.526670] =A0[<ffffffff811073f0>] ? dput+0x20/0x230
>> [ =A0 67.526737] =A0[<ffffffff810f3112>] ? fput+0x162/0x220
>> [ =A0 67.526783] =A0[<ffffffff81102a79>] ? sys_ioctl+0x49/0x90
>> [ =A0 67.526838] =A0[<ffffffff8130a03b>] ? system_call_fastpath+0x16=
/0x1b
>>
>> The following patch fixes the deadlock. When the quota subsystem tak=
es s_umount,
>> it checks if the filesystem is frozen. If it is, we drop s_umount, w=
ait for
>> the filesystem to resume and retry.
> =A0Thanks for the patch. I'm aware of the deadlock and Val Henson is =
working
> on resolving these types of deadlocks more systematically. But since =
I
> haven't heard from her for a while, I guess I'll merge your fix and s=
he'll
> update her series to reflect your change since those patches are goin=
g to
> go in at earliest in the next merge window.
> =A0To sum up: I've merged your patch.

=46YI, I no longer have time to consult in addition to my full-time job=
=2E
 Canonical is taking over this patch set.

-VAL
