Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66F04F1F8
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 22:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709247234; cv=none; b=uvEk+OBPDY4kqljeRtV7uo7l+c+XwnUc7MgRu5qT+EnfVeIibDKIWpWe1NcJNHYLq9pTcdZhKIk9TOWk+epucnMu5LDwYIMlGbNQk3oLnn+1RO6WgR9TysLLjyUf1mW2FPyndGuFofSkZjyfP4w/gXR7CaaVmdKg8+7tyWHXOiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709247234; c=relaxed/simple;
	bh=6KpyM2gx9eJmsJA2eoNoON2QPqvQQLwqsYAWad7/KoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fc7IV+Fzv9npIsRydcgV6Moc6ovrfSCHUnsZNPKDCVCaqzQD8QjRcmVCSrTgnyKot/gvFYyeUxWWRbzhqSCTyHvyztmQKQ4Bmhz055Qnh3PDP2OeFAzoDlU3J077GKUzP8bzdRskVTxIsBYJuLIBFu6UC69246sbhMCD3O+hF84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSstjoer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSstjoer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA21C433C7
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 22:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709247234;
	bh=6KpyM2gx9eJmsJA2eoNoON2QPqvQQLwqsYAWad7/KoM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iSstjoer6a03tzbfWpRZ36TvM+J4cEPIHVITBYin7o2dA/h6MLOtlzXVr4fpa1QsE
	 9rXqV7/N7h7unYSNtQN2BsJgO6PckUZ2NOG3BBr1H6YNgX8PBgH7vyMXv2/zHOK5hG
	 jU/FKbNl0+k1DCq3FKnbetufWbBerVLmsiFXPz10PhK5VXy/Pz0SLiUzxF88Caka3Y
	 +J1hEE4RhRBYa6XkLmpN0ZiuDYeBkQMENRUXELX0f2sDWpoNaKN8pCXn5mvcWJG5h4
	 aU992/ShJsDtTpVlJWImxPy3zZ9oE57mAnB2gjzO3aMK6Aic9YvUPbhQaJUYKqqYec
	 qV+Z7THghj1xQ==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5131316693cso1871161e87.0
        for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 14:53:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXp/xtlNzN7tw32I2lvj++Wljw5U6v+jI5dOfNcXiW3bcIT8AaMGA8g4UeidcgRMc/cjHcG4tqj2n+ZQs242Nr3BeUw3N/fwf8=
X-Gm-Message-State: AOJu0YxDojbi/vq2u+dnmo/Th6+2OSKoRYxfaQFbf1BUxXVZo6Aob3Wg
	ZhK3DcAWeMKeGC9Ew/oQAaAy0lkDpOklWzwYFUmediYpoRVWAsSRHBT9/LvHej3QcUe/ada4Qwd
	gkGjdTiybhq3/k21vp89haoRI0Hk=
X-Google-Smtp-Source: AGHT+IEMl/xIDythTcDhkr7CSnhgMAb+6WKhMJWjJVc5KW7QZgH606dqZn3JU+lh6tLu/EBmDKQAl1DBVItVHqz7xZg=
X-Received: by 2002:a05:6512:39ce:b0:511:54a8:3adb with SMTP id
 k14-20020a05651239ce00b0051154a83adbmr4909lfu.2.1709247232430; Thu, 29 Feb
 2024 14:53:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229154941.99557-1-xni@redhat.com> <20240229154941.99557-3-xni@redhat.com>
In-Reply-To: <20240229154941.99557-3-xni@redhat.com>
From: Song Liu <song@kernel.org>
Date: Thu, 29 Feb 2024 14:53:40 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6j5q+kjJ9Xn0dBmb_TVZC+z8FAjExpQHWO1pCAN_fYtQ@mail.gmail.com>
Message-ID: <CAPhsuW6j5q+kjJ9Xn0dBmb_TVZC+z8FAjExpQHWO1pCAN_fYtQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] md: Revert "md: Make sure md_do_sync() will set MD_RECOVERY_DONE"
To: Xiao Ni <xni@redhat.com>
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 7:50=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> This reverts commit 82ec0ae59d02e89164b24c0cc8e4e50de78b5fd6.
>
> The root cause is that MD_RECOVERY_WAIT isn't cleared when stopping raid.
> The following patch 'Clear MD_RECOVERY_WAIT when stopping dmraid' fixes
> this problem.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>

