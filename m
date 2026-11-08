Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170886;
	b=lf5RCcXyvL/rxhaT+AxY6id4rHYw5sJZJp/M7gSOETt5aLfZDcPpQLdql/BUmPLCB2Zd
	 GvepsqD7bpoe1frHBKRPq9OREiI5YhCIM8h+fnd/LQ58rflPk+7FobkIrpa3j9JuJDrw2
	 lJX4WUvrnZYUVLgUDCf+AgpLrH3ZMe8H4LEg+7MoZlqMrdbLOtMxM0d59C3RQ3QV+JU0p
	 T/SuKE2WaTVS3hs7/wnpxKDEzupnCRUV597LSxxrX7Fjl+CwAyM55C320i0gB+7vyrunk
	 pGrv+1TYjQpRAtp2CjJDxwZAQ7r0jAabzVG3VPQk8HB1lIJTIgJW0cGmWguhfnSG0rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170886;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oOyPSLk+GrgEBerLslrKlUTAOuWXuUUSVo0ysXdvyrQ=;
	b=vxkK1gYISLEeQep4Dr0oxdWRpl6wC1FSkG0689SloaSO/oPN1v+NniXs6bE+b1cMULZN
	 ecFED1WhM22ipcF1Ojnwqf5r+fsYHWw2AW0gLCt76eCIHeWYYnofw8ZCAZyRW/CY0bat/
	 MS22yUI0b5yZlc0WfHBkYIQEKgrS+Ht98tmPtfjO9p830P4lgjV1q1PsRl3tSoH0AabNC
	 KB/GeBwWg5M7XogewgB4DD+SwmF/ddkTASR7B/phHc36nwToQUvDK10JTMstA1Q3pjeD7
	 GSLesqy+YEFU6fWrjxwfIEKdDVr1OfV2+FN9DijuLS/qFDb9DSYpy+lBv7jlKaIkGDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vXzF4kKT;
	arc=none smtp.remote-ip=91.218.175.5
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E82606D813
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85E82606D813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vXzF4kKT
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=A5vtG0AAOU2USuDE74SFeoHqv0A6nD9sPzQHbB7H7SM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170883; v=1; x=1794775683;
 b=vXzF4kKTZu6A+xwg7ZBmZAh4VXOvtgllgjDS/xRaEoIhGeXSZ3LZOb38RZGqoesxCH5alzU4
 +qmft+LSea2+e5dN8qS6YQWk7Ey0oyUxbpIQ1QZZUQ8+ADe6veapa4ymgYx6d41kgRqBv12ixup
 QCUidBtIM5xnGQThCCtfEmQk=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 229adb54fd34a1a5;
	Sun, 08 Nov 2026 20:48:03 +0000
X-Mizu-Trace-ID: 229adb54fd34a1a5
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
Subject: [PATCH v9 09/29] libmultipath: Add support for block device IOCTL
Date: Sun,  8 Nov 2026 20:47:13 +0000
Message-ID: <20261108204733.557995-10-john.garry@linux.dev>
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

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index ae5a73d570b3..d59d7ba81087 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -455,11 +455,53 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+
+	/*
+	 * This check is duplicated from sd_ioctl() as we don't pass the
+	 * partition bdev to fops->ioctl. That is not yet possible as the
+	 * per-path disk is hidden and, as such, does not have partitions
+	 * scanned.
+	 */
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
+		return -ENOIOCTLCMD;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (!mpath_device->disk->fops->ioctl) {
+		err = -ENOTTY;
+		goto out_unlock;
+	}
+
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	/*
+	 * Both NVMe and SCSI use generic blkdev_compat_ptr_ioctl, so would
+	 * avoid their custom compat_ioctl implementation.
+	 */
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.0

