Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792482526;
	b=epSsxI783YBXZ07FqCGOf5QPc1gdwonNozB/aoxRSemOAiL2Kz9v/XCg9gdF+sRWPE5v
	 85belKyf1dOPolh6S4h9Tm3QxPKzih01rv1vGkOl7Vv/YyRl06ZLvdXcjUFe84LXIAEfz
	 aP9o6btkTRJarjOgO/k70w0ftDU20wksYdAX5H2tw/5oa/DOZflwACWOY41SUwi5J5xGb
	 vMxuBVB9X6fFetcozFCOzZzGYWqpr+woQWn5UC3smtYcuZL1ijhPHzPVm3tjZ9BVNBk8L
	 cIxb01mvKyq5ISMq1g+6ZNZq/2fvFa48lBS+h8nZBfsmnWu3u/2tTmfpG0v7XNtnWKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482526;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=u/6upEQ25rIzx6nSzKdsiZCvXU7+OtkTfQcaNNPOa/M=;
	b=qS0Ux1qN93ZzkYlmElWrpO6NeKwitRI9yj47LpGXUUfW0sMseUwxBMSTuqHmJGsFHmgb
	 CAiT4Ar/45Dy5GNnliovVm4rtCyTUJCfk1gyxxteySWY629QID+qPznWZHdaBymksWEt3
	 SV2vDyZixqEFdniUv3BLy8jyEb3prX7t8M+FuUTDnXdMdwv/tB12oXcPQR/MgMcZ1MRht
	 u2hewu47ZOBSMiIYJdtXg+Q4f3NMouxa4izgyelemDgyDWBFXSv8K4RLyVIe5yB8Yb0SH
	 32ugSIBAC+hKMSFt+GVbfri5QI9FMTCOyLSwGgFEMiHcr8h6clGM5CZJC4kYIV/F0RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=u87DFeQg;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A47606A319;
	Tue, 20 Oct 2026 07:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28A47606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=u87DFeQg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-ID:Date:Subject:From:
	Content-Type; bh=u/6upEQ25rIzx6nSzKdsiZCvXU7+OtkTfQcaNNPOa/M=; b=u87DFeQgd0ha
	DktpKQPeMO52H8EUYj30yWk/I8OqnVlkUAbIC9V+iuRKuYZTFvmwI8sUgc9dodX1+Osff+OSxxEEH
	ULFP1+Y0Cl1ZFPleHu5rkTK4j5+mBXWeVvm22bvZ1ibYFZJrISA5r2tcPAC15U0yKiwMYc1GCNddE
	unnNlFnmMscVqZUeTyOypbr17jGB5OhgvtbGYLCnkQe9HfgHNAs8i5RvyZBcdpAHoLQ2eL/EhDYF3
	++d+sYfDw4JxJuUws5b/3OPipEtjXk9fiH+q3JRKijK5Zy+0yrlq35IJrhDVbPkrywzSiUAJRC+LA
	i6SWRJb4Y8OfY19mMgZs3A==;
Received: from ch-vpn.virtuozzo.com ([130.117.225.6] helo=sky)
	by relay.virtuozzo.com with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <alexander.ivanov@virtuozzo.com>)
	id 1xJ4Wm-005vsL-03;
	Tue, 20 Oct 2026 09:48:28 +0200
From: Alexander Ivanov <alexander.ivanov@virtuozzo.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dm table: don't inherit live table's type for request-based tables
Date: Tue, 20 Oct 2026 09:48:34 +0200
Message-ID: <20261020074834.1282246-1-alexander.ivanov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A request-based table without devices inherits the live table's type
in dm_table_determine_type(). Since commit 6936c12cf809 ("dm table: fix
'all_blk_mq' inconsistency when an empty table is loaded") this
includes bio-based types, although the inheritance was meant to pick a
variant of the request-based type, and only one is left now. So a
request-based table loaded over a bio-based device becomes bio-based,
which its target cannot handle.

A multipath table with no paths and the default rq queue_mode keeps
m->queue_mode request-based while the table is bio-based. Its
per_io_data_size is sized for a request, so the first bio overruns its
per-bio data in multipath_map_bio():

  BUG: KASAN: slab-out-of-bounds in multipath_map_bio+0x376/0x380
   __map_bio+0x433/0x4f0
   dm_submit_bio+0x48a/0x1620

Removing the device then kicks the requeue work of a bio-based queue,
which was never initialized, from multipath_presuspend():

  WARNING: kernel/workqueue.c:2606 at __queue_delayed_work+0x29c/0x340
   mod_delayed_work_on+0xee/0x100
   kblockd_mod_delayed_work_on+0x16/0x20
   dm_table_presuspend_targets+0xdf/0x160
   __dm_destroy+0x41b/0x530

Drop the inheritance. table_load() then rejects such a table with
"can't change device type", as it does for request-based tables with
devices.

Fixes: 6936c12cf809 ("dm table: fix 'all_blk_mq' inconsistency when an empty table is loaded")
Signed-off-by: Alexander Ivanov <alexander.ivanov@virtuozzo.com>
---
 drivers/md/dm-table.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a483f49dd4ce..c5e55b4a527c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -967,16 +967,8 @@ static int dm_table_determine_type(struct dm_table *t)
 		return -EINVAL;
 	}
 
-	if (list_empty(devices)) {
-		int srcu_idx;
-		struct dm_table *live_table = dm_get_live_table(t->md, &srcu_idx);
-
-		/* inherit live table's type */
-		if (live_table)
-			t->type = live_table->type;
-		dm_put_live_table(t->md, srcu_idx);
+	if (list_empty(devices))
 		return 0;
-	}
 
 	ti = dm_table_get_immutable_target(t);
 	if (!ti) {
-- 
2.53.0

