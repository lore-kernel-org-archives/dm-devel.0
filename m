Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795437791;
	b=fX1KaRUt9MZYA9paC2J57p3kdoo3Ueegmka5SnoF/yIez5o7ymIdanrYTOQt3TKz372q
	 LF2qAv/w6tAiErB0sppF2yx1693x+QXz0y7bylbLFvbXkFrCSIWU5MPimY9wDGqT+5mK6
	 jd1ZfW4QcCm6t6FlCop/766DsnxxAXvuyzDAGIoXaaCFlgRDz+yuFKDsIYxID7RYzLzfL
	 9JOsPcgI2O8CUGBX1hshUQfjw5hvt+NOLld3boPu68bHCCa90YLuPt30a4YXbFnSFdyrm
	 lJyqI+RZ+0tgAJCD9J78o47wyt9rWJ80YF2zB1JP3yJE6sruYrYaIlKULYg8QwaKf9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795437791;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=nurLNsvhXtnd6T0cWQV7F3FEw1+K5Q7NyOeJPjQtAzU=;
	b=lI6F3D0EJOwMEQ3fdBzKVjGFwIVfrMC6NbfO5cxhIqTUVMzO7ZbWIuvJkZpBJN9u2+YG
	 06pytIEcbHPm+ns4POIj3/PRcOd73b6xBqKb8yLS4dH0PTy9Nnvu91baaR4uoFm0PR+Gj
	 rR2I1XzLq8jywFyt/vgChEFmbba0WJVULwR943tXVPGHiTt1u3uImS4+SDgdflMSwWJVK
	 2+sTxQhZ8RTtPSP+fY9pgaY0fw4fKt+8FjBbOw+juUOj44GUoGKAIOsAd0SNJ8+M6vKcZ
	 xfRd6DUG4ZnluyfjDQW5G/lYjDAu1XrOtG2deHuMmtu8AzZOaiJ63kVtjjtY/3dBvMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=LNbpaZuS;
	arc=none smtp.remote-ip=117.135.210.9
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B35606A321
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 12:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78B35606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=LNbpaZuS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=nu
	rLNsvhXtnd6T0cWQV7F3FEw1+K5Q7NyOeJPjQtAzU=; b=LNbpaZuSzV+MPMtDZ3
	4qKB9vn5uzmuiR1nnvhbQ16BSqlD3ThNk6gRE0akdk7SIUek3SuMCElB/c0TOxJq
	0LycWmtcAwQx5Op6fX6v6Mo4C7bTmiFkwgsgakZWi2W/n6wUaM9WV3vFwfciedgY
	YkWZVCG/gCb+PEgeLJL3qUHZk=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PikvCgA35uu4NARrP97wDw--.65328S5;
	Mon, 23 Nov 2026 20:42:47 +0800 (CST)
From: Genjian <zhanggenjian@126.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanggenjian@126.com,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 2/2] dm-integrity: don't mark the bitmap clean on a failed target
Date: Mon, 23 Nov 2026 20:42:13 +0800
Message-Id: <20261123124213.1102958-2-zhanggenjian@126.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261123124213.1102958-1-zhanggenjian@126.com>
References: <20261123124213.1102958-1-zhanggenjian@126.com>
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
X-CM-TRANSID:PikvCgA35uu4NARrP97wDw--.65328S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZF4ktr4UWr1rJr1rAF4Utwb_yoW8XrW7pr
	1xK3yFk3ykAF429a1xCF43CFyrKa4Ikry3CrZIkw1fK345ur17Xw1kGFyUJryUGF4fXF1U
	ZF1Yka4Uur4DWr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRZF4_UUUUU=
X-CM-SenderInfo: x2kd0wxjhqyxldq6ij2wof0z/xtbBtAcamGsENMfS1AAA3r

From: Genjian Zhang <zhanggenjian@kylinos.cn>

In bitmap mode, dm_integrity_postsuspend() clears SB_FLAG_DIRTY_BITMAP
and writes the superblock even when the target has already failed. If
resume rejected a changed superblock, this write can overwrite it with
the constructor's saved copy.

Check the target's failure state after init_journal() so that a journal
write error during initialization also prevents the bitmap from being
marked clean.

Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
---
 drivers/md/dm-integrity.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b17bb9da9195..0964d21c3c44 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3852,10 +3852,12 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 #if 1
 		/* set to 0 to test bitmap replay code */
 		init_journal(ic, 0, ic->journal_sections, 0);
-		ic->sb->flags &= ~cpu_to_le32(SB_FLAG_DIRTY_BITMAP);
-		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
-		if (unlikely(r))
-			dm_integrity_io_error(ic, "writing superblock", r);
+		if (!dm_integrity_failed(ic)) {
+			ic->sb->flags &= ~cpu_to_le32(SB_FLAG_DIRTY_BITMAP);
+			r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
+			if (unlikely(r))
+				dm_integrity_io_error(ic, "writing superblock", r);
+		}
 #endif
 	}
 
-- 
2.25.1

