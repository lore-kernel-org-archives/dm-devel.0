Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E73F79CF
	for <dm-devel@lists.linux.dev>; Sat,  3 Feb 2024 03:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706930384; cv=none; b=ZK5bgioqzBoUVvJ0oA2Mav1QZqQ791O8IJEdZ/tNdt+oeavRtnMC6zoQ/w+jYyxAXSti0YdJHcb9+85DiVu/U3/YOi7iMD7LjSYfObO8mUzWsGssMESrq4NP79oPXErTKKL5IX4+JmjsTiLFqd58HRh/rZT2Wqb7EJ0z7FmHFJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706930384; c=relaxed/simple;
	bh=t9zWajDPNWAPFveChfDeaoSpQR3NYvuD6gImhjgcZsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltjKkuGy+0TUR0TCE/TEsEG+ZRDHbMB7uxBCdibYL9dLzeH38zSauiP3LqLrojkn9V4qvZ9fM9qWwR+KcleCUoVY/TK8ScP52nYhByVXR3tj9HB19XXpdVboJBVi9ZpR2hrNz/Mnlx0z+zBha1zT5NM961HaMP4C5LesMc/lQk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d528VldN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d528VldN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706930381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YScCYgn/YDm7KyE4VHg/k76RzBwfrchw7aPmjYSdxAY=;
	b=d528VldNv3ChttLtQQ2K8vmCP4AZOns4TaH7O5TVj/sy44oA5RoHhgSdYs7oUebZPNOPN8
	FJtC9iOaCnFjDKofMftJq4M3JRA9nM2IVWEUu7wKAEPEfggwN3OF78D7O00BH7YgcnfxAp
	7iMCuR1/PoaXhghjJYzn1g0Lfd2x1i8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-_2-psdbHPO269oI85mlyEw-1; Fri,
 02 Feb 2024 22:19:35 -0500
X-MC-Unique: _2-psdbHPO269oI85mlyEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08DE43812014;
	Sat,  3 Feb 2024 03:19:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D5551BDB1;
	Sat,  3 Feb 2024 03:19:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 4133JYtL105861
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 2 Feb 2024 22:19:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 4133JW0f105860;
	Fri, 2 Feb 2024 22:19:32 -0500
Date: Fri, 2 Feb 2024 22:19:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, xni@redhat.com,
        blazej.kucman@linux.intel.com, agk@redhat.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, song@kernel.org, yukuai3@huawei.com,
        jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, akpm@osdl.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v5 00/14] dm-raid/md/raid: fix v6.7 regressions
Message-ID: <Zb2wxIpf7uYV6Vya@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240201092559.910982-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201092559.910982-1-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Thu, Feb 01, 2024 at 05:25:45PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> I apply this patchset on top of v6.8-rc1, and run lvm2 tests suite with
> folling cmd for 24 round(for about 2 days):
> 
> for t in `ls test/shell`; do
>         if cat test/shell/$t | grep raid &> /dev/null; then
>                 make check T=shell/$t
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
>       6 ###       failed: [ndev-vanilla] shell/lvchange-raid1-writemostly.sh
>       2 ###       failed: [ndev-vanilla] shell/lvchange-rebuild-raid.sh
>       5 ###       failed: [ndev-vanilla] shell/lvconvert-raid-reshape-stripes-load-reload.sh
>       4 ###       failed: [ndev-vanilla] shell/lvconvert-raid-restripe-linear.sh
>       1 ###       failed: [ndev-vanilla] shell/lvconvert-raid1-split-trackchanges.sh
>      20 ###       failed: [ndev-vanilla] shell/lvconvert-repair-raid.sh
>      20 ###       failed: [ndev-vanilla] shell/lvcreate-large-raid.sh
>      24 ###       failed: [ndev-vanilla] shell/lvextend-raid.sh
> 
> And I ramdomly pick some tests verified by hand that these test will
> fail in v6.6 as well(not all tests):
> 
> shell/lvextend-raid.sh
> shell/lvcreate-large-raid.sh
> shell/lvconvert-repair-raid.sh
> shell/lvchange-rebuild-raid.sh
> shell/lvchange-raid1-writemostly.sh

In my testing with this patchset on top of the head of linus's tree
(5c24e4e9e708) I am seeing failures in
shell/lvconvert-raid-reshape-stripes-load-reload.sh and
shell/lvconvert-repair-raid.sh in about 20% of my runs. I have never
seen either of these these fail running on the 6.6 kernel (ffc253263a13).

lvconvert-repair-raid.sh creates a raid array and then disables one if
its drives before there's enough time to finish the initial sync and
tries to repair it. This is supposed to fail (it uses dm-delay devices
to slow down the sync). When the test succeeds, I see things like this:

