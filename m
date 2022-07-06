Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C8AC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118336;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sSyZTo+k5As68K5GXteC0r/G17kMzrrpmRHL72LGPgg=;
	b=SCelRtmY/FJK3TZr2HLnH6NIJKtra5eal7dR32nonOFKoB9lkXUVLAx8M+F9FOHQ186vbS
	TFvRkOZWea9mOC2wmcdQKPkrcXMbsXcXivPRtsEFw/hCKO0MmGCDyBYIESK8wp4Dw7IZ43
	XGRyZdiHRZRbP+x6Fz6O7nIy6Noe9YY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-qXhfS4cTOtqHjtO3R3qSeg-1; Wed, 06 Jul 2022 10:38:53 -0400
X-MC-Unique: qXhfS4cTOtqHjtO3R3qSeg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58BA21C006B5;
	Wed,  6 Jul 2022 14:38:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47403C44AE3;
	Wed,  6 Jul 2022 14:38:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1914F1947063;
	Wed,  6 Jul 2022 14:38:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF5111947067
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B7A6C44AE6; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 97A2FC44AE3
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 811E918E004A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-BUtj84FiPWirBP5CIFNELw-1; Wed, 06 Jul 2022 10:38:41 -0400
X-MC-Unique: BUtj84FiPWirBP5CIFNELw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id CA78D22633;
 Wed,  6 Jul 2022 14:38:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E057134CF;
 Wed,  6 Jul 2022 14:38:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id iDcWJW+exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:39 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:18 +0200
Message-Id: <20220706143822.30182-11-mwilck@suse.com>
In-Reply-To: <20220706143822.30182-1-mwilck@suse.com>
References: <20220706143822.30182-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 10/14] libmultipath,
 multipathd: log failure setting sysfs attributes
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Failure to set a sysfs attribute is worth noting, normally.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   | 18 +++++++++++++++---
 multipathd/fpin_handlers.c | 11 +++++++++--
 multipathd/main.c          | 38 +++++++++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 0607dba..4427f91 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -489,9 +489,15 @@ void trigger_partitions_udev_change(struct udev_device *dev,
 
 		devtype = udev_device_get_devtype(part);
 		if (devtype && !strcmp("partition", devtype)) {
+			ssize_t ret;
+
 			condlog(4, "%s: triggering %s event for %s", __func__,
 				action, syspath);
-			sysfs_attr_set_value(part, "uevent", action, len);
+			ret = sysfs_attr_set_value(part, "uevent", action, len);
+			if (ret != len)
+				log_sysfs_attr_set_value(2, ret,
+					"%s: failed to trigger %s uevent",
+					syspath, action);
 		}
 		udev_device_unref(part);
 	}
@@ -510,6 +516,7 @@ trigger_path_udev_change(struct path *pp, bool is_mpath)
 	 */
 	const char *action = is_mpath ? "change" : "add";
 	const char *env;
+	ssize_t len, ret;
 
 	if (!pp->udev)
 		return;
@@ -536,8 +543,13 @@ trigger_path_udev_change(struct path *pp, bool is_mpath)
 
 	condlog(3, "triggering %s uevent for %s (is %smultipath member)",
 		action, pp->dev, is_mpath ? "" : "no ");
-	sysfs_attr_set_value(pp->udev, "uevent",
-			     action, strlen(action));
+
+	len = strlen(action);
+	ret = sysfs_attr_set_value(pp->udev, "uevent", action, len);
+	if (ret != len)
+		log_sysfs_attr_set_value(2, ret,
+					 "%s: failed to trigger %s uevent",
+					 pp->dev, action);
 	trigger_partitions_udev_change(pp->udev, action,
 				       strlen(action));
 }
diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index 384ae31..0019572 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -172,8 +172,15 @@ fpin_els_add_li_frame(struct fc_nl_event *fc_event)
 /*Sets the rport port_state to marginal*/
 static void fpin_set_rport_marginal(struct udev_device *rport_dev)
 {
-	sysfs_attr_set_value(rport_dev, "port_state",
-				"Marginal", strlen("Marginal"));
+	static const char marginal[] = "Marginal";
+	ssize_t ret;
+
+	ret = sysfs_attr_set_value(rport_dev, "port_state",
+				   marginal, sizeof(marginal) - 1);
+	if (ret != sizeof(marginal) - 1)
+		log_sysfs_attr_set_value(2, ret,
+					 "%s: failed to set port_state to marginal",
+					 udev_device_get_syspath(rport_dev));
 }
 
 /*Add the marginal devices info into the list*/
diff --git a/multipathd/main.c b/multipathd/main.c
index 68eca92..a160c82 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -911,14 +911,22 @@ rescan_path(struct udev_device *ud)
 {
 	ud = udev_device_get_parent_with_subsystem_devtype(ud, "scsi",
 							   "scsi_device");
-	if (ud)
-		sysfs_attr_set_value(ud, "rescan", "1", strlen("1"));
+	if (ud) {
+		ssize_t ret =
+			sysfs_attr_set_value(ud, "rescan", "1", strlen("1"));
+		if (ret != strlen("1"))
+			log_sysfs_attr_set_value(1, ret,
+						 "%s: failed to trigger rescan",
+						 udev_device_get_syspath(ud));
+	}
 }
 
 void
 handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 {
 	struct udev_device *udd;
+	static const char add[] = "add";
+	ssize_t ret;
 
 	if (!pp || !pp->udev)
 		return;
@@ -929,8 +937,12 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 		dm_fail_path(pp->mpp->alias, pp->dev_t);
 	}
 	rescan_path(udd);
-	sysfs_attr_set_value(udd, "uevent", "add", strlen("add"));
+	ret = sysfs_attr_set_value(udd, "uevent", add, sizeof(add) - 1);
 	udev_device_unref(udd);
+	if (ret != sizeof(add) - 1)
+		log_sysfs_attr_set_value(1, ret,
+					 "%s: failed to trigger add event",
+					 pp->dev);
 }
 
 bool
@@ -2003,9 +2015,14 @@ partial_retrigger_tick(vector pathvec)
 		    --pp->partial_retrigger_delay == 0) {
 			const char *msg = udev_device_get_is_initialized(pp->udev) ?
 					  "change" : "add";
+			ssize_t len = strlen(msg);
+			ssize_t ret = sysfs_attr_set_value(pp->udev, "uevent", msg,
+							   len);
 
-			sysfs_attr_set_value(pp->udev, "uevent", msg,
-					     strlen(msg));
+			if (len != ret)
+				log_sysfs_attr_set_value(2, ret,
+					"%s: failed to trigger %s event",
+					pp->dev, msg);
 		}
 	}
 }
@@ -2245,12 +2262,19 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 
 	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
 		if (pp->retriggers < retrigger_tries) {
+			static const char change[] = "change";
+			ssize_t ret;
+
 			condlog(2, "%s: triggering change event to reinitialize",
 				pp->dev);
 			pp->initialized = INIT_REQUESTED_UDEV;
 			pp->retriggers++;
-			sysfs_attr_set_value(pp->udev, "uevent", "change",
-					     strlen("change"));
+			ret = sysfs_attr_set_value(pp->udev, "uevent", change,
+						   sizeof(change) - 1);
+			if (ret != sizeof(change) - 1)
+				log_sysfs_attr_set_value(1, ret,
+							 "%s: failed to trigger change event",
+							 pp->dev);
 			return 0;
 		} else {
 			condlog(1, "%s: not initialized after %d udev retriggers",
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

