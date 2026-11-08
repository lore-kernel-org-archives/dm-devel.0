Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170902;
	b=3h0K/8NyvHDWe1+jFCvoS1bOUx8wCvJjiRdTNv/YcqmxgoAf8g7Ze4i8oYTCEG9gN9wb
	 y0sFLs0vDti0eBWFp2RbB0uXt5z1h3U508GjXCQa1ZfnFZAg7N0AW6dwajdc0PL4n02it
	 XisOpJG/wDho6Argu/LXhGKKgkBcLSsLPBB0UgIKfbpUAUa2lwGPu45Ga45AsSoAapgDx
	 9dwzL3WPR8hR3PHe383GCFK2YRmVZdlMiL1k+o7fEkpcOn/gL3Zt5pCNMd/LfDa9eISRG
	 nRYlTzXD3floQ8hmouieXVrYHYjVZq4grogo0TBmhso06rFL4eEo8nRipv8/RqWdKPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170902;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2nnhEenE0/1GT2EDac2uSW/ypInHmlgcoWTshjS2obA=;
	b=hOikw+dBh/mwwrOtAZQakRVHxYY9fgmw5MNU2n2c6KnxtJ68yaBkJ2T42+Qzpc3rm1N7
	 6FhDbN+75mHQTs0i7DvABuCokXffWrX2gbY9LVOK7K53MYEXl3dujpPGyz6+9YFDclWBt
	 78LSNPGOUq16usoMTNGmVMEM4vqo0wgh9td6atZl/xdxfiUmWKHYm4O7oBZaVh0OjvfKR
	 QqzwwlyyEhcKkn23Id7e6TffBhsN6u5qMvr0H7Gj/N8lyBsnUpHuxwa7YTERoyn1ZwlCf
	 JZB2kMYemfZZ7hemRJwHmSz9rQTBdmfTSN1S0lnRPWk8XGCPvzKpb1TQhgMGgC5ymOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=STCqHCKo;
	arc=none smtp.remote-ip=91.218.175.51
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9252C606D80D
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9252C606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=STCqHCKo
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pPiJo5YvvZwz+FSuNCP5LV5980zfLh166gCKBgUb8TU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170899; v=1; x=1794775699;
 b=STCqHCKooXiP/JFm9tRgW3k2K0EZRgZUzYpfsWJ/nZhmOi1NZ+x+eFysdDpxd0X+TvipCHrv
 /gW4YuE/qvdJCueQetYDDEYzWfKaUaAP3QmXi/e15EnooO37axtULx7Bs0syB5feEUrZaibzjFn
 +62QjsWOhnbO4EDrHG2uAPaY=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 3d3bbd98ebe99174;
	Sun, 08 Nov 2026 20:48:19 +0000
X-Mizu-Trace-ID: 3d3bbd98ebe99174
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
Subject: [PATCH v9 20/29] scsi-multipath: provide callbacks for path state
Date: Sun,  8 Nov 2026 20:47:24 +0000
Message-ID: <20261108204733.557995-21-john.garry@linux.dev>
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

Provide callbacks for .is_disabled, .is_optimized, and .available_path.

These all use scsi_device.sdev_state and scsi_device.access_state.

Member scsi_device.access_state will be driven by ALUA. Currently
only device handlers support this, and in future we will have core
SCSI support for implicit ALUA (not relying on device handlers).

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 4c965650c2bd..2f47c39d8293 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -298,7 +298,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
 	return clone;
 }
 
+static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
+		return true;
+
+	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
+	    access_state == SCSI_ACCESS_STATE_ACTIVE)
+		return false;
+
+	return true;
+}
+
+static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
+		return false;
+
+	return access_state == SCSI_ACCESS_STATE_OPTIMAL;
+}
+
+static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	enum scsi_device_state sdev_state = READ_ONCE(sdev->sdev_state);
+
+	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
+	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
+		return true;
+
+	return false;
+}
+
 static struct mpath_head_template smpdt = {
+	.is_disabled = scsi_mpath_is_disabled,
+	.is_optimized = scsi_mpath_is_optimized,
+	.available_path = scsi_mpath_available_path,
 	.clone_bio = scsi_mpath_clone_bio,
 };
 
-- 
2.43.0

