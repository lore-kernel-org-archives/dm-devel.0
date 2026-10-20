Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792479449;
	b=2o53O2hPGle1RenJi8AX2E+cJ1mQwsTh2jrb439Ok4A4dzphr5TtGBoSUFpwy7GJ4pg5
	 t2Ft/7Y0C3n12/p+ETXUZPGBSVpwpalPuSl7dnIhgblHu44cBb3ysSGGr7zPYCZ1DFPEM
	 HqODMpXYRaQ+2o7We3gTSzUdHSROLzf98s4hkQkxkJebiAdhj0sXz1hfG63f0P3twZ5WL
	 vNQ+FMH39SLnXxNUasWn2GyYBClNMVPb3Y4C8ZPQEE32Apf6d68TfoGQMMPPP16n/xLOF
	 2D5cWQkoixNEqfGjkoTwljLt5xa1/51l7usCZyOic4xod8mNY7eAGJe7vrHUmnK1sQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792479449;
	h=DMARC-Filter:DKIM-Signature:Date:Mime-Version:X-Lms-Return-Path:
	 Reply-To:Message-Id:From:Cc:To:X-Original-From:
	 Content-Transfer-Encoding:Received:References:In-Reply-To:
	 Content-Type:User-Agent:Subject;
	bh=YmzrkAr1UCdFF1b7GSnZNeQasDWPbv25bVPLQoA0QTE=;
	b=G+Ii2ILrfD0SNRiddZ6j+rCBUz6bqchbKxq9x9zSjLCqPkBzTbAYu6vGpah5Y3De+bhS
	 DpFs83LigcebKAhpSrk/8rk7nTd6285JFul2XnoKm+qvwiXElrKDlSHevRNzJrSdhjW53
	 qnPuUIiPNg1nEGghqNCtFgG3YbjVD6O2LWsiHnE/DSlGcy4CMvuo+KXAdxHuC63rKAP0O
	 SuR6EGvVyzi78RuRM99h9DWhm6YaHD1CjxSyrD65ugZfuDJAFxkBUKVzGZKEXWi5PS4Zb
	 +9fg0rzOia90CWb6cgDIuzMO0dzUwMlV27ccLVFRzWH7vgIiGcpO5yuOIKBdqd/dTTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=OMdnNeHn;
	arc=none smtp.remote-ip=209.127.231.48
Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275F660A383D
	for <dm-devel@lists.linux.dev>; Tue, 20 Oct 2026 06:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 275F660A383D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=OMdnNeHn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1792479433;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=YmzrkAr1UCdFF1b7GSnZNeQasDWPbv25bVPLQoA0QTE=;
 b=OMdnNeHnsa/x0j5hsYN3yNbcS2qb8SQ9eZpoRASiKSgY2V82t8+wNZ6lTor20AbDKTzRtS
 pf5W4k2tx/cIl+kLCJJ9cXRwY/CPQ1dLUe67JlDi+SCr/Dvfq6/+PPK0Qy1r56MsPSrsOG
 asiSe4KnszoJmlVNhxXun2cXLPRDHXvkL7Alxr8yEEX/knK0dpjHuTebAk5hkYnHjFxitY
 1E4M4APSta6jqKk2Yqc1m1cB5WGUdnoKgItjZtuCKry+8CZeUO4dl3fkVWzx+jzHmOCejT
 JDh5xsDJoNRpqjoFVXqkAl1yXDhoreUE17YVJbIT1ysN+SCBSpXmwalD5S88Sw==
Date: Tue, 20 Oct 2026 14:57:07 +0800
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ad710c8+1d6954+lists.linux.dev+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Message-Id: <e2c36f31-d198-40a7-a18d-156e1fd6fbb2@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Cc: <linux-block@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, 
	"Christoph Hellwig" <hch@lst.de>, "Damien Le Moal" <dlemoal@kernel.org>, 
	"Ming Lei" <tom.leiming@gmail.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, <dm-devel@lists.linux.dev>, 
	<linux-kernel@vger.kernel.org>, "Jack Wang" <jinpu.wang@cloud.ionos.com>
