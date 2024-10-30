Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135451E907A
	for <dm-devel@lists.linux.dev>; Wed, 30 Oct 2024 12:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730293087; cv=none; b=vDKPgbHv67Rchp7YARHD83U0LbNHvb5u8Yk2iY/mvXoMrEv++zS4gF9r3QQWQ7KFM5AZH/WmmC0XNJxBHriEBa4k/Hklx0pPWU6zRIqUwBY4XlSNnSbNMefmxFdik5bwQep9/bSBnKnp4X7tt6g+VS4QT8T1L9obn7LqLxKTuwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730293087; c=relaxed/simple;
	bh=m7WXx2z0qreCyA1FFnC2No4labI8I3muE/WCJ3rPoNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gJsQqIWnfRet62eIPS5hMngIlPWPYZMpUvWTdTIcYg7ShpL1sTnfsoUbIqn5mA9S9KH4WLIIlNyXY9GI6H8vcgiu3L6hhgzqy3a+US3apaLdGabF0eluLDAE1aRwHrRyJSTCJpsRgAPFc7x2UYKwFIiG6V8rw81XqDqoSpZdc6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tm1vsFej; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tm1vsFej"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730293084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yjOMKab4W5A1hCXnLQMqOuecsnyFsuLJQR73f/CaoW4=;
	b=Tm1vsFejI4LGJfwb5G4Jfpjo7I0y7bQGUyFDdITzKLMJJVxSe+K0LvwpXv8uhcRgFxWHhT
	NcuAuYEL+nU29ZHvf0rp+4eJz6ewGuGKO2SI7OYriduK0UF5dbhfmTuuEBfvB8yMZ+uty7
	YTzcvYruvFrGYRyXOJil1d9JerhcWro=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-51jl6EhCPfKadzRh5jR48A-1; Wed,
 30 Oct 2024 08:58:00 -0400
X-MC-Unique: 51jl6EhCPfKadzRh5jR48A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B5DC1955F25;
	Wed, 30 Oct 2024 12:57:59 +0000 (UTC)
Received: from bcodding.csb.redhat.com (unknown [10.22.58.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 020A619560A3;
	Wed, 30 Oct 2024 12:57:57 +0000 (UTC)
From: Benjamin Coddington <bcodding@redhat.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	dm-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org
Subject: [PATCH] dm: add support for get_unique_id
Date: Wed, 30 Oct 2024 08:57:56 -0400
Message-ID: <f3657efae72f9abb93d3169308052e77bf0dbad6.1730292757.git.bcodding@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This adds support to obtain a device's unique id through dm, similar to the
existing ioctl and persistent resevation handling.  We limit this to
single-target devices.

This enables knfsd to export pNFS SCSI luns that have been exported from
multipath devices.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
---
 drivers/md/dm.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 87bb90303435..e707b3f57f29 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3342,6 +3342,54 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	kfree(pools);
 }
 
+struct dm_unique_id {
+	u8 *id;
+	enum blk_unique_id type;
+};
+
+static int __dm_get_unique_id(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
+{
+	struct dm_unique_id *dmuuid = data;
+	const struct block_device_operations *fops = dev->bdev->bd_disk->fops;
+
+	if (fops->get_unique_id)
+		return fops->get_unique_id(dev->bdev->bd_disk, dmuuid->id, dmuuid->type);
+
+	return 0;
+}
+
+static int dm_blk_get_unique_id(struct gendisk *disk, u8 *id,
+		enum blk_unique_id type)
+{
+	struct mapped_device *md = disk->private_data;
+	struct dm_table *table;
+	struct dm_target *ti;
+	int ret = 0, srcu_idx;
+
+	struct dm_unique_id dmuuid = {
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
+	ret = ti->type->iterate_devices(ti, __dm_get_unique_id, &dmuuid);
+out:
+	dm_put_live_table(md, srcu_idx);
+	return ret;
+}
+
 struct dm_pr {
 	u64	old_key;
 	u64	new_key;
@@ -3667,6 +3715,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
 	.report_zones = dm_blk_report_zones,
+	.get_unique_id = dm_blk_get_unique_id,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
 };
@@ -3676,6 +3725,7 @@ static const struct block_device_operations dm_rq_blk_dops = {
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

