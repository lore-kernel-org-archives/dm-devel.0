Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D48367
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 00:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706661024; cv=none; b=gVOKoeuedIOgw+Qj++0gMWLCfwVNUS7fHA3sqMIMu9MBUhw8VhYwI/VAWhKLI3lONpeknKhUqvIjz9FNKoeJK46I7342jz9u5gzgjFo/N++dcx4u9B6kw39hu1G7Qg2iHcuNmM3+pffm6apaZP2lsF2qAyy1RIKVYUszXqqwgjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706661024; c=relaxed/simple;
	bh=Um9MP5IR0S8qSCeEIIL2uP+d/hqhg9QdcE+uf3B6U5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fllj+xFs12qbOIgaJTrZn0P8GOxt1UorLEyuBb1bhiScAK8LGAOfVRGmod8gDOQN9yo181+TghGXyu4OTg1HT6h8y5bv1kkXc3KwDvyb3AQsX5eqDu1dMIjQKIuLzDzRaaTtnXK3BYBRTMkJc2dQd21fbmZLWFla4ykrcqC/hTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P0MebBo6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P0MebBo6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706661020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIQSJdivFWuPvtkWJSsaXtnAr5OpJWhQCgp77Hp0q9c=;
	b=P0MebBo6Cg0jZUXsd9EigS0NVm0j+JgUW6zdjFIkf234PE4C0oA84BZMFm306PVpaBEdWv
	cIqdgvYZduJzqTEc6nj1U+t09SOylZvwtJJBJnpywWdGNxJ90bfDg1kmV4krYBz+/F3c37
	n2trePWxF1GlMIXwq1Tk3NKM3MzBB28=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-ADv5ZxX4NAeJyXCTfpd99A-1; Tue, 30 Jan 2024 19:30:03 -0500
X-MC-Unique: ADv5ZxX4NAeJyXCTfpd99A-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5ce63e72bc3so2834790a12.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 16:30:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706661003; x=1707265803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIQSJdivFWuPvtkWJSsaXtnAr5OpJWhQCgp77Hp0q9c=;
        b=qYJy2404DhyL1HTOHBLJ5nxQ2I7nq2IB8Li06i3Q+IfaVPHb2mHPjYVz9yA0UBV2Xj
         Bq8JXI2JxQnt5TJc//1K7CSR3T0SynOFF7zygqSoXFQ2VEolUjMzluhwHlVhij1viw9y
         v1DPD8UfxSREVu1S3walIiicIeE/YHE3+LiNm47hro/av8pg0bfhoLcxD+pPmFtHAjBd
         DwynA184LZ3F3YDY8xjImMEjQrBXhaodg9YWoPqtMVhXnHmGEJy095KVJN9Hwsiygnxp
         DxmjLp2HZOBWcB/wHm5sQUw2ZjyfmxOzHw3SPQfx4te+qvQkPSCdjo44mRVl7k4ZXef8
         HUHg==
X-Gm-Message-State: AOJu0Yyjr5ExvSqUfzgAixsceXJVznnROQNPE3W8lGr5cTFIMSrvaUAR
	1XhhISBXeJxyvT75HknNruzHXW6sks90rJCW7RZJo7T2+pGHiP51MuLaSs1bp39bGFKCnyY7IHI
	RjmJ//DTCktFk9wu1vMJlM694/Z/gApiVazKxskW3MhDRSuu8i4CToN1yoHkp12NI1QSczkl0nk
	gd58CyDKHPlOca6mYnIqXWYN72j9zfG7I=
X-Received: by 2002:a05:6a20:b313:b0:19a:7e25:d7d3 with SMTP id ef19-20020a056a20b31300b0019a7e25d7d3mr56941pzb.18.1706661002755;
        Tue, 30 Jan 2024 16:30:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdrQIrRz68R0OcDbuPBifQ3QFr85HOMVxcG7cBaRZ36f3y/EtbultqOYo2ZucridOem2iWozCP6hHyHqpvY+s=
X-Received: by 2002:a05:6a20:b313:b0:19a:7e25:d7d3 with SMTP id
 ef19-20020a056a20b31300b0019a7e25d7d3mr56913pzb.18.1706661002402; Tue, 30 Jan
 2024 16:30:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130021843.3608859-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240130021843.3608859-1-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 31 Jan 2024 08:29:51 +0800