To: "Jack Wang" <jinpu.wang@ionos.com>, "Song Liu" <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, "Nilay Shroff" <nilay@linux.ibm.com>, 
	<abd.masalkhi@gmail.com>, "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.21]) by smtp.larksuite.com with ESMTPS; Tue, 20 Oct 2026 06:57:11 +0000
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] md: don't wait for q->limits_lock while md holds back I/O

Hi,

=E5=9C=A8 2026/9/10 16:11, Jack Wang =E5=86=99=E9=81=93:
> From: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> Writing to a queue limits attribute of an md array while a spare is
> being re-added deadlocks the array.  I reported this earlier here:
>
>    https://lore.kernel.org/linux-raid/CAMGffE=3DheGA3y8FjQ0Sm1jj-kd-=3DH9=
Y54WozKASSEZhc9UNKjA@mail.gmail.com/
>
> Four tasks, one array:
>
>    udev-worker    queue_attr_store() holds q->limits_lock, waits in
>                   blk_mq_freeze_queue() for q_usage_counter to drain

Sorry for the delay, usually blk_mq_freeze_queue() is useless for bio-based
disks, because it can't guarantee inflight BIOs to drain. So this looks lik=
e
a long term problem since queue_attr_store() can still update limits while
there can still be bios inflight.

>    fio            holds a q_usage_counter reference, parked in
>                   md_handle_request()'s is_suspended() loop
>    mdadm          suspended the array, waits for reconfig_mutex
>    md_start_sync  holds reconfig_mutex, waits for q->limits_lock

And this deadlock looks related to blk_mq_freeze_queue() concurrent with
mddev_suspend(), hence there can be bio blocked between. So I think there
can be a simpler solution for this deadlock.

1) either remove the blk_mq_freeze_queue() from limits update for mdraid, o=
r
2) also add blk_mq_freeze_queue() to mddev_suspend().

If this is a mdraid specific problem, I'll suggest 2). If there are other
bio-based drivers have the same problem, we might what to replace
blk_mq_freeze_queue() with driver's bio suspend to fix that limits can
update with inflight bios as well.

