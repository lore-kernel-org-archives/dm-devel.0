Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0993D2D605
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c/hoiW1D";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="yDBP36/8";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JKd1fh2c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698216215;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=OlqCjbkpcUOAOmF7DULi44B63Wou7MPq7ZVGdSPexCM=;
	b=c/hoiW1DkjthRIVxh4R91Po2ZGaiBfHPBtiDiF/AeZg9REyA7AvhUX+SO+P/AEr7755d0z
	6oHqX2D4dpSJcZXlnrkv/Uz1CVAH7G1HTircLgVrMvYnWcDmek+iSB4WTsEjroIG0sc3ac
	kRy3GGE8evZYh7qyov7uybq6P9EUCwM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-176-27TugraxPY2eJmUMml_RGQ-1; Wed,
 25 Oct 2023 02:43:33 -0400
X-MC-Unique: 27TugraxPY2eJmUMml_RGQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 509A53C0BE43
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:43:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45F36492BFB
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:43:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F08321946595
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:43:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 204C51946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 Oct 2023 03:22:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F14FE143; Wed, 25 Oct 2023 03:22:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA27E134
 for <dm-devel@redhat.com>; Wed, 25 Oct 2023 03:22:10 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4D712825E82
 for <dm-devel@redhat.com>; Wed, 25 Oct 2023 03:22:10 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com
 [66.111.4.26]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-EUR8nHcuNTy1cDjOsoibyw-1; Tue, 24 Oct 2023 23:22:07 -0400
X-MC-Unique: EUR8nHcuNTy1cDjOsoibyw-1
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
 by mailout.nyi.internal (Postfix) with ESMTP id 2821F5C0276;
 Tue, 24 Oct 2023 23:22:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute3.internal (MEProxy); Tue, 24 Oct 2023 23:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:content-type:date
 :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
 :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
 1698204127; x=1698290527; bh=OlqCjbkpcUOAOmF7DULi44B63Wou7MPq7ZV
 GdSPexCM=; b=yDBP36/83+RMR8YOgAplRIqotPSW7Jr1xLhbBEh0fio7kelZ9JH
 wl5KiDYA/1ZSaiIcmFVlXHVdsZXLDNc6CH4qKMfhtHtU0I/dNEs9+sG1IjdRFi8B
 nn9JUwdAMLR73Uul7AVZ6Fw3JsKES845rnuDbWD07Sa2U04wgAossFZp9zYDHjOu
 Qaitk1TPrlOlRChgulB1OCRanVMYMBnByOybBkFdBFzwWLFE8XhoxfBbXj/1EuzU
 fOkgyoG5ZiY2hVGvWQSQdC/nzMMOv8D8x+Ef7VQrlqqOLxH2auoi0DzU9BChV+VD
 9CQux4xJ3p46lHsRBlW/fniMEt9ZAKQc0tQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:content-type:date:date
 :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm3; t=1698204127; x=1698290527; bh=OlqCjbkpcUOAO
 mF7DULi44B63Wou7MPq7ZVGdSPexCM=; b=JKd1fh2cE7DX856SyZG4akF5cJfiJ
 IwPz9r3pkxQR+h4YE0Oye8ygZ9TGSdbJTp1pJvLj/T6YoPlUhuYK1HiILyGmRmD1
 SYDq4vXcIMdDSa+OCP2TYzhJGGbeT3dkTxnbCXtMVfEeX8rNuJGavVaptV7HUV4j
 KL49G98GSq4ridCuCVQ4k5dymPTZiWryHINjAs9rEScGuc00torxClse7LtQj16H
 lGFesR7tShB991MxBK840uibbJDFqVG5DYstg8G/gDe9Vv64mHrYLIwIzr14hj7K
 LPq6q1QciVz/OennUht2bLUl26bFWhgFZSQV5AnoSekINnYC71HcnPKsg==
