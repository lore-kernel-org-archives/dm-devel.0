Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA45C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 642296128E
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 642296128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-Qxsjn8edMJW7M13Mvr-q8Q-1; Thu, 18 Nov 2021 18:03:26 -0500
X-MC-Unique: Qxsjn8edMJW7M13Mvr-q8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64FA21923761;
	Thu, 18 Nov 2021 23:03:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49AA35F4ED;
	Thu, 18 Nov 2021 23:03:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C03314EA37;
	Thu, 18 Nov 2021 23:03:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxGdP002342 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0020651DD; Thu, 18 Nov 2021 22:59:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE54051DC
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6E7285A5B5
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:15 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-376-XcVlQ4eaMAGkXyXyES2jCg-1; Thu, 18 Nov 2021 17:59:14 -0500
X-MC-Unique: XcVlQ4eaMAGkXyXyES2jCg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B5B421FD3C;
	Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F00413B11;
	Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id iOPuGMDalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:12 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:37 +0100
Message-Id: <20211118225840.19810-46-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxGdP002342
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 45/48] multipathd: retrigger uevent for
	partial paths
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

From: Benjamin Marzinski <bmarzins@redhat.com>

If a partial path appears and is not fully initialized within
180 seconds, trigger a uevent. If the udev device is not initialized
trigger an add event. Otherwise, trigger a change event.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version |  2 +-
 libmultipath/structs.h            |  1 +
 libmultipath/structs_vec.c        |  1 +
 multipathd/main.c                 | 20 ++++++++++++++++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 4f6fa1d..5a3ba4e 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_11.0.0 {
+LIBMULTIPATH_12.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 69409fd..c21d1ed 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -318,6 +318,7 @@ struct path {
 	int fd;
 	int initialized;
 	int retriggers;
+	int partial_retrigger_delay;
 	unsigned int path_failures;
 	time_t dis_reinstate_time;
 	int disable_reinstate;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 1de9175..9b6407b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -195,6 +195,7 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 					condlog(2, "%s: adding new path %s",
 						mpp->alias, pp->dev);
 					pp->initialized = INIT_PARTIAL;
+					pp->partial_retrigger_delay = 180;
 					store_path(pathvec, pp);
 					pp->tick = 1;
 				}
diff --git a/multipathd/main.c b/multipathd/main.c
index 828d229..bffafe9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1949,6 +1949,25 @@ retry_count_tick(vector mpvec)
 	}
 }
 
+static void
+partial_retrigger_tick(vector pathvec)
+{
+	struct path *pp;
+	unsigned int i;
+
+	vector_foreach_slot (pathvec, pp, i) {
+		if (pp->initialized == INIT_PARTIAL && pp->udev &&
+		    pp->partial_retrigger_delay > 0 &&
+		    --pp->partial_retrigger_delay == 0) {
+			const char *msg = udev_device_get_is_initialized(pp->udev) ?
+					  "change" : "add";
+
+			sysfs_attr_set_value(pp->udev, "uevent", msg,
+					     strlen(msg));
+		}
+	}
+}
+
 int update_prio(struct path *pp, int refresh_all)
 {
 	int oldpriority;
@@ -2567,6 +2586,7 @@ checkerloop (void *ap)
 		retry_count_tick(vecs->mpvec);
 		missing_uev_wait_tick(vecs);
 		ghost_delay_tick(vecs);
+		partial_retrigger_tick(vecs->pathvec);
 		lock_cleanup_pop(vecs->lock);
 
 		if (count)
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

