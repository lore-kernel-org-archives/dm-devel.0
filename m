Return-Path: <SRS0=Z7ED=LY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D24CC11F65
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 20:02:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A48EF61477
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 20:02:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A48EF61477
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-FRDVfAKMOLiMfzz3D1uM0Q-1; Wed, 30 Jun 2021 16:02:11 -0400
X-MC-Unique: FRDVfAKMOLiMfzz3D1uM0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A08D10C1ADC;
	Wed, 30 Jun 2021 20:02:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B3DF1001281;
	Wed, 30 Jun 2021 20:02:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 889D31809C99;
	Wed, 30 Jun 2021 20:02:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15UK1wqw016132 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Jun 2021 16:01:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7AADE20285C8; Wed, 30 Jun 2021 20:01:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75B3F20285BC
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 20:01:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98AAA800B28
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 20:01:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-115-LuyHgA7EO_qPhTRyS7OIHw-1; Wed, 30 Jun 2021 16:01:51 -0400
X-MC-Unique: LuyHgA7EO_qPhTRyS7OIHw-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 984DF1FEFA;
	Wed, 30 Jun 2021 20:01:49 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id 5CDB0118DD;
	Wed, 30 Jun 2021 20:01:49 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id 5qt3FK3N3GCmSQAALh3uQQ
	(envelope-from <mwilck@suse.com>); Wed, 30 Jun 2021 20:01:49 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 30 Jun 2021 22:01:35 +0200
Message-Id: <20210630200135.8423-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15UK1wqw016132
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] libmultipath: use uint64_t for sg_id.lun
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

SCSI LUNs are 64bit unsigned integers, and have been exposed as such by
the kernel for years. Storage using the full 8 bytes is fortunately rare.
Still, we should handle this properly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c                 | 10 +++++-----
 libmultipath/print.c                     |  2 +-
 libmultipath/prioritizers/weightedpath.c |  2 +-
 libmultipath/structs.c                   |  2 +-
 libmultipath/structs.h                   |  4 +++-
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index bfe2f56..e9f5703 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1427,7 +1427,7 @@ scsi_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 			attr_path = udev_device_get_sysname(parent);
 			if (!attr_path)
 				break;
-			if (sscanf(attr_path, "%i:%i:%i:%i",
+			if (sscanf(attr_path, "%i:%i:%i:%" SCNu64,
 				   &pp->sg_id.host_no,
 				   &pp->sg_id.channel,
 				   &pp->sg_id.scsi_id,
@@ -1462,7 +1462,7 @@ scsi_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 	/*
 	 * host / bus / target / lun
 	 */
-	condlog(3, "%s: h:b:t:l = %i:%i:%i:%i",
+	condlog(3, "%s: h:b:t:l = %i:%i:%i:%" PRIu64,
 			pp->dev,
 			pp->sg_id.host_no,
 			pp->sg_id.channel,
@@ -1577,7 +1577,7 @@ ccw_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 		   &pp->sg_id.host_no,
 		   &pp->sg_id.channel,
 		   &pp->sg_id.scsi_id) == 3) {
-		condlog(3, "%s: h:b:t:l = %i:%i:%i:%i",
+		condlog(3, "%s: h:b:t:l = %i:%i:%i:%" PRIu64,
 			pp->dev,
 			pp->sg_id.host_no,
 			pp->sg_id.channel,
@@ -1636,7 +1636,7 @@ cciss_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 	 */
 	pp->sg_id.lun = 0;
 	pp->sg_id.channel = 0;
-	condlog(3, "%s: h:b:t:l = %i:%i:%i:%i",
+	condlog(3, "%s: h:b:t:l = %i:%i:%i:%" PRIu64,
 		pp->dev,
 		pp->sg_id.host_no,
 		pp->sg_id.channel,
@@ -1815,7 +1815,7 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 			attr_path = udev_device_get_sysname(parent);
 			if (!attr_path)
 				break;
-			if (sscanf(attr_path, "%i:%i:%i:%i",
+			if (sscanf(attr_path, "%i:%i:%i:%" SCNu64,
 				   &pp->sg_id.host_no,
 				   &pp->sg_id.channel,
 				   &pp->sg_id.scsi_id,
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 3c69bf4..29ce499 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -392,7 +392,7 @@ snprint_hcil (char * buff, size_t len, const struct path * pp)
 	if (!pp || pp->sg_id.host_no < 0)
 		return snprintf(buff, len, "#:#:#:#");
 
-	return snprintf(buff, len, "%i:%i:%i:%i",
+	return snprintf(buff, len, "%i:%i:%i:%" PRIu64,
 			pp->sg_id.host_no,
 			pp->sg_id.channel,
 			pp->sg_id.scsi_id,
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 916970d..650088b 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -101,7 +101,7 @@ int prio_path_weight(struct path *pp, char *prio_args)
 	}
 
 	if (!strcmp(regex, HBTL)) {
-		sprintf(path, "%d:%d:%d:%d", pp->sg_id.host_no,
+		sprintf(path, "%d:%d:%d:%" PRIu64, pp->sg_id.host_no,
 			pp->sg_id.channel, pp->sg_id.scsi_id, pp->sg_id.lun);
 	} else if (!strcmp(regex, DEV_NAME)) {
 		strcpy(path, pp->dev);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 8751fc2..6e5a103 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -96,7 +96,7 @@ alloc_path (void)
 		pp->sg_id.host_no = -1;
 		pp->sg_id.channel = -1;
 		pp->sg_id.scsi_id = -1;
-		pp->sg_id.lun = -1;
+		pp->sg_id.lun = SCSI_INVALID_LUN;
 		pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
 		pp->fd = -1;
 		pp->tpgs = TPGS_UNDEF;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c8447e5..c52bcee 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -178,6 +178,8 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
+#define SCSI_INVALID_LUN ~0ULL
+
 enum no_undef_states {
 	NU_NO = -1,
 	NU_UNDEF = 0,
@@ -258,7 +260,7 @@ struct sg_id {
 	int host_no;
 	int channel;
 	int scsi_id;
-	int lun;
+	uint64_t lun;
 	short h_cmd_per_lun;
 	short d_queue_depth;
 	enum scsi_protocol proto_id;
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

