Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3E0C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 19:52:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6DA87611AD
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 19:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DA87611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-d6yOomoaNbWVk6tqWXISgw-1; Thu, 20 May 2021 15:52:49 -0400
X-MC-Unique: d6yOomoaNbWVk6tqWXISgw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BC1164171;
	Thu, 20 May 2021 19:52:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EEB95D74B;
	Thu, 20 May 2021 19:52:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3078A55353;
	Thu, 20 May 2021 19:52:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14KJqeCF013993 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 15:52:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 77D3920877A1; Thu, 20 May 2021 19:52:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 723D120534B6
	for <dm-devel@redhat.com>; Thu, 20 May 2021 19:52:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B99AA80D0E0
	for <dm-devel@redhat.com>; Thu, 20 May 2021 19:52:35 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-479-m-RYOr09OhOC9E_RYThM7A-1;
	Thu, 20 May 2021 15:52:31 -0400
X-MC-Unique: m-RYOr09OhOC9E_RYThM7A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 2DF6AAE46;
	Thu, 20 May 2021 19:52:29 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 20 May 2021 21:52:08 +0200
Message-Id: <20210520195208.30542-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14KJqeCF013993
X-loop: dm-devel@redhat.com
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, dm-devel@redhat.com,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] libmultipath: fix build without
	LIBDM_API_DEFERRED
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Build fails on distributions that don't support DM_DEFERRED_REMOVE
(libdevmapper < 1.02.89). Fix it.

Resolves: https://github.com/opensvc/multipath-tools/issues/7
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 libmultipath/devmapper.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 095cbc0..47a6d60 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -49,6 +49,9 @@ static int dm_conf_verbosity;
 
 #ifdef LIBDM_API_DEFERRED
 static int dm_cancel_remove_partmaps(const char * mapname);
+#define __DR_UNUSED__ /* empty */
+#else
+#define __DR_UNUSED__ __attribute__((unused))
 #endif
 
 static int do_foreach_partmaps(const char * mapname,
@@ -384,7 +387,8 @@ libmp_dm_task_create(int task)
 #define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) == DEFERRED_REMOVE_IN_PROGRESS)
 
 static int
-dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t udev_flags, int deferred_remove) {
+dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
+	      uint16_t udev_flags, int deferred_remove __DR_UNUSED__) {
 	int r = 0;
 	int udev_wait_flag = ((need_sync || udev_flags) &&
 			      (task == DM_DEVICE_RESUME ||
@@ -1122,7 +1126,8 @@ dm_flush_map_nopaths(const char * mapname, int deferred_remove)
 #else
 
 int
-dm_flush_map_nopaths(const char * mapname, int deferred_remove)
+dm_flush_map_nopaths(const char * mapname,
+		     int deferred_remove __attribute__((unused)))
 {
 	return _dm_flush_map(mapname, 1, 0, 0, 0);
 }
@@ -1573,7 +1578,7 @@ dm_cancel_deferred_remove (struct multipath *mpp)
 #else
 
 int
-dm_cancel_deferred_remove (struct multipath *mpp)
+dm_cancel_deferred_remove (struct multipath *mpp __attribute__((unused)))
 {
 	return 0;
 }
-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

