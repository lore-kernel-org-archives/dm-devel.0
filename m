Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FE6C4363D
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DB59207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DB59207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-QC-yJNo9NqWEctZ-fOLjWA-1; Fri, 16 Oct 2020 06:43:32 -0400
X-MC-Unique: QC-yJNo9NqWEctZ-fOLjWA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F2B818A0764;
	Fri, 16 Oct 2020 10:43:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F1501002C05;
	Fri, 16 Oct 2020 10:43:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 02D6A181A55A;
	Fri, 16 Oct 2020 10:43:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhEDE019970 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4F2D52011559; Fri, 16 Oct 2020 10:43:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A62B2011557
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30AAF805BD6
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:14 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-529-cQnCJpRGPCyKAz2f8P06LQ-1;
	Fri, 16 Oct 2020 06:43:08 -0400
X-MC-Unique: cQnCJpRGPCyKAz2f8P06LQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 48C87B2B2;
	Fri, 16 Oct 2020 10:43:05 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:42:33 +0200
Message-Id: <20201016104239.8217-7-mwilck@suse.com>
In-Reply-To: <20201016104239.8217-1-mwilck@suse.com>
References: <20201016104239.8217-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhEDE019970
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 06/12] libmultipath: checkers/prio: allow
	non-lazy .so loading
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If compiled with -DLOAD_ALL_SHARED_LIBS, all known prioritizers
and checkers will be loaded immediately on startup. This is useful
for determining symbol usage (start executables with LD_BIND_NOW=1).

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c | 17 +++++++++++++++++
 libmultipath/prio.c     | 22 ++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index f7ddd53..18b1f5e 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -7,6 +7,7 @@
 #include "debug.h"
 #include "checkers.h"
 #include "vector.h"
+#include "util.h"
 
 struct checker_class {
 	struct list_head node;
@@ -375,7 +376,23 @@ void checker_get(const char *multipath_dir, struct checker *dst,
 
 int init_checkers(const char *multipath_dir)
 {
+#ifdef LOAD_ALL_SHARED_LIBS
+	static const char *const all_checkers[] = {
+		DIRECTIO,
+		TUR,
+		HP_SW,
+		RDAC,
+		EMC_CLARIION,
+		READSECTOR0,
+		CCISS_TUR,
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(all_checkers); i++)
+		add_checker_class(multipath_dir, all_checkers[i]);
+#else
 	if (!add_checker_class(multipath_dir, DEFAULT_CHECKER))
 		return 1;
+#endif
 	return 0;
 }
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 3a718ba..c92bde7 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -20,8 +20,30 @@ unsigned int get_prio_timeout(unsigned int timeout_ms,
 
 int init_prio (const char *multipath_dir)
 {
+#ifdef LOAD_ALL_SHARED_LIBS
+	static const char *const all_prios[] = {
+		PRIO_ALUA,
+		PRIO_CONST,
+		PRIO_DATACORE,
+		PRIO_EMC,
+		PRIO_HDS,
+		PRIO_HP_SW,
+		PRIO_ONTAP,
+		PRIO_RANDOM,
+		PRIO_RDAC,
+		PRIO_WEIGHTED_PATH,
+		PRIO_SYSFS,
+		PRIO_PATH_LATENCY,
+		PRIO_ANA,
+	};
+	unsigned int i;
+
+	for  (i = 0; i < ARRAY_SIZE(all_prios); i++)
+		add_prio(multipath_dir, all_prios[i]);
+#else
 	if (!add_prio(multipath_dir, DEFAULT_PRIO))
 		return 1;
+#endif
 	return 0;
 }
 
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

