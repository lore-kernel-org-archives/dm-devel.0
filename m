Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D72BC2B9F4
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E58461C6A
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E58461C6A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-tNB3cWRlPOGp9D67jSYpkg-1; Mon, 28 Jun 2021 05:53:04 -0400
X-MC-Unique: tNB3cWRlPOGp9D67jSYpkg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73DEA1084F5F;
	Mon, 28 Jun 2021 09:52:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C5E71A875;
	Mon, 28 Jun 2021 09:52:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01F2A4EA40;
	Mon, 28 Jun 2021 09:52:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15S03F3w027044 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 27 Jun 2021 20:03:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DB15A11301C3; Mon, 28 Jun 2021 00:03:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D36A0100296D
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD0141064FAD
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:14 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-526-Ca8qHh2aPZmpHBxKGeNsqw-4;
	Sun, 27 Jun 2021 20:03:12 -0400
X-MC-Unique: Ca8qHh2aPZmpHBxKGeNsqw-4
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Abto2uqlRFa+Gnj9UhRGuFKoF6UHpDfIQ3DAb?=
	=?us-ascii?q?v31ZSRFFG/Fw9vre+MjzsCWYtN9/Yh8dcK+7UpVoLUm8yXcX2/h1AV7BZniEhI?=
	=?us-ascii?q?LAFugLgrcKqAeQeREWmNQ86Y5QN4B6CPDVSWNxlNvG5mCDeOoI8Z2q97+JiI7l?=
	=?us-ascii?q?o0tQcQ=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.83,304,1616428800"; d="scan'208";a="110256345"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 28 Jun 2021 08:03:10 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 237344D0BA7B;
	Mon, 28 Jun 2021 08:03:08 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 28 Jun 2021 08:03:04 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 28 Jun 2021 08:03:03 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 28 Jun 2021 08:02:13 +0800
Message-ID: <20210628000218.387833-5-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 237344D0BA7B.A1C39
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: snitzer@redhat.com, darrick.wong@oracle.com, rgoldwyn@suse.de,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v5 4/9] pmem,
	mm: Implement ->memory_failure in pmem driver
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With dax_holder notify support, we are able to notify the memory failure
from pmem driver to upper layers.  If there is something not support in
the notify routine, memory_failure will fall back to the generic hanlder.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 drivers/nvdimm/pmem.c | 13 +++++++++++++
 mm/memory-failure.c   | 14 ++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ed10a8b66068..95d79dfb2fc2 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -364,9 +364,22 @@ static void pmem_release_disk(void *__pmem)
 	put_disk(pmem->disk);
 }

+static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
+		unsigned long pfn, unsigned long nr_pfns, int flags)
+{
+	struct pmem_device *pmem =
+			container_of(pgmap, struct pmem_device, pgmap);
+	loff_t offset = PFN_PHYS(pfn) - pmem->phys_addr - pmem->data_offset;
+
+	return dax_holder_notify_failure(pmem->dax_dev, offset,
+					 page_size(pfn_to_page(pfn)) * nr_pfns,
+					 &flags);
+}
+
 static const struct dev_pagemap_ops fsdax_pagemap_ops = {
 	.kill			= pmem_pagemap_kill,
 	.cleanup		= pmem_pagemap_cleanup,
+	.memory_failure		= pmem_pagemap_memory_failure,
 };

 static int pmem_attach_disk(struct device *dev,
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 068753911946..30ce1e653c0a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1411,6 +1411,20 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	 */
 	SetPageHWPoison(page);

+	/*
+	 * Call driver's implementation to handle the memory failure, otherwise
+	 * fall back to generic handler.
+	 */
+	if (pgmap->ops->memory_failure) {
+		rc = pgmap->ops->memory_failure(pgmap, pfn, 1, flags);
+		/*
+		 * Fall back to generic handler too if operation is not
+		 * supported inside the driver/device/filesystem.
+		 */
+		if (rc != EOPNOTSUPP)
+			goto out;
+	}
+
 	mf_generic_kill_procs(pfn, flags);
 out:
 	/* drop pgmap ref acquired in caller */
--
2.32.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

