Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBC91D47A2
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 20:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730750717; cv=none; b=pq0qDE7EdtRABjkCwr2wZPrh3i5/Uc+z2WzA8aovKJUQtxizqjy5S2pRR7q1gyb78Ma77Ju05ULMX5urflXiRu4KbTQmmWnboJBE6U+Vn1SMrt2N1j/vOrFRmSKo6EUu9mN64zDNxPLFR0jAMw41QKOzkZRzdbpJw3ob04vgPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730750717; c=relaxed/simple;
	bh=ROwdF/GlkdwJjOXRA0TQkoepCcvaQ9A+dZBdatLN5hM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Ff1qPiku8rB6dXJtG8g44x0YGI1AfD9wIBneI0rrjz+6NZ4TIND5FihDIdWWE0FjAz4tbpH8aNLW6qhc7qy0k/I+VMEUltc/yQfuN2zZ6/hsw/5vSoPNfa4f8ZroOp8JD7lu4I9k3347LahBaeLVxj4N0Xh53/l4dFrWyPHWWbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=NzfIePGR; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="NzfIePGR"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1730750704;
	bh=aEUTI5c5dygbA/VOSIHkDquN5m76VakpfJZtO9hKPAA=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=NzfIePGRiqr9s3a4NmCaYU/PISZruMs7qUY3gSXTDJwsX9dhwxfg0hdDYZ5CJeJ/d
	 tYAkXoSV0wu4vwgWSQrKwwH50lapa5JoZz+/f1xFIzXRqSx184foks4asQdnBLBWpK
	 rRGi0YxOiQ3AmwTjKTZwjqh3n74OVLYhANvo3mkU=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <63DE1813-C719-49B7-9012-641DB3DECA26@flyingcircus.io>
Date: Mon, 4 Nov 2024 21:04:38 +0100
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F8A5ABD5-0773-414D-BBBC-538481BCD0F4@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
 <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
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
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

unfortunately no joy. After 5000 seconds it got stuck again. Here=E2=80=99=
s the full list of tracebacks once more.

Happy to add more debugging code if you hand me a patch.

