Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845A138FA6;
	Mon, 27 May 2024 12:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716813404; cv=none; b=aBtqS4LfulmMGB83VTyAU0dUFgaU/ItjcYHyXiPjA0v1IojzdFhOp61B+nvRcr7ip2OskUrSv/gbmUWwg4RjVMEP79j7hEnKTOYfwkuFBfKWXZ9AdcmINNJOop/GEhZTYOgqt1GspxbPAzGMFhfIV+LW3AykvKtjcBvWXbHoLBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716813404; c=relaxed/simple;
	bh=473ljOGiYz8d0Mj5N09Zg305IEPR+oLj9Hc19W6gfS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgakqp+4Ah59EN01d6X6lSkkcBmoh/ZxiqXK8j84MohwaHboLzE7hQiXM4WoVezp2gX5XJwcgYeEXb7mmfQOKAAUUFAceClU6p490Y5uJKDQ+WBg+j7HplNqacNdy4v2/+XPjV9QeEURnXlej8R0zX8PyD7/YxhDho2mp1AsAKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E5O8OcSd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E5O8OcSd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8dpH1/upE2fFbt4IJPQXK3FBXsvPwoRLOmU9xsdkOJw=; b=E5O8OcSdEIN2QgxVPqUnwN15ha
	ce1igUS3giDMqLbp5T8+1rcqxm+0J1E6Z01qxfoAgMK4NAkMijy3Spm+Zn/EGhDbpdW/S7jUF0BoR
	nM17mzSyPTFimzWPiAbruCpI0pUpz+tu6ZV/REhb0kQCXRzZwoKO1NmCFAnDlH9G10KRS8vQxu4Ws
	ZKOnFYgPtuAA6CbAlZcjhGV6szQdiA5tY7lvjuSw2T/E5o/0GRppUiwRzjtxIGCS40Snw2jSIqv5i
	474az9t0dWmPCpIwbdnuvbxIiqlAImTKRhv/lw853qG7q2T5vPk/v2UmIBiJ779TA+l2Zcsk5F8ND
	R69rdaew==;
Received: from 2a02-8389-2341-5b80-3177-e4c1-2108-f294.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3177:e4c1:2108:f294] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBZaj-0000000Eu1O-267w;
	Mon, 27 May 2024 12:36:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/3] dm: move setting zoned_enabled to dm_table_set_restrictions
Date: Mon, 27 May 2024 14:36:18 +0200
Message-ID: <20240527123634.1116952-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240527123634.1116952-1-hch@lst.de>
References: <20240527123634.1116952-1-hch@lst.de>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
index 8e6bcb0d786a1a..3103360ce7f040 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -287,7 +287,13 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 		       queue_emulates_zone_append(q) ? "emulated" : "native");
 	}
 
-	return dm_revalidate_zones(md, t);
+	ret = dm_revalidate_zones(md, t);
+	if (ret < 0)
+		return ret;
+
+	if (!static_key_enabled(&zoned_enabled.key))
+		static_branch_enable(&zoned_enabled);
+	return 0;
 }
 
 /*
-- 
2.43.0

