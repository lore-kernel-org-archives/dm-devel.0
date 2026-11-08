Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170904;
	b=N2kB8spV6nY2MkNEG7+Egw/7nSVmzuT1Rswlr+bhWcM4lsXdrrk/MV4JZepJfidSO6p0
	 /m+4TkBfEeSZ97s33UJ+aMh1uUl3/D2JVSo6QUqwTS4sxLpA0wrKui7XUnFlQZiYsekDn
	 FPGVKp2kXuozdtyxjewk/UCJ6oBza8Z4/HOurUP2qUbwYKGFp5DJZqorayhxHX54FVZCd
	 l2XZSmIqsH5/iOtVTK3GW7dAcR318ccBFEtDyzVlk3pa9HgAdD5bE4P7Y+IZNI2VlXIbb
	 dxedg2fL6dt52IAKBdh19Dj933YZcVopdOibTglYcyMMi3wJGJN6XnBlbXcTLJyJ0vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170904;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hCwRFUq2iDoZLi7clY/PuGBmmvq7M0hE+90qPhgsKN4=;
	b=XtjzNQYCyH3xlCxMlMKAzhmQXRXH/+qJSCWrDyKNGNW8EgxhnAiZy8NqfOh8nCUIcSmK
	 Ao51jOkIfXQfbmoUWVjioMyxr3NDNTaVOVpaFdB903CQOkR9Pvj8TpKlseWb3LISDUzxL
	 Z//qkBC4SNAggMfoozV+yuibR7HrxrR9BBVsiGzvPKBEm6PbpM+BbijPWozsBh+hEbHa6
	 HYgBH08X4nCWRE5vzIbvXFCTyzYch7vS/X6HaO45Aq7jtRbo0ATOUzqpTQYov15apkdxb
	 0J6FSKgvV7c9CAWmH9AuqwRYQFBjff6B8MSb8ONNkUREAGmSXYTv3PYPtM689TCa3rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bxX8Kb77;
	arc=none smtp.remote-ip=95.215.58.145
Received: from mta1.migadu.com (out-145.mta1.migadu.com [95.215.58.145])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B433606D807
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B433606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bxX8Kb77
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yrAIksUYEXTflpjgfac/bXgq6WaL9u4UCyIJD0wmCl0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170902; v=1; x=1794775702;
 b=bxX8Kb77ZDouS+L26RbpayQDxxmDsZkvPde/WUsTfOoG8SGWhRz5qS6FkGJl9nKmsKebbo5O
 y9Wh1LQZ5SvMN6+1kjU1L29H5QX7m4tk+bCHpqRJLUJ5spkRHR36evIR9nDlUIw/gvdg/sMhqYM
 1lnTF+VP4Mlu2VDTjOIuBr4Q=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 126689d4dbf56e8a;
	Sun, 08 Nov 2026 20:48:22 +0000
X-Mizu-Trace-ID: 126689d4dbf56e8a
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
Subject: [PATCH v9 23/29] scsi-multipath: add delayed disk removal support
Date: Sun,  8 Nov 2026 20:47:27 +0000
Message-ID: <20261108204733.557995-24-john.garry@linux.dev>
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

Add support in core code for delayed disk removal support. In this, the
callback calls into the scsi_driver to do the necessary removal work.

The scsi_disk driver (sd) must ensure that the scsi_mpath_device does not
go away while the delayed removal work is active, i.e. it must keep a
reference.

No reference to the scsi_disk multipath structures are kept outside that
driver, so that driver needs to provide a scsi_driver.mpath_remove_head
callback to do the necessary work.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 27 +++++++++++++++++++++++++++
 include/scsi/scsi_driver.h    |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index bec6dd94f3be..58b0be88a952 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -344,7 +344,34 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
 	return false;
 }
 
+static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
+
+	if (scsi_driver->mpath_remove_head)
+		scsi_driver->mpath_remove_head(scsi_mpath_head);
+
+	return 0;
+}
+
+static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
+{
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+
+	/*
+	 * scsi_mpath_remove_head_drv() could drop the final reference to
+	 * scsi_mpath_head, meaning that we pass a free'd pointer further
+	 * drivers - take a reference so that won't happen.
+	 */
+	scsi_mpath_get_head(scsi_mpath_head);
+	bus_for_each_drv(&scsi_bus_type, NULL, scsi_mpath_head,
+		scsi_mpath_remove_head_drv);
+	scsi_mpath_put_head(scsi_mpath_head);
+}
+
 static struct mpath_head_template smpdt = {
+	.remove_head = scsi_mpath_remove_head_work,
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
 	.available_path = scsi_mpath_available_path,
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 249cea724abd..d92b63d357f2 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -8,6 +8,7 @@
 
 struct module;
 struct request;
+struct scsi_mpath_head;
 
 struct scsi_driver {
 	struct device_driver	gendrv;
@@ -22,6 +23,9 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	#ifdef CONFIG_SCSI_MULTIPATH
+	void (*mpath_remove_head)(struct scsi_mpath_head *);
+	#endif
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
2.43.0

