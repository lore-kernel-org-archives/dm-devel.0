Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B82C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:22:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F7FE61B44
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7F7FE61B44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637184119;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JSEbamwY6RP0bAzXH38QLlyyC8sOkLCVeLDF037aiMo=;
	b=CUEldS/zG/fZDu2h3cc4OW91z5JcyBuTTKCYebequSO6w5jjDNcM5Zz0pow4neUT6RMPOm
	Lz2K0cbKsfS0nY9G58viI3KgsPl/x/j47UOvVfLNiqgtQ24nqN5XZLjUUMvtaiyY3M72en
	lfx/wPORNINY7ekscAbmjlp1hfbZQvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-q955cxZIMeepLv5JXOiHiQ-1; Wed, 17 Nov 2021 16:21:58 -0500
X-MC-Unique: q955cxZIMeepLv5JXOiHiQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE3FF80414A;
	Wed, 17 Nov 2021 21:21:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8B4D1017CF2;
	Wed, 17 Nov 2021 21:21:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A47641832DD7;
	Wed, 17 Nov 2021 21:21:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHLLbXN025278 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 16:21:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1881D5F4F5; Wed, 17 Nov 2021 21:21:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 004395F4ED;
	Wed, 17 Nov 2021 21:21:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHLLTtM004931; 
	Wed, 17 Nov 2021 15:21:29 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHLLTjl004930;
	Wed, 17 Nov 2021 15:21:29 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 15:21:18 -0600
Message-Id: <1637184084-4882-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 3/9] libmultipath: don't use fallback wwid in
	update_pathvec_from_dm
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When new paths are added in update_pathvec_from_dm(). If they can't get
their regular wwid, they shouldn't try the getting the fallback wwid,
and should just copy the wwid of the multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c   | 7 ++++---
 libmultipath/discovery.h   | 2 ++
 libmultipath/structs_vec.c | 3 +--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f25fe9e3..5edf9593 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2363,15 +2363,16 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	}
 
 	if ((mask & DI_WWID) && !strlen(pp->wwid)) {
-		get_uid(pp, path_state, pp->udev,
-			(pp->retriggers >= conf->retrigger_tries));
+		int allow_fallback = ((mask & DI_NOFALLBACK) == 0 &&
+				      pp->retriggers >= conf->retrigger_tries);
+		get_uid(pp, path_state, pp->udev, allow_fallback);
 		if (!strlen(pp->wwid)) {
 			if (pp->bus == SYSFS_BUS_UNDEF)
 				return PATHINFO_SKIPPED;
 			if (pp->initialized != INIT_FAILED) {
 				pp->initialized = INIT_MISSING_UDEV;
 				pp->tick = conf->retrigger_delay;
-			} else if (pp->retriggers >= conf->retrigger_tries &&
+			} else if (allow_fallback &&
 				   (pp->state == PATH_UP || pp->state == PATH_GHOST)) {
 				/*
 				 * We have failed to read udev info for this path
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index a5446b4d..095657bb 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -70,6 +70,7 @@ enum discovery_mode {
 	__DI_WWID,
 	__DI_BLACKLIST,
 	__DI_NOIO,
+	__DI_NOFALLBACK,
 };
 
 #define DI_SYSFS	(1 << __DI_SYSFS)
@@ -79,6 +80,7 @@ enum discovery_mode {
 #define DI_WWID		(1 << __DI_WWID)
 #define DI_BLACKLIST	(1 << __DI_BLACKLIST)
 #define DI_NOIO		(1 << __DI_NOIO) /* Avoid IO on the device */
+#define DI_NOFALLBACK	(1 << __DI_NOFALLBACK) /* do not allow wwid fallback */
 
 #define DI_ALL		(DI_SYSFS  | DI_SERIAL | DI_CHECKER | DI_PRIO | \
 			 DI_WWID)
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 4d56107a..d363e7f6 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -182,8 +182,7 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 							     conf);
 					pp->checkint = conf->checkint;
 					rc = pathinfo(pp, conf,
-						      DI_SYSFS|DI_WWID|DI_BLACKLIST|
-						      pathinfo_flags);
+						      DI_SYSFS|DI_WWID|DI_BLACKLIST|DI_NOFALLBACK|pathinfo_flags);
 					pthread_cleanup_pop(1);
 					if (rc != PATHINFO_OK) {
 						condlog(1, "%s: error %d in pathinfo, discarding path",
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

