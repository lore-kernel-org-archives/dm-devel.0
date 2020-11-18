Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45406C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 08:52:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5345620719
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 08:52:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5345620719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-M-Q0dXT0MRGpSDGIB7kD3w-1; Wed, 18 Nov 2020 03:52:14 -0500
X-MC-Unique: M-Q0dXT0MRGpSDGIB7kD3w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAE6459;
	Wed, 18 Nov 2020 08:52:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ACD5B6EF58;
	Wed, 18 Nov 2020 08:52:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8576C5A0FF;
	Wed, 18 Nov 2020 08:52:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AI8q097019151 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 03:52:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2A792218DA45; Wed, 18 Nov 2020 08:52:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 259AC2014E1B
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 08:52:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FF56811E76
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 08:52:00 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-103-Y3017Ug7Pqu_c9HVoE4QNA-1; Wed, 18 Nov 2020 03:51:58 -0500
X-MC-Unique: Y3017Ug7Pqu_c9HVoE4QNA-1
Received: from [2001:4bb8:18c:31ba:32b1:ec66:5459:36a] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kfJ8Q-0007lQ-JE; Wed, 18 Nov 2020 08:48:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 18 Nov 2020 09:47:47 +0100
Message-Id: <20201118084800.2339180-8-hch@lst.de>
In-Reply-To: <20201118084800.2339180-1-hch@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: [dm-devel] [PATCH 07/20] init: refactor name_to_dev_t
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Split each case into a self-contained helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/genhd.h |   7 +-
 init/do_mounts.c      | 183 +++++++++++++++++++++---------------------
 2 files changed, 91 insertions(+), 99 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 22f5b9fd96f8bf..ca5e356084c353 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -388,18 +388,13 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
 }
 #endif /* CONFIG_SYSFS */
 
+dev_t blk_lookup_devt(const char *name, int partno);
 #ifdef CONFIG_BLOCK
 void printk_all_partitions(void);
-dev_t blk_lookup_devt(const char *name, int partno);
 #else /* CONFIG_BLOCK */
 static inline void printk_all_partitions(void)
 {
 }
-static inline dev_t blk_lookup_devt(const char *name, int partno)
-{
-	dev_t devt = MKDEV(0, 0);
-	return devt;
-}
 #endif /* CONFIG_BLOCK */
 
 #endif /* _LINUX_GENHD_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index b5f9604d0c98a2..aef2f24461c7f1 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -90,7 +90,6 @@ static int match_dev_by_uuid(struct device *dev, const void *data)
 	return 0;
 }
 
-
 /**
  * devt_from_partuuid - looks up the dev_t of a partition by its UUID
  * @uuid_str:	char array containing ascii UUID
@@ -186,7 +185,83 @@ static int match_dev_by_label(struct device *dev, const void *data)
 
 	return 0;
 }
-#endif
+
+static dev_t devt_from_partlabel(const char *label)
+{
+	struct device *dev;
+	dev_t devt = 0;
+
+	dev = class_find_device(&block_class, NULL, label, &match_dev_by_label);
+	if (dev) {
+		devt = dev->devt;
+		put_device(dev);
+	}
+
+	return devt;
+}
+
+static dev_t devt_from_devname(const char *name)
+{
+	dev_t devt = 0;
+	int part;
+	char s[32];
+	char *p;
+
+	if (strlen(name) > 31)
+		return 0;
+	strcpy(s, name);
+	for (p = s; *p; p++) {
+		if (*p == '/')
+			*p = '!';
+	}
+
+	devt = blk_lookup_devt(s, 0);
+	if (devt)
+		return devt;
+
+	/*
+	 * Try non-existent, but valid partition, which may only exist after
+	 * opening the device, like partitioned md devices.
+	 */
+	while (p > s && isdigit(p[-1]))
+		p--;
+	if (p == s || !*p || *p == '0')
+		return 0;
+
+	/* try disk name without <part number> */
+	part = simple_strtoul(p, NULL, 10);
+	*p = '\0';
+	devt = blk_lookup_devt(s, part);
+	if (devt)
+		return devt;
+
+	/* try disk name without p<part number> */
+	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
+		return 0;
+	p[-1] = '\0';
+	return blk_lookup_devt(s, part);
+}
+#endif /* CONFIG_BLOCK */
+
+static dev_t devt_from_devnum(const char *name)
+{
+	unsigned maj, min, offset;
+	dev_t devt = 0;
+	char *p, dummy;
+
+	if (sscanf(name, "%u:%u%c", &maj, &min, &dummy) == 2 ||
+	    sscanf(name, "%u:%u:%u:%c", &maj, &min, &offset, &dummy) == 3) {
+		devt = MKDEV(maj, min);
+		if (maj != MAJOR(devt) || min != MINOR(devt))
+			return 0;
+	} else {
+		devt = new_decode_dev(simple_strtoul(name, &p, 16));
+		if (*p)
+			return 0;
+	}
+
+	return devt;
+}
 
 /*
  *	Convert a name into device number.  We accept the following variants:
@@ -218,101 +293,23 @@ static int match_dev_by_label(struct device *dev, const void *data)
  *	name contains slashes, the device name has them replaced with
  *	bangs.
  */
