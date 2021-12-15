Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6C5C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 09:09:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-gw0bo9moOvyz7_8Z5QJVyQ-1; Wed, 15 Dec 2021 04:09:31 -0500
X-MC-Unique: gw0bo9moOvyz7_8Z5QJVyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD3261934100;
	Wed, 15 Dec 2021 09:09:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 592456E96B;
	Wed, 15 Dec 2021 09:09:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 172A31809CB8;
	Wed, 15 Dec 2021 09:09:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BF99DLx019829 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 04:09:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9F0CC40CFD16; Wed, 15 Dec 2021 09:09:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A3A840CFD0D
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 09:09:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FB1E1C1CD6E
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 09:09:13 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-551-cbFadg-xNQ2TwUn6K4nxPg-1; Wed, 15 Dec 2021 04:09:11 -0500
X-MC-Unique: cbFadg-xNQ2TwUn6K4nxPg-1
Received: from [2001:4bb8:184:5c65:c56:ed89:c020:6100] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mxPuR-00ETyk-Ma; Wed, 15 Dec 2021 08:45:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Date: Wed, 15 Dec 2021 09:45:06 +0100
Message-Id: <20211215084508.435401-3-hch@lst.de>
In-Reply-To: <20211215084508.435401-1-hch@lst.de>
References: <20211215084508.435401-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>, Pankaj Gupta <pankaj.gupta@ionos.com>,
	Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH 2/4] dax: simplify dax_synchronous and
	set_dax_synchronous
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

Remove the pointless wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |  8 ++++----
 include/linux/dax.h | 12 ++----------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e7152a6c4cc40..e18155f43a635 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -208,17 +208,17 @@ bool dax_write_cache_enabled(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
 
-bool __dax_synchronous(struct dax_device *dax_dev)
+bool dax_synchronous(struct dax_device *dax_dev)
 {
 	return test_bit(DAXDEV_SYNC, &dax_dev->flags);
 }
-EXPORT_SYMBOL_GPL(__dax_synchronous);
+EXPORT_SYMBOL_GPL(dax_synchronous);
 
-void __set_dax_synchronous(struct dax_device *dax_dev)
+void set_dax_synchronous(struct dax_device *dax_dev)
 {
 	set_bit(DAXDEV_SYNC, &dax_dev->flags);
 }
-EXPORT_SYMBOL_GPL(__set_dax_synchronous);
+EXPORT_SYMBOL_GPL(set_dax_synchronous);
 
 bool dax_alive(struct dax_device *dax_dev)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 87ae4c9b1d65b..3bd1fdb5d5f4b 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -48,16 +48,8 @@ void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
-bool __dax_synchronous(struct dax_device *dax_dev);
-static inline bool dax_synchronous(struct dax_device *dax_dev)
-{
-	return  __dax_synchronous(dax_dev);
-}
-void __set_dax_synchronous(struct dax_device *dax_dev);
-static inline void set_dax_synchronous(struct dax_device *dax_dev)
-{
-	__set_dax_synchronous(dax_dev);
-}
+bool dax_synchronous(struct dax_device *dax_dev);
+void set_dax_synchronous(struct dax_device *dax_dev);
 /*
  * Check if given mapping is supported by the file / underlying device.
  */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