[ 0:13.469] #lvconvert-repair-raid.sh:161+ lvcreate --type raid10 -m 1 -i 2 -L 64 -n LV1 LVMTEST191946vg /tmp/LVMTEST191946.ImUMG6dyqB/dev/mapper/LVMTEST191946pv1 /tmp/LVMTEST191946.ImUMG6dyqB/dev/mapper/LVMTEST191946pv2 /tmp/LVMTEST191946.ImUMG6dyqB/dev/mapper/LVMTEST191946pv3 /tmp/LVMTEST191946.ImUMG6dyqB/dev/mapper/LVMTEST191946pv4
[ 0:13.469]   Using default stripesize 64.00 KiB.
[ 0:13.483]   Logical volume "LV1" created.
[ 0:14.042] 6,8908,1194343108,-;device-mapper: raid: Superblocks created for new raid set
[ 0:14.042] 5,8909,1194348704,-;md/raid10:mdX: not clean -- starting background reconstruction
[ 0:14.042] 6,8910,1194349443,-;md/raid10:mdX: active with 4 out of 4 devices
[ 0:14.042] 4,8911,1194459161,-;mdX: bitmap file is out of date, doing full recovery
[ 0:14.042] 6,8912,1194563810,-;md: resync of RAID array mdX
[ 0:14.042]   WARNING: This metadata update is NOT backed up.
[ 0:14.042] aux disable_dev "$dev4"
[ 0:14.058] #lvconvert-repair-raid.sh:163+ aux disable_dev /tmp/LVMTEST191946.ImUMG6dyqB/dev/mapper/LVMTEST191946pv4
[ 0:14.058] Disabling device /tmp/LVMTEST191946.ImUMG6dyqB/dev/mapper/LVMTEST191946pv4 (253:5)
[ 0:14.101] not lvconvert -y --repair $vg/$lv1

When it fails, I see:

[ 0:13.831] #lvconvert-repair-raid.sh:161+ lvcreate --type raid10 -m 1 -i 2 -L 64 -n LV1 LVMTEST192248vg /tmp/LVMTEST192248.ATcecgSGfE/dev/mapper/LVMTEST192248pv1 /tmp/LVMTEST192248.ATcecgSGfE/dev/mapper/LVMTEST192248pv2 /tmp/LVMTEST192248.ATcecgSGfE/dev/mapper/LVMTEST192248pv3 /tmp/LVMTEST192248.ATcecgSGfE/dev/mapper/LVMTEST192248pv4
[ 0:13.831]   Using default stripesize 64.00 KiB.
[ 0:13.847]   Logical volume "LV1" created.
[ 0:14.499]   WARNING: This metadata update is NOT backed up.
[ 0:14.499] 6,8925,1187444256,-;device-mapper: raid: Superblocks created for new raid set
[ 0:14.499] 5,8926,1187449525,-;md/raid10:mdX: not clean -- starting background reconstruction
[ 0:14.499] 6,8927,1187450148,-;md/raid10:mdX: active with 4 out of 4 devices
[ 0:14.499] 6,8928,1187452472,-;md: resync of RAID array mdX
[ 0:14.499] 6,8929,1187453016,-;md: mdX: resync done.
[ 0:14.499] 4,8930,1187555486,-;mdX: bitmap file is out of date, doing full recovery
[ 0:14.499] aux disable_dev "$dev4"
[ 0:14.515] #lvconvert-repair-raid.sh:163+ aux disable_dev /tmp/LVMTEST192248.AT
cecgSGfE/dev/mapper/LVMTEST192248pv4
[ 0:14.515] Disabling device /tmp/LVMTEST192248.ATcecgSGfE/dev/mapper/LVMTEST192
248pv4 (253:5)
[ 0:14.554] not lvconvert -y --repair $vg/$lv1

To me the important looking difference (and I admit, I'm no RAID expert), is that in the
case where the test passes (where lvconvert fails as expected), I see

[ 0:14.042] 4,8911,1194459161,-;mdX: bitmap file is out of date, doing full recovery
[ 0:14.042] 6,8912,1194563810,-;md: resync of RAID array mdX

When it fails I see:

[ 0:14.499] 6,8928,1187452472,-;md: resync of RAID array mdX
[ 0:14.499] 6,8929,1187453016,-;md: mdX: resync done.
[ 0:14.499] 4,8930,1187555486,-;mdX: bitmap file is out of date, doing full recovery

Which appears to show a resync that takes no time, presumable because it happens before
the device notices that the bitmaps are wrong and schedules a full recovery.


lvconvert-raid-reshape-stripes-load-reload.sh repeatedly reloads the
device table during a raid reshape, and then tests the filesystem for
corruption afterwards. With this patchset, the filesystem is
occasionally corrupted.  I do not see this with the 6.6 kernel.

-Ben
 
> Xiao Ni also test the last version on a real machine, see [1].
> 
> [1] https://lore.kernel.org/all/CALTww29QO5kzmN6Vd+jT=-8W5F52tJjHKSgrfUc1Z1ZAeRKHHA@mail.gmail.com/
> 
> Yu Kuai (14):
>   md: don't ignore suspended array in md_check_recovery()
>   md: don't ignore read-only array in md_check_recovery()
>   md: make sure md_do_sync() will set MD_RECOVERY_DONE
>   md: don't register sync_thread for reshape directly
>   md: don't suspend the array for interrupted reshape
>   md: fix missing release of 'active_io' for flush
>   md: export helpers to stop sync_thread
>   md: export helper md_is_rdwr()
>   dm-raid: really frozen sync_thread during suspend
>   md/dm-raid: don't call md_reap_sync_thread() directly
>   dm-raid: add a new helper prepare_suspend() in md_personality
>   md/raid456: fix a deadlock for dm-raid456 while io concurrent with
>     reshape
>   dm-raid: fix lockdep waring in "pers->hot_add_disk"
>   dm-raid: remove mddev_suspend/resume()
> 
>  drivers/md/dm-raid.c |  78 +++++++++++++++++++--------
>  drivers/md/md.c      | 126 +++++++++++++++++++++++++++++--------------
>  drivers/md/md.h      |  16 ++++++
>  drivers/md/raid10.c  |  16 +-----
>  drivers/md/raid5.c   |  61 +++++++++++----------
>  5 files changed, 192 insertions(+), 105 deletions(-)
> 
> -- 
> 2.39.2
> 