-
 dev_t name_to_dev_t(const char *name)
 {
-	char s[32];
-	char *p;
-	dev_t res = 0;
-	int part;
-
+	if (strcmp(name, "/dev/nfs") == 0)
+		return Root_NFS;
+	if (strcmp(name, "/dev/cifs") == 0)
+		return Root_CIFS;
+	if (strcmp(name, "/dev/ram") == 0)
+		return Root_RAM0;
 #ifdef CONFIG_BLOCK
-	if (strncmp(name, "PARTUUID=", 9) == 0) {
-		name += 9;
-		res = devt_from_partuuid(name);
-		if (!res)
-			goto fail;
-		goto done;
-	} else if (strncmp(name, "PARTLABEL=", 10) == 0) {
-		struct device *dev;
-
-		dev = class_find_device(&block_class, NULL, name + 10,
-					&match_dev_by_label);
-		if (!dev)
-			goto fail;
-
-		res = dev->devt;
-		put_device(dev);
-		goto done;
-	}
+	if (strncmp(name, "PARTUUID=", 9) == 0)
+		return devt_from_partuuid(name + 9);
+	if (strncmp(name, "PARTLABEL=", 10) == 0)
+		return devt_from_partlabel(name + 10);
+	if (strncmp(name, "/dev/", 5) == 0)
+		return devt_from_devname(name + 5);
 #endif
-
-	if (strncmp(name, "/dev/", 5) != 0) {
-		unsigned maj, min, offset;
-		char dummy;
-
-		if ((sscanf(name, "%u:%u%c", &maj, &min, &dummy) == 2) ||
-		    (sscanf(name, "%u:%u:%u:%c", &maj, &min, &offset, &dummy) == 3)) {
-			res = MKDEV(maj, min);
-			if (maj != MAJOR(res) || min != MINOR(res))
-				goto fail;
-		} else {
-			res = new_decode_dev(simple_strtoul(name, &p, 16));
-			if (*p)
-				goto fail;
-		}
-		goto done;
-	}
-
-	name += 5;
-	res = Root_NFS;
-	if (strcmp(name, "nfs") == 0)
-		goto done;
-	res = Root_CIFS;
-	if (strcmp(name, "cifs") == 0)
-		goto done;
-	res = Root_RAM0;
-	if (strcmp(name, "ram") == 0)
-		goto done;
-
-	if (strlen(name) > 31)
-		goto fail;
-	strcpy(s, name);
-	for (p = s; *p; p++)
-		if (*p == '/')
-			*p = '!';
-	res = blk_lookup_devt(s, 0);
-	if (res)
-		goto done;
-
-	/*
-	 * try non-existent, but valid partition, which may only exist
-	 * after revalidating the disk, like partitioned md devices
-	 */
-	while (p > s && isdigit(p[-1]))
-		p--;
-	if (p == s || !*p || *p == '0')
-		goto fail;
-
-	/* try disk name without <part number> */
-	part = simple_strtoul(p, NULL, 10);
-	*p = '\0';
-	res = blk_lookup_devt(s, part);
-	if (res)
-		goto done;
-
-	/* try disk name without p<part number> */
-	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
-		goto fail;
-	p[-1] = '\0';
-	res = blk_lookup_devt(s, part);
-	if (res)
-		goto done;
-
-fail:
-	return 0;
-done:
-	return res;
+	return devt_from_devnum(name);
 }
 EXPORT_SYMBOL_GPL(name_to_dev_t);
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

