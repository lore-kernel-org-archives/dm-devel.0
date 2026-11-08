Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170906;
	b=nTHxP3qm08GVEieTiO+ZVxw0rHHNY7eI2ipJNHYiyXN/PKblhlzWmHM3th4q06jRAa3q
	 D8+pTyLkLK4gzo8lN1c/nMjytOQHGAJ5iaOc6calJas5eGr6aYOgzDmSpfhoHJswnG1Os
	 cDHw8CCVI1rHuszKJsoMnpUPaSxsGR7nnaRCTN73LiLWmMgNxygLcXOC32gFebKiwJbyz
	 gjDBRh07ZVrPEyLnOBoIAqQqbamOfNlUUYYckjzXhpJu4DsBuUixqjs2zHgt5zOfuZuC+
	 CSda7wisRHvkovZCyg4/1+rkWpSc4bTx6yGJ/tSGjM469QIMyRMUdnJGZvdWUopJZDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170906;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NH++uILCmGMzLfbUG6KWi5pvlPjSfnXwM7WYlgTEACw=;
	b=DWmYjJnAIjRjdEFCE6CZwXsGxC0+0v2Qtfgaz8wISwNDRJGdCcx4aYrTpw7D4vdX24ZS
	 MUPYMlF8C9ukMzFY9K39SptvxV5NKHEHybQ//LgtRya0GQAvMvueTXgMIkj4t1oJBcyq4
	 9puvTEFrWf4deizDU9YnKqaYJcrSbcfONCpto26G2UelyV+UX1zAsytsudhbkdg3tNI42
	 EnoL/cbGDzRW5YluEAOhAMkmQFbtTnjQFoOv8K5hK5xq6whcbBp4nsIjXwA5peuzvUZck
	 kuGEsJpHSgg276h9JgTIuf074W/BCXjm7Hxaavi73nB8PmJ0z3b2qXEN4n7SNRjPZ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=C8hpQrZA;
	arc=none smtp.remote-ip=91.218.175.74
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EBB606D827
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:48:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9EBB606D827
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=C8hpQrZA
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PRPDmf+VsuCuxp7vixvF6VpbQfdLH9H9PmqoKRZH3W4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170903; v=1; x=1794775703;
 b=C8hpQrZAEkeq7E/OeqAxa4Q4ynhVZ57/Xj/R8r8A5PySwT1Zv6HLm2fot6jH0m2BY+6BSCFi
 rNjUZLDKAw4Cqy3OngjfUGvFBvTAvE61LhvVk70K6KPlNl0SnXW6JoIyke10+RqY2VRbImw1DWC
 hqYc+aS2WXAqsG4EFDqk1rWQ=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 042d4a44635e17aa;
	Sun, 08 Nov 2026 20:48:23 +0000
X-Mizu-Trace-ID: 042d4a44635e17aa
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
Subject: [PATCH v9 25/29] scsi: sd: add multipath disk attr groups
Date: Sun,  8 Nov 2026 20:47:29 +0000
Message-ID: <20261108204733.557995-26-john.garry@linux.dev>
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

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 03617029a552..fb87b1663ad6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4021,6 +4021,42 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
+}
+
+static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_show(mpath_head, buf);
+}
+
+static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
+		sd_mpath_device_delayed_removal_show,
+		sd_mpath_device_delayed_removal_store);
+
+static struct attribute *sd_mpath_disk_attrs[] = {
+	&dev_attr_delayed_removal_secs.attr,
+	NULL
+};
+
+static const struct attribute_group sd_mpath_disk_attr_group = {
+	.attrs		= sd_mpath_disk_attrs,
+};
+
+__maybe_unused
+static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
+	&sd_mpath_disk_attr_group,
+	&mpath_attr_group,
+	NULL
+};
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
-- 
2.43.0

