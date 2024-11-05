Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C3F18BC21
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 10:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801757; cv=none; b=g03qKupgCHscKuX0PDzr8zTnKmQrjgI9+dLl0ZTgsIzLw+r5jnMmujjU3sUSMN5DmaMDc6d8kT9fYhTNiB0H2ajMqIQ7rqJ9sijv6LnzxANocwZsAAMMc07L6n9QApuHrxqe2n5aANFPlEZuZZ8AthcQN5yOpafXtaFwFuLTqJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801757; c=relaxed/simple;
	bh=JPAZ4f+zgH4if7j6AzjCeDFNdefFaO+wleRgu5YivJ8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lzUyPL9UJBr8qWQl0NpKLqcOrXT8Qvag1Ty6dWRTKeKjgFr+EH6SaFz5gnjj8Irvn6BpG1rhZQFb7TRvgtF4dSVmPWCwJfd89v8sIF9HXKhp6pLCrqOmwZOeVB77uGfZwYvb80rg0RVvidaQvyBOXWxbMb3BrnmbdUmYOJ09GcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=ipsdjXvC; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="ipsdjXvC"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1730801750;
	bh=ZgvVP9fng+oh32yqub5iFemoFSN1w2ZtbxgQC7ZRyjE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=ipsdjXvCGIlmbDk0OnnkYHNhDbQ/YvKCYvpALQoroxYQjUvE5MHmyfu7CN7sG130e
	 CKj0l4BQd4BM+r16SY0Qqy8JUkiEwiBan0b/u8T9Ssuq5Lt3LOBDdL0Elccy0Kh1kj
	 UzAz+RA3PndcVY5bYtkFW4etlDcZh8rFLIiL8q5M=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
Date: Tue, 5 Nov 2024 11:15:29 +0100
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BE85CBCF-1B09-48D0-9931-AA8D298F1D6B@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
 <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
 <3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io>
 <1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
 <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io>
 <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
 <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
 <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
 <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
 <26403.59789.480428.418012@quad.stoffel.home>
 <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com>
 <F8CEEB15-0E3C-4F67-951D-12E165D6CC05@flyingcircus.io>
 <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io>
 <5170f0d2-cb0f-2e0f-eb5e-31aa9d6ff65d@huawei.com>
 <2b093abc-cd9a-0b84-bcba-baec689fa153@huaweicloud.com>
 <63DE1813-C719-49B7-9012-641DB3DECA26@flyingcircus.io>
 <F8A5ABD5-0773-414D-BBBC-538481BCD0F4@flyingcircus.io>
 <753611d4-5c54-ee0d-30ab-9321274fd749@huaweicloud.com>
 <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,


after about 2 hours it stalled again. Here=E2=80=99s the full blocked =
process dump. (Tell me if this isn=E2=80=99t helpful, otherwise I=E2=80=99=
ll keep posting that as it=E2=80=99s the only real data I can show)

