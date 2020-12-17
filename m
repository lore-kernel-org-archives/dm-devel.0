Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C5DC4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DFC792389B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFC792389B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-9-EJ1NOFMnO3NQrXL6R9OA-1; Thu, 17 Dec 2020 06:01:13 -0500
X-MC-Unique: 9-EJ1NOFMnO3NQrXL6R9OA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E123918C8C0D;
	Thu, 17 Dec 2020 11:01:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFBB3710DC;
	Thu, 17 Dec 2020 11:01:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 94C944EEEE;
	Thu, 17 Dec 2020 11:01:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHB0k5N030308 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 06:00:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C0DD62166B2E; Thu, 17 Dec 2020 11:00:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B99ED2166B31
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84161805B01
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:41 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-507-FxLM_QkIMf-jwXqqUBpRhQ-1;
	Thu, 17 Dec 2020 06:00:35 -0500
X-MC-Unique: FxLM_QkIMf-jwXqqUBpRhQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9523DAD2B;
	Thu, 17 Dec 2020 11:00:33 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Dec 2020 12:00:15 +0100
Message-Id: <20201217110018.3347-5-mwilck@suse.com>
In-Reply-To: <20201217110018.3347-1-mwilck@suse.com>
References: <20201217110018.3347-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BHB0k5N030308
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 4/7] libmultipath: force map reload if udev
	incomplete
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

We've recently observed various cases of incompletely processed uevents
during initrd processing. Typically, this would leave a dm device in
the state it had after the initial "add" uevent, which is basically unusable,
because udevd had been killed by systemd before processing the subsequent
"change" event. After switching root, the coldplug event would re-read
the db file, which would be in unusable state, and would not do anything.
In such cases, a RELOAD action with force_udev_reload=1 is in order to
make udev re-process the device completely (DM_UDEV_PRIMARY_SOURCE_FLAG=1 and
DM_SUBSYSTEM_UDEV_FLAG0=0).

The previous commits

2b25a9e libmultipath: select_action(): force udev reload for uninitialized maps
cb10d38 multipathd: uev_trigger(): handle incomplete ADD events

addressed the same issue, but incompletely. They would miss cases where the
map was configured correctly but none of the RELOAD criteria were met.
This patch partially reverts 2b25a9e by converting select_reload_action() into
a trivial helper. Instead, we now check for incompletely initialized udev now
before checking any of the other reload criteria.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 45 ++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3dbc1f1..d64fe88 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -695,12 +695,11 @@ sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
 	return err;
 }
 
-static void
-select_reload_action(struct multipath *mpp, const struct multipath *cmpp,
-		     const char *reason)
+static bool is_udev_ready(struct multipath *cmpp)
 {
 	struct udev_device *mpp_ud;
 	const char *env;
+	bool rc;
 
 	/*
 	 * MPATH_DEVICE_READY != 1 can mean two things:
@@ -712,14 +711,20 @@ select_reload_action(struct multipath *mpp, const struct multipath *cmpp,
 	 */
 
 	mpp_ud = get_udev_for_mpp(cmpp);
+	if (!mpp_ud)
+		return true;
 	env = udev_device_get_property_value(mpp_ud, "MPATH_DEVICE_READY");
-	if ((!env || strcmp(env, "1")) && count_active_paths(mpp) > 0)
-		mpp->force_udev_reload = 1;
+	rc = (env != NULL && !strcmp(env, "1"));
 	udev_device_unref(mpp_ud);
+	condlog(4, "%s: %s: \"%s\" -> %d\n", __func__, cmpp->alias, env, rc);
+	return rc;
+}
+
+static void
+select_reload_action(struct multipath *mpp, const char *reason)
+{
 	mpp->action = ACT_RELOAD;
-	condlog(3, "%s: set ACT_RELOAD (%s%s)", mpp->alias,
-		mpp->force_udev_reload ? "forced, " : "",
-		reason);
+	condlog(3, "%s: set ACT_RELOAD (%s)", mpp->alias, reason);
 }
 
 void select_action (struct multipath *mpp, const struct _vector *curmp,
@@ -788,10 +793,18 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		return;
 	}
 
+	if (!is_udev_ready(cmpp) && count_active_paths(mpp) > 0) {
+		mpp->force_udev_reload = 1;
+		mpp->action = ACT_RELOAD;
+		condlog(3, "%s: set ACT_RELOAD (udev incomplete)",
+			mpp->alias);
+		return;
+	}
+
 	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 	    !!strstr(mpp->features, "queue_if_no_path") !=
 	    !!strstr(cmpp->features, "queue_if_no_path")) {
-		select_reload_action(mpp, cmpp, "no_path_retry change");
+		select_reload_action(mpp, "no_path_retry change");
 		return;
 	}
 	if ((mpp->retain_hwhandler != RETAIN_HWHANDLER_ON ||
@@ -799,7 +812,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 	    (strlen(cmpp->hwhandler) != strlen(mpp->hwhandler) ||
 	     strncmp(cmpp->hwhandler, mpp->hwhandler,
 		    strlen(mpp->hwhandler)))) {
-		select_reload_action(mpp, cmpp, "hwhandler change");
+		select_reload_action(mpp, "hwhandler change");
 		return;
 	}
 
@@ -807,7 +820,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 	    !!strstr(mpp->features, "retain_attached_hw_handler") !=
 	    !!strstr(cmpp->features, "retain_attached_hw_handler") &&
 	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0)) {
-		select_reload_action(mpp, cmpp, "retain_hwhandler change");
+		select_reload_action(mpp, "retain_hwhandler change");
 		return;
 	}
 
@@ -819,7 +832,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		remove_feature(&cmpp_feat, "queue_if_no_path");
 		remove_feature(&cmpp_feat, "retain_attached_hw_handler");
 		if (strncmp(mpp_feat, cmpp_feat, PARAMS_SIZE)) {
-			select_reload_action(mpp, cmpp, "features change");
+			select_reload_action(mpp, "features change");
 			FREE(cmpp_feat);
 			FREE(mpp_feat);
 			return;
@@ -830,19 +843,19 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 
 	if (!cmpp->selector || strncmp(cmpp->selector, mpp->selector,
 		    strlen(mpp->selector))) {
-		select_reload_action(mpp, cmpp, "selector change");
+		select_reload_action(mpp, "selector change");
 		return;
 	}
 	if (cmpp->minio != mpp->minio) {
-		select_reload_action(mpp, cmpp, "minio change");
+		select_reload_action(mpp, "minio change");
 		return;
 	}
 	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
-		select_reload_action(mpp, cmpp, "path group number change");
+		select_reload_action(mpp, "path group number change");
 		return;
 	}
 	if (pgcmp(mpp, cmpp)) {
-		select_reload_action(mpp, cmpp, "path group topology change");
+		select_reload_action(mpp, "path group topology change");
 		return;
 	}
 	if (cmpp->nextpg != mpp->bestpg) {
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

