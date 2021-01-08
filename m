Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE7FC433DB
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 17:01:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFBC12368A
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 17:01:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFBC12368A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-p852_uf7MGKojlRNcxsF8w-1; Fri, 08 Jan 2021 12:01:32 -0500
X-MC-Unique: p852_uf7MGKojlRNcxsF8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FEAFC7403;
	Fri,  8 Jan 2021 17:01:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68A8619C48;
	Fri,  8 Jan 2021 17:01:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2A719180954D;
	Fri,  8 Jan 2021 17:01:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 108H1Nac022582 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Jan 2021 12:01:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 67E722026D25; Fri,  8 Jan 2021 17:01:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 625242026D13
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 17:01:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 876AB805C3F
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 17:01:18 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-238-gZ2F-YNhMBCbwPfslysWNw-1;
	Fri, 08 Jan 2021 12:01:16 -0500
X-MC-Unique: gZ2F-YNhMBCbwPfslysWNw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BF79AAD1E;
	Fri,  8 Jan 2021 17:01:14 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  8 Jan 2021 18:00:43 +0100
Message-Id: <20210108170044.7883-3-mwilck@suse.com>
In-Reply-To: <20210108170044.7883-1-mwilck@suse.com>
References: <20210108170044.7883-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 108H1Nac022582
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/3] libmultipath: coalesce_paths(): stop
	triggering spurious uevents
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Since 0d66e03 ("libmultipath: force map reload if udev incomplete"), we
force-reload maps that we find incompletely initialized by udev. If
select_action returns ACT_NOTHING nonetheless, the map must be initialized
in udev, and thus and "add" uevent must have been seen already. Triggering
this event once more is unlikely to fix anything for real.

Reverts: b516118 ("libmultipath: coalesce_paths: trigger uevent if nothing done")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 999f310..3263bb0 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -527,18 +527,6 @@ get_udev_for_mpp(const struct multipath *mpp)
 	return udd;
 }
 
-static void
-trigger_udev_change(const struct multipath *mpp)
-{
-	static const char change[] = "change";
-	struct udev_device *udd = get_udev_for_mpp(mpp);
-	if (!udd)
-		return;
-	condlog(3, "triggering %s uevent for %s", change, mpp->alias);
-	sysfs_attr_set_value(udd, "uevent", change, sizeof(change)-1);
-	udev_device_unref(udd);
-}
-
 static void trigger_partitions_udev_change(struct udev_device *dev,
 					   const char *action, int len)
 {
@@ -1297,18 +1285,6 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 			continue;
 		}
 
-		if (r == DOMAP_EXIST && mpp->action == ACT_NOTHING &&
-		    force_reload == FORCE_RELOAD_WEAK)
-			/*
-			 * First time we're called, and no changes applied.
-			 * domap() was a noop. But we can't be sure that
-			 * udev has already finished setting up this device
-			 * (udev in initrd may have been shut down while
-			 * processing this device or its children).
-			 * Trigger a change event, just in case.
-			 */
-			trigger_udev_change(find_mp_by_wwid(curmp, mpp->wwid));
-
 		conf = get_multipath_config();
 		allow_queueing = conf->allow_queueing;
 		put_multipath_config(conf);
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