[13827.157511] sysrq: Show Blocked State
[13827.161742] task:kworker/u130:0  state:D stack:0     pid:212   =
tgid:212   ppid:2      flags:0x00004000
[13827.161748] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.161758] Call Trace:
[13827.161760]  <TASK>
[13827.161764]  __schedule+0x425/0x1460
[13827.161774]  schedule+0x27/0xf0
[13827.161778]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.161787]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.161793]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.161800]  raid5_make_request+0x364/0x1290 [raid456]
[13827.161806]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.161810]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.161814]  ? __pfx_woken_wake_function+0x10/0x10
[13827.161818]  ? bio_split_rw+0x141/0x2a0
[13827.161823]  md_handle_request+0x153/0x270 [md_mod]
[13827.161830]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.161833]  __submit_bio+0x190/0x240
[13827.161838]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.161841]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.161843]  ? submit_bio_noacct+0x47/0x5b0
[13827.161846]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.161850]  process_one_work+0x18f/0x3b0
[13827.161855]  worker_thread+0x21f/0x330
[13827.161857]  ? __pfx_worker_thread+0x10/0x10
[13827.161859]  kthread+0xcd/0x100
[13827.161863]  ? __pfx_kthread+0x10/0x10
[13827.161866]  ret_from_fork+0x31/0x50
[13827.161870]  ? __pfx_kthread+0x10/0x10
[13827.161873]  ret_from_fork_asm+0x1a/0x30
[13827.161878]  </TASK>
[13827.162001] task:kworker/u130:3  state:D stack:0     pid:1741  =
tgid:1741  ppid:2      flags:0x00004000
[13827.162006] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162009] Call Trace:
[13827.162010]  <TASK>
[13827.162012]  __schedule+0x425/0x1460
[13827.162017]  schedule+0x27/0xf0
[13827.162019]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162025]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162028]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162033]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162038]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162041]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162043]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162046]  ? bio_split_rw+0x141/0x2a0
[13827.162051]  md_handle_request+0x153/0x270 [md_mod]
[13827.162056]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162060]  __submit_bio+0x190/0x240
[13827.162063]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162066]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162069]  ? submit_bio_noacct+0x47/0x5b0
[13827.162072]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162075]  process_one_work+0x18f/0x3b0
[13827.162078]  worker_thread+0x21f/0x330
[13827.162080]  ? __pfx_worker_thread+0x10/0x10
[13827.162082]  kthread+0xcd/0x100
[13827.162085]  ? __pfx_kthread+0x10/0x10
[13827.162087]  ret_from_fork+0x31/0x50
[13827.162090]  ? __pfx_kthread+0x10/0x10
[13827.162092]  ret_from_fork_asm+0x1a/0x30
[13827.162096]  </TASK>
[13827.162166] task:kworker/u130:4  state:D stack:0     pid:3097  =
tgid:3097  ppid:2      flags:0x00004000
[13827.162169] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162172] Call Trace:
[13827.162173]  <TASK>
[13827.162175]  __schedule+0x425/0x1460
[13827.162180]  schedule+0x27/0xf0
[13827.162182]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162188]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162190]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162195]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162200]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162203]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162205]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162208]  ? bio_split_rw+0x141/0x2a0
[13827.162213]  md_handle_request+0x153/0x270 [md_mod]
[13827.162218]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162221]  __submit_bio+0x190/0x240
[13827.162226]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162228]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162231]  ? submit_bio_noacct+0x47/0x5b0
[13827.162234]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162237]  process_one_work+0x18f/0x3b0
[13827.162240]  worker_thread+0x21f/0x330
[13827.162243]  ? __pfx_worker_thread+0x10/0x10
[13827.162245]  kthread+0xcd/0x100
[13827.162247]  ? __pfx_kthread+0x10/0x10
[13827.162250]  ret_from_fork+0x31/0x50
[13827.162252]  ? __pfx_kthread+0x10/0x10
[13827.162254]  ret_from_fork_asm+0x1a/0x30
[13827.162259]  </TASK>
[13827.162260] task:kworker/u130:5  state:D stack:0     pid:3098  =
tgid:3098  ppid:2      flags:0x00004000
[13827.162263] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162266] Call Trace:
[13827.162267]  <TASK>
[13827.162269]  __schedule+0x425/0x1460
[13827.162271]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162277]  schedule+0x27/0xf0
[13827.162279]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162284]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162287]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162292]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162297]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162300]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162302]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162305]  ? bio_split_rw+0x141/0x2a0
[13827.162309]  md_handle_request+0x153/0x270 [md_mod]
[13827.162315]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162318]  __submit_bio+0x190/0x240
[13827.162322]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162326]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162328]  ? submit_bio_noacct+0x47/0x5b0
[13827.162331]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162334]  process_one_work+0x18f/0x3b0
[13827.162337]  worker_thread+0x21f/0x330
[13827.162339]  ? __pfx_worker_thread+0x10/0x10
[13827.162341]  kthread+0xcd/0x100
[13827.162344]  ? __pfx_kthread+0x10/0x10
[13827.162346]  ret_from_fork+0x31/0x50
[13827.162349]  ? __pfx_kthread+0x10/0x10
[13827.162351]  ret_from_fork_asm+0x1a/0x30
[13827.162355]  </TASK>
[13827.162357] task:kworker/u130:6  state:D stack:0     pid:3099  =
tgid:3099  ppid:2      flags:0x00004000
[13827.162359] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162362] Call Trace:
[13827.162363]  <TASK>
[13827.162365]  __schedule+0x425/0x1460
[13827.162370]  schedule+0x27/0xf0
[13827.162373]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162378]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162381]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162386]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162391]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162394]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162396]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162399]  ? bio_split_rw+0x141/0x2a0
[13827.162403]  md_handle_request+0x153/0x270 [md_mod]
[13827.162409]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162412]  __submit_bio+0x190/0x240
[13827.162416]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162420]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162422]  ? submit_bio_noacct+0x47/0x5b0
[13827.162425]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162428]  process_one_work+0x18f/0x3b0
[13827.162431]  worker_thread+0x21f/0x330
[13827.162433]  ? __pfx_worker_thread+0x10/0x10
[13827.162435]  kthread+0xcd/0x100
[13827.162437]  ? __pfx_kthread+0x10/0x10
[13827.162440]  ret_from_fork+0x31/0x50
[13827.162443]  ? __pfx_kthread+0x10/0x10
[13827.162445]  ret_from_fork_asm+0x1a/0x30
[13827.162449]  </TASK>
[13827.162451] task:kworker/u130:8  state:D stack:0     pid:3101  =
tgid:3101  ppid:2      flags:0x00004000
[13827.162454] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162457] Call Trace:
[13827.162458]  <TASK>
[13827.162459]  __schedule+0x425/0x1460
[13827.162465]  schedule+0x27/0xf0
[13827.162467]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162472]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162475]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162480]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162485]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162488]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162490]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162493]  ? bio_split_rw+0x141/0x2a0
[13827.162497]  md_handle_request+0x153/0x270 [md_mod]
[13827.162503]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162506]  __submit_bio+0x190/0x240
[13827.162510]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162513]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162516]  ? submit_bio_noacct+0x47/0x5b0
[13827.162519]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162522]  process_one_work+0x18f/0x3b0
[13827.162525]  worker_thread+0x21f/0x330
[13827.162527]  ? __pfx_worker_thread+0x10/0x10
[13827.162529]  ? __pfx_worker_thread+0x10/0x10
[13827.162531]  kthread+0xcd/0x100
[13827.162533]  ? __pfx_kthread+0x10/0x10
[13827.162536]  ret_from_fork+0x31/0x50
[13827.162538]  ? __pfx_kthread+0x10/0x10
[13827.162541]  ret_from_fork_asm+0x1a/0x30
[13827.162545]  </TASK>
[13827.162546] task:kworker/u130:9  state:D stack:0     pid:3102  =
tgid:3102  ppid:2      flags:0x00004000
[13827.162550] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162552] Call Trace:
[13827.162553]  <TASK>
[13827.162555]  __schedule+0x425/0x1460
[13827.162560]  schedule+0x27/0xf0
[13827.162562]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162568]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162571]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162576]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162581]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162583]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162586]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162589]  ? bio_split_rw+0x141/0x2a0
[13827.162593]  md_handle_request+0x153/0x270 [md_mod]
[13827.162599]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162602]  __submit_bio+0x190/0x240
[13827.162606]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162609]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162612]  ? submit_bio_noacct+0x47/0x5b0
[13827.162615]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162618]  process_one_work+0x18f/0x3b0
[13827.162621]  worker_thread+0x21f/0x330
[13827.162623]  ? __pfx_worker_thread+0x10/0x10
[13827.162625]  kthread+0xcd/0x100
[13827.162628]  ? __pfx_kthread+0x10/0x10
[13827.162630]  ret_from_fork+0x31/0x50
[13827.162632]  ? __pfx_kthread+0x10/0x10
[13827.162635]  ret_from_fork_asm+0x1a/0x30
[13827.162640]  </TASK>
[13827.162641] task:kworker/u130:11 state:D stack:0     pid:3104  =
tgid:3104  ppid:2      flags:0x00004000
[13827.162643] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162646] Call Trace:
[13827.162648]  <TASK>
[13827.162650]  __schedule+0x425/0x1460
[13827.162655]  schedule+0x27/0xf0
[13827.162657]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162663]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162666]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162671]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162676]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162678]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162681]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162684]  ? bio_split_rw+0x141/0x2a0
[13827.162688]  md_handle_request+0x153/0x270 [md_mod]
[13827.162694]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162698]  __submit_bio+0x190/0x240
[13827.162702]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162704]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162707]  ? submit_bio_noacct+0x47/0x5b0
[13827.162710]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162713]  process_one_work+0x18f/0x3b0
[13827.162716]  worker_thread+0x21f/0x330
[13827.162719]  ? __pfx_worker_thread+0x10/0x10
[13827.162721]  kthread+0xcd/0x100
[13827.162723]  ? __pfx_kthread+0x10/0x10
[13827.162726]  ret_from_fork+0x31/0x50
[13827.162728]  ? __pfx_kthread+0x10/0x10
[13827.162731]  ret_from_fork_asm+0x1a/0x30
[13827.162736]  </TASK>
[13827.162737] task:kworker/u130:12 state:D stack:0     pid:3105  =
tgid:3105  ppid:2      flags:0x00004000
[13827.162740] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162743] Call Trace:
[13827.162744]  <TASK>
[13827.162746]  __schedule+0x425/0x1460
[13827.162751]  schedule+0x27/0xf0
[13827.162753]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162759]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162762]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162767]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162772]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162774]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162777]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162779]  ? bio_split_rw+0x141/0x2a0
[13827.162785]  md_handle_request+0x153/0x270 [md_mod]
[13827.162790]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162794]  __submit_bio+0x190/0x240
[13827.162798]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162801]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162804]  ? submit_bio_noacct+0x47/0x5b0
[13827.162807]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162809]  process_one_work+0x18f/0x3b0
[13827.162812]  worker_thread+0x21f/0x330
[13827.162815]  ? __pfx_worker_thread+0x10/0x10
[13827.162817]  kthread+0xcd/0x100
[13827.162819]  ? __pfx_kthread+0x10/0x10
[13827.162822]  ret_from_fork+0x31/0x50
[13827.162824]  ? __pfx_kthread+0x10/0x10
[13827.162827]  ret_from_fork_asm+0x1a/0x30
[13827.162831]  </TASK>
[13827.162832] task:kworker/u130:13 state:D stack:0     pid:3106  =
tgid:3106  ppid:2      flags:0x00004000
[13827.162835] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162838] Call Trace:
[13827.162839]  <TASK>
[13827.162840]  __schedule+0x425/0x1460
[13827.162846]  schedule+0x27/0xf0
[13827.162848]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162854]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162856]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162862]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162867]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162870]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162872]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162875]  ? bio_split_rw+0x141/0x2a0
[13827.162879]  md_handle_request+0x153/0x270 [md_mod]
[13827.162885]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162888]  __submit_bio+0x190/0x240
[13827.162892]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162895]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162902]  ? submit_bio_noacct+0x47/0x5b0
[13827.162905]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.162908]  process_one_work+0x18f/0x3b0
[13827.162911]  worker_thread+0x21f/0x330
[13827.162913]  ? __pfx_worker_thread+0x10/0x10
[13827.162915]  kthread+0xcd/0x100
[13827.162918]  ? __pfx_kthread+0x10/0x10
[13827.162921]  ret_from_fork+0x31/0x50
[13827.162923]  ? __pfx_kthread+0x10/0x10
[13827.162925]  ret_from_fork_asm+0x1a/0x30
[13827.162929]  </TASK>
[13827.162931] task:kworker/u130:14 state:D stack:0     pid:3107  =
tgid:3107  ppid:2      flags:0x00004000
[13827.162934] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.162936] Call Trace:
[13827.162937]  <TASK>
[13827.162939]  __schedule+0x425/0x1460
[13827.162944]  schedule+0x27/0xf0
[13827.162946]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.162952]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.162955]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.162960]  raid5_make_request+0x364/0x1290 [raid456]
[13827.162965]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162967]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.162970]  ? __pfx_woken_wake_function+0x10/0x10
[13827.162972]  ? bio_split_rw+0x141/0x2a0
[13827.162977]  md_handle_request+0x153/0x270 [md_mod]
[13827.162983]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162986]  __submit_bio+0x190/0x240
[13827.162990]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.162993]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.162995]  ? submit_bio_noacct+0x47/0x5b0
[13827.162998]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163001]  process_one_work+0x18f/0x3b0
[13827.163004]  worker_thread+0x21f/0x330
[13827.163006]  ? __pfx_worker_thread+0x10/0x10
[13827.163008]  kthread+0xcd/0x100
[13827.163011]  ? __pfx_kthread+0x10/0x10
[13827.163014]  ret_from_fork+0x31/0x50
[13827.163016]  ? __pfx_kthread+0x10/0x10
[13827.163018]  ret_from_fork_asm+0x1a/0x30
[13827.163023]  </TASK>
[13827.163024] task:kworker/u130:16 state:D stack:0     pid:3109  =
tgid:3109  ppid:2      flags:0x00004000
[13827.163027] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163029] Call Trace:
[13827.163031]  <TASK>
[13827.163032]  __schedule+0x425/0x1460
[13827.163037]  schedule+0x27/0xf0
[13827.163040]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163045]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163048]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163053]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163058]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163061]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163065]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163068]  ? bio_split_rw+0x141/0x2a0
[13827.163072]  md_handle_request+0x153/0x270 [md_mod]
[13827.163078]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163081]  __submit_bio+0x190/0x240
[13827.163085]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163088]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163091]  ? submit_bio_noacct+0x47/0x5b0
[13827.163094]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163097]  process_one_work+0x18f/0x3b0
[13827.163100]  worker_thread+0x21f/0x330
[13827.163103]  ? __pfx_worker_thread+0x10/0x10
[13827.163105]  kthread+0xcd/0x100
[13827.163107]  ? __pfx_kthread+0x10/0x10
[13827.163110]  ret_from_fork+0x31/0x50
[13827.163112]  ? __pfx_kthread+0x10/0x10
[13827.163115]  ret_from_fork_asm+0x1a/0x30
[13827.163119]  </TASK>
[13827.163120] task:kworker/u130:17 state:D stack:0     pid:3110  =
tgid:3110  ppid:2      flags:0x00004000
[13827.163123] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163126] Call Trace:
[13827.163127]  <TASK>
[13827.163128]  __schedule+0x425/0x1460
[13827.163133]  schedule+0x27/0xf0
[13827.163136]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163142]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163144]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163150]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163154]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163157]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163160]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163162]  ? bio_split_rw+0x141/0x2a0
[13827.163167]  md_handle_request+0x153/0x270 [md_mod]
[13827.163173]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163176]  __submit_bio+0x190/0x240
[13827.163180]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163183]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163185]  ? submit_bio_noacct+0x47/0x5b0
[13827.163188]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163192]  process_one_work+0x18f/0x3b0
[13827.163194]  worker_thread+0x21f/0x330
[13827.163197]  ? __pfx_worker_thread+0x10/0x10
[13827.163199]  kthread+0xcd/0x100
[13827.163201]  ? __pfx_kthread+0x10/0x10
[13827.163204]  ret_from_fork+0x31/0x50
[13827.163206]  ? __pfx_kthread+0x10/0x10
[13827.163209]  ret_from_fork_asm+0x1a/0x30
[13827.163213]  </TASK>
[13827.163214] task:kworker/u130:18 state:D stack:0     pid:3111  =
tgid:3111  ppid:2      flags:0x00004000
[13827.163217] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163219] Call Trace:
[13827.163220]  <TASK>
[13827.163222]  __schedule+0x425/0x1460
[13827.163227]  schedule+0x27/0xf0
[13827.163230]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163235]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163238]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163243]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163248]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163250]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163253]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163255]  ? bio_split_rw+0x141/0x2a0
[13827.163260]  md_handle_request+0x153/0x270 [md_mod]
[13827.163266]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163269]  __submit_bio+0x190/0x240
[13827.163273]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163276]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163279]  ? submit_bio_noacct+0x47/0x5b0
[13827.163282]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163285]  process_one_work+0x18f/0x3b0
[13827.163288]  worker_thread+0x21f/0x330
[13827.163290]  ? __pfx_worker_thread+0x10/0x10
[13827.163292]  kthread+0xcd/0x100
[13827.163294]  ? __pfx_kthread+0x10/0x10
[13827.163297]  ret_from_fork+0x31/0x50
[13827.163300]  ? __pfx_kthread+0x10/0x10
[13827.163302]  ret_from_fork_asm+0x1a/0x30
[13827.163306]  </TASK>
[13827.163308] task:kworker/u130:19 state:D stack:0     pid:3112  =
tgid:3112  ppid:2      flags:0x00004000
[13827.163311] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163313] Call Trace:
[13827.163314]  <TASK>
[13827.163315]  __schedule+0x425/0x1460
[13827.163321]  schedule+0x27/0xf0
[13827.163323]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163328]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163332]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163336]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163341]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163344]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163347]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163349]  ? bio_split_rw+0x141/0x2a0
[13827.163354]  md_handle_request+0x153/0x270 [md_mod]
[13827.163360]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163363]  __submit_bio+0x190/0x240
[13827.163367]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163370]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163372]  ? submit_bio_noacct+0x47/0x5b0
[13827.163375]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163378]  process_one_work+0x18f/0x3b0
[13827.163381]  worker_thread+0x21f/0x330
[13827.163384]  ? __pfx_worker_thread+0x10/0x10
[13827.163386]  kthread+0xcd/0x100
[13827.163388]  ? __pfx_kthread+0x10/0x10
[13827.163391]  ret_from_fork+0x31/0x50
[13827.163393]  ? __pfx_kthread+0x10/0x10
[13827.163396]  ret_from_fork_asm+0x1a/0x30
[13827.163401]  </TASK>
[13827.163402] task:kworker/u130:20 state:D stack:0     pid:3113  =
tgid:3113  ppid:2      flags:0x00004000
[13827.163405] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163407] Call Trace:
[13827.163408]  <TASK>
[13827.163410]  __schedule+0x425/0x1460
[13827.163415]  schedule+0x27/0xf0
[13827.163417]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163423]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163426]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163431]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163436]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163438]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163441]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163444]  ? bio_split_rw+0x141/0x2a0
[13827.163448]  md_handle_request+0x153/0x270 [md_mod]
[13827.163454]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163458]  __submit_bio+0x190/0x240
[13827.163461]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163464]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163467]  ? submit_bio_noacct+0x47/0x5b0
[13827.163470]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163473]  process_one_work+0x18f/0x3b0
[13827.163476]  worker_thread+0x21f/0x330
[13827.163478]  ? __pfx_worker_thread+0x10/0x10
[13827.163481]  kthread+0xcd/0x100
[13827.163483]  ? __pfx_kthread+0x10/0x10
[13827.163485]  ret_from_fork+0x31/0x50
[13827.163488]  ? __pfx_kthread+0x10/0x10
[13827.163490]  ret_from_fork_asm+0x1a/0x30
[13827.163495]  </TASK>
[13827.163496] task:kworker/u130:21 state:D stack:0     pid:3114  =
tgid:3114  ppid:2      flags:0x00004000
[13827.163499] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163502] Call Trace:
[13827.163503]  <TASK>
[13827.163504]  __schedule+0x425/0x1460
[13827.163509]  schedule+0x27/0xf0
[13827.163512]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163518]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163520]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163525]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163530]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163533]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163535]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163538]  ? bio_split_rw+0x141/0x2a0
[13827.163543]  md_handle_request+0x153/0x270 [md_mod]
[13827.163548]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163552]  __submit_bio+0x190/0x240
[13827.163556]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163558]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163561]  ? submit_bio_noacct+0x47/0x5b0
[13827.163564]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163567]  process_one_work+0x18f/0x3b0
[13827.163570]  worker_thread+0x21f/0x330
[13827.163572]  ? __pfx_worker_thread+0x10/0x10
[13827.163574]  kthread+0xcd/0x100
[13827.163577]  ? __pfx_kthread+0x10/0x10
[13827.163579]  ret_from_fork+0x31/0x50
[13827.163582]  ? __pfx_kthread+0x10/0x10
[13827.163584]  ret_from_fork_asm+0x1a/0x30
[13827.163588]  </TASK>
[13827.163590] task:kworker/u130:23 state:D stack:0     pid:3116  =
tgid:3116  ppid:2      flags:0x00004000
[13827.163593] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163595] Call Trace:
[13827.163596]  <TASK>
[13827.163598]  __schedule+0x425/0x1460
[13827.163603]  schedule+0x27/0xf0
[13827.163605]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163611]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163614]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163618]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163623]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163626]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163629]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163631]  ? bio_split_rw+0x141/0x2a0
[13827.163636]  md_handle_request+0x153/0x270 [md_mod]
[13827.163642]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163645]  __submit_bio+0x190/0x240
[13827.163649]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163652]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163654]  ? submit_bio_noacct+0x47/0x5b0
[13827.163657]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163661]  process_one_work+0x18f/0x3b0
[13827.163663]  worker_thread+0x21f/0x330
[13827.163666]  ? __pfx_worker_thread+0x10/0x10
[13827.163668]  kthread+0xcd/0x100
[13827.163670]  ? __pfx_kthread+0x10/0x10
[13827.163673]  ret_from_fork+0x31/0x50
[13827.163675]  ? __pfx_kthread+0x10/0x10
[13827.163678]  ret_from_fork_asm+0x1a/0x30
[13827.163682]  </TASK>
[13827.163684] task:kworker/u130:25 state:D stack:0     pid:3118  =
tgid:3118  ppid:2      flags:0x00004000
[13827.163686] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163689] Call Trace:
[13827.163690]  <TASK>
[13827.163692]  __schedule+0x425/0x1460
[13827.163697]  schedule+0x27/0xf0
[13827.163699]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163705]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163708]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163712]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163717]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163720]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163723]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163725]  ? bio_split_rw+0x141/0x2a0
[13827.163730]  md_handle_request+0x153/0x270 [md_mod]
[13827.163736]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163739]  __submit_bio+0x190/0x240
[13827.163743]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163746]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163749]  ? submit_bio_noacct+0x47/0x5b0
[13827.163752]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163755]  process_one_work+0x18f/0x3b0
[13827.163758]  worker_thread+0x21f/0x330
[13827.163760]  ? __pfx_worker_thread+0x10/0x10
[13827.163762]  kthread+0xcd/0x100
[13827.163765]  ? __pfx_kthread+0x10/0x10
[13827.163767]  ret_from_fork+0x31/0x50
[13827.163769]  ? __pfx_kthread+0x10/0x10
[13827.163772]  ret_from_fork_asm+0x1a/0x30
[13827.163776]  </TASK>
[13827.163778] task:kworker/u130:26 state:D stack:0     pid:3119  =
tgid:3119  ppid:2      flags:0x00004000
[13827.163780] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163783] Call Trace:
[13827.163783]  <TASK>
[13827.163785]  __schedule+0x425/0x1460
[13827.163790]  schedule+0x27/0xf0
[13827.163793]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163798]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163801]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163806]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163811]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163814]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163817]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163819]  ? bio_split_rw+0x141/0x2a0
[13827.163824]  md_handle_request+0x153/0x270 [md_mod]
[13827.163830]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163833]  __submit_bio+0x190/0x240
[13827.163837]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163840]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163842]  ? submit_bio_noacct+0x47/0x5b0
[13827.163845]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163848]  process_one_work+0x18f/0x3b0
[13827.163851]  worker_thread+0x21f/0x330
[13827.163854]  ? __pfx_worker_thread+0x10/0x10
[13827.163856]  kthread+0xcd/0x100
[13827.163858]  ? __pfx_kthread+0x10/0x10
[13827.163861]  ret_from_fork+0x31/0x50
[13827.163863]  ? __pfx_kthread+0x10/0x10
[13827.163866]  ret_from_fork_asm+0x1a/0x30
[13827.163870]  </TASK>
[13827.163872] task:kworker/u130:27 state:D stack:0     pid:3120  =
tgid:3120  ppid:2      flags:0x00004000
[13827.163874] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163877] Call Trace:
[13827.163878]  <TASK>
[13827.163879]  __schedule+0x425/0x1460
[13827.163885]  schedule+0x27/0xf0
[13827.163887]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163892]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163896]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.163904]  raid5_make_request+0x364/0x1290 [raid456]
[13827.163909]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163912]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.163914]  ? __pfx_woken_wake_function+0x10/0x10
[13827.163917]  ? bio_split_rw+0x141/0x2a0
[13827.163922]  md_handle_request+0x153/0x270 [md_mod]
[13827.163927]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163931]  __submit_bio+0x190/0x240
[13827.163935]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.163938]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.163940]  ? submit_bio_noacct+0x47/0x5b0
[13827.163943]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.163946]  process_one_work+0x18f/0x3b0
[13827.163949]  worker_thread+0x21f/0x330
[13827.163951]  ? __pfx_worker_thread+0x10/0x10
[13827.163953]  kthread+0xcd/0x100
[13827.163956]  ? __pfx_kthread+0x10/0x10
[13827.163959]  ret_from_fork+0x31/0x50
[13827.163961]  ? __pfx_kthread+0x10/0x10
[13827.163964]  ret_from_fork_asm+0x1a/0x30
[13827.163969]  </TASK>
[13827.163970] task:kworker/u130:29 state:D stack:0     pid:3122  =
tgid:3122  ppid:2      flags:0x00004000
[13827.163973] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.163976] Call Trace:
[13827.163977]  <TASK>
[13827.163979]  __schedule+0x425/0x1460
[13827.163984]  schedule+0x27/0xf0
[13827.163986]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.163992]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.163995]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.164000]  raid5_make_request+0x364/0x1290 [raid456]
[13827.164005]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164007]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.164010]  ? __pfx_woken_wake_function+0x10/0x10
[13827.164013]  ? bio_split_rw+0x141/0x2a0
[13827.164018]  md_handle_request+0x153/0x270 [md_mod]
[13827.164023]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164027]  __submit_bio+0x190/0x240
[13827.164030]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.164033]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164036]  ? submit_bio_noacct+0x47/0x5b0
[13827.164039]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.164042]  process_one_work+0x18f/0x3b0
[13827.164045]  worker_thread+0x21f/0x330
[13827.164047]  ? __pfx_worker_thread+0x10/0x10
[13827.164049]  ? __pfx_worker_thread+0x10/0x10
[13827.164051]  kthread+0xcd/0x100
[13827.164054]  ? __pfx_kthread+0x10/0x10
[13827.164057]  ret_from_fork+0x31/0x50
[13827.164059]  ? __pfx_kthread+0x10/0x10
[13827.164062]  ret_from_fork_asm+0x1a/0x30
[13827.164066]  </TASK>
[13827.164067] task:kworker/u130:30 state:D stack:0     pid:3123  =
tgid:3123  ppid:2      flags:0x00004000
[13827.164070] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.164073] Call Trace:
[13827.164074]  <TASK>
[13827.164075]  __schedule+0x425/0x1460
[13827.164080]  schedule+0x27/0xf0
[13827.164083]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.164089]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.164091]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.164096]  raid5_make_request+0x364/0x1290 [raid456]
[13827.164101]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164104]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.164106]  ? __pfx_woken_wake_function+0x10/0x10
[13827.164109]  ? bio_split_rw+0x141/0x2a0
[13827.164114]  md_handle_request+0x153/0x270 [md_mod]
[13827.164120]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164123]  __submit_bio+0x190/0x240
[13827.164127]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.164130]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164133]  ? submit_bio_noacct+0x47/0x5b0
[13827.164137]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.164139]  process_one_work+0x18f/0x3b0
[13827.164142]  worker_thread+0x21f/0x330
[13827.164145]  ? __pfx_worker_thread+0x10/0x10
[13827.164147]  kthread+0xcd/0x100
[13827.164149]  ? __pfx_kthread+0x10/0x10
[13827.164152]  ret_from_fork+0x31/0x50
[13827.164154]  ? __pfx_kthread+0x10/0x10
[13827.164157]  ret_from_fork_asm+0x1a/0x30
[13827.164161]  </TASK>
[13827.164162] task:kworker/u130:31 state:D stack:0     pid:3124  =
tgid:3124  ppid:2      flags:0x00004000
[13827.164165] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.164168] Call Trace:
[13827.164168]  <TASK>
[13827.164170]  __schedule+0x425/0x1460
[13827.164175]  schedule+0x27/0xf0
[13827.164178]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.164183]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.164186]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.164191]  raid5_make_request+0x364/0x1290 [raid456]
[13827.164196]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164198]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.164201]  ? __pfx_woken_wake_function+0x10/0x10
[13827.164204]  ? bio_split_rw+0x141/0x2a0
[13827.164208]  md_handle_request+0x153/0x270 [md_mod]
[13827.164214]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164217]  __submit_bio+0x190/0x240
[13827.164221]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.164224]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164227]  ? submit_bio_noacct+0x47/0x5b0
[13827.164230]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.164233]  process_one_work+0x18f/0x3b0
[13827.164236]  worker_thread+0x21f/0x330
[13827.164239]  ? __pfx_worker_thread+0x10/0x10
[13827.164240]  kthread+0xcd/0x100
[13827.164243]  ? __pfx_kthread+0x10/0x10
[13827.164245]  ret_from_fork+0x31/0x50
[13827.164248]  ? __pfx_kthread+0x10/0x10
[13827.164251]  ret_from_fork_asm+0x1a/0x30
[13827.164255]  </TASK>
[13827.164257] task:kworker/u130:33 state:D stack:0     pid:4077  =
tgid:4077  ppid:2      flags:0x00004000
[13827.164260] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.164262] Call Trace:
[13827.164263]  <TASK>
[13827.164265]  __schedule+0x425/0x1460
[13827.164267]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164272]  schedule+0x27/0xf0
[13827.164274]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.164280]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.164284]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.164288]  raid5_make_request+0x364/0x1290 [raid456]
[13827.164294]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164296]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.164299]  ? __pfx_woken_wake_function+0x10/0x10
[13827.164302]  ? bio_split_rw+0x141/0x2a0
[13827.164307]  md_handle_request+0x153/0x270 [md_mod]
[13827.164313]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164316]  __submit_bio+0x190/0x240
[13827.164320]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.164323]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164326]  ? submit_bio_noacct+0x47/0x5b0
[13827.164329]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.164332]  process_one_work+0x18f/0x3b0
[13827.164334]  worker_thread+0x21f/0x330
[13827.164337]  ? __pfx_worker_thread+0x10/0x10
[13827.164339]  ? __pfx_worker_thread+0x10/0x10
[13827.164341]  kthread+0xcd/0x100
[13827.164343]  ? __pfx_kthread+0x10/0x10
[13827.164346]  ret_from_fork+0x31/0x50
[13827.164349]  ? __pfx_kthread+0x10/0x10
[13827.164351]  ret_from_fork_asm+0x1a/0x30
[13827.164355]  </TASK>
[13827.164358] task:kworker/u130:32 state:D stack:0     pid:10102 =
tgid:10102 ppid:2      flags:0x00004000
[13827.164361] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.164364] Call Trace:
[13827.164365]  <TASK>
[13827.164367]  __schedule+0x425/0x1460
[13827.164372]  schedule+0x27/0xf0
[13827.164374]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.164380]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.164383]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.164388]  raid5_make_request+0x364/0x1290 [raid456]
[13827.164394]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164396]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.164399]  ? __pfx_woken_wake_function+0x10/0x10
[13827.164401]  ? bio_split_rw+0x141/0x2a0
[13827.164406]  md_handle_request+0x153/0x270 [md_mod]
[13827.164412]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164415]  __submit_bio+0x190/0x240
[13827.164419]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.164422]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164424]  ? submit_bio_noacct+0x47/0x5b0
[13827.164428]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.164430]  process_one_work+0x18f/0x3b0
[13827.164433]  worker_thread+0x21f/0x330
[13827.164435]  ? __pfx_worker_thread+0x10/0x10
[13827.164437]  ? __pfx_worker_thread+0x10/0x10
[13827.164440]  kthread+0xcd/0x100
[13827.164442]  ? __pfx_kthread+0x10/0x10
[13827.164444]  ret_from_fork+0x31/0x50
[13827.164447]  ? __pfx_kthread+0x10/0x10
[13827.164449]  ret_from_fork_asm+0x1a/0x30
[13827.164454]  </TASK>
[13827.164455] task:kworker/u132:9  state:D stack:0     pid:10362 =
tgid:10362 ppid:2      flags:0x00004000
[13827.164459] Workqueue: xfs-cil/dm-4 xlog_cil_push_work [xfs]
[13827.164544] Call Trace:
[13827.164545]  <TASK>
[13827.164547]  __schedule+0x425/0x1460
[13827.164553]  schedule+0x27/0xf0
[13827.164556]  xlog_wait_on_iclog+0x167/0x180 [xfs]
[13827.164611]  ? __pfx_default_wake_function+0x10/0x10
[13827.164615]  xlog_cil_push_work+0x84a/0x880 [xfs]
[13827.164669]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164673]  process_one_work+0x18f/0x3b0
[13827.164676]  worker_thread+0x21f/0x330
[13827.164678]  ? __pfx_worker_thread+0x10/0x10
[13827.164680]  kthread+0xcd/0x100
[13827.164683]  ? __pfx_kthread+0x10/0x10
[13827.164686]  ret_from_fork+0x31/0x50
[13827.164688]  ? __pfx_kthread+0x10/0x10
[13827.164690]  ret_from_fork_asm+0x1a/0x30
[13827.164695]  </TASK>
[13827.164697] task:kworker/u130:15 state:D stack:0     pid:16150 =
tgid:16150 ppid:2      flags:0x00004000
[13827.164701] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.164704] Call Trace:
[13827.164704]  <TASK>
[13827.164706]  __schedule+0x425/0x1460
[13827.164711]  schedule+0x27/0xf0
[13827.164714]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.164721]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.164724]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.164729]  raid5_make_request+0x364/0x1290 [raid456]
[13827.164734]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164737]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.164739]  ? __pfx_woken_wake_function+0x10/0x10
[13827.164742]  ? bio_split_rw+0x141/0x2a0
[13827.164747]  md_handle_request+0x153/0x270 [md_mod]
[13827.164753]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164757]  __submit_bio+0x190/0x240
[13827.164761]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.164764]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164766]  ? submit_bio_noacct+0x47/0x5b0
[13827.164770]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.164773]  process_one_work+0x18f/0x3b0
[13827.164775]  worker_thread+0x21f/0x330
[13827.164778]  ? __pfx_worker_thread+0x10/0x10
[13827.164780]  kthread+0xcd/0x100
[13827.164782]  ? __pfx_kthread+0x10/0x10
[13827.164785]  ret_from_fork+0x31/0x50
[13827.164787]  ? __pfx_kthread+0x10/0x10
[13827.164790]  ret_from_fork_asm+0x1a/0x30
[13827.164794]  </TASK>
[13827.164796] task:kworker/u130:1  state:D stack:0     pid:18969 =
tgid:18969 ppid:2      flags:0x00004000
[13827.164799] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.164801] Call Trace:
[13827.164803]  <TASK>
[13827.164804]  __schedule+0x425/0x1460
[13827.164809]  schedule+0x27/0xf0
[13827.164812]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.164818]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.164821]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.164826]  raid5_make_request+0x364/0x1290 [raid456]
[13827.164831]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164833]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.164836]  ? __pfx_woken_wake_function+0x10/0x10
[13827.164839]  ? bio_split_rw+0x141/0x2a0
[13827.164843]  md_handle_request+0x153/0x270 [md_mod]
[13827.164849]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164853]  __submit_bio+0x190/0x240
[13827.164856]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.164860]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164862]  ? submit_bio_noacct+0x47/0x5b0
[13827.164865]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.164868]  process_one_work+0x18f/0x3b0
[13827.164871]  worker_thread+0x21f/0x330
[13827.164873]  ? __pfx_worker_thread+0x10/0x10
[13827.164875]  ? __pfx_worker_thread+0x10/0x10
[13827.164877]  kthread+0xcd/0x100
[13827.164880]  ? __pfx_kthread+0x10/0x10
[13827.164882]  ret_from_fork+0x31/0x50
[13827.164885]  ? __pfx_kthread+0x10/0x10
[13827.164887]  ret_from_fork_asm+0x1a/0x30
[13827.164891]  </TASK>
[13827.164901] task:kworker/u130:28 state:D stack:0     pid:25349 =
tgid:25349 ppid:2      flags:0x00004000
[13827.164904] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.164907] Call Trace:
[13827.164908]  <TASK>
[13827.164909]  __schedule+0x425/0x1460
[13827.164914]  schedule+0x27/0xf0
[13827.164917]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.164922]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.164925]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.164930]  raid5_make_request+0x364/0x1290 [raid456]
[13827.164935]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164938]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.164941]  ? __pfx_woken_wake_function+0x10/0x10
[13827.164943]  ? bio_split_rw+0x141/0x2a0
[13827.164948]  md_handle_request+0x153/0x270 [md_mod]
[13827.164954]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164957]  __submit_bio+0x190/0x240
[13827.164961]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.164964]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.164967]  ? submit_bio_noacct+0x47/0x5b0
[13827.164970]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.164973]  process_one_work+0x18f/0x3b0
[13827.164976]  worker_thread+0x21f/0x330
[13827.164978]  ? __pfx_worker_thread+0x10/0x10
[13827.164980]  kthread+0xcd/0x100
[13827.164982]  ? __pfx_kthread+0x10/0x10
[13827.164985]  ret_from_fork+0x31/0x50
[13827.164988]  ? __pfx_kthread+0x10/0x10
[13827.164990]  ret_from_fork_asm+0x1a/0x30
[13827.164994]  </TASK>
[13827.165003] task:rsync           state:D stack:0     pid:26235 =
tgid:26235 ppid:26234  flags:0x00000000
[13827.165006] Call Trace:
[13827.165007]  <TASK>
[13827.165009]  __schedule+0x425/0x1460
[13827.165014]  ? nvme_queue_rqs+0x149/0x1f0 [nvme]
[13827.165019]  schedule+0x27/0xf0
[13827.165022]  schedule_timeout+0x15d/0x170
[13827.165026]  __down_common+0x119/0x220
[13827.165028]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.165032]  down+0x47/0x60
[13827.165034]  xfs_buf_lock+0x31/0xe0 [xfs]
[13827.165110]  xfs_buf_find_lock+0x55/0x100 [xfs]
[13827.165163]  xfs_buf_get_map+0x1ea/0xa80 [xfs]
[13827.165215]  ? __entry_text_end+0x101e87/0x101e89
[13827.165220]  xfs_buf_read_map+0x62/0x2a0 [xfs]
[13827.165272]  ? xfs_da_read_buf+0x106/0x180 [xfs]
[13827.165344]  xfs_trans_read_buf_map+0x12e/0x310 [xfs]
[13827.165414]  ? xfs_da_read_buf+0x106/0x180 [xfs]
[13827.165476]  xfs_da_read_buf+0x106/0x180 [xfs]
[13827.165528]  xfs_dir3_block_read+0x3c/0xf0 [xfs]
[13827.165588]  xfs_dir2_block_getdents+0xa8/0x2a0 [xfs]
[13827.165656]  xfs_readdir+0x1bf/0x200 [xfs]
[13827.165709]  iterate_dir+0x121/0x220
[13827.165715]  __x64_sys_getdents64+0x88/0x130
[13827.165717]  ? __pfx_filldir64+0x10/0x10
[13827.165721]  do_syscall_64+0xb7/0x200
[13827.165726]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[13827.165729] RIP: 0033:0x7f9a23704ea7
[13827.165731] RSP: 002b:00007ffef3ab7a58 EFLAGS: 00000293 ORIG_RAX: =
00000000000000d9
[13827.165734] RAX: ffffffffffffffda RBX: 000000001649b740 RCX: =
00007f9a23704ea7
[13827.165735] RDX: 0000000000008000 RSI: 000000001649b770 RDI: =
0000000000000005
[13827.165737] RBP: 000000001649b770 R08: 0000000000000030 R09: =
0000000000000001
[13827.165738] R10: 0000000000000000 R11: 0000000000000293 R12: =
ffffffffffffff88
[13827.165740] R13: 000000001649b744 R14: 0000000000000000 R15: =
0000000000000001
[13827.165744]  </TASK>
[13827.165749] task:kworker/u130:34 state:D stack:0     pid:29724 =
tgid:29724 ppid:2      flags:0x00004000
[13827.165752] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.165756] Call Trace:
[13827.165757]  <TASK>
[13827.165759]  __schedule+0x425/0x1460
[13827.165765]  schedule+0x27/0xf0
[13827.165767]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.165774]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.165777]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.165782]  raid5_make_request+0x364/0x1290 [raid456]
[13827.165788]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.165791]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.165794]  ? __pfx_woken_wake_function+0x10/0x10
[13827.165797]  ? bio_split_rw+0x141/0x2a0
[13827.165801]  md_handle_request+0x153/0x270 [md_mod]
[13827.165808]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.165811]  __submit_bio+0x190/0x240
[13827.165816]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.165819]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.165821]  ? submit_bio_noacct+0x47/0x5b0
[13827.165824]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.165827]  process_one_work+0x18f/0x3b0
[13827.165831]  worker_thread+0x21f/0x330
[13827.165832]  ? __pfx_worker_thread+0x10/0x10
[13827.165835]  ? __pfx_worker_thread+0x10/0x10
[13827.165837]  kthread+0xcd/0x100
[13827.165840]  ? __pfx_kthread+0x10/0x10
[13827.165842]  ret_from_fork+0x31/0x50
[13827.165845]  ? __pfx_kthread+0x10/0x10
[13827.165847]  ret_from_fork_asm+0x1a/0x30
[13827.165852]  </TASK>
[13827.165854] task:kworker/31:2    state:D stack:0     pid:29965 =
tgid:29965 ppid:2      flags:0x00004000
[13827.165858] Workqueue: xfs-sync/dm-4 xfs_log_worker [xfs]
[13827.165928] Call Trace:
[13827.165930]  <TASK>
[13827.165932]  __schedule+0x425/0x1460
[13827.165934]  ? ttwu_do_activate+0x64/0x210
[13827.165937]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.165942]  schedule+0x27/0xf0
[13827.165944]  schedule_timeout+0x15d/0x170
[13827.165948]  __wait_for_common+0x90/0x1c0
[13827.165951]  ? __pfx_schedule_timeout+0x10/0x10
[13827.165955]  __flush_workqueue+0x158/0x440
[13827.165957]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.165962]  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
[13827.166014]  xlog_cil_force_seq+0x69/0x240 [xfs]
[13827.166066]  xfs_log_force+0x7a/0x230 [xfs]
[13827.166116]  xfs_log_worker+0x3d/0xc0 [xfs]
[13827.166165]  process_one_work+0x18f/0x3b0
[13827.166168]  worker_thread+0x21f/0x330
[13827.166170]  ? __pfx_worker_thread+0x10/0x10
[13827.166173]  ? __pfx_worker_thread+0x10/0x10
[13827.166175]  kthread+0xcd/0x100
[13827.166177]  ? __pfx_kthread+0x10/0x10
[13827.166180]  ret_from_fork+0x31/0x50
[13827.166183]  ? __pfx_kthread+0x10/0x10
[13827.166185]  ret_from_fork_asm+0x1a/0x30
[13827.166190]  </TASK>
[13827.166194] task:rsync           state:D stack:0     pid:30636 =
tgid:30636 ppid:30606  flags:0x00000000
[13827.166197] Call Trace:
[13827.166198]  <TASK>
[13827.166199]  __schedule+0x425/0x1460
[13827.166202]  ? blk_mq_flush_plug_list.part.0+0x4a7/0x5a0
[13827.166208]  schedule+0x27/0xf0
[13827.166210]  schedule_timeout+0x15d/0x170
[13827.166214]  __wait_for_common+0x90/0x1c0
[13827.166216]  ? __pfx_schedule_timeout+0x10/0x10
[13827.166220]  xfs_buf_iowait+0x1c/0xc0 [xfs]
[13827.166282]  __xfs_buf_submit+0x132/0x1e0 [xfs]
[13827.166333]  xfs_buf_read_map+0x129/0x2a0 [xfs]
[13827.166383]  ? xfs_da_read_buf+0x106/0x180 [xfs]
[13827.166451]  xfs_trans_read_buf_map+0x12e/0x310 [xfs]
[13827.166517]  ? xfs_da_read_buf+0x106/0x180 [xfs]
[13827.166575]  xfs_da_read_buf+0x106/0x180 [xfs]
[13827.166627]  __xfs_dir3_free_read+0x34/0x1a0 [xfs]
[13827.166688]  xfs_dir2_node_addname+0x4ba/0xa30 [xfs]
[13827.166739]  ? xfs_bmap_last_offset+0x98/0x140 [xfs]
[13827.166805]  xfs_dir_createname+0x129/0x160 [xfs]
[13827.166860]  ? xfs_trans_ichgtime+0x2f/0x90 [xfs]
[13827.166935]  xfs_dir_create_child+0x6a/0x150 [xfs]
[13827.166989]  ? xfs_diflags_to_iflags+0x12/0x50 [xfs]
[13827.167057]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.167060]  ? xfs_setup_inode+0x52/0x110 [xfs]
[13827.167109]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.167113]  xfs_create+0x3b3/0x490 [xfs]
[13827.167170]  xfs_generic_create+0x312/0x370 [xfs]
[13827.167222]  path_openat+0xf54/0x1210
[13827.167227]  do_filp_open+0xc4/0x170
[13827.167234]  do_sys_openat2+0xab/0xe0
[13827.167239]  __x64_sys_openat+0x57/0xa0
[13827.167243]  do_syscall_64+0xb7/0x200
[13827.167246]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[13827.167248] RIP: 0033:0x7f44f132be2f
[13827.167250] RSP: 002b:00007ffffdc01f90 EFLAGS: 00000246 ORIG_RAX: =
0000000000000101
[13827.167253] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: =
00007f44f132be2f
[13827.167254] RDX: 00000000000000c2 RSI: 00007ffffdc04260 RDI: =
00000000ffffff9c
[13827.167255] RBP: 000000000003a2f8 R08: 001fa65a6d219dd4 R09: =
00007ffffdc021cc
[13827.167256] R10: 0000000000000180 R11: 0000000000000246 R12: =
00007ffffdc042a9
[13827.167257] R13: 00007ffffdc04260 R14: 8421084210842109 R15: =
00007f44f13c6a80
[13827.167261]  </TASK>
[13827.167265] task:kworker/u130:22 state:D stack:0     pid:32348 =
tgid:32348 ppid:2      flags:0x00004000
[13827.167268] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.167271] Call Trace:
[13827.167272]  <TASK>
[13827.167275]  __schedule+0x425/0x1460
[13827.167280]  schedule+0x27/0xf0
[13827.167283]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.167290]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.167293]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.167298]  raid5_make_request+0x364/0x1290 [raid456]
[13827.167303]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.167306]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.167309]  ? __pfx_woken_wake_function+0x10/0x10
[13827.167312]  ? bio_split_rw+0x141/0x2a0
[13827.167317]  md_handle_request+0x153/0x270 [md_mod]
[13827.167323]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.167327]  __submit_bio+0x190/0x240
[13827.167331]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.167334]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.167336]  ? submit_bio_noacct+0x47/0x5b0
[13827.167340]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.167343]  process_one_work+0x18f/0x3b0
[13827.167346]  worker_thread+0x21f/0x330
[13827.167348]  ? __pfx_worker_thread+0x10/0x10
[13827.167350]  ? __pfx_worker_thread+0x10/0x10
[13827.167353]  kthread+0xcd/0x100
[13827.167355]  ? __pfx_kthread+0x10/0x10
[13827.167358]  ret_from_fork+0x31/0x50
[13827.167360]  ? __pfx_kthread+0x10/0x10
[13827.167363]  ret_from_fork_asm+0x1a/0x30
[13827.167368]  </TASK>
[13827.167370] task:kworker/u130:35 state:D stack:0     pid:34332 =
tgid:34332 ppid:2      flags:0x00004000
[13827.167373] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[13827.167376] Call Trace:
[13827.167377]  <TASK>
[13827.167379]  __schedule+0x425/0x1460
[13827.167384]  schedule+0x27/0xf0
[13827.167387]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[13827.167392]  ? __pfx_autoremove_wake_function+0x10/0x10
[13827.167395]  __add_stripe_bio+0x1f4/0x240 [raid456]
[13827.167400]  raid5_make_request+0x364/0x1290 [raid456]
[13827.167405]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.167408]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[13827.167411]  ? __pfx_woken_wake_function+0x10/0x10
[13827.167413]  ? bio_split_rw+0x141/0x2a0
[13827.167418]  md_handle_request+0x153/0x270 [md_mod]
[13827.167424]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.167427]  __submit_bio+0x190/0x240
[13827.167431]  submit_bio_noacct_nocheck+0x19a/0x3c0
[13827.167434]  ? srso_alias_return_thunk+0x5/0xfbef5
[13827.167437]  ? submit_bio_noacct+0x47/0x5b0
[13827.167440]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[13827.167443]  process_one_work+0x18f/0x3b0
[13827.167446]  worker_thread+0x21f/0x330
[13827.167448]  ? __pfx_worker_thread+0x10/0x10
[13827.167450]  ? __pfx_worker_thread+0x10/0x10
[13827.167452]  kthread+0xcd/0x100
[13827.167454]  ? __pfx_kthread+0x10/0x10
[13827.167457]  ret_from_fork+0x31/0x50
[13827.167459]  ? __pfx_kthread+0x10/0x10
[13827.167462]  ret_from_fork_asm+0x1a/0x30
[13827.167466]  </TASK>

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

