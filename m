Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA654C43217
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 10:39:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-YMdMDOizNjmMiUsVTkyutw-1; Mon, 29 Nov 2021 05:39:51 -0500
X-MC-Unique: YMdMDOizNjmMiUsVTkyutw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19AA119251B4;
	Mon, 29 Nov 2021 10:39:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0187272FA6;
	Mon, 29 Nov 2021 10:39:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D0EA11806D2D;
	Mon, 29 Nov 2021 10:39:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATAdaqs014332 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 05:39:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CDD542180146; Mon, 29 Nov 2021 10:39:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8D3A2166B26
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:39:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B1EF811E7A
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:39:32 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-108-6EkNDrmPOeazP29yX4ASGQ-1; Mon, 29 Nov 2021 05:39:29 -0500
X-MC-Unique: 6EkNDrmPOeazP29yX4ASGQ-1
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdnR-0073Ig-7d; Mon, 29 Nov 2021 10:22:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Nov 2021 11:21:35 +0100
Message-Id: <20211129102203.2243509-2-hch@lst.de>
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 01/29] dm: fix alloc_dax error handling in
	alloc_dev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Make sure ->dax_dev is NULL on error so that the cleanup path doesn't
trip over an ERR_PTR.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 662742a310cbb..acc84dc1bded5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1786,8 +1786,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
-		if (IS_ERR(md->dax_dev))
+		if (IS_ERR(md->dax_dev)) {
+			md->dax_dev = NULL;
 			goto bad;
+		}
 	}
 
 	format_dev_t(md->name, MKDEV(_major, minor));
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

