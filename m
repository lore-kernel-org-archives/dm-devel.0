Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276E7C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 21:28:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F20364DA8
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 21:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F20364DA8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-34BZj4geM3KshkBmGon_Xg-1; Tue, 02 Feb 2021 16:27:58 -0500
X-MC-Unique: 34BZj4geM3KshkBmGon_Xg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FB9B803622;
	Tue,  2 Feb 2021 21:27:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A526010016DB;
	Tue,  2 Feb 2021 21:27:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 256925003C;
	Tue,  2 Feb 2021 21:27:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112LRoKJ015476 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 16:27:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6237D1016D71; Tue,  2 Feb 2021 21:27:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E6FA1102E1E
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 21:27:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF69680027F
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 21:27:47 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-381-a4WtywhjNwaesb9SazgvSQ-1;
	Tue, 02 Feb 2021 16:27:42 -0500
X-MC-Unique: a4WtywhjNwaesb9SazgvSQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5155FADE1;
	Tue,  2 Feb 2021 21:27:41 +0000 (UTC)
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>, lixiaokeng@huawei.com
Date: Tue,  2 Feb 2021 22:27:28 +0100
Message-Id: <20210202212729.18442-3-mwilck@suse.com>
In-Reply-To: <20210202212729.18442-1-mwilck@suse.com>
References: <20210202212729.18442-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 112LRoKJ015476
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/3] libmultipath: pathinfo: call filter_property
	only with DI_BLACKLIST
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

With the previous change to call filter_property() after sysfs_pathinfo(),
it can't happen any more that filter_property() is called from pathinfo
with uid_attribute not set. This may cause pathinfo() to return failure
in some cases where it should actually proceed (e.g. when called from
"multipath -m" -> get_refwwid(). Therefore, don't call filter_property()
any more unless DI_BLACKLIST is set.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 16 ++++++----------
 tests/test-lib.c         | 17 +++++++++--------
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index febcd0a..9be94cd 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2255,8 +2255,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		 * uid_attribute is required for filter_property below,
 		 * and needs access to pp->hwe.
 		 */
-		if (!(mask & DI_SYSFS) && !pp->uid_attribute &&
-		    VECTOR_SIZE(pp->hwe) == 0)
+		if (!(mask & DI_SYSFS) && (mask & DI_BLACKLIST) &&
+		    !pp->uid_attribute && VECTOR_SIZE(pp->hwe) == 0)
 			mask |= DI_SYSFS;
 	}
 
@@ -2295,17 +2295,13 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		}
 	}
 
-	if (pp->udev) {
+	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
 		/* uid_attribute is required for filter_property() */
-		if (!pp->uid_attribute)
+		if (pp->udev && !pp->uid_attribute)
 			select_getuid(conf, pp);
 
-		if (filter_property(conf, pp->udev, 4, pp->uid_attribute) > 0)
-			return PATHINFO_SKIPPED;
-	}
-
-	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
-		if (filter_device(conf->blist_device, conf->elist_device,
+		if (filter_property(conf, pp->udev, 4, pp->uid_attribute) > 0 ||
+		    filter_device(conf->blist_device, conf->elist_device,
 				  pp->vendor_id, pp->product_id, pp->dev) > 0 ||
 		    filter_protocol(conf->blist_protocol, conf->elist_protocol,
 				    pp) > 0)
diff --git a/tests/test-lib.c b/tests/test-lib.c
index 960a766..f5542ed 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -260,14 +260,15 @@ void mock_pathinfo(int mask, const struct mocked_path *mp)
 	if (mask & DI_SYSFS)
 		mock_sysfs_pathinfo(mp);
 
-	/* filter_property */
-	will_return(__wrap_udev_device_get_sysname, mp->devnode);
-	if (mp->flags & BL_BY_PROPERTY) {
-		will_return(__wrap_udev_list_entry_get_name, "BAZ");
-		return;
-	} else
-		will_return(__wrap_udev_list_entry_get_name,
-			    "SCSI_IDENT_LUN_NAA_EXT");
+	if (mask & DI_BLACKLIST) {
+		will_return(__wrap_udev_device_get_sysname, mp->devnode);
+		if (mp->flags & BL_BY_PROPERTY) {
+			will_return(__wrap_udev_list_entry_get_name, "BAZ");
+			return;
+		} else
+			will_return(__wrap_udev_list_entry_get_name,
+				    "SCSI_IDENT_LUN_NAA_EXT");
+	}
 
 	if (mp->flags & BL_BY_DEVICE &&
 	    (mask & DI_BLACKLIST && mask & DI_SYSFS))
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

