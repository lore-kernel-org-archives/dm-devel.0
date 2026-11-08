Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170908;
	b=vK10WLbEfA3ya4PexMPZi45L12U8GY/CG5b7QycwSCrFul+RNNDyfewmUTdaShtaHWSS
	 Kgc3gcBbMzRZw0cFF6UUZasNcBpvKUvQxkueZG6lLXQX9YhNnebddF27UVEYumOI1FUFq
	 a+PLPjZJJC7j5zYdHyeCf3wewXEWv4RvvcnG1kFL/p3+deM+RBnMqLW/PTMDSCi5FYTWP
	 ldXpjqyVPG8ZOJRTcqXQ2OrJRE3p2eGwYpfPpI9h5n7Xc96iXQCtxt+qlMfXGSz2CinTj
	 2HCY/qLxqlw9jVTFC97RU9drn2QkEDahfDsr3sQq4eQoTxIBjj5jesuvLIKU3LMB45g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170908;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hgQyJUm3fD2hbrVKtDPbJw7PYul+RUHS+0oIlFRIqb8=;
	b=InUTQuVrT7FOS61yys6fe2dHi67yEU4EUeVxfe2cHfM41Iea1/4JTHbSVFtIM+RoxAYV
	 mWnEZSXaILLea+rHIuSd5DGPpXfABoBBM3pOj71Mhdc7EEhmIXb6idbFXSVqWJa1JsPwT
	 RyeFX0QwYsxp5BK89i2z5ScByxqUGZ3+uVeXMhFml2IXk9M4/QMQ6q4LTY/pLRNRy1syd
	 JBxopFdzEA0RAiX9bC0xezx+irACMO1qTixnUO+610yumDuDeDfd3TrYebI4qsKRyz5OV
	 I22cwpUyREbjPYEYhmmhLiPxc+Pj7T0RMrogyOTxUMElkDuF3imBfsuXWVTK1J0ouwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qN+Mijk0;
	arc=none smtp.remote-ip=95.215.58.172
Received: from mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F059B606A33D
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F059B606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qN+Mijk0
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GyT5fWgsqH1g3ZJJxZVOHEbN4qoGZGT9aB6YYU68Beg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170906; v=1; x=1794775706;
 b=qN+Mijk0hX3t2BiryFgzitSDoSr7DzS1Y7Cp1ojY/ySaup6dT7B24fIgcOaXLC1B00+5iOwj
 EA+pM2u2dTQaUrg6inXz4na8UcRJjupZ2KKiE+ErIN/VsvMEAF4JcaQG6lZcrGEWTprhQ6Ozv1Y
 B6M2rgra8AfZgLss21YjM+ho=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 6b66009fe5bd4c37;
	Sun, 08 Nov 2026 20:48:25 +0000
X-Mizu-Trace-ID: 6b66009fe5bd4c37
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 27/29] scsi: sd: add mpath_dev file
Date: Sun,  8 Nov 2026 20:47:31 +0000
Message-ID: <20261108204733.557995-28-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
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

Add a mpath_dev file so that the multipath disk can be looked up from
per-path scsi_disk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_disk is missing.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab4ce6c2a8dd..8469feb9ba5f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4124,6 +4124,77 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 	return 0;
 }
 
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct gendisk *disk;
+	char devt_str[13];
+	ssize_t ret = -EINVAL;
+
+	/*
+	 * This attr is for the per-path scsi_disk block device. We need to
+	 * handle the scenario that the multipath disk has been deleted and
+	 * the per-path scsi_disk (and its attr files) is still present.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk)
+		goto out_unlock;
+	if (!sd_mpath_disk->disk_count)
+		goto out_put_disk;
+
+	disk = mpath_head->disk;
+	/* A reference to this disk is held through sd_mpath_disk */
+	if (!disk || !test_bit(GD_ADDED, &disk->state))
+		goto out_put_disk;
+	format_dev_t(devt_str, disk_to_dev(disk)->devt);
+	ret = sysfs_emit(page, "%s\n", devt_str);
+out_put_disk:
+	sd_mpath_put_disk(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return ret;
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4405,6 +4476,8 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 	return 0;
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 
 /**
@@ -4557,7 +4630,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.0