[12240.198494] sysrq: Show Blocked State
[12240.202734] task:kworker/u132:0  state:D stack:0     pid:214   =
tgid:214   ppid:2      flags:0x00004000
[12240.202740] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.202750] Call Trace:
[12240.202752]  <TASK>
[12240.202756]  __schedule+0x425/0x1460
[12240.202763]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.202769]  schedule+0x27/0xf0
[12240.202773]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.202782]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.202800]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.202807]  raid5_make_request+0x364/0x1290 [raid456]
[12240.202814]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.202816]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.202821]  ? __pfx_woken_wake_function+0x10/0x10
[12240.202825]  ? bio_split_rw+0x141/0x2a0
[12240.202830]  md_handle_request+0x153/0x270 [md_mod]
[12240.202838]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.202841]  __submit_bio+0x190/0x240
[12240.202845]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.202848]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.202851]  ? submit_bio_noacct+0x47/0x5b0
[12240.202854]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.202858]  process_one_work+0x18f/0x3b0
[12240.202863]  worker_thread+0x21f/0x330
[12240.202865]  ? __pfx_worker_thread+0x10/0x10
[12240.202868]  kthread+0xcd/0x100
[12240.202871]  ? __pfx_kthread+0x10/0x10
[12240.202874]  ret_from_fork+0x31/0x50
[12240.202878]  ? __pfx_kthread+0x10/0x10
[12240.202881]  ret_from_fork_asm+0x1a/0x30
[12240.202887]  </TASK>
[12240.202939] task:kworker/u129:3  state:D stack:0     pid:436   =
tgid:436   ppid:2      flags:0x00004000
[12240.202943] Workqueue: xfs-cil/dm-4 xlog_cil_push_work [xfs]
[12240.203028] Call Trace:
[12240.203029]  <TASK>
[12240.203031]  __schedule+0x425/0x1460
[12240.203034]  ? __blk_flush_plug+0xf5/0x150
[12240.203040]  schedule+0x27/0xf0
[12240.203042]  xlog_state_get_iclog_space+0x102/0x2b0 [xfs]
[12240.203097]  ? __pfx_default_wake_function+0x10/0x10
[12240.203101]  xlog_write_get_more_iclog_space+0xd0/0x100 [xfs]
[12240.203152]  xlog_write+0x310/0x470 [xfs]
[12240.203203]  xlog_cil_push_work+0x6a5/0x880 [xfs]
[12240.203256]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203260]  process_one_work+0x18f/0x3b0
[12240.203263]  worker_thread+0x21f/0x330
[12240.203266]  ? __pfx_worker_thread+0x10/0x10
[12240.203268]  kthread+0xcd/0x100
[12240.203270]  ? __pfx_kthread+0x10/0x10
[12240.203273]  ret_from_fork+0x31/0x50
[12240.203276]  ? __pfx_kthread+0x10/0x10
[12240.203278]  ret_from_fork_asm+0x1a/0x30
[12240.203283]  </TASK>
[12240.203289] task:kworker/u132:1  state:D stack:0     pid:490   =
tgid:490   ppid:2      flags:0x00004000
[12240.203293] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.203296] Call Trace:
[12240.203298]  <TASK>
[12240.203299]  __schedule+0x425/0x1460
[12240.203302]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203305]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203307]  ? raid5_bio_lowest_chunk_sector+0x65/0xe0 [raid456]
[12240.203313]  schedule+0x27/0xf0
[12240.203316]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.203323]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.203326]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.203331]  raid5_make_request+0x364/0x1290 [raid456]
[12240.203336]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203338]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.203342]  ? __pfx_woken_wake_function+0x10/0x10
[12240.203345]  ? bio_split_rw+0x141/0x2a0
[12240.203349]  md_handle_request+0x153/0x270 [md_mod]
[12240.203356]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203359]  __submit_bio+0x190/0x240
[12240.203363]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.203366]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203368]  ? submit_bio_noacct+0x47/0x5b0
[12240.203372]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.203375]  process_one_work+0x18f/0x3b0
[12240.203377]  worker_thread+0x21f/0x330
[12240.203380]  ? __pfx_worker_thread+0x10/0x10
[12240.203382]  kthread+0xcd/0x100
[12240.203385]  ? __pfx_kthread+0x10/0x10
[12240.203387]  ret_from_fork+0x31/0x50
[12240.203390]  ? __pfx_kthread+0x10/0x10
[12240.203392]  ret_from_fork_asm+0x1a/0x30
[12240.203396]  </TASK>
[12240.203405] task:kworker/u132:2  state:D stack:0     pid:504   =
tgid:504   ppid:2      flags:0x00004000
[12240.203409] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.203411] Call Trace:
[12240.203412]  <TASK>
[12240.203414]  __schedule+0x425/0x1460
[12240.203419]  schedule+0x27/0xf0
[12240.203422]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.203427]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.203430]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.203435]  raid5_make_request+0x364/0x1290 [raid456]
[12240.203440]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203443]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.203446]  ? __pfx_woken_wake_function+0x10/0x10
[12240.203448]  ? bio_split_rw+0x141/0x2a0
[12240.203453]  md_handle_request+0x153/0x270 [md_mod]
[12240.203459]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203462]  __submit_bio+0x190/0x240
[12240.203466]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.203469]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203472]  ? submit_bio_noacct+0x47/0x5b0
[12240.203475]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.203478]  process_one_work+0x18f/0x3b0
[12240.203481]  worker_thread+0x21f/0x330
[12240.203483]  ? __pfx_worker_thread+0x10/0x10
[12240.203485]  ? __pfx_worker_thread+0x10/0x10
[12240.203487]  kthread+0xcd/0x100
[12240.203489]  ? __pfx_kthread+0x10/0x10
[12240.203492]  ret_from_fork+0x31/0x50
[12240.203495]  ? __pfx_kthread+0x10/0x10
[12240.203497]  ret_from_fork_asm+0x1a/0x30
[12240.203501]  </TASK>
[12240.203557] task:kworker/u132:3  state:D stack:0     pid:1731  =
tgid:1731  ppid:2      flags:0x00004000
[12240.203561] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.203563] Call Trace:
[12240.203565]  <TASK>
[12240.203567]  __schedule+0x425/0x1460
[12240.203572]  schedule+0x27/0xf0
[12240.203575]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.203580]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.203583]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.203588]  raid5_make_request+0x364/0x1290 [raid456]
[12240.203593]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203595]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.203598]  ? __pfx_woken_wake_function+0x10/0x10
[12240.203600]  ? bio_split_rw+0x141/0x2a0
[12240.203605]  md_handle_request+0x153/0x270 [md_mod]
[12240.203611]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203614]  __submit_bio+0x190/0x240
[12240.203618]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.203621]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203624]  ? submit_bio_noacct+0x47/0x5b0
[12240.203627]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.203630]  process_one_work+0x18f/0x3b0
[12240.203633]  worker_thread+0x21f/0x330
[12240.203635]  ? __pfx_worker_thread+0x10/0x10
[12240.203637]  ? __pfx_worker_thread+0x10/0x10
[12240.203639]  kthread+0xcd/0x100
[12240.203641]  ? __pfx_kthread+0x10/0x10
[12240.203644]  ret_from_fork+0x31/0x50
[12240.203646]  ? __pfx_kthread+0x10/0x10
[12240.203649]  ret_from_fork_asm+0x1a/0x30
[12240.203653]  </TASK>
[12240.203682] task:kworker/u132:4  state:D stack:0     pid:2131  =
tgid:2131  ppid:2      flags:0x00004000
[12240.203686] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.203689] Call Trace:
[12240.203690]  <TASK>
[12240.203691]  __schedule+0x425/0x1460
[12240.203697]  schedule+0x27/0xf0
[12240.203699]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.203705]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.203707]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.203712]  raid5_make_request+0x364/0x1290 [raid456]
[12240.203718]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203720]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.203723]  ? __pfx_woken_wake_function+0x10/0x10
[12240.203725]  ? bio_split_rw+0x141/0x2a0
[12240.203730]  md_handle_request+0x153/0x270 [md_mod]
[12240.203736]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203739]  __submit_bio+0x190/0x240
[12240.203743]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.203746]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203749]  ? submit_bio_noacct+0x47/0x5b0
[12240.203752]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.203754]  process_one_work+0x18f/0x3b0
[12240.203758]  worker_thread+0x21f/0x330
[12240.203760]  ? __pfx_worker_thread+0x10/0x10
[12240.203762]  ? __pfx_worker_thread+0x10/0x10
[12240.203764]  kthread+0xcd/0x100
[12240.203766]  ? __pfx_kthread+0x10/0x10
[12240.203769]  ret_from_fork+0x31/0x50
[12240.203771]  ? __pfx_kthread+0x10/0x10
[12240.203774]  ret_from_fork_asm+0x1a/0x30
[12240.203778]  </TASK>
[12240.203780] task:kworker/u132:5  state:D stack:0     pid:2132  =
tgid:2132  ppid:2      flags:0x00004000
[12240.203784] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.203793] Call Trace:
[12240.203794]  <TASK>
[12240.203795]  __schedule+0x425/0x1460
[12240.203800]  schedule+0x27/0xf0
[12240.203803]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.203808]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.203812]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.203817]  raid5_make_request+0x364/0x1290 [raid456]
[12240.203821]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203824]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.203827]  ? __pfx_woken_wake_function+0x10/0x10
[12240.203829]  ? bio_split_rw+0x141/0x2a0
[12240.203834]  md_handle_request+0x153/0x270 [md_mod]
[12240.203840]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203843]  __submit_bio+0x190/0x240
[12240.203847]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.203850]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203853]  ? submit_bio_noacct+0x47/0x5b0
[12240.203856]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.203859]  process_one_work+0x18f/0x3b0
[12240.203862]  worker_thread+0x21f/0x330
[12240.203864]  ? __pfx_worker_thread+0x10/0x10
[12240.203866]  kthread+0xcd/0x100
[12240.203869]  ? __pfx_kthread+0x10/0x10
[12240.203871]  ret_from_fork+0x31/0x50
[12240.203874]  ? __pfx_kthread+0x10/0x10
[12240.203876]  ret_from_fork_asm+0x1a/0x30
[12240.203880]  </TASK>
[12240.203882] task:kworker/u132:7  state:D stack:0     pid:2134  =
tgid:2134  ppid:2      flags:0x00004000
[12240.203885] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.203888] Call Trace:
[12240.203889]  <TASK>
[12240.203891]  __schedule+0x425/0x1460
[12240.203893]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203898]  schedule+0x27/0xf0
[12240.203901]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.203906]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.203909]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.203914]  raid5_make_request+0x364/0x1290 [raid456]
[12240.203919]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203922]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.203925]  ? __pfx_woken_wake_function+0x10/0x10
[12240.203927]  ? bio_split_rw+0x141/0x2a0
[12240.203932]  md_handle_request+0x153/0x270 [md_mod]
[12240.203938]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203941]  __submit_bio+0x190/0x240
[12240.203945]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.203948]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.203950]  ? submit_bio_noacct+0x47/0x5b0
[12240.203953]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.203956]  process_one_work+0x18f/0x3b0
[12240.203959]  worker_thread+0x21f/0x330
[12240.203961]  ? __pfx_worker_thread+0x10/0x10
[12240.203964]  kthread+0xcd/0x100
[12240.203966]  ? __pfx_kthread+0x10/0x10
[12240.203969]  ret_from_fork+0x31/0x50
[12240.203971]  ? __pfx_kthread+0x10/0x10
[12240.203974]  ret_from_fork_asm+0x1a/0x30
[12240.203978]  </TASK>
[12240.203981] task:kworker/u132:9  state:D stack:0     pid:2136  =
tgid:2136  ppid:2      flags:0x00004000
[12240.203984] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.203987] Call Trace:
[12240.203988]  <TASK>
[12240.203989]  __schedule+0x425/0x1460
[12240.203995]  schedule+0x27/0xf0
[12240.203997]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.204003]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.204006]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.204011]  raid5_make_request+0x364/0x1290 [raid456]
[12240.204016]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204018]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.204021]  ? __pfx_woken_wake_function+0x10/0x10
[12240.204023]  ? bio_split_rw+0x141/0x2a0
[12240.204028]  md_handle_request+0x153/0x270 [md_mod]
[12240.204034]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204037]  __submit_bio+0x190/0x240
[12240.204041]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.204044]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204046]  ? submit_bio_noacct+0x47/0x5b0
[12240.204050]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.204052]  process_one_work+0x18f/0x3b0
[12240.204055]  worker_thread+0x21f/0x330
[12240.204058]  ? __pfx_worker_thread+0x10/0x10
[12240.204060]  kthread+0xcd/0x100
[12240.204062]  ? __pfx_kthread+0x10/0x10
[12240.204065]  ret_from_fork+0x31/0x50
[12240.204067]  ? __pfx_kthread+0x10/0x10
[12240.204069]  ret_from_fork_asm+0x1a/0x30
[12240.204074]  </TASK>
[12240.204076] task:kworker/u132:11 state:D stack:0     pid:2138  =
tgid:2138  ppid:2      flags:0x00004000
[12240.204078] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.204081] Call Trace:
[12240.204082]  <TASK>
[12240.204084]  __schedule+0x425/0x1460
[12240.204089]  schedule+0x27/0xf0
[12240.204092]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.204097]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.204100]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.204105]  raid5_make_request+0x364/0x1290 [raid456]
[12240.204110]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204113]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.204116]  ? __pfx_woken_wake_function+0x10/0x10
[12240.204119]  ? bio_split_rw+0x141/0x2a0
[12240.204123]  md_handle_request+0x153/0x270 [md_mod]
[12240.204129]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204132]  __submit_bio+0x190/0x240
[12240.204136]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.204139]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204142]  ? submit_bio_noacct+0x47/0x5b0
[12240.204145]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.204148]  process_one_work+0x18f/0x3b0
[12240.204151]  worker_thread+0x21f/0x330
[12240.204154]  ? __pfx_worker_thread+0x10/0x10
[12240.204156]  kthread+0xcd/0x100
[12240.204159]  ? __pfx_kthread+0x10/0x10
[12240.204161]  ret_from_fork+0x31/0x50
[12240.204164]  ? __pfx_kthread+0x10/0x10
[12240.204166]  ret_from_fork_asm+0x1a/0x30
[12240.204171]  </TASK>
[12240.204172] task:kworker/u132:12 state:D stack:0     pid:2139  =
tgid:2139  ppid:2      flags:0x00004000
[12240.204175] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.204178] Call Trace:
[12240.204179]  <TASK>
[12240.204180]  __schedule+0x425/0x1460
[12240.204186]  schedule+0x27/0xf0
[12240.204188]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.204194]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.204197]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.204202]  raid5_make_request+0x364/0x1290 [raid456]
[12240.204207]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204209]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.204212]  ? __pfx_woken_wake_function+0x10/0x10
[12240.204215]  ? bio_split_rw+0x141/0x2a0
[12240.204220]  md_handle_request+0x153/0x270 [md_mod]
[12240.204226]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204229]  __submit_bio+0x190/0x240
[12240.204233]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.204235]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204238]  ? submit_bio_noacct+0x47/0x5b0
[12240.204241]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.204244]  process_one_work+0x18f/0x3b0
[12240.204247]  worker_thread+0x21f/0x330
[12240.204249]  ? __pfx_worker_thread+0x10/0x10
[12240.204251]  kthread+0xcd/0x100
[12240.204254]  ? __pfx_kthread+0x10/0x10
[12240.204257]  ret_from_fork+0x31/0x50
[12240.204259]  ? __pfx_kthread+0x10/0x10
[12240.204261]  ret_from_fork_asm+0x1a/0x30
[12240.204266]  </TASK>
[12240.204267] task:kworker/u132:14 state:D stack:0     pid:2141  =
tgid:2141  ppid:2      flags:0x00004000
[12240.204270] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.204273] Call Trace:
[12240.204274]  <TASK>
[12240.204276]  __schedule+0x425/0x1460
[12240.204278]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204283]  schedule+0x27/0xf0
[12240.204286]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.204291]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.204294]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.204299]  raid5_make_request+0x364/0x1290 [raid456]
[12240.204304]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204306]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.204309]  ? __pfx_woken_wake_function+0x10/0x10
[12240.204312]  ? bio_split_rw+0x141/0x2a0
[12240.204317]  md_handle_request+0x153/0x270 [md_mod]
[12240.204322]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204326]  __submit_bio+0x190/0x240
[12240.204330]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.204333]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204335]  ? submit_bio_noacct+0x47/0x5b0
[12240.204338]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.204341]  process_one_work+0x18f/0x3b0
[12240.204344]  worker_thread+0x21f/0x330
[12240.204346]  ? __pfx_worker_thread+0x10/0x10
[12240.204348]  kthread+0xcd/0x100
[12240.204351]  ? __pfx_kthread+0x10/0x10
[12240.204354]  ret_from_fork+0x31/0x50
[12240.204356]  ? __pfx_kthread+0x10/0x10
[12240.204358]  ret_from_fork_asm+0x1a/0x30
[12240.204363]  </TASK>
[12240.204364] task:kworker/u132:15 state:D stack:0     pid:2142  =
tgid:2142  ppid:2      flags:0x00004000
[12240.204367] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.204370] Call Trace:
[12240.204371]  <TASK>
[12240.204372]  __schedule+0x425/0x1460
[12240.204377]  schedule+0x27/0xf0
[12240.204380]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.204385]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.204388]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.204393]  raid5_make_request+0x364/0x1290 [raid456]
[12240.204398]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204401]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.204403]  ? __pfx_woken_wake_function+0x10/0x10
[12240.204406]  ? bio_split_rw+0x141/0x2a0
[12240.204410]  md_handle_request+0x153/0x270 [md_mod]
[12240.204416]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204419]  __submit_bio+0x190/0x240
[12240.204424]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.204427]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204429]  ? submit_bio_noacct+0x47/0x5b0
[12240.204432]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.204435]  process_one_work+0x18f/0x3b0
[12240.204438]  worker_thread+0x21f/0x330
[12240.204441]  ? __pfx_worker_thread+0x10/0x10
[12240.204443]  kthread+0xcd/0x100
[12240.204445]  ? __pfx_kthread+0x10/0x10
[12240.204448]  ret_from_fork+0x31/0x50
[12240.204450]  ? __pfx_kthread+0x10/0x10
[12240.204453]  ret_from_fork_asm+0x1a/0x30
[12240.204457]  </TASK>
[12240.204458] task:kworker/u132:16 state:D stack:0     pid:2143  =
tgid:2143  ppid:2      flags:0x00004000
[12240.204461] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.204464] Call Trace:
[12240.204465]  <TASK>
[12240.204466]  __schedule+0x425/0x1460
[12240.204471]  schedule+0x27/0xf0
[12240.204474]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.204480]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.204482]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.204487]  raid5_make_request+0x364/0x1290 [raid456]
[12240.204493]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204495]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.204497]  ? __pfx_woken_wake_function+0x10/0x10
[12240.204500]  ? bio_split_rw+0x141/0x2a0
[12240.204505]  md_handle_request+0x153/0x270 [md_mod]
[12240.204511]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204514]  __submit_bio+0x190/0x240
[12240.204518]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.204521]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.204524]  ? submit_bio_noacct+0x47/0x5b0
[12240.204527]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.204530]  process_one_work+0x18f/0x3b0
[12240.204532]  worker_thread+0x21f/0x330
[12240.204535]  ? __pfx_worker_thread+0x10/0x10
[12240.204537]  kthread+0xcd/0x100
[12240.204540]  ? __pfx_kthread+0x10/0x10
[12240.204542]  ret_from_fork+0x31/0x50
[12240.204544]  ? __pfx_kthread+0x10/0x10
[12240.204547]  ret_from_fork_asm+0x1a/0x30
[12240.204551]  </TASK>
[12240.204553] task:kworker/u132:17 state:D stack:0     pid:2144  =
tgid:2144  ppid:2      flags:0x00004000
[12240.204556] Workqueue: writeback wb_workfn (flush-254:4)
[12240.204560] Call Trace:
[12240.204561]  <TASK>
[12240.204563]  __schedule+0x425/0x1460
[12240.204568]  schedule+0x27/0xf0
[12240.204570]  schedule_timeout+0x15d/0x170
[12240.204575]  __wait_for_common+0x90/0x1c0
[12240.204577]  ? __pfx_schedule_timeout+0x10/0x10
[12240.204581]  xfs_buf_iowait+0x1c/0xc0 [xfs]
[12240.204655]  __xfs_buf_submit+0x132/0x1e0 [xfs]
[12240.204708]  xfs_buf_read_map+0x129/0x2a0 [xfs]
[12240.204761]  ? xfs_btree_read_buf_block+0xa7/0x120 [xfs]
[12240.204837]  xfs_trans_read_buf_map+0x12e/0x310 [xfs]
[12240.204910]  ? xfs_btree_read_buf_block+0xa7/0x120 [xfs]
[12240.204972]  xfs_btree_read_buf_block+0xa7/0x120 [xfs]
[12240.205025]  xfs_btree_lookup_get_block+0xa6/0x1f0 [xfs]
[12240.205077]  xfs_btree_lookup+0xea/0x500 [xfs]
[12240.205129]  xfs_alloc_fixup_trees+0x70/0x520 [xfs]
[12240.205195]  xfs_alloc_cur_finish+0x2b/0xa0 [xfs]
[12240.205245]  xfs_alloc_ag_vextent_near+0x437/0x540 [xfs]
[12240.205297]  xfs_alloc_vextent_iterate_ags.constprop.0+0xc8/0x200 =
[xfs]
[12240.205347]  ? xfs_buf_item_format+0x1b8/0x450 [xfs]
[12240.205416]  xfs_alloc_vextent_start_ag+0xc0/0x190 [xfs]
[12240.205471]  xfs_bmap_btalloc+0x4dd/0x640 [xfs]
[12240.205535]  xfs_bmapi_allocate+0xac/0x2c0 [xfs]
[12240.205585]  xfs_bmapi_convert_one_delalloc+0x1f6/0x430 [xfs]
[12240.205639]  xfs_bmapi_convert_delalloc+0x43/0x60 [xfs]
[12240.205689]  xfs_map_blocks+0x257/0x420 [xfs]
[12240.205762]  iomap_writepages+0x271/0x9b0
[12240.205768]  xfs_vm_writepages+0x67/0x90 [xfs]
[12240.205826]  do_writepages+0x76/0x260
[12240.205832]  __writeback_single_inode+0x3d/0x350
[12240.205836]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.205838]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.205842]  writeback_sb_inodes+0x21c/0x4e0
[12240.205853]  __writeback_inodes_wb+0x4c/0xf0
[12240.205856]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.205859]  wb_writeback+0x193/0x310
[12240.205864]  wb_workfn+0x357/0x450
[12240.205868]  process_one_work+0x18f/0x3b0
[12240.205871]  worker_thread+0x21f/0x330
[12240.205874]  ? __pfx_worker_thread+0x10/0x10
[12240.205876]  kthread+0xcd/0x100
[12240.205878]  ? __pfx_kthread+0x10/0x10
[12240.205881]  ret_from_fork+0x31/0x50
[12240.205884]  ? __pfx_kthread+0x10/0x10
[12240.205886]  ret_from_fork_asm+0x1a/0x30
[12240.205891]  </TASK>
[12240.205893] task:kworker/u132:18 state:D stack:0     pid:2145  =
tgid:2145  ppid:2      flags:0x00004000
[12240.205896] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.205899] Call Trace:
[12240.205900]  <TASK>
[12240.205901]  __schedule+0x425/0x1460
[12240.205907]  schedule+0x27/0xf0
[12240.205910]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.205916]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.205919]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.205925]  raid5_make_request+0x364/0x1290 [raid456]
[12240.205930]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.205933]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.205936]  ? __pfx_woken_wake_function+0x10/0x10
[12240.205939]  ? bio_split_rw+0x141/0x2a0
[12240.205943]  md_handle_request+0x153/0x270 [md_mod]
[12240.205950]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.205953]  __submit_bio+0x190/0x240
[12240.205957]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.205961]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.205963]  ? submit_bio_noacct+0x47/0x5b0
[12240.205966]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.205970]  process_one_work+0x18f/0x3b0
[12240.205972]  worker_thread+0x21f/0x330
[12240.205975]  ? __pfx_worker_thread+0x10/0x10
[12240.205977]  kthread+0xcd/0x100
[12240.205980]  ? __pfx_kthread+0x10/0x10
[12240.205982]  ret_from_fork+0x31/0x50
[12240.205985]  ? __pfx_kthread+0x10/0x10
[12240.205987]  ret_from_fork_asm+0x1a/0x30
[12240.205992]  </TASK>
[12240.205993] task:kworker/u132:19 state:D stack:0     pid:2146  =
tgid:2146  ppid:2      flags:0x00004000
[12240.205996] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.205998] Call Trace:
[12240.205999]  <TASK>
[12240.206001]  __schedule+0x425/0x1460
[12240.206007]  schedule+0x27/0xf0
[12240.206009]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206015]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206018]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206022]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206028]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206030]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206033]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206035]  ? bio_split_rw+0x141/0x2a0
[12240.206040]  md_handle_request+0x153/0x270 [md_mod]
[12240.206046]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206050]  __submit_bio+0x190/0x240
[12240.206053]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206057]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206059]  ? submit_bio_noacct+0x47/0x5b0
[12240.206062]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206065]  process_one_work+0x18f/0x3b0
[12240.206068]  worker_thread+0x21f/0x330
[12240.206071]  ? __pfx_worker_thread+0x10/0x10
[12240.206073]  kthread+0xcd/0x100
[12240.206075]  ? __pfx_kthread+0x10/0x10
[12240.206078]  ret_from_fork+0x31/0x50
[12240.206080]  ? __pfx_kthread+0x10/0x10
[12240.206083]  ret_from_fork_asm+0x1a/0x30
[12240.206087]  </TASK>
[12240.206089] task:kworker/u132:20 state:D stack:0     pid:2147  =
tgid:2147  ppid:2      flags:0x00004000
[12240.206091] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206094] Call Trace:
[12240.206095]  <TASK>
[12240.206097]  __schedule+0x425/0x1460
[12240.206102]  schedule+0x27/0xf0
[12240.206105]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206110]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206113]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206118]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206123]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206126]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206128]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206131]  ? bio_split_rw+0x141/0x2a0
[12240.206136]  md_handle_request+0x153/0x270 [md_mod]
[12240.206142]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206145]  __submit_bio+0x190/0x240
[12240.206149]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206152]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206155]  ? submit_bio_noacct+0x47/0x5b0
[12240.206158]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206161]  process_one_work+0x18f/0x3b0
[12240.206163]  worker_thread+0x21f/0x330
[12240.206166]  ? __pfx_worker_thread+0x10/0x10
[12240.206168]  kthread+0xcd/0x100
[12240.206171]  ? __pfx_kthread+0x10/0x10
[12240.206173]  ret_from_fork+0x31/0x50
[12240.206175]  ? __pfx_kthread+0x10/0x10
[12240.206178]  ret_from_fork_asm+0x1a/0x30
[12240.206182]  </TASK>
[12240.206184] task:kworker/u132:22 state:D stack:0     pid:2149  =
tgid:2149  ppid:2      flags:0x00004000
[12240.206187] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206189] Call Trace:
[12240.206190]  <TASK>
[12240.206192]  __schedule+0x425/0x1460
[12240.206197]  schedule+0x27/0xf0
[12240.206199]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206205]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206208]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206213]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206218]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206220]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206223]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206226]  ? bio_split_rw+0x141/0x2a0
[12240.206230]  md_handle_request+0x153/0x270 [md_mod]
[12240.206236]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206240]  __submit_bio+0x190/0x240
[12240.206243]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206246]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206249]  ? submit_bio_noacct+0x47/0x5b0
[12240.206252]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206255]  process_one_work+0x18f/0x3b0
[12240.206258]  worker_thread+0x21f/0x330
[12240.206260]  ? __pfx_worker_thread+0x10/0x10
[12240.206262]  kthread+0xcd/0x100
[12240.206265]  ? __pfx_kthread+0x10/0x10
[12240.206268]  ret_from_fork+0x31/0x50
[12240.206270]  ? __pfx_kthread+0x10/0x10
[12240.206272]  ret_from_fork_asm+0x1a/0x30
[12240.206277]  </TASK>
[12240.206279] task:kworker/u132:24 state:D stack:0     pid:2151  =
tgid:2151  ppid:2      flags:0x00004000
[12240.206281] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206284] Call Trace:
[12240.206284]  <TASK>
[12240.206286]  __schedule+0x425/0x1460
[12240.206289]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206294]  schedule+0x27/0xf0
[12240.206296]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206302]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206305]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206310]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206315]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206318]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206320]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206323]  ? bio_split_rw+0x141/0x2a0
[12240.206327]  md_handle_request+0x153/0x270 [md_mod]
[12240.206333]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206336]  __submit_bio+0x190/0x240
[12240.206340]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206344]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206346]  ? submit_bio_noacct+0x47/0x5b0
[12240.206349]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206352]  process_one_work+0x18f/0x3b0
[12240.206355]  worker_thread+0x21f/0x330
[12240.206357]  ? __pfx_worker_thread+0x10/0x10
[12240.206359]  kthread+0xcd/0x100
[12240.206362]  ? __pfx_kthread+0x10/0x10
[12240.206365]  ret_from_fork+0x31/0x50
[12240.206367]  ? __pfx_kthread+0x10/0x10
[12240.206370]  ret_from_fork_asm+0x1a/0x30
[12240.206374]  </TASK>
[12240.206376] task:kworker/u132:25 state:D stack:0     pid:2152  =
tgid:2152  ppid:2      flags:0x00004000
[12240.206379] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206381] Call Trace:
[12240.206382]  <TASK>
[12240.206384]  __schedule+0x425/0x1460
[12240.206389]  schedule+0x27/0xf0
[12240.206391]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206397]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206400]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206405]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206410]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206412]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206415]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206418]  ? bio_split_rw+0x141/0x2a0
[12240.206422]  md_handle_request+0x153/0x270 [md_mod]
[12240.206428]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206432]  __submit_bio+0x190/0x240
[12240.206436]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206438]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206441]  ? submit_bio_noacct+0x47/0x5b0
[12240.206444]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206447]  process_one_work+0x18f/0x3b0
[12240.206450]  worker_thread+0x21f/0x330
[12240.206452]  ? __pfx_worker_thread+0x10/0x10
[12240.206454]  kthread+0xcd/0x100
[12240.206457]  ? __pfx_kthread+0x10/0x10
[12240.206460]  ret_from_fork+0x31/0x50
[12240.206462]  ? __pfx_kthread+0x10/0x10
[12240.206464]  ret_from_fork_asm+0x1a/0x30
[12240.206469]  </TASK>
[12240.206470] task:kworker/u132:26 state:D stack:0     pid:2153  =
tgid:2153  ppid:2      flags:0x00004000
[12240.206473] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206475] Call Trace:
[12240.206476]  <TASK>
[12240.206479]  __schedule+0x425/0x1460
[12240.206484]  schedule+0x27/0xf0
[12240.206486]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206492]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206495]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206499]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206504]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206507]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206510]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206512]  ? bio_split_rw+0x141/0x2a0
[12240.206517]  md_handle_request+0x153/0x270 [md_mod]
[12240.206523]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206526]  __submit_bio+0x190/0x240
[12240.206530]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206533]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206536]  ? submit_bio_noacct+0x47/0x5b0
[12240.206539]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206541]  process_one_work+0x18f/0x3b0
[12240.206544]  worker_thread+0x21f/0x330
[12240.206547]  ? __pfx_worker_thread+0x10/0x10
[12240.206549]  kthread+0xcd/0x100
[12240.206551]  ? __pfx_kthread+0x10/0x10
[12240.206554]  ret_from_fork+0x31/0x50
[12240.206556]  ? __pfx_kthread+0x10/0x10
[12240.206559]  ret_from_fork_asm+0x1a/0x30
[12240.206563]  </TASK>
[12240.206565] task:kworker/u132:27 state:D stack:0     pid:2154  =
tgid:2154  ppid:2      flags:0x00004000
[12240.206567] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206570] Call Trace:
[12240.206570]  <TASK>
[12240.206572]  __schedule+0x425/0x1460
[12240.206575]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206580]  schedule+0x27/0xf0
[12240.206582]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206588]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206590]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206595]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206600]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206603]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206605]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206608]  ? bio_split_rw+0x141/0x2a0
[12240.206613]  md_handle_request+0x153/0x270 [md_mod]
[12240.206619]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206622]  __submit_bio+0x190/0x240
[12240.206626]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206629]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206631]  ? submit_bio_noacct+0x47/0x5b0
[12240.206635]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206638]  process_one_work+0x18f/0x3b0
[12240.206640]  worker_thread+0x21f/0x330
[12240.206643]  ? __pfx_worker_thread+0x10/0x10
[12240.206645]  kthread+0xcd/0x100
[12240.206647]  ? __pfx_kthread+0x10/0x10
[12240.206650]  ret_from_fork+0x31/0x50
[12240.206652]  ? __pfx_kthread+0x10/0x10
[12240.206655]  ret_from_fork_asm+0x1a/0x30
[12240.206659]  </TASK>
[12240.206661] task:kworker/u132:28 state:D stack:0     pid:2155  =
tgid:2155  ppid:2      flags:0x00004000
[12240.206663] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206666] Call Trace:
[12240.206667]  <TASK>
[12240.206668]  __schedule+0x425/0x1460
[12240.206673]  schedule+0x27/0xf0
[12240.206676]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206681]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206684]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206689]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206694]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206697]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206699]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206702]  ? bio_split_rw+0x141/0x2a0
[12240.206707]  md_handle_request+0x153/0x270 [md_mod]
[12240.206713]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206716]  __submit_bio+0x190/0x240
[12240.206720]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206722]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206725]  ? submit_bio_noacct+0x47/0x5b0
[12240.206728]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206731]  process_one_work+0x18f/0x3b0
[12240.206734]  worker_thread+0x21f/0x330
[12240.206736]  ? __pfx_worker_thread+0x10/0x10
[12240.206738]  kthread+0xcd/0x100
[12240.206741]  ? __pfx_kthread+0x10/0x10
[12240.206744]  ret_from_fork+0x31/0x50
[12240.206746]  ? __pfx_kthread+0x10/0x10
[12240.206748]  ret_from_fork_asm+0x1a/0x30
[12240.206753]  </TASK>
[12240.206754] task:kworker/u132:30 state:D stack:0     pid:2157  =
tgid:2157  ppid:2      flags:0x00004000
[12240.206756] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206759] Call Trace:
[12240.206760]  <TASK>
[12240.206762]  __schedule+0x425/0x1460
[12240.206767]  schedule+0x27/0xf0
[12240.206769]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206775]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206778]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206783]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206793]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206796]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206798]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206801]  ? bio_split_rw+0x141/0x2a0
[12240.206806]  md_handle_request+0x153/0x270 [md_mod]
[12240.206813]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206816]  __submit_bio+0x190/0x240
[12240.206821]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206824]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206826]  ? submit_bio_noacct+0x47/0x5b0
[12240.206829]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206833]  process_one_work+0x18f/0x3b0
[12240.206836]  worker_thread+0x21f/0x330
[12240.206838]  ? __pfx_worker_thread+0x10/0x10
[12240.206840]  kthread+0xcd/0x100
[12240.206843]  ? __pfx_kthread+0x10/0x10
[12240.206845]  ret_from_fork+0x31/0x50
[12240.206848]  ? __pfx_kthread+0x10/0x10
[12240.206850]  ret_from_fork_asm+0x1a/0x30
[12240.206854]  </TASK>
[12240.206898] task:kworker/u132:34 state:D stack:0     pid:3394  =
tgid:3394  ppid:2      flags:0x00004000
[12240.206901] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.206904] Call Trace:
[12240.206905]  <TASK>
[12240.206907]  __schedule+0x425/0x1460
[12240.206910]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206912]  ? raid5_bio_lowest_chunk_sector+0x65/0xe0 [raid456]
[12240.206918]  schedule+0x27/0xf0
[12240.206921]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.206926]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.206929]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.206934]  raid5_make_request+0x364/0x1290 [raid456]
[12240.206939]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206942]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.206945]  ? __pfx_woken_wake_function+0x10/0x10
[12240.206947]  ? bio_split_rw+0x141/0x2a0
[12240.206952]  md_handle_request+0x153/0x270 [md_mod]
[12240.206958]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206961]  __submit_bio+0x190/0x240
[12240.206965]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.206968]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.206971]  ? submit_bio_noacct+0x47/0x5b0
[12240.206974]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.206977]  process_one_work+0x18f/0x3b0
[12240.206979]  worker_thread+0x21f/0x330
[12240.206982]  ? __pfx_worker_thread+0x10/0x10
[12240.206984]  ? __pfx_worker_thread+0x10/0x10
[12240.206986]  kthread+0xcd/0x100
[12240.206988]  ? __pfx_kthread+0x10/0x10
[12240.206991]  ret_from_fork+0x31/0x50
[12240.206994]  ? __pfx_kthread+0x10/0x10
[12240.206996]  ret_from_fork_asm+0x1a/0x30
[12240.207000]  </TASK>
[12240.207002] task:kworker/u132:33 state:D stack:0     pid:5300  =
tgid:5300  ppid:2      flags:0x00004000
[12240.207005] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.207008] Call Trace:
[12240.207009]  <TASK>
[12240.207010]  __schedule+0x425/0x1460
[12240.207015]  schedule+0x27/0xf0
[12240.207018]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.207024]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.207027]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.207032]  raid5_make_request+0x364/0x1290 [raid456]
[12240.207037]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207040]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.207042]  ? __pfx_woken_wake_function+0x10/0x10
[12240.207045]  ? bio_split_rw+0x141/0x2a0
[12240.207050]  md_handle_request+0x153/0x270 [md_mod]
[12240.207056]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207059]  __submit_bio+0x190/0x240
[12240.207063]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.207066]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207068]  ? submit_bio_noacct+0x47/0x5b0
[12240.207071]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.207074]  process_one_work+0x18f/0x3b0
[12240.207077]  worker_thread+0x21f/0x330
[12240.207080]  ? __pfx_worker_thread+0x10/0x10
[12240.207082]  kthread+0xcd/0x100
[12240.207084]  ? __pfx_kthread+0x10/0x10
[12240.207087]  ret_from_fork+0x31/0x50
[12240.207089]  ? __pfx_kthread+0x10/0x10
[12240.207092]  ret_from_fork_asm+0x1a/0x30
[12240.207096]  </TASK>
[12240.207098] task:kworker/u132:35 state:D stack:0     pid:6467  =
tgid:6467  ppid:2      flags:0x00004000
[12240.207100] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.207103] Call Trace:
[12240.207104]  <TASK>
[12240.207105]  __schedule+0x425/0x1460
[12240.207111]  schedule+0x27/0xf0
[12240.207113]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.207119]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.207122]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.207126]  raid5_make_request+0x364/0x1290 [raid456]
[12240.207131]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207134]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.207137]  ? __pfx_woken_wake_function+0x10/0x10
[12240.207139]  ? bio_split_rw+0x141/0x2a0
[12240.207144]  md_handle_request+0x153/0x270 [md_mod]
[12240.207150]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207153]  __submit_bio+0x190/0x240
[12240.207157]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.207160]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207163]  ? submit_bio_noacct+0x47/0x5b0
[12240.207166]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.207169]  process_one_work+0x18f/0x3b0
[12240.207172]  worker_thread+0x21f/0x330
[12240.207174]  ? __pfx_worker_thread+0x10/0x10
[12240.207176]  ? __pfx_worker_thread+0x10/0x10
[12240.207178]  kthread+0xcd/0x100
[12240.207180]  ? __pfx_kthread+0x10/0x10
[12240.207184]  ret_from_fork+0x31/0x50
[12240.207186]  ? __pfx_kthread+0x10/0x10
[12240.207188]  ret_from_fork_asm+0x1a/0x30
[12240.207193]  </TASK>
[12240.207194] task:kworker/u132:13 state:D stack:0     pid:9685  =
tgid:9685  ppid:2      flags:0x00004000
[12240.207197] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.207199] Call Trace:
[12240.207201]  <TASK>
[12240.207202]  __schedule+0x425/0x1460
[12240.207207]  schedule+0x27/0xf0
[12240.207210]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.207215]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.207218]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.207223]  raid5_make_request+0x364/0x1290 [raid456]
[12240.207228]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207231]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.207233]  ? __pfx_woken_wake_function+0x10/0x10
[12240.207236]  ? bio_split_rw+0x141/0x2a0
[12240.207241]  md_handle_request+0x153/0x270 [md_mod]
[12240.207247]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207250]  __submit_bio+0x190/0x240
[12240.207254]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.207257]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207260]  ? submit_bio_noacct+0x47/0x5b0
[12240.207263]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.207266]  process_one_work+0x18f/0x3b0
[12240.207269]  worker_thread+0x21f/0x330
[12240.207270]  ? __pfx_worker_thread+0x10/0x10
[12240.207273]  ? __pfx_worker_thread+0x10/0x10
[12240.207275]  kthread+0xcd/0x100
[12240.207277]  ? __pfx_kthread+0x10/0x10
[12240.207280]  ret_from_fork+0x31/0x50
[12240.207282]  ? __pfx_kthread+0x10/0x10
[12240.207285]  ret_from_fork_asm+0x1a/0x30
[12240.207289]  </TASK>
[12240.207291] task:kworker/0:0     state:D stack:0     pid:9924  =
tgid:9924  ppid:2      flags:0x00004000
[12240.207294] Workqueue: xfs-sync/dm-4 xfs_log_worker [xfs]
[12240.207366] Call Trace:
[12240.207368]  <TASK>
[12240.207370]  __schedule+0x425/0x1460
[12240.207373]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207377]  schedule+0x27/0xf0
[12240.207380]  schedule_timeout+0x15d/0x170
[12240.207384]  __wait_for_common+0x90/0x1c0
[12240.207386]  ? __pfx_schedule_timeout+0x10/0x10
[12240.207390]  __flush_workqueue+0x158/0x440
[12240.207392]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207397]  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
[12240.207449]  xlog_cil_force_seq+0x69/0x240 [xfs]
[12240.207499]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207502]  ? __schedule+0x42d/0x1460
[12240.207506]  xfs_log_force+0x7a/0x230 [xfs]
[12240.207556]  xfs_log_worker+0x3d/0xc0 [xfs]
[12240.207605]  process_one_work+0x18f/0x3b0
[12240.207608]  worker_thread+0x21f/0x330
[12240.207610]  ? __pfx_worker_thread+0x10/0x10
[12240.207612]  ? __pfx_worker_thread+0x10/0x10
[12240.207615]  kthread+0xcd/0x100
[12240.207617]  ? __pfx_kthread+0x10/0x10
[12240.207620]  ret_from_fork+0x31/0x50
[12240.207623]  ? __pfx_kthread+0x10/0x10
[12240.207625]  ret_from_fork_asm+0x1a/0x30
[12240.207630]  </TASK>
[12240.207632] task:kworker/u132:23 state:D stack:0     pid:11661 =
tgid:11661 ppid:2      flags:0x00004000
[12240.207635] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.207638] Call Trace:
[12240.207639]  <TASK>
[12240.207641]  __schedule+0x425/0x1460
[12240.207646]  schedule+0x27/0xf0
[12240.207649]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.207656]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.207659]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.207664]  raid5_make_request+0x364/0x1290 [raid456]
[12240.207669]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207672]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.207675]  ? __pfx_woken_wake_function+0x10/0x10
[12240.207677]  ? bio_split_rw+0x141/0x2a0
[12240.207682]  md_handle_request+0x153/0x270 [md_mod]
[12240.207689]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207692]  __submit_bio+0x190/0x240
[12240.207696]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.207700]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207702]  ? submit_bio_noacct+0x47/0x5b0
[12240.207705]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.207708]  process_one_work+0x18f/0x3b0
[12240.207711]  worker_thread+0x21f/0x330
[12240.207713]  ? __pfx_worker_thread+0x10/0x10
[12240.207716]  ? __pfx_worker_thread+0x10/0x10
[12240.207718]  kthread+0xcd/0x100
[12240.207720]  ? __pfx_kthread+0x10/0x10
[12240.207723]  ret_from_fork+0x31/0x50
[12240.207725]  ? __pfx_kthread+0x10/0x10
[12240.207728]  ret_from_fork_asm+0x1a/0x30
[12240.207732]  </TASK>
[12240.207735] task:kworker/u132:10 state:D stack:0     pid:14188 =
tgid:14188 ppid:2      flags:0x00004000
[12240.207738] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.207741] Call Trace:
[12240.207742]  <TASK>
[12240.207744]  __schedule+0x425/0x1460
[12240.207749]  schedule+0x27/0xf0
[12240.207751]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.207757]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.207760]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.207765]  raid5_make_request+0x364/0x1290 [raid456]
[12240.207770]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207772]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.207775]  ? __pfx_woken_wake_function+0x10/0x10
[12240.207778]  ? bio_split_rw+0x141/0x2a0
[12240.207783]  md_handle_request+0x153/0x270 [md_mod]
[12240.207794]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207797]  __submit_bio+0x190/0x240
[12240.207801]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.207804]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207806]  ? submit_bio_noacct+0x47/0x5b0
[12240.207809]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.207813]  process_one_work+0x18f/0x3b0
[12240.207816]  worker_thread+0x21f/0x330
[12240.207817]  ? __pfx_worker_thread+0x10/0x10
[12240.207820]  ? __pfx_worker_thread+0x10/0x10
[12240.207822]  kthread+0xcd/0x100
[12240.207824]  ? __pfx_kthread+0x10/0x10
[12240.207827]  ret_from_fork+0x31/0x50
[12240.207829]  ? __pfx_kthread+0x10/0x10
[12240.207832]  ret_from_fork_asm+0x1a/0x30
[12240.207836]  </TASK>
[12240.207838] task:kworker/u132:21 state:D stack:0     pid:15639 =
tgid:15639 ppid:2      flags:0x00004000
[12240.207841] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.207843] Call Trace:
[12240.207844]  <TASK>
[12240.207846]  __schedule+0x425/0x1460
[12240.207848]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207853]  schedule+0x27/0xf0
[12240.207856]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.207862]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.207864]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.207869]  raid5_make_request+0x364/0x1290 [raid456]
[12240.207874]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207877]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.207879]  ? __pfx_woken_wake_function+0x10/0x10
[12240.207882]  ? bio_split_rw+0x141/0x2a0
[12240.207887]  md_handle_request+0x153/0x270 [md_mod]
[12240.207892]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207895]  __submit_bio+0x190/0x240
[12240.207899]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.207903]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.207905]  ? submit_bio_noacct+0x47/0x5b0
[12240.207908]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.207911]  process_one_work+0x18f/0x3b0
[12240.207914]  worker_thread+0x21f/0x330
[12240.207916]  ? __pfx_worker_thread+0x10/0x10
[12240.207918]  ? __pfx_worker_thread+0x10/0x10
[12240.207920]  kthread+0xcd/0x100
[12240.207922]  ? __pfx_kthread+0x10/0x10
[12240.207925]  ret_from_fork+0x31/0x50
[12240.207927]  ? __pfx_kthread+0x10/0x10
[12240.207930]  ret_from_fork_asm+0x1a/0x30
[12240.207934]  </TASK>
[12240.207942] task:rsync           state:D stack:0     pid:21424 =
tgid:21424 ppid:21415  flags:0x00000000
[12240.207945] Call Trace:
[12240.207946]  <TASK>
[12240.207948]  __schedule+0x425/0x1460
[12240.207950]  ? blk_mq_flush_plug_list.part.0+0x4a7/0x5a0
[12240.207956]  schedule+0x27/0xf0
[12240.207958]  schedule_timeout+0x15d/0x170
[12240.207962]  __wait_for_common+0x90/0x1c0
[12240.207964]  ? __pfx_schedule_timeout+0x10/0x10
[12240.207968]  xfs_buf_iowait+0x1c/0xc0 [xfs]
[12240.208035]  __xfs_buf_submit+0x132/0x1e0 [xfs]
[12240.208086]  xfs_buf_read_map+0x129/0x2a0 [xfs]
[12240.208136]  ? xfs_da_read_buf+0x106/0x180 [xfs]
[12240.208207]  xfs_trans_read_buf_map+0x12e/0x310 [xfs]
[12240.208275]  ? xfs_da_read_buf+0x106/0x180 [xfs]
[12240.208335]  xfs_da_read_buf+0x106/0x180 [xfs]
[12240.208387]  __xfs_dir3_free_read+0x34/0x1a0 [xfs]
[12240.208449]  xfs_dir2_node_addname+0x4ba/0xa30 [xfs]
[12240.208500]  ? xfs_bmap_last_offset+0x98/0x140 [xfs]
[12240.208565]  xfs_dir_createname+0x129/0x160 [xfs]
[12240.208621]  ? xfs_trans_ichgtime+0x2f/0x90 [xfs]
[12240.208688]  xfs_dir_create_child+0x6a/0x150 [xfs]
[12240.208743]  ? xfs_diflags_to_iflags+0x12/0x50 [xfs]
[12240.208815]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.208819]  ? xfs_setup_inode+0x52/0x110 [xfs]
[12240.208869]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.208873]  xfs_create+0x3b3/0x490 [xfs]
[12240.208929]  xfs_generic_create+0x312/0x370 [xfs]
[12240.208981]  path_openat+0xf54/0x1210
[12240.208988]  do_filp_open+0xc4/0x170
[12240.208994]  do_sys_openat2+0xab/0xe0
[12240.208999]  __x64_sys_openat+0x57/0xa0
[12240.209002]  do_syscall_64+0xb7/0x200
[12240.209006]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[12240.209010] RIP: 0033:0x7f7c3a92be2f
[12240.209013] RSP: 002b:00007ffc2513e470 EFLAGS: 00000246 ORIG_RAX: =
0000000000000101
[12240.209015] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: =
00007f7c3a92be2f
[12240.209017] RDX: 00000000000000c2 RSI: 00007ffc25140740 RDI: =
00000000ffffff9c
[12240.209018] RBP: 000000000003a2f8 R08: 002123761d6309f6 R09: =
00007ffc2513e6ac
[12240.209019] R10: 0000000000000180 R11: 0000000000000246 R12: =
00007ffc25140789
[12240.209021] R13: 00007ffc25140740 R14: 8421084210842109 R15: =
00007f7c3a9c6a80
[12240.209025]  </TASK>
[12240.209027] task:kworker/u132:6  state:D stack:0     pid:23378 =
tgid:23378 ppid:2      flags:0x00004000
[12240.209030] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.209034] Call Trace:
[12240.209035]  <TASK>
[12240.209036]  __schedule+0x425/0x1460
[12240.209040]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.209042]  ? raid5_bio_lowest_chunk_sector+0x65/0xe0 [raid456]
[12240.209049]  schedule+0x27/0xf0
[12240.209052]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.209058]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.209062]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.209067]  raid5_make_request+0x364/0x1290 [raid456]
[12240.209072]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.209075]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.209077]  ? __pfx_woken_wake_function+0x10/0x10
[12240.209080]  ? bio_split_rw+0x141/0x2a0
[12240.209085]  md_handle_request+0x153/0x270 [md_mod]
[12240.209092]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.209095]  __submit_bio+0x190/0x240
[12240.209099]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.209102]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.209104]  ? submit_bio_noacct+0x47/0x5b0
[12240.209108]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.209111]  process_one_work+0x18f/0x3b0
[12240.209114]  worker_thread+0x21f/0x330
[12240.209115]  ? __pfx_worker_thread+0x10/0x10
[12240.209118]  ? __pfx_worker_thread+0x10/0x10
[12240.209120]  kthread+0xcd/0x100
[12240.209123]  ? __pfx_kthread+0x10/0x10
[12240.209125]  ret_from_fork+0x31/0x50
[12240.209128]  ? __pfx_kthread+0x10/0x10
[12240.209130]  ret_from_fork_asm+0x1a/0x30
[12240.209135]  </TASK>
[12240.209137] task:kworker/u132:29 state:D stack:0     pid:24814 =
tgid:24814 ppid:2      flags:0x00004000
[12240.209140] Workqueue: kcryptd-254:4-1 kcryptd_crypt [dm_crypt]
[12240.209143] Call Trace:
[12240.209144]  <TASK>
[12240.209146]  __schedule+0x425/0x1460
[12240.209151]  schedule+0x27/0xf0
[12240.209154]  md_bitmap_startwrite+0x14f/0x1c0 [md_mod]
[12240.209159]  ? __pfx_autoremove_wake_function+0x10/0x10
[12240.209163]  __add_stripe_bio+0x1f4/0x240 [raid456]
[12240.209167]  raid5_make_request+0x364/0x1290 [raid456]
[12240.209172]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.209175]  ? submit_bio_noacct_nocheck+0x276/0x3c0
[12240.209178]  ? __pfx_woken_wake_function+0x10/0x10
[12240.209180]  ? bio_split_rw+0x141/0x2a0
[12240.209185]  md_handle_request+0x153/0x270 [md_mod]
[12240.209191]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.209194]  __submit_bio+0x190/0x240
[12240.209198]  submit_bio_noacct_nocheck+0x19a/0x3c0
[12240.209201]  ? srso_alias_return_thunk+0x5/0xfbef5
[12240.209204]  ? submit_bio_noacct+0x47/0x5b0
[12240.209207]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
[12240.209210]  process_one_work+0x18f/0x3b0
[12240.209213]  worker_thread+0x21f/0x330
[12240.209215]  ? __pfx_worker_thread+0x10/0x10
[12240.209217]  ? __pfx_worker_thread+0x10/0x10
[12240.209219]  kthread+0xcd/0x100
[12240.209222]  ? __pfx_kthread+0x10/0x10
[12240.209224]  ret_from_fork+0x31/0x50
[12240.209227]  ? __pfx_kthread+0x10/0x10
[12240.209229]  ret_from_fork_asm+0x1a/0x30
[12240.209233]  </TASK>


> On 4. Nov 2024, at 15:45, Christian Theune <ct@flyingcircus.io> wrote:
>=20
> Hi
>=20
>> On 4. Nov 2024, at 13:18, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>=20
>>=20
>> I think I found a problem by code review, can you test the following
>> patch? (Noted this is still from latest mainline).
>=20
> Thanks - I can try that. I think I got the gist of it and adapted it =
to 6.11.6:
> https://github.com/flyingcircusio/linux-stable/pull/2/files
>=20
> (I=E2=80=99m not properly tooled to apply embedded patches from the =
mailing lists, I need to improve my toolchain if I have to deep dive =
this far more often in the future.)
>=20
> Liebe Gr=C3=BC=C3=9Fe,
> Christian Theune
>=20
> --=20
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>=20

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

