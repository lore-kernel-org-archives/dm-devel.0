Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FD1C7EE2E
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 08:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832201;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QpdZAn3AH3RVGhGKv7zqMrO6A+FoLqglumOCtqxyhpE=;
	b=TMJzhOW/WT/h6uLcmWzKNOz9vusZFRA0lPfBhYvEDcaG4weqneCqmylX2DMcqW1GYLWA2q
	1QJHGdGI1anw3m1Eie05yw7Efo69dcZ0APhqfh1hyTswF2TvPDCqev9PmHTLPos1gHnWJl
	635X0gsaWEQeUDCCa00xS0teerallkM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-J9yscAKAO4OMD5QCR4SuFw-1; Tue, 23 May 2023 04:56:38 -0400
X-MC-Unique: J9yscAKAO4OMD5QCR4SuFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF4628007D9;
	Tue, 23 May 2023 08:56:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AEE5340CFD45;
	Tue, 23 May 2023 08:56:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8871419465A0;
	Tue, 23 May 2023 08:56:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 80C321946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:56:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6DAE1140E961; Tue, 23 May 2023 08:56:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66558140E95D
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:56:35 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BA7F3802617
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:56:35 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-4bXpW2GZOIOgrsT6-grLfw-1; Tue, 23 May 2023 04:56:33 -0400
X-MC-Unique: 4bXpW2GZOIOgrsT6-grLfw-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1MiC-009GTv-0t; Tue, 23 May 2023 07:45:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:12 +0200
Message-Id: <20230523074535.249802-2-hch@lst.de>
In-Reply-To: <20230523074535.249802-1-hch@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 01/24] driver core: return bool from
 driver_probe_done
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

bool is the most sensible return value for a yes/no return.  Also
add __init as this funtion is only called from the early boot code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/dd.c             | 6 ++----
 include/linux/device/driver.h | 2 +-
 init/do_mounts.c              | 2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9c09ca5c4ab68e..878aa7646b37e4 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -751,14 +751,12 @@ static int really_probe_debug(struct device *dev, struct device_driver *drv)
  *
  * Should somehow figure out how to use a semaphore, not an atomic variable...
  */
-int driver_probe_done(void)
+bool __init driver_probe_done(void)
 {
 	int local_probe_count = atomic_read(&probe_count);
 
 	pr_debug("%s: probe_count = %d\n", __func__, local_probe_count);
-	if (local_probe_count)
-		return -EBUSY;
-	return 0;
+	return !local_probe_count;
 }
 
 /**
diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index c244267a67443e..7738f458995fba 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -126,7 +126,7 @@ int __must_check driver_register(struct device_driver *drv);
 void driver_unregister(struct device_driver *drv);
 
 struct device_driver *driver_find(const char *name, const struct bus_type *bus);
-int driver_probe_done(void);
+bool __init driver_probe_done(void);
 void wait_for_device_probe(void);
 void __init wait_for_init_devices_probe(void);
 
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 811e94daf0a84a..2fe7901b5bcfaf 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -635,7 +635,7 @@ void __init prepare_namespace(void)
 	if ((ROOT_DEV == 0) && root_wait) {
 		printk(KERN_INFO "Waiting for root device %s...\n",
 			saved_root_name);
-		while (driver_probe_done() != 0 ||
+		while (!driver_probe_done() ||
 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
 			msleep(5);
 		async_synchronize_full();
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

