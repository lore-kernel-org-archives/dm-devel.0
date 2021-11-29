Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC9AAC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 10:40:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-PHJU9iLwNn6yvtl7ZQGg2g-1; Mon, 29 Nov 2021 05:40:47 -0500
X-MC-Unique: PHJU9iLwNn6yvtl7ZQGg2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A2B086A064;
	Mon, 29 Nov 2021 10:40:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 502FE5D9DE;
	Mon, 29 Nov 2021 10:40:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2A0F81802E2A;
	Mon, 29 Nov 2021 10:40:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATAecge014749 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 05:40:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D5D6F51E1; Mon, 29 Nov 2021 10:40:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D03AD51DC
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:40:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB75B85A5A8
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:40:33 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-186-D1yVz_enOWy5YJgoLeqQaQ-1; Mon, 29 Nov 2021 05:40:31 -0500
X-MC-Unique: D1yVz_enOWy5YJgoLeqQaQ-1
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdo4-0073aO-0q; Mon, 29 Nov 2021 10:22:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Nov 2021 11:22:03 +0100
Message-Id: <20211129102203.2243509-30-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 29/29] fsdax: don't require CONFIG_BLOCK
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The file system DAX code now does not require the block code.  So allow
building a kernel with fuse DAX but not block layer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 6d608330a096e..7a2b11c0b8036 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -42,6 +42,8 @@ source "fs/nilfs2/Kconfig"
 source "fs/f2fs/Kconfig"
 source "fs/zonefs/Kconfig"
 
+endif # BLOCK
+
 config FS_DAX
 	bool "File system based Direct Access (DAX) support"
 	depends on MMU
@@ -89,8 +91,6 @@ config FS_DAX_PMD
 config FS_DAX_LIMITED
 	bool
 
-endif # BLOCK
-
 # Posix ACL utility routines
 #
 # Note: Posix ACLs can be implemented without these helpers.  Never use
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

