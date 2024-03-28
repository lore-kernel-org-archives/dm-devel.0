Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836F613AD2D
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 20:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711658440; cv=none; b=uaRwup/hc8G+KwoYuYGYJRac0twmXM1fHCZ3ELAmu5vQ/tOmCoH0XJ6RVkcwsSzQwdCd0NUhsDRZgss1vw/8uBgDm4Yf/52afu14C/a+gx1F3Zd9InbETzNkGQIrM/+1LXyI+xUMz/gHzT6JO+v9N8jDnB0yjdJLKlrXgCt9adI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711658440; c=relaxed/simple;
	bh=SI9EyP15CZh3jJTeMjwpu+Zr17yZzGKirE/DIG97dXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSFGBmk+lse28oZouqxnvgerfnFN9phe4G88ba1c3CFsgPYUAfeY/vOr7701BU5JXCiMaT/u0OwC6XoonEsWzIXBKS3EN4E4I1UFKftEcp6atrCUvPr8qDhCAskWKkXXSxLgBMYlOSvGXo+MLsIo+kXfLWUGPqu4eeRDL9HVyQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LDeu/HgB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LDeu/HgB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711658437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lf6jghLGdSH/W25WTkrfJgf1lvUf+tFV6p9B6mZYK3I=;
	b=LDeu/HgBVwqgwKlEo+B1Y2lywmykkC1Qmo+LclIao2TaLrJXT+lihPhKRil/S5foI8EHxn
	0TBHltPk5qeZro28XS8ee89Foi5DAuaPnv1tZYCXeHNon55zYsSQfrzipnaj3Pvf6c2pKQ
	/BW4iVBYjlzbwHwVejTnInEUBhzj5qk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-SH43pzrSOta28V_OS728qA-1; Thu,
 28 Mar 2024 16:40:33 -0400
X-MC-Unique: SH43pzrSOta28V_OS728qA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CE073C025B1;
	Thu, 28 Mar 2024 20:40:33 +0000 (UTC)
Received: from localhost (unknown [10.39.194.117])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 484432166B31;
	Thu, 28 Mar 2024 20:40:31 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	eblake@redhat.com,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	David Teigland <teigland@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Joe Thornber <ejt@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [RFC 8/9] dm thin: add llseek(SEEK_HOLE/SEEK_DATA) support
Date: Thu, 28 Mar 2024 16:39:09 -0400
Message-ID: <20240328203910.2370087-9-stefanha@redhat.com>
In-Reply-To: <20240328203910.2370087-1-stefanha@redhat.com>
References: <20240328203910.2370087-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
Open issues:
- Locking?
- thin_seek_hole_data() does not run as a bio or request. This patch
  assumes dm_thin_find_mapped_range() synchronously performs I/O if
  metadata needs to be loaded from disk. Is that a valid assumption?
---
 drivers/md/dm-thin.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 4793ad2aa1f7e..3c5dc4f0fe8a3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4501,6 +4501,82 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	}
 }
 
+static dm_block_t loff_to_block(struct pool *pool, loff_t offset)
+{
+	sector_t offset_sectors = offset >> SECTOR_SHIFT;
+	dm_block_t ret;
+
+	if (block_size_is_power_of_two(pool))
+		ret = offset_sectors >> pool->sectors_per_block_shift;
+	else {
+		ret = offset_sectors;
+		(void) sector_div(ret, pool->sectors_per_block);
+	}
+
+	return ret;
+}
+
+static loff_t block_to_loff(struct pool *pool, dm_block_t block)
+{
+	return block_to_sectors(pool, block) << SECTOR_SHIFT;
+}
+
+static loff_t thin_seek_hole_data(struct dm_target *ti, loff_t offset,
+		int whence)
+{
+	struct thin_c *tc = ti->private;
+	struct dm_thin_device *td = tc->td;
+	struct pool *pool = tc->pool;
+	dm_block_t begin;
+	dm_block_t end;
+	dm_block_t mapped_begin;
+	dm_block_t mapped_end;
+	dm_block_t pool_begin;
+	bool maybe_shared;
+	int ret;
+
+	/* TODO locking? */
+
+	if (block_size_is_power_of_two(pool))
+		end = ti->len >> pool->sectors_per_block_shift;
+	else {
+		end = ti->len;
+		(void) sector_div(end, pool->sectors_per_block);
+	}
+
+	offset -= ti->begin << SECTOR_SHIFT;
+
+	while (true) {
+		begin = loff_to_block(pool, offset);
+		ret = dm_thin_find_mapped_range(td, begin, end,
+						&mapped_begin, &mapped_end,
+						&pool_begin, &maybe_shared);
+		if (ret == -ENODATA) {
+			if (whence == SEEK_DATA)
+				return -ENXIO;
+			break;
+		} else if (ret < 0) {
+			/* TODO handle EWOULDBLOCK? */
+			return -ENXIO;
+		}
+
+		/* SEEK_DATA finishes here... */
+		if (whence == SEEK_DATA) {
+			if (mapped_begin != begin)
+				offset = block_to_loff(pool, mapped_begin);
+			break;
+		}
+
+		/* ...while SEEK_HOLE may need to look further */
+		if (mapped_begin != begin)
+			break; /* offset is in a hole */
+
+		offset = block_to_loff(pool, mapped_end);
+	}
+
+	return offset + (ti->begin << SECTOR_SHIFT);
+}
+
 static struct target_type thin_target = {
 	.name = "thin",
 	.version = {1, 23, 0},
@@ -4515,6 +4591,7 @@ static struct target_type thin_target = {
 	.status = thin_status,
 	.iterate_devices = thin_iterate_devices,
 	.io_hints = thin_io_hints,
+	.seek_hole_data = thin_seek_hole_data,
 };
 
 /*----------------------------------------------------------------*/
-- 
2.44.0