I think we still need 82ec0ae59d02e89164b24c0cc8e4e50de78b5fd6 or some
variation of it. Otherwise, we may hit the following deadlock. The test vm =
here
has 2 raid arrays: one raid5 with journal, and a raid1.

I pushed other patches in the set to the md-6.9-for-hch branch for
further tests.

Thanks,
Song


[  250.347646] INFO: task systemd-udevd:546 blocked for more than 122 secon=
ds.
[  250.348443]       Not tainted 6.8.0-rc3+ #479
[  250.348912] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  250.349741] task:systemd-udevd   state:D stack:27136 pid:546
tgid:546   ppid:525    flags:0x00000000
[  250.350740] Call Trace:
[  250.351043]  <TASK>
[  250.351310]  __schedule+0x862/0x19b0
[  250.351770]  ? __pfx___schedule+0x10/0x10
[  250.352222]  ? lock_release+0x250/0x690
[  250.352657]  ? __pfx_lock_release+0x10/0x10
[  250.353128]  ? mark_held_locks+0x62/0x90
[  250.353604]  schedule+0x77/0x200
[  250.353976]  md_handle_request+0x1fe/0x650
[  250.354459]  ? __pfx_md_handle_request+0x10/0x10
[  250.354957]  ? bio_split_to_limits+0x131/0x150
[  250.355456]  ? __pfx_autoremove_wake_function+0x10/0x10
[  250.356031]  ? lock_is_held_type+0xda/0x130
[  250.356515]  __submit_bio+0x99/0xe0
[  250.356910]  submit_bio_noacct_nocheck+0x25a/0x570
[  250.357510]  ? __pfx_submit_bio_noacct_nocheck+0x10/0x10
[  250.358080]  ? __might_resched+0x274/0x350
[  250.358546]  ? submit_bio_noacct+0x1b7/0x6c0
[  250.359067]  mpage_readahead+0x25b/0x300
[  250.359507]  ? __pfx_mpage_readahead+0x10/0x10
[  250.359986]  ? __pfx___lock_acquire+0x10/0x10
[  250.360524]  ? __pfx_blkdev_get_block+0x10/0x10
[  250.361046]  ? __pfx_lock_release+0x10/0x10
[  250.361602]  ? __pfx___filemap_add_folio+0x10/0x10
[  250.362250]  ? lock_is_held_type+0xda/0x130
[  250.362785]  read_pages+0xfd/0x650
[  250.363173]  ? __pfx_read_pages+0x10/0x10
[  250.363685]  page_cache_ra_unbounded+0x1df/0x2d0
[  250.364228]  force_page_cache_ra+0x11e/0x150
[  250.364716]  filemap_get_pages+0x6f1/0xbb0
[  250.365218]  ? __pfx_filemap_get_pages+0x10/0x10
[  250.365735]  ? lock_is_held_type+0xda/0x130
[  250.366266]  filemap_read+0x216/0x6a0
[  250.366679]  ? __pfx_mark_lock+0x10/0x10
[  250.367132]  ? __pfx_ptep_set_access_flags+0x10/0x10
[  250.367765]  ? __pfx_filemap_read+0x10/0x10
[  250.368234]  ? __lock_acquire+0x959/0x3540
[  250.368756]  blkdev_read_iter+0xc0/0x230
[  250.369200]  vfs_read+0x38c/0x540
[  250.369581]  ? __pfx_vfs_read+0x10/0x10
[  250.370038]  ? __fget_light+0x96/0xd0
[  250.370469]  ksys_read+0xcb/0x170
[  250.370839]  ? __pfx_ksys_read+0x10/0x10
[  250.371320]  do_syscall_64+0x7a/0x1a0
[  250.371735]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[  250.372367] RIP: 0033:0x7fcb590118b2
[  250.372865] RSP: 002b:00007ffcdd5f9c18 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[  250.373840] RAX: ffffffffffffffda RBX: 0000555885985010 RCX: 00007fcb590=
118b2
[  250.374641] RDX: 0000000000000040 RSI: 0000555885985038 RDI: 00000000000=
00011
[  250.375437] RBP: 000055588599fd40 R08: 0000555885985010 R09: 00005558859=
6c010
[  250.376222] R10: 00007fcb58fbfbc0 R11: 0000000000000246 R12: 00000000804=
f0000
[  250.376974] R13: 0000000000000040 R14: 000055588599fd90 R15: 00005558859=
85028
[  250.377811]  </TASK>
[  250.378073] INFO: task mdadm:562 blocked for more than 122 seconds.
[  250.378753]       Not tainted 6.8.0-rc3+ #479
[  250.379237] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  250.380055] task:mdadm           state:D stack:25872 pid:562
tgid:562   ppid:543    flags:0x00004000
[  250.381071] Call Trace:
[  250.381369]  <TASK>
[  250.381625]  __schedule+0x862/0x19b0
[  250.382054]  ? __pfx___schedule+0x10/0x10
[  250.382502]  ? lock_release+0x250/0x690
[  250.382943]  ? __pfx_lock_release+0x10/0x10
[  250.383407]  ? mark_held_locks+0x24/0x90
[  250.383851]  ? lockdep_hardirqs_on+0x7d/0x100
[  250.384345]  ? preempt_count_sub+0x18/0xd0
[  250.384806]  ? _raw_spin_unlock_irqrestore+0x3f/0x60
[  250.385358]  schedule+0x77/0x200
[  250.385718]  md_ioctl+0x1750/0x1d60
[  250.386114]  ? __pfx_md_ioctl+0x10/0x10
[  250.386535]  ? _raw_spin_unlock_irqrestore+0x34/0x60
[  250.387063]  ? lockdep_hardirqs_on+0x7d/0x100
[  250.387567]  ? preempt_count_sub+0x18/0xd0
[  250.388024]  ? populate_seccomp_data+0x184/0x220
[  250.388522]  ? __pfx_autoremove_wake_function+0x10/0x10
[  250.389083]  ? __seccomp_filter+0x102/0x760
[  250.389553]  blkdev_ioctl+0x1f1/0x3c0
[  250.389956]  ? __pfx_blkdev_ioctl+0x10/0x10
[  250.390441]  __x64_sys_ioctl+0xc6/0x100
[  250.390880]  do_syscall_64+0x7a/0x1a0
[  250.391313]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[  250.391877] RIP: 0033:0x7fd88eef362b
[  250.392290] RSP: 002b:00007fff8c298438 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  250.393098] RAX: ffffffffffffffda RBX: 000055e1b77a2300 RCX: 00007fd88ee=
f362b
[  250.393896] RDX: 00007fff8c2985a8 RSI: 0000000040140921 RDI: 00000000000=
00004
[  250.394664] RBP: 0000000000000005 R08: 000000000000001e R09: 00007fff8c2=
98197
[  250.395457] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
00000
[  250.396223] R13: 000055e1b77a4c70 R14: 00007fff8c2984f8 R15: 000055e1b77=
a46d0
[  250.397050]  </TASK>
[  250.397357]
[  250.397357] Showing all locks held in the system:
[  250.398092] 1 lock held by khungtaskd/211:
[  250.398535]  #0: ffffffff87f6fea0 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x4d/0x230
[  250.399613] 1 lock held by systemd-journal/499:
[  250.400124] 1 lock held by systemd-udevd/546:
[  250.400616]  #0: ffff88801461d178
(mapping.invalidate_lock){.+.+}-{3:3}, at:
page_cache_ra_unbounded+0xa4/0x2d0
[  250.401701]
[  250.401882] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  250.401882]
[  250.402618] Kernel panic - not syncing: hung_task: blocked tasks
[  250.403294] CPU: 2 PID: 211 Comm: khungtaskd Not tainted 6.8.0-rc3+ #479
[  250.404046] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  250.405264] Call Trace:
[  250.405537]  <TASK>
[  250.405776]  dump_stack_lvl+0x4a/0x80
[  250.406185]  panic+0x41c/0x460
[  250.406592]  ? __pfx_panic+0x10/0x10
[  250.407167]  ? lock_release+0x205/0x690
[  250.407713]  ? preempt_count_sub+0x18/0xd0
[  250.408273]  watchdog+0x9af/0x9b0
[  250.408673]  ? __pfx_watchdog+0x10/0x10
[  250.409097]  kthread+0x1b1/0x1f0
[  250.409476]  ? kthread+0xf6/0x1f0
[  250.409849]  ? __pfx_kthread+0x10/0x10
[  250.410276]  ret_from_fork+0x31/0x60
[  250.410704]  ? __pfx_kthread+0x10/0x10
[  250.411123]  ret_from_fork_asm+0x1b/0x30
[  250.411604]  </TASK>
[  250.412330] Kernel Offset: disabled
[  250.412802] ---[ end Kernel panic - not syncing: hung_task: blocked
tasks ]---