X-ME-Sender: <xms:34k4ZXFXN5snppNrE-hSWWv4UMnnxcQbwBe3dlwa-Vs30_oEqxPN4w>
 <xme:34k4ZUXdQbHVZcLM7qGFPg8T-SPLpc-USM_cYdJsM1EO9E_AbTaI9iuy52z8efxJ7
 yKyVipEEz5vCw>
X-ME-Received: <xmr:34k4ZZKM024KQTtOt5NsaTzI7tXoPZet2HGveNMEeLYHlhCN9ypO54vxMEmHzuKUnZ6RLIZYmuRJKoj5GCnpPzIc7ew1Ppl5VC8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeelgdejtdcutefuodetggdotefrodftvf
 curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
 uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
 fjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
 ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
 hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeevieel
 tdelheeiueelvdfgleekledvhfefueetveeiffetgeejudevfeeigfffgfenucffohhmrg
 hinheprhgvughhrghtrdgtohhmpdhgihhthhhusgdrtghomhenucevlhhushhtvghrufhi
 iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhish
 hisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:34k4ZVFy2bed2KlBhqUGSlBL3pjJZ4eqVvlhdKE2NSk9m92a7w4LBQ>
 <xmx:34k4ZdU2OoGINUHDu6FmGg86teuvRA1sozz8Z16OyN-igswL-yWSOw>
 <xmx:34k4ZQNTTxZd6zl-geq6sBfhRJc-UR097NDRoXiL6W9pVtcpLKiM5Q>
 <xmx:34k4ZQT23-bGYMAugqeM-aWd6huJ57pW4W8kDqxVOO8QIuInxooCaw>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Oct 2023 23:22:05 -0400 (EDT)
Date: Wed, 25 Oct 2023 05:22:03 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZTiJ3CO8w0jauOzW@mail-itl>
References: <ZTNH0qtmint/zLJZ@mail-itl>
 <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com>
 <ZTiHQDY54E7WAld+@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="QBmfba23+tgBfLjb"
Content-Disposition: inline
In-Reply-To: <ZTiHQDY54E7WAld+@mail-itl>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 25 Oct 2023 06:43:31 +0000
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, regressions@lists.linux.dev,
 stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10


