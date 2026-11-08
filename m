Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170897;
	b=1wh0+7x0scxRxFBIINxh8CmUnTl2Q1W6wq4jXk+9GV5X4P/g05dA2b5szvozOvm5vlYx
	 LCU2bDmB8KmaS72zRfzQohUwv1EBZuFJOpiXx7LTopZvXqS5Wccn9lVzMX49MC2vj4BwA
	 ObX0fuXFM1xPXzAsTj/HzZ1YCiOCu3ToGF5umVJNKqQ7vrfq025Tfa2FWIsylKaFOd6VR
	 jtL6QAgIvoWQxFUIleqv+vtwYVd/Rr4Oz40d+ACpxz+vO9u64uZtxqgSsSTEQo4ned5Rb
	 i/SXr9fc7gD3lrUzCB2Jw0tHnu53VGoXzFIiFVLiXeYsx6gGk+/a/FCmTIE05ER6PLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170897;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D+bQhpD+WSSIraJnCjz2Iq12MaRnWIXb3SJNp+9C77c=;
	b=lsmNF3qqaKxVKia4WX8pLIJO3tIGSYpU15tLPgTxUSvkpzJh7YhqRgrx39qj0rUIIMQ9
	 yFxJlFLktbhIRfhmO86W9XGbdQCr6LGutdYrdADYKGWsHZyl/xNPr29UjGXb2dWgt9I2Y
	 7KtzzVXkkRr3zrAcO9AK04QftFxVdGKRN/Cp9JpxZUe8z3Kvb2mNPVOxfH0ogrN84PkHD
	 nas1Psstz+EMprObuP11fT7H5Dxiylt7VyPmBXHZs8CNEG0rGH/37sz+/VWQ8P0TzB55G
	 VjIEPk8aSe8m1E3H/zv1qRYRcU9FCej4him/yl4JEeaS10mLw3KzHscwQ70bZvQdiEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cIGgOEoy;
	arc=none smtp.remote-ip=95.215.58.111
Received: from mta1.migadu.com (out-111.mta1.migadu.com [95.215.58.111])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F32A606D807
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F32A606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cIGgOEoy
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YyW1RuL9yvQgmJEET/4NGirmk+hqjG05wn7wJajP8N4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170895; v=1; x=1794775695;
 b=cIGgOEoy1ufqEv1YU0oMqMHdURHor9uWsg9yfLGSzxb1+8wuZOxyQYjl/+mJ0byfLzgqnYqf
 9X17K191+HjMh8TgVMs9vUdICWj2hBWxZSkyQWW0HAyLPBKOvNyhzJQHsUJIPseeG9zHJs/2R6X
 nb8Ql9bf69JXzocE4vsbkBA4=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id c1e933660bf6bd0f;
	Sun, 08 Nov 2026 20:48:15 +0000
X-Mizu-Trace-ID: c1e933660bf6bd0f
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
Subject: [PATCH v9 17/29] scsi-multipath: clear path when device is blocked
Date: Sun,  8 Nov 2026 20:47:21 +0000
Message-ID: <20261108204733.557995-18-john.garry@linux.dev>
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

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 10 ++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 36bc995e4e25..1950034f580f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_multipath.h>
 
 #include <trace/events/scsi.h>
 
@@ -3037,6 +3038,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 		scsi_stop_queue(sdev);
 
 	mutex_unlock(&sdev->state_mutex);
+	if ((err == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
 
 	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
 		  __func__, dev_name(&sdev->sdev_gendev), state);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 8e229357e62c..67e9010d5478 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -240,6 +240,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       if (mpath_clear_current_path(mpath_device))
+               mpath_synchronize(mpath_head);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d2ef94ebd29a..2064a3e92274 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -55,6 +55,7 @@ int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -99,5 +100,9 @@ static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
 {
 }
+static inline
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.0

