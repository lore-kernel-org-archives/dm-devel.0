Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E2AC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:15:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2CD5264F33
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:15:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CD5264F33
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-3M0E0uwUNJSS-Rr5fF3ytg-1; Thu, 18 Mar 2021 05:15:05 -0400
X-MC-Unique: 3M0E0uwUNJSS-Rr5fF3ytg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FD451007B01;
	Thu, 18 Mar 2021 09:15:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D0C85D9DE;
	Thu, 18 Mar 2021 09:15:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 44B384A7C9;
	Thu, 18 Mar 2021 09:15:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12I9Efex005128 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Mar 2021 05:14:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 89FC2F5CE4; Thu, 18 Mar 2021 09:14:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 844BFF640A
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 09:14:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02189803C9F
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 09:14:39 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-97-um8-eARpNWOFvBMXFFhk6A-1;
	Thu, 18 Mar 2021 05:14:34 -0400
X-MC-Unique: um8-eARpNWOFvBMXFFhk6A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D50FBAD71;
	Thu, 18 Mar 2021 09:14:32 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Mar 2021 10:14:13 +0100
Message-Id: <20210318091413.28027-3-mwilck@suse.com>
In-Reply-To: <20210318091413.28027-1-mwilck@suse.com>
References: <20210318091413.28027-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12I9Efex005128
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 3/3] multipath-tools tests: check if
	/sys/dev/block is non-empty
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

From: Martin Wilck <mwilck@suse.com>

Since f131e31 ("multipath-tools: devt test: avoid failure when run in
containers"), we check the existence of /sys/dev/block before running
the devt test. It turns out that on recent releases of podman (3.0.1),
this check is insufficient, because /sys/dev/block exists now in
containers, albeit empty. So we need to check for actual entries
in the directory.

Fixes: f131e31 ("multipath-tools: devt test: avoid failure when run in containers")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/devt.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/tests/devt.c b/tests/devt.c
index 02f2e8f..d971302 100644
--- a/tests/devt.c
+++ b/tests/devt.c
@@ -13,7 +13,9 @@
 #include <sys/sysmacros.h>
 #include <fcntl.h>
 #include <sys/stat.h>
+#include <sys/types.h>
 #include <unistd.h>
+#include <dirent.h>
 #include "util.h"
 #include "debug.h"
 
@@ -21,12 +23,22 @@
 
 static bool sys_dev_block_exists(void)
 {
-	int fd;
-	bool rc;
+	DIR *dir;
+	bool rc = false;
 
-	fd = open("/sys/dev/block", O_RDONLY|O_DIRECTORY);
-	rc = (fd != -1);
-	close(fd);
+	dir = opendir("/sys/dev/block");
+	if (dir != NULL) {
+		struct dirent *de;
+
+		while((de = readdir(dir)) != NULL) {
+			if (strcmp(de->d_name, ".") &&
+			    strcmp(de->d_name, "..")) {
+				rc = true;
+				break;
+			}
+		}
+	}
+	closedir(dir);
 	return rc;
 }
 
-- 
2.30.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

