Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDB5C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62F1161A7D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 62F1161A7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-Y3twuPUuMvuWzfycPEUDbA-1; Thu, 18 Nov 2021 18:05:09 -0500
X-MC-Unique: Y3twuPUuMvuWzfycPEUDbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85A8A101F7A1;
	Thu, 18 Nov 2021 23:05:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6626B3AEA;
	Thu, 18 Nov 2021 23:05:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3DA4D1800FE4;
	Thu, 18 Nov 2021 23:05:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxEYJ002330 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D0C6651DD; Thu, 18 Nov 2021 22:59:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAD0851DC
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B283085A5AA
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-509-NBlB2xtPPVSz7JX30SlrXw-1; Thu, 18 Nov 2021 17:59:12 -0500
X-MC-Unique: NBlB2xtPPVSz7JX30SlrXw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A3F51FD3D;
	Thu, 18 Nov 2021 22:59:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 50B3613DC0;
	Thu, 18 Nov 2021 22:59:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id mCGtEb/almGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:11 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:34 +0100
Message-Id: <20211118225840.19810-43-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxEYJ002330
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 42/48] libmultipath: don't use fallback wwid
	in update_pathvec_from_dm
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

From: Benjamin Marzinski <bmarzins@redhat.com>

When new paths are added in update_pathvec_from_dm(). If they can't get
their regular wwid, they shouldn't try the getting the fallback wwid,
and should just copy the wwid of the multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c   | 7 ++++---
 libmultipath/discovery.h   | 2 ++
 libmultipath/structs_vec.c | 3 +--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f25fe9e..5edf959 100644
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
index a5446b4..095657b 100644
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
index 4d56107..d363e7f 100644
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
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

