Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326D63B2AD
	for <dm-devel@lists.linux.dev>; Wed, 21 Feb 2024 05:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708494334; cv=none; b=Mjv1XPQXV8NfvckutYZifKSabYLKRQaLcQWUop1peVrQ4PFrLlKmWtUZGdluivsPUety7VGljyAJCE1nZ9B3WKMF5DlDytSY2uT4Yo9n6af4fu/QxIrtqNhe+yi7uU0/1gyS7jRPOZb1GOzqXash0/F2C6ZayYooSp9bmsZFKVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708494334; c=relaxed/simple;
	bh=hYZkMb5dMZgn7yBjtBVuyqLNP6xnOmpr+aw/VVMbZbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kX6u0a3MdUePlGOvGD+VSY1ZBTvER7BhbQUrKSgn9IttoblFRMfhmV5McLoZPuxRtcDywXRwTAfNE2cfdIti04/TAI/vvB0zyYIgVrPAfueYJ9uElhnnIbar7mB5+1E8W63CoPkznuG/IUzD8K7xkLaagSkqROtaMa+9peJQEFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBQ/Ljo0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBQ/Ljo0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708494330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=80HG10fnyJe9+VFtDqb0QmxzRH/bSTX9wn1afisZkqo=;
	b=XBQ/Ljo0oWbbi6KTKsIN+nUidoP8Hble5SYU8Nqd95uPJI9maNRlt9xmhrhIeIfM/wzjMd
	wDUFaC0LkPdp+eCNGHYYdhD5GJXt2dlnmVBhMh21aygL528AKBKlKYZLQgEcWiZIIyiITX
	sbQetvfsGmB/5iByyil7YLSwfiCcRk4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-4T0Xqp4AMuKoutm16yFPeA-1; Wed, 21 Feb 2024 00:45:29 -0500
X-MC-Unique: 4T0Xqp4AMuKoutm16yFPeA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9BD78493E4;
	Wed, 21 Feb 2024 05:45:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67C801121306;
	Wed, 21 Feb 2024 05:45:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41L5jS9O501645
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 00:45:28 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41L5jQ7K501644;
	Wed, 21 Feb 2024 00:45:26 -0500
Date: Wed, 21 Feb 2024 00:45:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, yukuai1@huaweicloud.com, heinzm@redhat.com,
        snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de,
        linux-raid@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH RFC V2 0/4] Fix regression bugs
Message-ID: <ZdWN9qu8WUeJk13Q@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240220153059.11233-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220153059.11233-1-xni@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Tue, Feb 20, 2024 at 11:30:55PM +0800, Xiao Ni wrote:
> Hi all
> 
> Sorry, I know this patch set conflict with Yu Kuai's patch set. But
> I have to send out this patch set. Now we're facing some deadlock
> regression problems. So it's better to figure out the root cause and
> fix them. But Kuai's patch set looks too complicate for me. And like
> we're talking in the emails, Kuai's patch set breaks some rules. It's
> not good to fix some problem by breaking the original logic. If we really
> need to break some logic. It's better to use a distinct patch set to
> describe why we need them.
> 
> This patch is based on linus's tree. The tag is 6.8-rc5. If this patch set
> can be accepted. We need to revert Kuai's patches which have been merged
> in Song's tree (md-6.8-20240216 tag). This patch set has four patches.
> The first two resolves deadlock problems. With these two patches, it can
> resolve most deadlock problem. The third one fixes active_io counter bug.
> The fouth one fixes the raid5 reshape deadlock problem.

With this patchset on top of the v6.8-rc5 kernel I can still see a hang
tearing down the devices at the end of lvconvert-raid-reshape.sh if I
run it repeatedly. I haven't dug into this enough to be certain, but it
appears that when this hangs, stripe_result make_stripe_request() is
returning STRIPE_SCHEDULE_AND_RETRY because of

ahead_of_reshape(mddev, logical_sector, conf->reshape_safe))

this never runs stripe_across_reshape() from you last patch.

It hangs with the following hung-task backtrace:

