Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795764928;
	b=PMV8X58qI3WKFhn8HmALszG1g/Q6bRwkJKNTYLNra9y/JTPieqsCV0nq/18Kz9f0oCrH
	 DkSuROsWqc2tHMXMWDUaDHLMDDNihDqkIF5BLMGhqXAQ5qAtWEHyc6Wwi+GF7swfKRnLF
	 ZESrWowkuVJ8CuxHGPpI11DVWI5+rZ/jqGPLj1sM2K3aru1nsHqKdoG1/5E9Tnvkj2QPS
	 XNVUp8C4Ap+2GAb07KHpLtTe4C0irEZ+hR4yaN7ZbZwagXxRc8Pu4w/5UyMmBmfWqaI2f
	 K3hMwp3IJ85/YSl+30U6LX56HDjvUP/ulg1S3HgwM1IlYOMT5zQm2OWDwwu5HVQ1m0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795764928;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:Date:X-Mailer:To:From:
	 X-Lms-Return-Path:Content-Transfer-Encoding:Subject:Message-Id:
	 Mime-Version:Received:Cc:X-Original-From:Content-Type;
	bh=exRdp/EX4S1XNnmQ0lxYZW46n7JXagdYqiAU1dNsEJg=;
	b=5HTaIl3GEtbLf9ygwJCDMB6o1zplbaczkv878ZXGY3/BX61Yk7f21Drhro5hvp2N9s6w
	 PVgJBoTD2P0uibgayCySys6P3Zi1WxVOR+zgNXPbob7J4tD/A+ORVj4fOAc0FFkBz9kRD
	 6h+ntM7nDJAK5wyjreP3tolrxuHYnve2B7ddJ/5k1SKdd+kjGUrxUVjQBWxk9O5yVUdB3
	 X0Bk9vdaMh1u0XjELqCjyYCIqaMhlxE8zspKtq7RadxXxWfsBdScDZzMUeoD/5OmSML/W
	 3oN1wSFwbyO+ERGlB+219wXwsSI7nCsqHcAnCMeCT0+xIdYmWQ6igS5h7jiV+nMUZqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kaihong.com;
	spf=pass smtp.mailfrom=kaihong.com;
	arc=none smtp.remote-ip=115.124.28.89
Received: from out28-89.mail.aliyun.com (out28-89.mail.aliyun.com [115.124.28.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555C3606A31E
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 07:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 555C3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaihong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaihong.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.08067833|-1;BR=01201311R261S10rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00554454-0.000711638-0.993744;FP=14394826012851074287|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037034017;MF=haoruiqiang@kaihong.com;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.kBFopdZ_1795764914;
Received: from localhost(mailfrom:haoruiqiang@kaihong.com fp:SMTPD_---.kBFopdZ_1795764914 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 27 Nov 2026 15:35:15 +0800
Date: Fri, 27 Nov 2026 15:35:08 +0800
X-Mailer: git-send-email 2.43.0
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>, 
	<bmarzins@redhat.com>
From: "Ruiqiang Hao" <haoruiqiang@kaihong.com>
X-Lms-Return-Path: <lba+26b0932b0+4b12d6+kernel.org+haoruiqiang@kaihong.com>
Content-Transfer-Encoding: 7bit
Subject: [PATCH] dm snapshot: fix double vfree on partial alloc_area failure
Message-Id: <20261127073508.2506240-1-haoruiqiang@kaihong.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Received: from ubuntu24-dev.. ([219.142.21.190]) by smtp.feishu.cn with ESMTPS; Fri, 27 Nov 2026 15:35:11 +0800
Cc: <dm-devel@lists.linux.dev>, "Ruiqiang Hao" <haoruiqiang@kaihong.com>, 
	<syzbot+1eda626824b6334f5ad3@syzkaller.appspotmail.com>, 
	<stable@vger.kernel.org>
X-Original-From: Ruiqiang Hao <haoruiqiang@kaihong.com>
Content-Type: text/plain; charset=UTF-8

alloc_area() frees ps->area and ps->zero_area when a later allocation
fails, but leaves the pointers set.  persistent_read_metadata() then
returns -ENOMEM, snapshot_ctr() aborts and dm_exception_store_destroy()
calls persistent_dtr() -> free_area(), which vfree()s the same areas
again:

  Trying to vfree() nonexistent vm area (ffffc90024410000)
  WARNING: mm/vmalloc.c:3539 at vfree+0x463/0x490

Clear each pointer after freeing it so free_area() is safe on the
partial-allocation error path.

Fixes: 7c9e6c17325f ("dm exception store: refactor zero_area")
Reported-by: syzbot+1eda626824b6334f5ad3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1eda626824b6334f5ad3
Cc: stable@vger.kernel.org
Signed-off-by: Ruiqiang Hao <haoruiqiang@kaihong.com>
---
 drivers/md/dm-snap-persistent.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index b587ee733056..9f5ade4f51ce 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -194,9 +194,11 @@ static int alloc_area(struct pstore *ps)
 
 err_header_area:
 	vfree(ps->zero_area);
+	ps->zero_area = NULL;
 
 err_zero_area:
 	vfree(ps->area);
+	ps->area = NULL;
 
 err_area:
 	return r;
-- 
2.43.0