--QBmfba23+tgBfLjb
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Oct 2023 05:22:03 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@redhat.com
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Wed, Oct 25, 2023 at 05:10:56AM +0200, Marek Marczykowski-G=C3=B3recki w=
rote:
> On Mon, Oct 23, 2023 at 10:59:40PM +0200, Mikulas Patocka wrote:
> > Hi
> >=20
> > It's hard to say what causes this. Perhaps dm-crypt exhausts all the=20
> > higher-order pages and some subsystem stalls because of it.
> >=20
> > In drivers/md/dm-crypt.c in function crypt_alloc_buffer there is
> > "unsigned int order =3D MAX_ORDER - 1"
> >=20
> > What happens if you set the "order" variable to some small value, like =
1,=20
> > 2 or 3. Does the problem go away? Could you find a threshold value=20
> > (something between 0 and MAX_ORDER-1) where the bug starts to appear?
>=20
> With 3 and lower it seems to work, with 4 it freezes. My test is not
> 100% reproducible, but I've repeated it a few times and got rather
> consistent results on this system (i3-1315U, NVMe).
>=20
> BTW, when trying on a much older system (Thinkpad P52 with i7-8750H) I
> couldn't reproduce the issue at all. But OTOH, I hit it once on a system
> with i7-7600U and otherwise similar specs but much different workload
> (several more VMs accessing the data). I'm not sure if that info helps
> at all...
>=20
> >=20
> > What happens if you replace
> > "pages =3D alloc_pages(gfp_mask"
> > with
> > "pages =3D alloc_pages((gfp_mask & ~__GFP_KSWAPD_RECLAIM)"
> > ? Does the bug go away?
>=20
> In a limited test, with order restored to MAX_ORDER - 1, no, still got
> the issue, and got this via sysrq (just one task listed):
>=20
> [  516.375254] sysrq: Show Blocked State
> [  516.375461] task:dd              state:D stack:13072 pid:4385  ppid:43=
71   flags:0x00004002
> [  516.375496] Call Trace:
> [  516.375507]  <TASK>
> [  516.375518]  __schedule+0x30e/0x8b0
> [  516.375549]  schedule+0x59/0xb0
> [  516.375566]  io_schedule+0x41/0x70
> [  516.375582]  folio_wait_bit_common+0x12c/0x300
> [  516.375603]  ? __pfx_wake_page_function+0x10/0x10
> [  516.375623]  folio_wait_writeback+0x27/0x80
> [  516.375639]  __filemap_fdatawait_range+0x7b/0xe0
> [  516.375656]  file_write_and_wait_range+0x86/0xb0
> [  516.375672]  blkdev_fsync+0x33/0x60
> [  516.375693]  __x64_sys_fdatasync+0x4a/0x90
> [  516.375713]  do_syscall_64+0x3c/0x90
> [  516.375729]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> [  516.375751] RIP: 0033:0x7fd718562da4
> [  516.375764] RSP: 002b:00007ffea3815278 EFLAGS: 00000202 ORIG_RAX: 0000=
00000000004b
> [  516.375784] RAX: ffffffffffffffda RBX: 0000000000015200 RCX: 00007fd71=
8562da4
> [  516.375801] RDX: 0000000000028000 RSI: 0000000000000000 RDI: 000000000=
0000001
> [  516.375817] RBP: 00007fd71845e6c0 R08: 00000000ffffffff R09: 000000000=
0000000
> [  516.375833] R10: 0000000000000022 R11: 0000000000000202 R12: 000000000=
0000000
> [  516.375848] R13: 0000000000000000 R14: 0000000000028000 R15: 000000000=
0000000
> [  516.375865]  </TASK>
>=20
> (it is dd writing to LVM thin volume, where PV is on dm-crypt)

In this bad state, I extracted some more info on memory:

/proc/meminfo:

MemTotal:        3983088 kB
MemFree:          349264 kB
MemAvailable:    3474744 kB
Buffers:         1511732 kB
Cached:          1608132 kB
SwapCached:           12 kB
Active:           203136 kB
Inactive:        3147696 kB
Active(anon):       1288 kB
Inactive(anon):   252128 kB
Active(file):     201848 kB
Inactive(file):  2895568 kB
Unevictable:       46064 kB
Mlocked:           39920 kB
SwapTotal:       4112380 kB
SwapFree:        4112124 kB
Dirty:                 0 kB
Writeback:          8556 kB
AnonPages:        277020 kB
Mapped:           137424 kB
Shmem:             13792 kB
KReclaimable:      91728 kB
Slab:             182428 kB
SReclaimable:      91728 kB
SUnreclaim:        90700 kB
KernelStack:        5776 kB
PageTables:         7480 kB
SecPageTables:         0 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     6103924 kB
Committed_AS:     990924 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       11560 kB
VmallocChunk:          0 kB
Percpu:             2528 kB
DirectMap4k:     4325764 kB
DirectMap2M:           0 kB

