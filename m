Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170901;
	b=n49+ap/sTww8pb7T4l9Vwl6mN65DcaQZTF70P5xbeFovAdmWRauxTGcKL6WCXf1ODkCV
	 4foq7COIDn7xIM5FThwUBTkf5Xa95Jecac66VoV8+1Gh9nUsmc2vvc1izIRWHX2YZw1L5
	 HXRT2AFpWvmeFpQbbpdk8+pBpYg2f3uIcLfYK+u3/IGnlY1eFBIqrVqjL2YXTmJU2OxNR
	 ETr9iLRuJBgjcJU97zx+h6KTHsTdNP7kpfzSbYwpeva+68tnZphSK+aIoisn4oYO0ozMc
	 +AR3aQhwIesuZW3Swx5bR+QBmnO98l9f/DYMQMNFS6f5NJ8rxKlAQMFQ/ExAqasBu0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170901;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bg8FXpLHnbOeiNV48wfI35oG9d3WX/Hy47TPVM7dxC4=;
	b=RWoa5capmYgPkVczrpBKW9TwoeT2KpNeSvrdAwF1iFqOQHXOSu+yACix92XUw3Nhns0m
	 kUmO+37Rnll2t2keTPomZbP5pq85sjWabuWoZJ4GSRSEMy43Pu+w8wuGt5Hdm3G4ZgukD
	 Q72YpxDuTKdQNMqRzZu1pePEIu+l+vmvGQIM4nnKnbriyxRC6y4nPgX/EoEvPMC8In6dF
	 c/e3X52ka7y9k9EDsnPXnUeWP9ksyTU4TE78JU+8gTZk4dgpziOp1dJlrfg2+kXj4Gvjr
	 ZDU5LDDy/TG3HMPoNYrfYzyFkikRHHKGlx5TbSO561dKaJWl5eS9xtIcSMZAkfyZsTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vcxQBIGT;
	arc=none smtp.remote-ip=91.218.175.48
Received: from mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878D1606A330
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 878D1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vcxQBIGT
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=UyfHMX3gPf6wrmvanoi2cr7axUd6+M+2yQBxEJvHYJ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170898; v=1; x=1794775698;
 b=vcxQBIGTD+JRdf/eMc+16fxaDHKm+w0w/DUbOjsrA4Lq/DcEm8CCcbFcE739JXeGb3/8m64v
 Vb38AXeyPUswuiLgXNSwnBzfiHdCl4Prr5tptPKNGUD4AF7UpSsGiu2QFPArsFvxK6yldwzGNSB
 qyy/JwpgP7MGDH8WsxxRmysI=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 98e5f5536fe4272a;
	Sun, 08 Nov 2026 20:48:18 +0000
X-Mizu-Trace-ID: 98e5f5536fe4272a
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
Subject: [PATCH v9 19/29] scsi-multipath: failover handling
Date: Sun,  8 Nov 2026 20:47:23 +0000
Message-ID: <20261108204733.557995-20-john.garry@linux.dev>
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

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down.

For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

A bio which for which failover occurs is handled in
scsi_mpath_clone_end_io(). Failover is detected for blk_path_error()
occuring, same as how dm-mpath detects this.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 008bcafe73ad..4c965650c2bd 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -262,6 +262,20 @@ static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
 
+	if (clone->bi_status && blk_path_error(clone->bi_status)) {
+		struct mpath_head *mpath_head =
+				master_bio->bi_bdev->bd_disk->private_data;
+		unsigned long flags;
+
+		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+		bio_list_add(&mpath_head->requeue_list, master_bio);
+		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+		bio_put(clone);
+
+		mpath_schedule_requeue_work(mpath_head);
+		return;
+	}
+
 	master_bio->bi_status = clone->bi_status;
 	bio_put(clone);
 	bio_endio(master_bio);
-- 
2.43.0