Message-ID: <CALTww29QO5kzmN6Vd+jT=-8W5F52tJjHKSgrfUc1Z1ZAeRKHHA@mail.gmail.com>
Subject: Re: [PATCH v4 00/14] dm-raid: fix v6.7 regressions
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, agk@redhat.com, snitzer@kernel.org, 
	dm-devel@lists.linux.dev, song@kernel.org, yukuai3@huawei.com, 
	jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 10:23=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v4:
>  - add patch 10 to fix a raid456 deadlock(for both md/raid and dm-raid);
>  - add patch 13 to wait for inflight IO completion while removing dm
>  device;
>
> Changes in v3:
>  - fix a problem in patch 5;
>  - add patch 12;
>
> Changes in v2:
>  - replace revert changes for dm-raid with real fixes;
>  - fix dm-raid5 deadlock that exist for a long time, this deadlock is
>  triggered because another problem is fixed in raid5, and instead of
>  deadlock, user will read wrong data before v6.7, patch 9-11;
>
> First regression related to stop sync thread:
>
> The lifetime of sync_thread is designed as following:
>
> 1) Decide want to start sync_thread, set MD_RECOVERY_NEEDED, and wake up
> daemon thread;
> 2) Daemon thread detect that MD_RECOVERY_NEEDED is set, then set
> MD_RECOVERY_RUNNING and register sync_thread;
> 3) Execute md_do_sync() for the actual work, if it's done or
> interrupted, it will set MD_RECOVERY_DONE and wake up daemone thread;
> 4) Daemon thread detect that MD_RECOVERY_DONE is set, then clear
> MD_RECOVERY_RUNNING and unregister sync_thread;
>
> In v6.7, we fix md/raid to follow this design by commit f52f5c71f3d4
> ("md: fix stopping sync thread"), however, dm-raid is not considered at
> that time, and following test will hang:
>
> shell/integrity-caching.sh
> shell/lvconvert-raid-reshape.sh
>
> This patch set fix the broken test by patch 1-4;
>  - patch 1 fix that step 4) is broken by suspended array;
>  - patch 2 fix that step 4) is broken by read-only array;
>  - patch 3 fix that step 3) is broken that md_do_sync() doesn't set
>  MD_RECOVERY_DONE; Noted that this patch will introdece new problem that
>  data will be corrupted, which will be fixed in later patches.
>  - patch 4 fix that setp 1) is broken that sync_thread is register and
>  MD_RECOVERY_RUNNING is set directly, md/raid behaviour, not related to
>  dm-raid;
>
> With patch 1-4, the above test won't hang anymore, however, the test
> will still fail and complain that ext4 is corrupted;
>
> Second regression related to frozen sync thread:
>
> Noted that for raid456, if reshape is interrupted, then call
> "pers->start_reshape" will corrupt data. And dm-raid rely on md_do_sync()
> doesn't set MD_RECOVERY_DONE so that new sync_thread won't be registered,
> and patch 3 just break this.
>
>  - Patch 5-6 fix this problem by interrupting reshape and frozen
>  sync_thread in dm_suspend(), then unfrozen and continue reshape in
> dm_resume(). It's verified that dm-raid tests won't complain that
> ext4 is corrupted anymore.
>  - Patch 7 fix the problem that raid_message() call
>  md_reap_sync_thread() directly, without holding 'reconfig_mutex'.
>
> Last regression related to dm-raid456 IO concurrent with reshape:
>
> For raid456, if reshape is still in progress, then IO across reshape
> position will wait for reshape to make progress. However, for dm-raid,
> in following cases reshape will never make progress hence IO will hang:
>
> 1) the array is read-only;
> 2) MD_RECOVERY_WAIT is set;
> 3) MD_RECOVERY_FROZEN is set;
>
> After commit c467e97f079f ("md/raid6: use valid sector values to determin=
e
> if an I/O should wait on the reshape") fix the problem that IO across
> reshape position doesn't wait for reshape, the dm-raid test
> shell/lvconvert-raid-reshape.sh start to hang at raid5_make_request().
>
> For md/raid, the problem doesn't exist because:
>
> 1) If array is read-only, it can switch to read-write by ioctl/sysfs;
> 2) md/raid never set MD_RECOVERY_WAIT;
> 3) If MD_RECOVERY_FROZEN is set, mddev_suspend() doesn't hold
>    'reconfig_mutex' anymore, it can be cleared and reshape can continue b=
y
>    sysfs api 'sync_action'.
>
> However, I'm not sure yet how to avoid the problem in dm-raid yet.
>
>  - patch 9-11 fix this problem by detecting the above 3 cases in
>  dm_suspend(), and fail those IO directly.
>
> If user really meet the IO error, then it means they're reading the wrong
> data before c467e97f079f. And it's safe to read/write the array after
> reshape make progress successfully.
>
> There are also some other minor changes: patch 8 and patch 12;
>
> Test result:
>
> I apply this patchset on top of v6.8-rc1, and run lvm2 tests suite with
> folling cmd for 24 round(for about 2 days):
>
> for t in `ls test/shell`; do
>         if cat test/shell/$t | grep raid &> /dev/null; then
>                 make check T=3Dshell/$t
>         fi
> done
>
> failed count                             failed test
>       1 ###       failed: [ndev-vanilla] shell/dmsecuretest.sh
>       1 ###       failed: [ndev-vanilla] shell/dmsetup-integrity-keys.sh
>       1 ###       failed: [ndev-vanilla] shell/dmsetup-keyring.sh
>       5 ###       failed: [ndev-vanilla] shell/duplicate-pvs-md0.sh
>       1 ###       failed: [ndev-vanilla] shell/duplicate-vgid.sh
>       2 ###       failed: [ndev-vanilla] shell/duplicate-vgnames.sh
>       1 ###       failed: [ndev-vanilla] shell/fsadm-crypt.sh
>       1 ###       failed: [ndev-vanilla] shell/integrity.sh
>       6 ###       failed: [ndev-vanilla] shell/lvchange-raid1-writemostly=
.sh
>       2 ###       failed: [ndev-vanilla] shell/lvchange-rebuild-raid.sh
>       5 ###       failed: [ndev-vanilla] shell/lvconvert-raid-reshape-str=
ipes-load-reload.sh
>       4 ###       failed: [ndev-vanilla] shell/lvconvert-raid-restripe-li=
near.sh
>       1 ###       failed: [ndev-vanilla] shell/lvconvert-raid1-split-trac=
kchanges.sh
>      20 ###       failed: [ndev-vanilla] shell/lvconvert-repair-raid.sh
>      20 ###       failed: [ndev-vanilla] shell/lvcreate-large-raid.sh
>      24 ###       failed: [ndev-vanilla] shell/lvextend-raid.sh
>
> And I ramdomly pick some tests verified by hand that these test will
> fail in v6.6 as well(not all tests, I don't have the time do do this yet)=
:
>
> shell/lvextend-raid.sh
> shell/lvcreate-large-raid.sh
> shell/lvconvert-repair-raid.sh
> shell/lvchange-rebuild-raid.sh
> shell/lvchange-raid1-writemostly.sh
>
> Yu Kuai (14):
>   md: don't ignore suspended array in md_check_recovery()
>   md: don't ignore read-only array in md_check_recovery()
>   md: make sure md_do_sync() will set MD_RECOVERY_DONE
>   md: don't register sync_thread for reshape directly
>   md: export helpers to stop sync_thread
>   dm-raid: really frozen sync_thread during suspend
>   md/dm-raid: don't call md_reap_sync_thread() directly
>   dm-raid: add a new helper prepare_suspend() in md_personality
>   md: export helper md_is_rdwr()
>   md: don't suspend the array for interrupted reshape
>   md/raid456: fix a deadlock for dm-raid456 while io concurrent with
>     reshape
>   dm-raid: fix lockdep waring in "pers->hot_add_disk"
>   dm: wait for IO completion before removing dm device
>   dm-raid: remove mddev_suspend/resume()
>
>  drivers/md/dm-raid.c |  78 +++++++++++++++++++---------
>  drivers/md/dm.c      |   3 ++
>  drivers/md/md.c      | 120 +++++++++++++++++++++++++++++--------------
>  drivers/md/md.h      |  16 ++++++
>  drivers/md/raid10.c  |  16 +-----
>  drivers/md/raid5.c   |  61 ++++++++++++----------
>  6 files changed, 190 insertions(+), 104 deletions(-)
>
> --
> 2.39.2
>

Hi all

In my environment, the lvm2 regression test has passed. There are only
three failed cases which also fail in kernel 6.6.

###       failed: [ndev-vanilla] shell/lvresize-fs-crypt.sh
###       failed: [ndev-vanilla] shell/pvck-dump.sh
###       failed: [ndev-vanilla] shell/select-report.sh
### 426 tests: 346 passed, 70 skipped, 0 timed out, 7 warned, 3 failed
  in 89:26.073

Best Regards
Xiao