and also:
[ 1168.537096] sysrq: Show Memory
[ 1168.537192] Mem-Info:
[ 1168.537206] active_anon:322 inactive_anon:63032 isolated_anon:0
[ 1168.537206]  active_file:50462 inactive_file:723892 isolated_file:0
[ 1168.537206]  unevictable:11516 dirty:1 writeback:2139
[ 1168.537206]  slab_reclaimable:22932 slab_unreclaimable:22675
[ 1168.537206]  mapped:34357 shmem:3448 pagetables:1870
[ 1168.537206]  sec_pagetables:0 bounce:0
[ 1168.537206]  kernel_misc_reclaimable:0
[ 1168.537206]  free:87499 free_pcp:1642 free_cma:0
[ 1168.537279] Node 0 active_anon:1288kB inactive_anon:252128kB active_file=
:201848kB inactive_file:2895568kB unevictable:46064kB isolated(anon):0kB is=
olated(file):0kB mapped:137428kB dirty:4kB writeback:8556kB shmem:13792kB w=
riteback_tmp:0kB kernel_stack:5776kB pagetables:7480kB sec_pagetables:0kB a=
ll_unreclaimable? no
[ 1168.537332] Node 0 DMA free:15488kB boost:0kB min:32kB low:44kB high:56k=
B reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:84k=
B inactive_file:352kB unevictable:0kB writepending:84kB present:15996kB man=
aged:15936kB mlocked:0kB bounce:0kB free_pcp:12kB local_pcp:0kB free_cma:0kB
[ 1168.537387] lowmem_reserve[]: 0 1728 3857 3857
[ 1168.537409] Node 0 DMA32 free:155300kB boost:0kB min:3552kB low:5320kB h=
igh:7088kB reserved_highatomic:0KB active_anon:16kB inactive_anon:3368kB ac=
tive_file:5660kB inactive_file:1585120kB unevictable:0kB writepending:7576k=
B present:1924360kB managed:1803376kB mlocked:0kB bounce:0kB free_pcp:3184k=
B local_pcp:864kB free_cma:0kB
[ 1168.537464] lowmem_reserve[]: 0 0 2129 2129
[ 1168.537483] Node 0 Normal free:179208kB boost:0kB min:4376kB low:6556kB =
high:8736kB reserved_highatomic:2048KB active_anon:1272kB inactive_anon:248=
760kB active_file:196104kB inactive_file:1310096kB unevictable:46064kB writ=
epending:900kB present:2253948kB managed:2163776kB mlocked:39920kB bounce:0=
kB free_pcp:3372kB local_pcp:632kB free_cma:0kB
[ 1168.537540] lowmem_reserve[]: 0 0 0 0
[ 1168.537557] Node 0 DMA: 4*4kB (UM) 4*8kB (UM) 3*16kB (UM) 3*32kB (U) 3*6=
4kB (U) 2*128kB (UM) 0*256kB 1*512kB (M) 2*1024kB (UM) 0*2048kB 3*4096kB (M=
) =3D 15488kB
[ 1168.537624] Node 0 DMA32: 1945*4kB (UME) 1446*8kB (UME) 953*16kB (UME) 1=
410*32kB (UM) 297*64kB (UM) 162*128kB (UM) 60*256kB (UM) 22*512kB (UM) 7*10=
24kB (UM) 1*2048kB (U) 0*4096kB =3D 155300kB
[ 1168.537695] Node 0 Normal: 3146*4kB (UMEH) 2412*8kB (UMEH) 1444*16kB (UM=
EH) 1138*32kB (UMEH) 486*64kB (UME) 97*128kB (UM) 13*256kB (UM) 8*512kB (M)=
 2*1024kB (M) 5*2048kB (M) 6*4096kB (UM) =3D 179208kB
[ 1168.537767] 779973 total pagecache pages
[ 1168.537778] 3 pages in swap cache
[ 1168.537788] Free swap  =3D 4112124kB
[ 1168.537798] Total swap =3D 4112380kB
[ 1168.537807] 1048576 pages RAM
[ 1168.537817] 0 pages HighMem/MovableOnly
[ 1168.537827] 52804 pages reserved


