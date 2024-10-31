Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDD619C552
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387222; cv=none; b=Ru8OL6VDgsnRm2h3MLGNJInKHQGdRVd1awQKhgCC8GRMyYIeMKrMVj73OQi0DQce8kK3pggC9rWrJqmNly6H5IS73Kt/cNOrGhVx4Fc9rHtQQnGs8fLreGu2MasfTUvXcSrMNc2Zvapf9GRk7nIp7e3GTZ5+4uiTgghJJAbH3UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387222; c=relaxed/simple;
	bh=h2EeO+RDrnIsPHyYE0q67DkKeZA7IVsjRSvZ1TyeRsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i/lfi8uasSfwH7zE17rkVFhRFcTe69DsAHf7YBqKkpOlnwBZDIpys17Aip+3FVPNAJQ23H+NDGEWXnYu/G93COY1a+vdX1myEi5vaZ5uDMs8T2J6ANYVpQwrvogDJYrsNFYtBYontMVXeLtdsQ8toGva3ONi65VgnJbvTeO30GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TGLVT9nF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TGLVT9nF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730387218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zW1p1Hk2ATUzKb/rrzNSAt+zs2hNmejNsvS9zd6KgUs=;
	b=TGLVT9nF8D3bZw5ecsNNfpVguzPl9qls3N9isKVV0nAHYJYFlpqRJpb+4d1ImUZKN9okIA
	iVgguAfd9FoG4jd9oXTaBjTxmI+/wFtC+0BhUkJjBVNb5YVVaLal8O81joldOAJVYaTE/j
	HQuHiDQGxZhgOhTOzoG+Szo8wSPmRpc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-6H7ozxj9PNi7pSjP5mZ0Pg-1; Thu,
 31 Oct 2024 11:06:53 -0400
X-MC-Unique: 6H7ozxj9PNi7pSjP5mZ0Pg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 058B019540F3;
	Thu, 31 Oct 2024 15:06:51 +0000 (UTC)
Received: from bcodding.csb.redhat.com (unknown [10.22.58.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C9EF919560A2;
	Thu, 31 Oct 2024 15:06:49 +0000 (UTC)
From: Benjamin Coddington <bcodding@redhat.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	dm-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org
Subject: [PATCH v2] dm: add support for get_unique_id
Date: Thu, 31 Oct 2024 11:06:48 -0400
Message-ID: <701894fdf55ce2cb379eb26f6ee0536f96103ab9.1730387019.git.bcodding@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This adds support to obtain a device's unique id through dm, similar to the
existing ioctl and persistent resevation handling.  We limit this to
single-target devices.

This enables knfsd to export pNFS SCSI luns that have been exported from
multipath devices.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>

---
V2: style, add a comment about sanity, strip "uuid" from variable names

---
 drivers/md/dm.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 87bb90303435..ee97e23ffffc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3342,6 +3342,59 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	kfree(pools);
 }
 
+struct dm_blkdev_id {
+	u8 *id;
+	enum blk_unique_id type;
+};
+
+static int __dm_get_unique_id(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
+{
+	struct dm_blkdev_id *dm_id = data;
+	const struct block_device_operations *fops = dev->bdev->bd_disk->fops;
+
+	if (!fops->get_unique_id)
+		return 0;
+
+	return fops->get_unique_id(dev->bdev->bd_disk, dm_id->id, dm_id->type);
+}
+
+/*
+ * Allow access to get_unique_id() for the first device returning a
+ * non-zero result.  Reasonable use expects all devices to have the
+ * same unique id.
+ */
+static int dm_blk_get_unique_id(struct gendisk *disk, u8 *id,
+		enum blk_unique_id type)
+{
+	struct mapped_device *md = disk->private_data;
+	struct dm_table *table;
+	struct dm_target *ti;
+	int ret = 0, srcu_idx;
+
+	struct dm_blkdev_id dm_id = {
+		.id = id,
+		.type = type,
+	};
+
+	table = dm_get_live_table(md, &srcu_idx);
+	if (!table || !dm_table_get_size(table))
+		goto out;
+
+	/* We only support devices that have a single target */
+	if (table->num_targets != 1)
+		goto out;
+	ti = dm_table_get_target(table, 0);
+
+	if (!ti->type->iterate_devices)
+		goto out;
+
+	ret = ti->type->iterate_devices(ti, __dm_get_unique_id, &dm_id);
+out:
+	dm_put_live_table(md, srcu_idx);
+	return ret;
+}
+
 struct dm_pr {
 	u64	old_key;
 	u64	new_key;
@@ -3667,6 +3720,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
 	.report_zones = dm_blk_report_zones,
+	.get_unique_id = dm_blk_get_unique_id,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
 };
@@ -3676,6 +3730,7 @@ static const struct block_device_operations dm_rq_blk_dops = {
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
+	.get_unique_id = dm_blk_get_unique_id,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
 };

base-commit: 98f7e32f20d28ec452afb208f9cffc08448a2652
-- 
2.47.0