[ 4569.331345] sysrq: Show Blocked State
[ 4569.332640] task:mdX_resync      state:D stack:0     pid:155469 tgid:155469 ppid:2      flags:0x00004000
[ 4569.335367] Call Trace:
[ 4569.336122]  <TASK>
[ 4569.336758]  __schedule+0x3ec/0x15c0
[ 4569.337789]  ? __schedule+0x3f4/0x15c0
[ 4569.338433]  ? __wake_up_klogd.part.0+0x3c/0x60
[ 4569.339186]  schedule+0x32/0xd0
[ 4569.339709]  md_do_sync+0xede/0x11c0
[ 4569.340324]  ? __pfx_autoremove_wake_function+0x10/0x10
[ 4569.341183]  ? __pfx_md_thread+0x10/0x10
[ 4569.341831]  md_thread+0xab/0x190
[ 4569.342397]  kthread+0xe5/0x120
[ 4569.342933]  ? __pfx_kthread+0x10/0x10
[ 4569.343554]  ret_from_fork+0x31/0x50
[ 4569.344152]  ? __pfx_kthread+0x10/0x10
[ 4569.344761]  ret_from_fork_asm+0x1b/0x30
[ 4569.345193]  </TASK>
[ 4569.345403] task:dmsetup         state:D stack:0     pid:156091 tgid:156091 ppid:155933 flags:0x00004002
[ 4569.346300] Call Trace:
[ 4569.346538]  <TASK>
[ 4569.346746]  __schedule+0x3ec/0x15c0
[ 4569.347097]  ? __schedule+0x3f4/0x15c0
[ 4569.347440]  ? sysvec_call_function_single+0xe/0x90
[ 4569.347905]  ? asm_sysvec_call_function_single+0x1a/0x20
[ 4569.348401]  ? __pfx_dev_remove+0x10/0x10
[ 4569.348779]  schedule+0x32/0xd0
[ 4569.349079]  stop_sync_thread+0x136/0x1d0
[ 4569.349465]  ? __pfx_autoremove_wake_function+0x10/0x10
[ 4569.349965]  __md_stop_writes+0x15/0xe0
[ 4569.350341]  md_stop_writes+0x29/0x40
[ 4569.350698]  raid_postsuspend+0x53/0x60 [dm_raid]
[ 4569.351159]  dm_table_postsuspend_targets+0x3d/0x60
[ 4569.351627]  __dm_destroy+0x1c5/0x1e0
[ 4569.351984]  dev_remove+0x11d/0x190
[ 4569.352328]  ctl_ioctl+0x30e/0x5e0
[ 4569.352659]  dm_ctl_ioctl+0xe/0x20
[ 4569.352992]  __x64_sys_ioctl+0x94/0xd0
[ 4569.353352]  do_syscall_64+0x86/0x170
[ 4569.353703]  ? dm_ctl_ioctl+0xe/0x20
[ 4569.354059]  ? syscall_exit_to_user_mode+0x89/0x230
[ 4569.354517]  ? do_syscall_64+0x96/0x170
[ 4569.354891]  ? exc_page_fault+0x7f/0x180
[ 4569.355258]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[ 4569.355744] RIP: 0033:0x7f49e5dbc13d
[ 4569.356113] RSP: 002b:00007ffc365585f0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 4569.356804] RAX: ffffffffffffffda RBX: 000055638c4932c0 RCX: 00007f49e5dbc13d
[ 4569.357488] RDX: 000055638c493af0 RSI: 00000000c138fd04 RDI: 0000000000000003
[ 4569.358140] RBP: 00007ffc36558640 R08: 00007f49e5fbc690 R09: 00007ffc365584a8
[ 4569.358783] R10: 00007f49e5fbb97d R11: 0000000000000246 R12: 00007f49e5fbb97d
[ 4569.359442] R13: 000055638c493ba0 R14: 00007f49e5fbb97d R15: 00007f49e5fbb97d
[ 4569.360090]  </TASK>


> 
> I have run lvm2 regression test. There are 4 failed cases:
> shell/dmsetup-integrity-keys.sh
> shell/lvresize-fs-crypt.sh
> shell/pvck-dump.sh
> shell/select-report.sh
> 
> Xiao Ni (4):
>   Clear MD_RECOVERY_WAIT when stopping dmraid
>   Set MD_RECOVERY_FROZEN before stop sync thread
>   md: Missing decrease active_io for flush io
>   Don't check crossing reshape when reshape hasn't started
> 
>  drivers/md/dm-raid.c |  2 ++
>  drivers/md/md.c      |  8 +++++++-
>  drivers/md/raid5.c   | 22 ++++++++++------------
>  3 files changed, 19 insertions(+), 13 deletions(-)
> 
> -- 
> 2.32.0 (Apple Git-132)