>=20
> >=20
> > Mikulas
> >=20
> >=20
> > On Sat, 21 Oct 2023, Marek Marczykowski-G=C3=B3recki wrote:
> >=20
> > > Hi,
> > >=20
> > > Since updating from 6.4.13 to 6.5.5 occasionally I hit a storage
> > > subsystem freeze - any I/O ends up frozen. I'm not sure what exactly
> > > triggers the issue, but often it happens when doing some LVM operatio=
ns
> > > (lvremove, lvrename etc) on a dm-thin volume together with bulk data
> > > copy to/from another LVM thin volume with ext4 fs.
> > >=20
> > > The storage stack I use is:
> > >   nvme -> dm-crypt (LUKS) -> dm-thin (LVM thin pool) -> ext4
> > >=20
> > > And this whole thing running in a (PV) dom0 under Xen, on Qubes OS 4.=
2 to be
> > > specific.
> > >=20
> > > I can reproduce the issue on at least 3 different machines. I did tri=
ed
> > > also 6.5.6 and the issue is still there. I haven't checked newer
> > > versions, but briefly reviewed git log and haven't found anything
> > > suggesting a fix to similar issue.
> > >=20
> > > I managed to bisect it down to this commit:
> > >=20
> > >     commit 5054e778fcd9cd29ddaa8109077cd235527e4f94
> > >     Author: Mikulas Patocka <mpatocka@redhat.com>
> > >     Date:   Mon May 1 09:19:17 2023 -0400
> > >=20
> > >     dm crypt: allocate compound pages if possible
> > >    =20
> > >     It was reported that allocating pages for the write buffer in dm-=
crypt
> > >     causes measurable overhead [1].
> > >    =20
> > >     Change dm-crypt to allocate compound pages if they are available.=
 If
> > >     not, fall back to the mempool.
> > >    =20
> > >     [1] https://listman.redhat.com/archives/dm-devel/2023-February/05=
3284.html
> > >    =20
> > >     Suggested-by: Matthew Wilcox <willy@infradead.org>
> > >     Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > >     Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > >=20
> > > TBH, I'm not sure if the bug is in this commit, or maybe in some
> > > functions it uses (I don't see dm-crypt functions directly involved in
> > > the stack traces I collected). But reverting this commit on top of 6.=
5.6
> > > seems to fix the issue.
> > >=20
> > > I tried also CONFIG_PROVE_LOCKING, but it didn't show any issue.
> > >=20
> > > I managed to collect "blocked tasks" dump via sysrq below. Few more c=
an
> > > be found at https://github.com/QubesOS/qubes-issues/issues/8575
> > >=20
> > >     [ 4246.558313] sysrq: Show Blocked State
> > >     [ 4246.558388] task:journal-offline state:D stack:0     pid:8098 =
 ppid:1      flags:0x00000002
> > >     [ 4246.558407] Call Trace:
> > >     [ 4246.558414]  <TASK>
> > >     [ 4246.558422]  __schedule+0x23d/0x670
> > >     [ 4246.558440]  schedule+0x5e/0xd0
> > >     [ 4246.558450]  io_schedule+0x46/0x70
> > >     [ 4246.558461]  folio_wait_bit_common+0x13d/0x350
> > >     [ 4246.558475]  ? __pfx_wake_page_function+0x10/0x10
> > >     [ 4246.558488]  folio_wait_writeback+0x2c/0x90
> > >     [ 4246.558498]  mpage_prepare_extent_to_map+0x15c/0x4d0
> > >     [ 4246.558512]  ext4_do_writepages+0x25f/0x770
> > >     [ 4246.558523]  ext4_writepages+0xad/0x180
> > >     [ 4246.558533]  do_writepages+0xcf/0x1e0
> > >     [ 4246.558543]  ? __seccomp_filter+0x32a/0x4f0
> > >     [ 4246.558554]  filemap_fdatawrite_wbc+0x63/0x90
> > >     [ 4246.558567]  __filemap_fdatawrite_range+0x5c/0x80
> > >     [ 4246.558578]  file_write_and_wait_range+0x4a/0xb0
> > >     [ 4246.558588]  ext4_sync_file+0x88/0x380
> > >     [ 4246.558598]  __x64_sys_fsync+0x3b/0x70
> > >     [ 4246.558609]  do_syscall_64+0x5c/0x90
> > >     [ 4246.558621]  ? exit_to_user_mode_prepare+0xb2/0xd0
> > >     [ 4246.558632]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> > >     [ 4246.558644] RIP: 0033:0x7710cf124d0a
> > >     [ 4246.558654] RSP: 002b:00007710ccdfda40 EFLAGS: 00000293 ORIG_R=
AX: 000000000000004a
> > >     [ 4246.558668] RAX: ffffffffffffffda RBX: 000064bb92f67e60 RCX: 0=
0007710cf124d0a
> > >     [ 4246.558679] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0=
000000000000028
> > >     [ 4246.558691] RBP: 000064bb92f72670 R08: 0000000000000000 R09: 0=
0007710ccdfe6c0
> > >     [ 4246.558702] R10: 00007710cf0adfee R11: 0000000000000293 R12: 0=
00064bb92505940
> > >     [ 4246.558713] R13: 0000000000000002 R14: 00007ffc05649500 R15: 0=
0007710cc5fe000
> > >     [ 4246.558728]  </TASK>
> > >     [ 4246.558836] task:lvm             state:D stack:0     pid:7835 =
 ppid:5665   flags:0x00004006
