Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87A82DAFB8;
	Tue, 18 Nov 2025 07:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763449413; cv=none; b=K2b2k/7AhCOHssu+sm3Dy6723kpYfsArJlgJlu2ACTOpZtkKfxGqBA5Fb1DB05ZkumMmInnhVjeRGgPLCgAjwwupO1Bs6lVmK4glcBhS4Reb15X/i6HE4h0v00Ff/07w9MqfnNNoJk9DRTa68hSLOf1X/FRwB4+XiCf8COMLpJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763449413; c=relaxed/simple;
	bh=0Py3NdFKqRZzA7YqHWCOjISV5ep7wgzaZQt6A9FYxJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzcolQJCjG+QBFFZWzKWLYvU4OPNX/G3GRZkv2crfpi8UOmjlC5XmjkfmokPU37e7axnB/GQJN1qYQd3uqVYW6aSuOjtXc9jhnfnRPzVKsRCew1LG1TcQQVyOLbmqI/KZg5l1CRWSYmdAr7AspXhcrRFLiqBW3w0l12HsRh0G+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JMGQOUPE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JMGQOUPE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zXyLLiSWH+HR5uXPxlDXhGflO0EpgeT/pjfamh6M5LI=; b=JMGQOUPElOu+qpPfECXC7R5CnQ
	755SAbCTjwSsUEjzOoQ47CkQY7nMlQLuTE0dSgKRjRqmePvPE1SAvqDOgpZLm+RkgYda1MMtWy4bQ
	NJWrP+skbLu6bhKQKFy6YiFxdWvbwU9aRi9ux+6T9kiwNwb4wsg7BWd17AosAQeiwdrf3cBZbnJcu
	f5lIWZH22paRaPMbW4803gP5KlT+37NqXtisHYfh0y4uwHVZulDU97zynkQoDKWYMQCulwaDTZ0PT
	FqaHQmYPaPV9vbAsRMZao8mwyz9C0mwloXeZ0lvlPFeSzJINOjWNMUXOhmPhyle5OVDp5gtEax5hy
	O3KgjWSg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLFkQ-0000000HWyv-1tzd;
	Tue, 18 Nov 2025 07:03:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 1/3] block: add a bio_list_add_sorted helper
Date: Tue, 18 Nov 2025 08:03:08 +0100
Message-ID: <20251118070321.2367097-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251118070321.2367097-1-hch@lst.de>
References: <20251118070321.2367097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to insert a bio into a bio_list so that the list remains
sorted by bi_sector.

While it is on the upper hand of the size for an inline function, it is a
trade off for having it with the common helpers, but not bloating the
kernel unless the so far only user is enabled.  If it gets more widely
used moving it out of line should be considered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bio.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index ad2d57908c1c..e5f92bc88eea 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -565,6 +565,27 @@ static inline void bio_list_add_head(struct bio_list *bl, struct bio *bio)
 		bl->tail = bio;
 }
 
+static inline void bio_list_add_sorted(struct bio_list *bl, struct bio *bio)
+{
+	if (bio_list_empty(bl) ||
+	    bio->bi_iter.bi_sector > bl->tail->bi_iter.bi_sector) {
+		bio_list_add(bl, bio);
+	} else if (bio->bi_iter.bi_sector < bl->head->bi_iter.bi_sector) {
+		bio_list_add_head(bl, bio);
+	} else {
+		struct bio *n = bl->head, *next;
+
+		while ((next = n->bi_next) != NULL) {
+			if (bio->bi_iter.bi_sector < next->bi_iter.bi_sector) {
+				bio->bi_next = next;
+				n->bi_next = bio;
+				break;
+			}
+			n = next;
+		}
+	}
+}
+
 static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
 {
 	if (!bl2->head)
-- 
2.47.3

