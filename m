Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B5512C496
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560980; cv=none; b=c3WZh2KSpHyD1aXXrT/OsOj1SItxvcpDjcCR2hNEmp6rhMZ5mbDpSbAF0af2s04cZmt6oGjqqr2fWWTTdcY7bP6tE9lX6Cz9I/Rv5xgAgrfEZdDxEDp5acx6QjsrQ5mm5a50TrLEj7DuCmnpWvsvBLAkiNOwZFt/sOWbAZ7xjqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560980; c=relaxed/simple;
	bh=m/crkvdj6tgZu8Rjo/8pPIhVHQPC9wz6wLIU0Ouju64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZSU9dkd8QouXOOs3Qyg5+RUdm/0PiEnZ8ubYQ0SaGnUS/KGysgspDE0a3Ol82PL629ViiISJ1sys32STxgXy7Tf0eWulfrAHBLAkt/q0QrK2k7q1rdl2NT/VSIIcnMDGKQoE8A2x5rpJ2xEqKEb6Eerb28lFA72d3QuZd01FHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wixcHswy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wixcHswy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w9fc44ZoadWtFqeM/SZvVFQF2HSr7fN/ty6EajFhxzs=; b=wixcHswyNvWd/e2kJW+1nRqz6D
	draxFNrk68PwsPqx72G+xX1rzvyO5W7xATKy1N02uP390laN3FDKC/GosJ0YUcOnJFisua89lMt7X
	b4It2O+0QiEKIxhVqx9Uj7anMBkqsy/WRUHl4ep7tTkuHAEF+xCj64x1bJH/IQ+4mbb2XkJPSFnM0
	bP5a667QUWtsgBHyVMEDz+QgDY+zNIWXwei4YsoAXlvO0rRrpxpZ8wcbPxK3GMQE+0qty1+4VjXWc
	hwFk/NMD9eln8Cd4bD8xun6W1A5rGR1SNxhFrPk99ZOA8tO9N7Q5c2IZ65QomLr/D+gJLnt3rG/2Z
	XrBCPYdw==;
Received: from [2001:4bb8:2dd:2931:3dd2:5393:218b:4dfd] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAVvN-000000097c9-1CGy;
	Fri, 24 May 2024 14:29:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [PATCH 1/3] dm: move setting zoned_enabled to dm_table_set_restrictions
Date: Fri, 24 May 2024 16:29:09 +0200
Message-ID: <20240524142929.817565-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240524142929.817565-1-hch@lst.de>
References: <20240524142929.817565-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Keep it together with the rest of the zoned code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c | 3 ---
 drivers/md/dm-zone.c  | 8 +++++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index cc66a27c363a65..e291b78b307b13 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2040,9 +2040,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		r = dm_set_zones_restrictions(t, q);
 		if (r)
 			return r;
-		if (blk_queue_is_zoned(q) &&
-		    !static_key_enabled(&zoned_enabled.key))
-			static_branch_enable(&zoned_enabled);
 	}
 
 	dm_update_crypto_profile(q, t);
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 8e6bcb0d786a1a..eb1165324ab047 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -287,7 +287,13 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 		       queue_emulates_zone_append(q) ? "emulated" : "native");
 	}
 
-	return dm_revalidate_zones(md, t);
+	ret = dm_revalidate_zones(md, t);
+	if (ret < 0)
+		return 0;
+
+	if (!static_key_enabled(&zoned_enabled.key))
+		static_branch_enable(&zoned_enabled);
+	return 0;
 }
 
 /*
-- 
2.43.0