> > >     [ 4246.558852] Call Trace:
> > >     [ 4246.558857]  <TASK>
> > >     [ 4246.558863]  __schedule+0x23d/0x670
> > >     [ 4246.558874]  schedule+0x5e/0xd0
> > >     [ 4246.558884]  io_schedule+0x46/0x70
> > >     [ 4246.558894]  dm_wait_for_bios_completion+0xfc/0x110
> > >     [ 4246.558909]  ? __pfx_autoremove_wake_function+0x10/0x10
> > >     [ 4246.558922]  __dm_suspend+0x7e/0x1b0
> > >     [ 4246.558932]  dm_internal_suspend_noflush+0x5c/0x80
> > >     [ 4246.558946]  pool_presuspend+0xcc/0x130 [dm_thin_pool]
> > >     [ 4246.558968]  dm_table_presuspend_targets+0x3f/0x60
> > >     [ 4246.558980]  __dm_suspend+0x41/0x1b0
> > >     [ 4246.558991]  dm_suspend+0xc0/0xe0
> > >     [ 4246.559001]  dev_suspend+0xa5/0xd0
> > >     [ 4246.559011]  ctl_ioctl+0x26e/0x350
> > >     [ 4246.559020]  ? __pfx_dev_suspend+0x10/0x10
> > >     [ 4246.559032]  dm_ctl_ioctl+0xe/0x20
> > >     [ 4246.559041]  __x64_sys_ioctl+0x94/0xd0
> > >     [ 4246.559052]  do_syscall_64+0x5c/0x90
> > >     [ 4246.559062]  ? do_syscall_64+0x6b/0x90
> > >     [ 4246.559072]  ? do_syscall_64+0x6b/0x90
> > >     [ 4246.559081]  ? xen_pv_evtchn_do_upcall+0x54/0xb0
> > >     [ 4246.559093]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> > >     [ 4246.559104] RIP: 0033:0x7f1cb77cfe0f
> > >     [ 4246.559112] RSP: 002b:00007fff870f2560 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000010
> > >     [ 4246.559141] RAX: ffffffffffffffda RBX: 00005b8d13c16580 RCX: 0=
0007f1cb77cfe0f
> > >     [ 4246.559152] RDX: 00005b8d144a2180 RSI: 00000000c138fd06 RDI: 0=
000000000000003
> > >     [ 4246.559164] RBP: 00005b8d144a2180 R08: 00005b8d132b1190 R09: 0=
0007fff870f2420
> > >     [ 4246.559175] R10: 0000000000000000 R11: 0000000000000246 R12: 0=
00000000000000c
> > >     [ 4246.559186] R13: 00005b8d132aacf0 R14: 00005b8d1324414d R15: 0=
0005b8d144a21b0
> > >     [ 4246.559199]  </TASK>
> > >     [ 4246.559207] task:kworker/u8:3    state:D stack:0     pid:8033 =
 ppid:2      flags:0x00004000
