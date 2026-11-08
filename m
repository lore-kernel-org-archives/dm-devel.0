Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.83
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170908;
	b=qeGLpg9fx6Vxu5ueLq919YUUKQ/NUPgfqx/vHg3nvUzJzrhcbwtM85zzRpG32/wx5ZPM
	 bgy5PlH/3oUH22/RBvyvdrBWwLbcKJLXFS2CRpOxNgD6jQejjcnKMCG3NtqvYBMJEeX/U
	 RvUGZPdU+GoBQ51ZWd3YUawkwJofNyxr+FYOIlRMc5SwhTxbxJMeAcHHAbB1ooCmM62fy
	 HAQoRpn/GfLwm/LIZDP8qdMpmnmAMwAHUCmE/6m0CqYtEEaLh/MfLevRCJSnxyEGJncKF
	 rhaTQSxuNICvPmV7YieGAi+0lF/76PhjfAmo47t0guV6v/57QvJT+nRrCVqpvONXT5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170908;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aLBSphUPpkQSmk/BQU8w4WnHJtgwOWRaiwq4m3R70Zc=;
	b=Et1qgT/fnAk8SFHiyVflBIMl9JBwxA8IM8JRKyNsMqj95SGi3hcMfUaSRwcghsGadmBj
	 eywxRKoBfbm4zQMzk0xWRmpqEvMNBvOm+V+3dNWWY7yKBTrGT7VXp4qz5PTr29Z2aZhgi
	 SqOoXZNXMvau2sbSwMwXEPJl6x+s2Ha/smDLs2ZygD0jXRMp7gK/1glskNVfzkg2kyddF
	 SVw0BE0eTkREHfsR319htxetax6h3LnCs8QwsEN//Wr3Ma+3Zsd4nG/THIdKv7y5QhLvl
	 HBpitftCV1t3V+3mKB5Xm6UvtD7pdNPhrNMipKHnOZ9xjc2XmjCWviQCMAYHVX4cOPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CuTd5rkN;
	arc=none smtp.remote-ip=91.218.175.83
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B13606D80B
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23B13606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CuTd5rkN
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yUyDco5Tbx6PoduIOfYi9iHiRgOj0lG9rUJG6HkMHEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170906; v=1; x=1794775706;
 b=CuTd5rkNsbW27Id7uZBFk7XgMqScOKbnoGAu7ZTJ1i8d3IwtTjQcEBSRZF/H5PRAafYOBKeM
 DpAataKvwRUoeSPFfJ2MmuQRaTtAPwKYJExNrI3K/BmZ2naPhy1q3jS/NLuNdGnNTC7RZ/684hF
 i7ZnqS3BmMmF3c2x+cv6ohYk=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 37ce54ce466a1928;
	Sun, 08 Nov 2026 20:48:25 +0000
X-Mizu-Trace-ID: 37ce54ce466a1928
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
Subject: [PATCH v9 28/29] scsi: sd: add mpath_numa_nodes dev attribute
Date: Sun,  8 Nov 2026 20:47:32 +0000
Message-ID: <20261108204733.557995-29-john.garry@linux.dev>
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

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8469feb9ba5f..5ea604c4bbb0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4165,8 +4165,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
 
+static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+
+	return mpath_numa_nodes_show(mpath_device, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.0

