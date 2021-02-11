Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93250C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 156FE64E45
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 156FE64E45
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-ZJVRVGBtP_2FvriQtwsvLA-1; Thu, 11 Feb 2021 18:47:22 -0500
X-MC-Unique: ZJVRVGBtP_2FvriQtwsvLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0536010066F5;
	Thu, 11 Feb 2021 23:47:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9DD96268D;
	Thu, 11 Feb 2021 23:47:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD9B04EE76;
	Thu, 11 Feb 2021 23:47:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BNl5fO010531 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 18:47:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AE2022166B31; Thu, 11 Feb 2021 23:47:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A91672166B2E
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 23:47:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F988101A56C
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 23:47:02 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-562-9rHs1JAoOJSQSJyl4EX5zw-1;
	Thu, 11 Feb 2021 18:46:59 -0500
X-MC-Unique: 9rHs1JAoOJSQSJyl4EX5zw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CCEFAAE9A;
	Thu, 11 Feb 2021 23:46:57 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 12 Feb 2021 00:46:50 +0100
Message-Id: <20210211234650.21890-4-mwilck@suse.com>
In-Reply-To: <20210211234650.21890-1-mwilck@suse.com>
References: <20210211234650.21890-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11BNl5fO010531
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 4/4] libmultipath: fix compilation error with gcc
	10 on i386
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

gcc complained about a possible negative value of "nr" in the
memcpy() call. I consider that a false positive, but it's easily
fixed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/sysfs.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 5390de6..7a2af1e 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -344,24 +344,23 @@ bool sysfs_is_multipathed(struct path *pp, bool set_wwid)
 		pthread_cleanup_push(close_fd, (void *)fd);
 		nr = read(fd, uuid, sizeof(uuid));
 		if (nr > (int)UUID_PREFIX_LEN &&
-		    !memcmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+		    !memcmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN)) {
 			found = true;
-		else if (nr < 0) {
+			if (set_wwid) {
+				nr -= UUID_PREFIX_LEN;
+				memcpy(pp->wwid, uuid + UUID_PREFIX_LEN, nr);
+				if (nr == WWID_SIZE) {
+					condlog(4, "%s: overflow while reading from %s",
+						__func__, pathbuf);
+					pp->wwid[0] = '\0';
+				} else {
+					pp->wwid[nr] = '\0';
+					strchop(pp->wwid);
+				}
+			}
+                } else if (nr < 0)
 			condlog(1, "%s: error reading from %s: %m",
 				__func__, pathbuf);
-		}
-		if (found && set_wwid) {
-			nr -= UUID_PREFIX_LEN;
-			memcpy(pp->wwid, uuid + UUID_PREFIX_LEN, nr);
-			if (nr == WWID_SIZE) {
-				condlog(4, "%s: overflow while reading from %s",
-					__func__, pathbuf);
-				pp->wwid[0] = '\0';
-			} else {
-				pp->wwid[nr] = '\0';
-				strchop(pp->wwid);
-			}
-                }
 
 		pthread_cleanup_pop(1);
 	}
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

