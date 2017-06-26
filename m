From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH] dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Mon, 26 Jun 2017 11:46:08 +0200
Message-ID: <7ba503ae-ab87-493a-264c-3b42f8418c34@redhat.com>
References: <20170626090848.21585-1-zren@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170626090848.21585-1-zren@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Ren <zren@suse.com>, dm-devel@redhat.com
Cc: jtang@suse.com, agk@redhat.com, neilb@suse.com, snitzer@redhat.com
List-Id: dm-devel.ids

Dne 26.6.2017 v 11:08 Eric Ren napsal(a):
> When the primary mirror device fails, activating a mirrored
> LV will crash the kernel. It can be reproduced 100% with the
> scripts below:
> 
> """
> dd if=/dev/zero of=file.raw bs=1G count=1
> loopdev=$(losetup -f)
> losetup $loopdev file.raw
> dmsetup create pv1 --table "0 102399 linear $loopdev 0"
> dmsetup create pv2 --table "0 102399 linear $loopdev 102400"
> vgcreate vgtest /dev/mapper/pv1 /dev/mapper/pv2
> lvcreate -l1 --type mirror -m1 -n mirror12 --mirrorlog core \
>                   vgtest /dev/mapper/pv1 /dev/mapper/pv2
> vgchange -an vgtest
> echo 0 10000000 error | dmsetup load /dev/mapper/pv1
> dmsetup resume /dev/mapper/pv1
> vgchange -ay vgtest
> " > The call trace:
> """
> [  287.008629] device-mapper: raid1: Unable to read primary mirror during recovery
> [  287.008632] device-mapper: raid1: Primary mirror (254:10) failed while out-of-sync: Reads may fail.
> ...
> [  287.012480] BUG: unable to handle kernel NULL pointer dereference at 0000000000000019
> [  287.012515] IP: [<ffffffffa00d944f>] mirror_end_io+0x7f/0x130 [dm_mirror]
> ...
> [  291.994645] Call Trace:
> [  291.994671]  [<ffffffffa007b215>] clone_endio+0x35/0xe0 [dm_mod]
> [  291.994675]  [<ffffffffa0589ced>] do_reads+0x17d/0x1d0 [dm_mirror]
> [  291.994680]  [<ffffffffa058af5c>] do_mirror+0xec/0x250 [dm_mirror]
> [  291.994687]  [<ffffffff810958fe>] process_one_work+0x14e/0x410
> [  291.994691]  [<ffffffff81096156>] worker_thread+0x116/0x490
> [  291.994694]  [<ffffffff8109b627>] kthread+0xc7/0xe0
> """
> 
> Fixes it by setting "details.bi_bdev" to NULL in error path beforing
> calling into mirror_end_io(), which will fail the IO properly.


Hi

Which kernel version is this ?

I'd thought we've already fixed this BZ for old mirrors:
https://bugzilla.redhat.com/show_bug.cgi?id=1382382

There similar BZ for md-raid based mirrors (--type raid1)
https://bugzilla.redhat.com/show_bug.cgi?id=1416099


Regards

Zdenej
