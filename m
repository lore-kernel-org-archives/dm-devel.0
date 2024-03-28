Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7342513B5AC
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 20:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711658411; cv=none; b=FYACGsStYdFHyDDQM3LUD5IFc0b1+PVRhIIZfosF0RzDRcpee9EPM6Qe5kcOhQjrj0NKwcbdwlTVyZQCqXoA2KciZTinggtpU6i1mpdoXy8PXwrtHV8pYzA5AbBKLPng4w4QCYEnfwDv+DIsBKTFClhH+7BOyD2+fe0FMNbBauI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711658411; c=relaxed/simple;
	bh=5/XIIKiTB1kK6mCedHSlUjddeWaCgNaGwQ7W/dFaZPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDgX8xwzJu0a4VTcs9OLp6qnImPIIIEb+4lLj9gx10/9gzx5Mkw4Fmo6gr37g83R89N3JnsBDgMlpq0CbAvw+eIgJvG3X19NPt6z8uOQ29RW3y4fJvT/RDSFRpyD3fu9r2vEYRDf2BxFei+8KUQ7aDJqKON3HsFezmzxl1UTqT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RlVvCpUn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RlVvCpUn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711658408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O2S5dlufkY7ji1jTEmuLexd5aljX5StH7MYrMWEnyTc=;
	b=RlVvCpUn3mqmI+KgqWey/npCb7ke2TrnIIgN/k7i5PydkoFZvmWSF1IJNRX5o4AfkcjKp9
	ErWjcV2Br6Ykc5iYjEn8yW4exLi2UWlUWo3mdDoIpLo2otOVbE/8YW/2WQz3TpASy/65dx
	cWBkClT9T92k61KQfChYQ+0N6lyORz4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-8_4MxpuOPVm5kw_6Dhr1YQ-1; Thu, 28 Mar 2024 16:40:06 -0400
X-MC-Unique: 8_4MxpuOPVm5kw_6Dhr1YQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C38E1185A781;
	Thu, 28 Mar 2024 20:40:05 +0000 (UTC)
Received: from localhost (unknown [10.39.194.117])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1E612166B35;
	Thu, 28 Mar 2024 20:40:04 +0000 (UTC)
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
Subject: [RFC 4/9] dm: add llseek(SEEK_HOLE/SEEK_DATA) support
Date: Thu, 28 Mar 2024 16:39:05 -0400
Message-ID: <20240328203910.2370087-5-stefanha@redhat.com>
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

Delegate SEEK_HOLE/SEEK_DATA to device-mapper targets. The new
dm_seek_hole_data() callback allows target types to customize behavior.
The default implementation treats the target as all data with no holes.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/linux/device-mapper.h |  5 +++
 drivers/md/dm.c               | 68 +++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 82b2195efaca7..e89ebaab6507a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -161,6 +161,10 @@ typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
 typedef size_t (*dm_dax_recovery_write_fn)(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
 
+/* Like llseek(SEEK_HOLE/SEEK_DATA) */
+typedef loff_t (*dm_seek_hole_data)(struct dm_target *ti, loff_t offset,
+		int whence);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -210,6 +214,7 @@ struct target_type {
 	dm_dax_direct_access_fn direct_access;
 	dm_dax_zero_page_range_fn dax_zero_page_range;
 	dm_dax_recovery_write_fn dax_recovery_write;
+	dm_seek_hole_data seek_hole_data;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 56aa2a8b9d715..3c921bdbd17fc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3167,6 +3167,72 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	kfree(pools);
 }
 
+/* Default implementation for targets that do not implement the callback */
+static loff_t dm_blk_seek_hole_data_default(loff_t offset, int whence,
+		loff_t size)
+{
+	switch (whence) {
+	case SEEK_DATA:
+		if ((unsigned long long)offset >= size)
+			return -ENXIO;
+		return offset;
+	case SEEK_HOLE:
+		if ((unsigned long long)offset >= size)
+			return -ENXIO;
+		return size;
+	default:
+		return -EINVAL;
+	}
+}
+
+static loff_t dm_blk_do_seek_hole_data(struct dm_table *table, loff_t offset,
+		int whence)
+{
+	struct dm_target *ti;
+	loff_t end;
+
+	/* Loop when the end of a target is reached */
+	do {
+		ti = dm_table_find_target(table, offset >> SECTOR_SHIFT);
+		if (!ti)
+			return whence == SEEK_DATA ? -ENXIO : offset;
+
+		end = (ti->begin + ti->len) << SECTOR_SHIFT;
+
+		if (ti->type->seek_hole_data)
+			offset = ti->type->seek_hole_data(ti, offset, whence);
+		else
+			offset = dm_blk_seek_hole_data_default(offset, whence, end);
+
+		if (whence == SEEK_DATA && offset == -ENXIO)
+			offset = end;
+	} while (offset == end);
+
+	return offset;
+}
+
+static loff_t dm_blk_seek_hole_data(struct block_device *bdev, loff_t offset,
+		int whence)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	struct dm_table *table;
+	int srcu_idx;
+	loff_t ret;
+
+	if (dm_suspended_md(md))
+		return -EAGAIN;
+
+	table = dm_get_live_table(md, &srcu_idx);
+	if (!table)
+		return -EIO;
+
+	ret = dm_blk_do_seek_hole_data(table, offset, whence);
+
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
 struct dm_pr {
 	u64	old_key;
 	u64	new_key;
@@ -3493,6 +3559,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.getgeo = dm_blk_getgeo,
 	.report_zones = dm_blk_report_zones,
 	.pr_ops = &dm_pr_ops,
+	.seek_hole_data = dm_blk_seek_hole_data,
 	.owner = THIS_MODULE
 };
 
@@ -3502,6 +3569,7 @@ static const struct block_device_operations dm_rq_blk_dops = {
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
+	.seek_hole_data = dm_blk_seek_hole_data,
 	.owner = THIS_MODULE
 };
 
-- 
2.44.0

