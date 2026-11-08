Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170910;
	b=X78CvxFBDRC/pAOzB5KLMlkE5jLs3YlXJ+CBwGYhFx3gdmddFgOS68NBbntRJD/VGf9o
	 nPNomnJmCoK/8YJji8AuyH8vQeH6x0hRvZ2JNe4YZHym98Cs49/kFki2zAWe6Tc2A17L8
	 rnmjU9fLZiFPGbXwTxjmDVkM7yQqeMf3WGeqmDoLLn4/M1eTfCb9h3E80N0zs4Dp6xkaP
	 Y77GjmnpSxnImlyNEHV6eIMp+2Tx8aiHy/Bgmvp0XvWZ9HwNuXoHrNCU3pyO2mQAg07Mz
	 gIfeVCJpdtJEqRNBzH6SQ5yWIB7s0N2YnuSVJ0AhlZzDTTel8E6CtMfz2pJlcaN6RcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170910;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U2xG8uBDS3ZX6a/oBks6CKUJxumAGYWP5iIhTx2myFE=;
	b=pX86cqZz9cbw/45GP04gVG9nUab/g4rrW81VeAYM0qsqv59zijKBeElCMJ0n/0OLlUuh
	 1xMRORyVvU2V7vHoB8zpgnMV/EpCB1g7VCv3FO7ecn31wETFZoOVpv0A5/fo0Kr6YJJm0
	 bYcOpmc59Q+9r/6e9mO+Z041l/2+NEfjiFNT8A6dIm6/EU0Ln2sH2P8OlrpFBYJCIF+5G
	 DnXsgHKRO5O3WkYO7QYzlCLCEaf5t3R8P6lBYZYYFaCry/hYs+5EQ3lf8J/N65eKkM5I5
	 JWLp9Gj6TjZAKv6AFip3wum260jbEQPFlATqChet3M1C2tWT+9GvoXRlZRpiuZW6UPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BBtI6KRw;
	arc=none smtp.remote-ip=95.215.58.180
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E9A606D80E
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1E9A606D80E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BBtI6KRw
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=H0+4Td4UmVtpFq6ZyOOwjEU0diM7bm7DIDQy7pV4k4k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170908; v=1; x=1794775708;
 b=BBtI6KRwD+LgJiIsK0tbzEbJR7XsAlORonJND3gVANNlrjgRXyd1H+m32fr7hZVUC4xoDS1p
 i4s7LfzLzOygTVkWCc25DuTs6H8vBPkpEKrrMR1Hypwz05btOwR/atXuAINj2ux4LsaHuQPWduz
 eYvMAEqwCdrmO6J9UfsKowEk=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id a74b715b38ffa497;
	Sun, 08 Nov 2026 20:48:26 +0000
X-Mizu-Trace-ID: a74b715b38ffa497
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
Subject: [PATCH v9 29/29] scsi: sd: add mpath_queue_depth dev attribute
Date: Sun,  8 Nov 2026 20:47:33 +0000
Message-ID: <20261108204733.557995-30-john.garry@linux.dev>
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

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5ea604c4bbb0..29ac1ee806c5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4178,9 +4178,28 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.0