>
> The last leg is mddev_stack_new_rdev() from ->hot_add_disk().  Since
> commit c99f66e4084a ("block: fix queue freeze vs limits lock order in
> sysfs store methods") the sysfs store holds q->limits_lock across the
> freeze, so md must not block on that lock while it is holding back the
> I/O the freeze waits for.  That is the same hazard mddev_suspend()
> already documents for reconfig_mutex.
>
> v1 kept q->limits_lock outermost where it could and used a trylock
> everywhere else.  Christoph asked for the lock ordering to be fixed
> instead, so v2 drops the trylock and the block patch that added it.
>
> The rule v2 applies is that q->limits_lock nests outside reconfig_mutex
> and the suspend everywhere, with no exceptions to paper over.  The two
> callers that cannot own an update do not need one: check_sb_changes()
> and md_check_recovery() only ever re-add a device that is already a
> member, so its limits are stacked and the update is a refresh, and they
> now take the no-stack path unconditionally.  mddev_update_io_opt() is
> not an add and does need the update, so patch 4 defers it to a work
> item that takes the lock with nothing held.
>
> Making the hoists unconditional exposed a second cycle that the trylock
> had been hiding, which Nilay hit with lockdep on v1:
>
>    q->limits_lock -> reconfig_mutex        added by this series
>    reconfig_mutex -> disk->open_mutex      pre-existing, md opens legs
>                                            under reconfig_mutex
>    disk->open_mutex -> q->limits_lock      pre-existing, sd_open() ->
>                                            sd_revalidate_disk()
>
> Only the middle edge can go, so legs are now opened before any md lock
> is taken.  Patch 7 does the opens and patch 8 the holder links, which
> take disk->open_mutex too and were easy to miss because the release
> side only takes blk_holder_mutex.  Opening without reconfig_mutex means
> the superblock format fields have to be snapshotted and rechecked once
> the array is locked.
>
> Patches 1, 3 and 6 are plumbing with no functional change.
>
> Two callers still take q->limits_lock inside reconfig_mutex, both with
> the array suspended, and patch 5 says why: ->start_reshape() from
> action_store(), which suspends before flushing sync_work, and
> raid*_run() -> queue_limits_set() from level_store(), which already
> hangs on its own because it freezes the queue while suspended.  Both
> need more restructuring than belongs here.
>
> The patches are based on v7.3-rc2.
>
> v1: https://lore.kernel.org/linux-raid/20260909063029.GC29874@lst.de/T/#t
>
> Changes since v1:
>   - Drop the trylock and the block patch adding
>     queue_limits_start_update_trylock(), per Christoph.
>   - check_sb_changes() and md_check_recovery() take the no-stack path
>     unconditionally instead of trying the lock first.
>   - Defer the io_opt update to a work item rather than skipping it on a
>     contended pass (patch 4, was "md: don't wait for q->limits_lock in
>     mddev_update_io_opt()").
>   - New patches 6-8 to close the reconfig_mutex -> disk->open_mutex
>     edge that lockdep reported on v1: pass a queue_limits through
>     ->run(), open new legs before locking the array, and link their
>     holders there too.
>   - Rebased on v7.3-rc2.
>
> Testing, on v7.3-rc2 with lockdep (PROVE_LOCKING, DEBUG_LOCK_ALLOC):
>
>   - the reproducer below, 20 fail/remove/add cycles with fio in flight
>     and a loop writing queue/max_sectors_kb, where the same test wedges
>     the array before the series
>   - array start at raid0, raid1, raid5, raid10 and linear, spare add,
>     fail and remove, the rdev sysfs stores, ADD_NEW_DISK, array_state
>     transitions, a level change and a raid5 3 -> 4 reshape to
>     completion, which is what exercises patch 4's work item: io_opt
>     goes from 1048576 to 1572864 once end_reshape() runs
>   - HOT_ADD_DISK of an undersized leg, so bind_rdev_to_array() fails
>     and patch 8's release path runs
>
> No lockdep reports, and debug_locks stayed 1 throughout.  Every patch
> builds on its own.
>
> A blktests case covering this deadlock will be sent separately.
>
> The reproducer, for anyone who wants it:
>
>    mdadm -C /dev/md111 --force -e 1.2 --assume-clean -l 1 \
>          --bitmap=3Dinternal -n 2 /dev/ram0 /dev/ram1
>
>    fio --direct=3D1 --rw=3Drandrw --ioengine=3Dlibaio --iodepth=3D32 --nu=
mjobs=3D4 \
>        --time_based=3D1 --runtime=3D180 --filename=3D/dev/md111 --name=3D=
repro &
>
>    while :; do
>        echo 128 > /sys/block/md111/queue/max_sectors_kb 2>/dev/null
>    done &
>
>    for i in $(seq 20); do
>        mdadm /dev/md111 --fail /dev/ram0
>        mdadm /dev/md111 --remove /dev/ram0
>        mdadm /dev/md111 --add /dev/ram0
>        mdadm --wait /dev/md111
>    done
>
> Jack Wang (8):
>    md: pass a queue_limits down to ->hot_add_disk()
>    md: don't wait for q->limits_lock in check_sb_changes()
>    md: pass a queue_limits through the rdev sysfs stores
>    md: defer the io_opt update out of the sync thread
>    md: take q->limits_lock before locking and suspending the array
>    md: pass a queue_limits through ->run()
>    md: open new legs before locking the array
>    md: link a new leg's holder before locking the array
>
>   drivers/md/dm-raid.c       |   4 +-
>   drivers/md/md-autodetect.c |  38 ++-
>   drivers/md/md-linear.c     |  30 +-
>   drivers/md/md.c            | 661 +++++++++++++++++++++++++++++--------
>   drivers/md/md.h            |  56 +++-
>   drivers/md/raid0.c         |  16 +-
>   drivers/md/raid1.c         |  26 +-
>   drivers/md/raid10.c        |  37 ++-
>   drivers/md/raid5.c         |  54 ++-
>   9 files changed, 741 insertions(+), 181 deletions(-)
>
--=20
Thanks,
Kuai