> > >     [ 4246.559222] Workqueue: writeback wb_workfn (flush-253:4)
> > >     [ 4246.559238] Call Trace:
> > >     [ 4246.559244]  <TASK>
> > >     [ 4246.559249]  __schedule+0x23d/0x670
> > >     [ 4246.559260]  schedule+0x5e/0xd0
> > >     [ 4246.559270]  io_schedule+0x46/0x70
> > >     [ 4246.559280]  folio_wait_bit_common+0x13d/0x350
> > >     [ 4246.559290]  ? __pfx_wake_page_function+0x10/0x10
> > >     [ 4246.559302]  mpage_prepare_extent_to_map+0x309/0x4d0
> > >     [ 4246.559314]  ext4_do_writepages+0x25f/0x770
> > >     [ 4246.559324]  ext4_writepages+0xad/0x180
> > >     [ 4246.559334]  do_writepages+0xcf/0x1e0
> > >     [ 4246.559344]  ? find_busiest_group+0x42/0x1a0
> > >     [ 4246.559354]  __writeback_single_inode+0x3d/0x280
> > >     [ 4246.559368]  writeback_sb_inodes+0x1ed/0x4a0
> > >     [ 4246.559381]  __writeback_inodes_wb+0x4c/0xf0
> > >     [ 4246.559393]  wb_writeback+0x298/0x310
> > >     [ 4246.559403]  wb_do_writeback+0x230/0x2b0
> > >     [ 4246.559414]  wb_workfn+0x5f/0x260
> > >     [ 4246.559424]  ? _raw_spin_unlock+0xe/0x30
> > >     [ 4246.559434]  ? finish_task_switch.isra.0+0x95/0x2b0
> > >     [ 4246.559447]  ? __schedule+0x245/0x670
> > >     [ 4246.559457]  process_one_work+0x1df/0x3e0
> > >     [ 4246.559466]  worker_thread+0x51/0x390
> > >     [ 4246.559475]  ? __pfx_worker_thread+0x10/0x10
> > >     [ 4246.559484]  kthread+0xe5/0x120
> > >     [ 4246.559495]  ? __pfx_kthread+0x10/0x10
> > >     [ 4246.559504]  ret_from_fork+0x31/0x50
> > >     [ 4246.559514]  ? __pfx_kthread+0x10/0x10
> > >     [ 4246.559523]  ret_from_fork_asm+0x1b/0x30
> > >     [ 4246.559536]  </TASK>
> > >=20
> > > --=20
> > > Best Regards,
> > > Marek Marczykowski-G=C3=B3recki
> > > Invisible Things Lab
> > >=20
>=20
>=20
> --=20
> Best Regards,
> Marek Marczykowski-G=C3=B3recki
> Invisible Things Lab



--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--QBmfba23+tgBfLjb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmU4idwACgkQ24/THMrX
1yxWLwgAk9QBWK4BDq6PPPlbOrJli9E9krEyPeVhEJ56/rLubMdnqDoEwHHPssdn
LHNr35XPadiCzPnjPIl3tcR5w6nN3DcpKGBNqq5+c5VaTICzptqeWFoQ9Rc5tCVD
vacDX5k0YJ/cCWuuwSfxJt/o4/A1LQe0jB4dcJizK24lBg1bv2I0Je+rM+zIuwmh
kZQfyOhoQhHxg5cNYrxDpCMfOERUqn13mlGZx1BvKShi546mcjxLNBT0UPcPXeER
A0nxL7LBQeV4s5PZqVH0jcue4VjbGKr8YUyMSqYyyjFyU0vjh36ujFFg3BSihMP4
k+CIh8bKxAmS90+bWu1cVT0g6J1U6g==
=31uI
-----END PGP SIGNATURE-----

--QBmfba23+tgBfLjb--

