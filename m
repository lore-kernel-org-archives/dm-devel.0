Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1698C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 04:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649910475;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=399NikyeoYVAm31KoEhcPWR2w6c4J9fqtht4UlWAgao=;
	b=XNyI4KuTuIeKAGGcrn8Si3Qd5pSpyNIiND3kNPGQ47yvkyP82f2LV52/oP1x/FWf1EcyUB
	3yYQfFTtgB3OSy9+ka8H6jm2sUBBYRvfQp5UkzyhHa70gsa8YMw02YUtmnxif7S+V95/GV
	ycIXF0X3bSAI/pwN/KIqXpj8GPfDT+4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-GvFZOKEMPxe93LnxWpeBow-1; Thu, 14 Apr 2022 00:27:52 -0400
X-MC-Unique: GvFZOKEMPxe93LnxWpeBow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CC1880159B;
	Thu, 14 Apr 2022 04:27:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AB9CC08087;
	Thu, 14 Apr 2022 04:27:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 376171940347;
	Thu, 14 Apr 2022 04:27:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 066D31940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 04:27:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DCE68141ADA5; Thu, 14 Apr 2022 04:27:48 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BBE8D14582F6;
 Thu, 14 Apr 2022 04:27:48 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23E4Rlih025317;
 Wed, 13 Apr 2022 23:27:47 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23E4RlS6025316;
 Wed, 13 Apr 2022 23:27:47 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 13 Apr 2022 23:27:38 -0500
Message-Id: <1649910461-25263-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v2 4/7] libmultipath: Set the scsi timeout
 parameters by path
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instead of dev_loss, fast_io_fail, and eh_deadline belonging to the
multipath structure, have them belong to the path structure. This means
that they are selected per path, and that sysfs_set_scsi_tmo() doesn't
assume that all paths of a multipath device will have the same value.
Currently they will all be the same, but a future patch will make it
possible for paths to have different values based on their protocol.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c |   5 +-
 libmultipath/discovery.c | 174 ++++++++++++++++++++++-----------------
 libmultipath/discovery.h |   2 +-
 libmultipath/propsel.c   |  42 +++++-----
 libmultipath/propsel.h   |   6 +-
 libmultipath/structs.c   |   1 -
 libmultipath/structs.h   |   6 +-
 7 files changed, 127 insertions(+), 109 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index eca11ba0..09ae708d 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -329,9 +329,6 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	select_mode(conf, mpp);
 	select_uid(conf, mpp);
 	select_gid(conf, mpp);
-	select_fast_io_fail(conf, mpp);
-	select_dev_loss(conf, mpp);
-	select_eh_deadline(conf, mpp);
 	select_reservation_key(conf, mpp);
 	select_deferred_remove(conf, mpp);
 	select_marginal_path_err_sample_time(conf, mpp);
@@ -347,7 +344,7 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	select_ghost_delay(conf, mpp);
 	select_flush_on_last_del(conf, mpp);
 
-	sysfs_set_scsi_tmo(mpp, conf->checkint);
+	sysfs_set_scsi_tmo(conf, mpp);
 	marginal_pathgroups = conf->marginal_pathgroups;
 	pthread_cleanup_pop(1);
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b969fba1..c6ba1967 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -598,13 +598,13 @@ sysfs_get_asymmetric_access_state(struct path *pp, char *buff, int buflen)
 }
 
 static int
-sysfs_set_eh_deadline(struct multipath *mpp, struct path *pp)
+sysfs_set_eh_deadline(struct path *pp)
 {
 	struct udev_device *hostdev;
 	char host_name[HOST_NAME_LEN], value[16];
 	int ret, len;
 
-	if (mpp->eh_deadline == EH_DEADLINE_UNSET)
+	if (pp->eh_deadline == EH_DEADLINE_UNSET)
 		return 0;
 
 	sprintf(host_name, "host%d", pp->sg_id.host_no);
@@ -613,12 +613,12 @@ sysfs_set_eh_deadline(struct multipath *mpp, struct path *pp)
 	if (!hostdev)
 		return 1;
 
-	if (mpp->eh_deadline == EH_DEADLINE_OFF)
+	if (pp->eh_deadline == EH_DEADLINE_OFF)
 		len = sprintf(value, "off");
-	else if (mpp->eh_deadline == EH_DEADLINE_ZERO)
+	else if (pp->eh_deadline == EH_DEADLINE_ZERO)
 		len = sprintf(value, "0");
 	else
-		len = sprintf(value, "%d", mpp->eh_deadline);
+		len = sprintf(value, "%d", pp->eh_deadline);
 
 	ret = sysfs_attr_set_value(hostdev, "eh_deadline",
 				   value, len + 1);
@@ -642,8 +642,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	unsigned int tmo;
 	int ret;
 
-	if (mpp->dev_loss == DEV_LOSS_TMO_UNSET &&
-	    mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
+	if (pp->dev_loss == DEV_LOSS_TMO_UNSET &&
+	    pp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
 		return;
 
 	sprintf(rport_id, "rport-%d:%d-%d",
@@ -685,14 +685,14 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	 * then set fast_io_fail, and _then_ set dev_loss_tmo
 	 * to the correct value.
 	 */
-	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
-	    mpp->fast_io_fail != MP_FAST_IO_FAIL_ZERO &&
-	    mpp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
+	if (pp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
+	    pp->fast_io_fail != MP_FAST_IO_FAIL_ZERO &&
+	    pp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
 		/* Check if we need to temporarily increase dev_loss_tmo */
-		if ((unsigned int)mpp->fast_io_fail >= tmo) {
+		if ((unsigned int)pp->fast_io_fail >= tmo) {
 			/* Increase dev_loss_tmo temporarily */
 			snprintf(value, sizeof(value), "%u",
-				 (unsigned int)mpp->fast_io_fail + 1);
+				 (unsigned int)pp->fast_io_fail + 1);
 			ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
 						   value, strlen(value));
 			if (ret <= 0) {
@@ -706,20 +706,20 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 				goto out;
 			}
 		}
-	} else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO &&
-		mpp->no_path_retry != NO_PATH_RETRY_QUEUE) {
+	} else if (pp->dev_loss > DEFAULT_DEV_LOSS_TMO &&
+		   mpp->no_path_retry != NO_PATH_RETRY_QUEUE) {
 		condlog(2, "%s: limiting dev_loss_tmo to %d, since "
 			"fast_io_fail is not set",
 			rport_id, DEFAULT_DEV_LOSS_TMO);
-		mpp->dev_loss = DEFAULT_DEV_LOSS_TMO;
+		pp->dev_loss = DEFAULT_DEV_LOSS_TMO;
 	}
-	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
-		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
+	if (pp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
+		if (pp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 			sprintf(value, "off");
-		else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
+		else if (pp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
 			sprintf(value, "0");
 		else
-			snprintf(value, 16, "%u", mpp->fast_io_fail);
+			snprintf(value, 16, "%u", pp->fast_io_fail);
 		ret = sysfs_attr_set_value(rport_dev, "fast_io_fail_tmo",
 					   value, strlen(value));
 		if (ret <= 0) {
@@ -730,8 +730,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 					rport_id, value, -ret);
 		}
 	}
-	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET) {
-		snprintf(value, 16, "%u", mpp->dev_loss);
+	if (pp->dev_loss != DEV_LOSS_TMO_UNSET) {
+		snprintf(value, 16, "%u", pp->dev_loss);
 		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
 					   value, strlen(value));
 		if (ret <= 0) {
@@ -747,15 +747,15 @@ out:
 }
 
 static void
-sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
+sysfs_set_session_tmo(struct path *pp)
 {
 	struct udev_device *session_dev = NULL;
 	char session_id[64];
 	char value[11];
 
-	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET)
+	if (pp->dev_loss != DEV_LOSS_TMO_UNSET)
 		condlog(3, "%s: ignoring dev_loss_tmo on iSCSI", pp->dev);
-	if (mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
+	if (pp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
 		return;
 
 	sprintf(session_id, "session%d", pp->sg_id.transport_id);
@@ -769,15 +769,15 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
 		pp->sg_id.channel, pp->sg_id.scsi_id, session_id);
 
-	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
-		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF) {
+	if (pp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
+		if (pp->fast_io_fail == MP_FAST_IO_FAIL_OFF) {
 			condlog(3, "%s: can't switch off fast_io_fail_tmo "
 				"on iSCSI", pp->dev);
-		} else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO) {
+		} else if (pp->fast_io_fail == MP_FAST_IO_FAIL_ZERO) {
 			condlog(3, "%s: can't set fast_io_fail_tmo to '0'"
 				"on iSCSI", pp->dev);
 		} else {
-			snprintf(value, 11, "%u", mpp->fast_io_fail);
+			snprintf(value, 11, "%u", pp->fast_io_fail);
 			if (sysfs_attr_set_value(session_dev, "recovery_tmo",
 						 value, strlen(value)) <= 0) {
 				condlog(3, "%s: Failed to set recovery_tmo, "
@@ -790,14 +790,14 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 }
 
 static void
-sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
+sysfs_set_nexus_loss_tmo(struct path *pp)
 {
 	struct udev_device *parent, *sas_dev = NULL;
 	const char *end_dev_id = NULL;
 	char value[11];
 	static const char ed_str[] = "end_device-";
 
-	if (!pp->udev || mpp->dev_loss == DEV_LOSS_TMO_UNSET)
+	if (!pp->udev || pp->dev_loss == DEV_LOSS_TMO_UNSET)
 		return;
 
 	for (parent = udev_device_get_parent(pp->udev);
@@ -824,8 +824,8 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
 		pp->sg_id.channel, pp->sg_id.scsi_id, end_dev_id);
 
-	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET) {
-		snprintf(value, 11, "%u", mpp->dev_loss);
+	if (pp->dev_loss != DEV_LOSS_TMO_UNSET) {
+		snprintf(value, 11, "%u", pp->dev_loss);
 		if (sysfs_attr_set_value(sas_dev, "I_T_nexus_loss_timeout",
 					 value, strlen(value)) <= 0)
 			condlog(3, "%s: failed to update "
@@ -836,76 +836,98 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 	return;
 }
 
+static void
+scsi_tmo_error_msg(struct path *pp)
+{
+	STATIC_BITFIELD(bf, LAST_BUS_PROTOCOL_ID + 1);
+	STRBUF_ON_STACK(proto_buf);
+	unsigned int proto_id = bus_protocol_id(pp);
+
+	snprint_path_protocol(&proto_buf, pp);
+	condlog(2, "%s: setting scsi timeouts is unsupported for protocol %s",
+		pp->dev, get_strbuf_str(&proto_buf));
+	set_bit_in_bitfield(proto_id, bf);
+}
+
 int
-sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
+sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
 {
 	struct path *pp;
 	int i;
-	unsigned int dev_loss_tmo = mpp->dev_loss;
-	struct path *err_path = NULL;
-	STATIC_BITFIELD(bf, LAST_BUS_PROTOCOL_ID + 1);
+	unsigned int min_dev_loss = 0;
+	bool warn_dev_loss = false;
+	bool warn_fast_io_fail = false;
 
 	if (mpp->no_path_retry > 0) {
 		uint64_t no_path_retry_tmo =
-			(uint64_t)mpp->no_path_retry * checkint;
+			(uint64_t)mpp->no_path_retry * conf->checkint;
 
 		if (no_path_retry_tmo > MAX_DEV_LOSS_TMO)
-			no_path_retry_tmo = MAX_DEV_LOSS_TMO;
-		if (no_path_retry_tmo > dev_loss_tmo)
-			dev_loss_tmo = no_path_retry_tmo;
-	} else if (mpp->no_path_retry == NO_PATH_RETRY_QUEUE) {
-		dev_loss_tmo = MAX_DEV_LOSS_TMO;
-	}
-	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET &&
-	    mpp->dev_loss != dev_loss_tmo) {
-		condlog(2, "%s: Using dev_loss_tmo=%u instead of %u because of no_path_retry setting",
-			mpp->alias, dev_loss_tmo, mpp->dev_loss);
-		mpp->dev_loss = dev_loss_tmo;
-	}
-	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET &&
-	    mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
-	    (unsigned int)mpp->fast_io_fail >= mpp->dev_loss) {
-		condlog(3, "%s: turning off fast_io_fail (%d is not smaller than dev_loss_tmo)",
-			mpp->alias, mpp->fast_io_fail);
-		mpp->fast_io_fail = MP_FAST_IO_FAIL_OFF;
-	}
-	if (mpp->dev_loss == DEV_LOSS_TMO_UNSET &&
-	    mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET &&
-	    mpp->eh_deadline == EH_DEADLINE_UNSET)
-		return 0;
+			min_dev_loss = MAX_DEV_LOSS_TMO;
+		else
+			min_dev_loss = no_path_retry_tmo;
+	} else if (mpp->no_path_retry == NO_PATH_RETRY_QUEUE)
+		min_dev_loss = MAX_DEV_LOSS_TMO;
 
 	vector_foreach_slot(mpp->paths, pp, i) {
+		select_fast_io_fail(conf, pp);
+		select_dev_loss(conf, pp);
+		select_eh_deadline(conf, pp);
+
+		if (pp->dev_loss == DEV_LOSS_TMO_UNSET &&
+		    pp->fast_io_fail == MP_FAST_IO_FAIL_UNSET &&
+		    pp->eh_deadline == EH_DEADLINE_UNSET)
+			continue;
+
 		if (pp->bus != SYSFS_BUS_SCSI) {
-			if (!err_path)
-				err_path = pp;
+			scsi_tmo_error_msg(pp);
 			continue;
 		}
+		sysfs_set_eh_deadline(pp);
+
+		if (pp->dev_loss == DEV_LOSS_TMO_UNSET &&
+		    pp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
+			continue;
+
+		if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP &&
+		    pp->sg_id.proto_id != SCSI_PROTOCOL_ISCSI &&
+		    pp->sg_id.proto_id != SCSI_PROTOCOL_SAS) {
+			scsi_tmo_error_msg(pp);
+			continue;
+		}
+
+		if (pp->dev_loss != DEV_LOSS_TMO_UNSET &&
+		    pp->dev_loss < min_dev_loss) {
+			warn_dev_loss = true;
+			pp->dev_loss = min_dev_loss;
+		}
+		if (pp->dev_loss != DEV_LOSS_TMO_UNSET &&
+		    pp->fast_io_fail > 0 &&
+		    (unsigned int)pp->fast_io_fail >= pp->dev_loss) {
+			warn_fast_io_fail = true;
+			pp->fast_io_fail = MP_FAST_IO_FAIL_OFF;
+		}
 
 		switch (pp->sg_id.proto_id) {
 		case SCSI_PROTOCOL_FCP:
 			sysfs_set_rport_tmo(mpp, pp);
 			break;
 		case SCSI_PROTOCOL_ISCSI:
-			sysfs_set_session_tmo(mpp, pp);
+			sysfs_set_session_tmo(pp);
 			break;
 		case SCSI_PROTOCOL_SAS:
-			sysfs_set_nexus_loss_tmo(mpp, pp);
+			sysfs_set_nexus_loss_tmo(pp);
 			break;
 		default:
-			if (!err_path)
-				err_path = pp;
+			break;
 		}
-		sysfs_set_eh_deadline(mpp, pp);
-	}
-
-	if (err_path && !is_bit_set_in_bitfield(bus_protocol_id(pp), bf)) {
-		STRBUF_ON_STACK(proto_buf);
-
-		snprint_path_protocol(&proto_buf, err_path);
-		condlog(2, "%s: setting dev_loss_tmo is unsupported for protocol %s",
-			mpp->alias, get_strbuf_str(&proto_buf));
-		set_bit_in_bitfield(bus_protocol_id(pp), bf);
 	}
+	if (warn_dev_loss)
+		condlog(2, "%s: Raising dev_loss_tmo to %u because of no_path_retry setting",
+			mpp->alias, min_dev_loss);
+	if (warn_fast_io_fail)
+		condlog(3, "%s: turning off fast_io_fail (not smaller than dev_loss_tmo)",
+			mpp->alias);
 	return 0;
 }
 
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 466af345..acd51792 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -42,7 +42,7 @@ int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
-int sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint);
+int sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp);
 int sysfs_get_timeout(const struct path *pp, unsigned int *timeout);
 int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address);
 int sysfs_get_host_adapter_name(const struct path *pp,
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 1419ec6f..d2d70090 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -769,53 +769,53 @@ int select_minio(struct config *conf, struct multipath *mp)
 		return select_minio_bio(conf, mp);
 }
 
-int select_fast_io_fail(struct config *conf, struct multipath *mp)
+int select_fast_io_fail(struct config *conf, struct path *pp)
 {
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	mp_set_ovr(fast_io_fail);
-	mp_set_hwe(fast_io_fail);
-	mp_set_conf(fast_io_fail);
-	mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
+	pp_set_ovr(fast_io_fail);
+	pp_set_hwe(fast_io_fail);
+	pp_set_conf(fast_io_fail);
+	pp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
 out:
-	print_undef_off_zero(&buff, mp->fast_io_fail);
-	condlog(3, "%s: fast_io_fail_tmo = %s %s", mp->alias,
+	print_undef_off_zero(&buff, pp->fast_io_fail);
+	condlog(3, "%s: fast_io_fail_tmo = %s %s", pp->dev,
 		get_strbuf_str(&buff), origin);
 	return 0;
 }
 
-int select_dev_loss(struct config *conf, struct multipath *mp)
+int select_dev_loss(struct config *conf, struct path *pp)
 {
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	mp_set_ovr(dev_loss);
-	mp_set_hwe(dev_loss);
-	mp_set_conf(dev_loss);
-	mp->dev_loss = DEV_LOSS_TMO_UNSET;
+	pp_set_ovr(dev_loss);
+	pp_set_hwe(dev_loss);
+	pp_set_conf(dev_loss);
+	pp->dev_loss = DEV_LOSS_TMO_UNSET;
 	return 0;
 out:
-	print_dev_loss(&buff, mp->dev_loss);
-	condlog(3, "%s: dev_loss_tmo = %s %s", mp->alias,
+	print_dev_loss(&buff, pp->dev_loss);
+	condlog(3, "%s: dev_loss_tmo = %s %s", pp->dev,
 		get_strbuf_str(&buff), origin);
 	return 0;
 }
 
-int select_eh_deadline(struct config *conf, struct multipath *mp)
+int select_eh_deadline(struct config *conf, struct path *pp)
 {
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	mp_set_ovr(eh_deadline);
-	mp_set_hwe(eh_deadline);
-	mp_set_conf(eh_deadline);
-	mp->eh_deadline = EH_DEADLINE_UNSET;
+	pp_set_ovr(eh_deadline);
+	pp_set_hwe(eh_deadline);
+	pp_set_conf(eh_deadline);
+	pp->eh_deadline = EH_DEADLINE_UNSET;
 	/* not changing sysfs in default cause, so don't print anything */
 	return 0;
 out:
-	print_undef_off_zero(&buff, mp->eh_deadline);
-	condlog(3, "%s: eh_deadline = %s %s", mp->alias,
+	print_undef_off_zero(&buff, pp->eh_deadline);
+	condlog(3, "%s: eh_deadline = %s %s", pp->dev,
 		get_strbuf_str(&buff), origin);
 	return 0;
 }
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 72a7e33c..152ca44c 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -16,9 +16,9 @@ int select_minio(struct config *conf, struct multipath *mp);
 int select_mode(struct config *conf, struct multipath *mp);
 int select_uid(struct config *conf, struct multipath *mp);
 int select_gid(struct config *conf, struct multipath *mp);
-int select_fast_io_fail(struct config *conf, struct multipath *mp);
-int select_dev_loss(struct config *conf, struct multipath *mp);
-int select_eh_deadline(struct config *conf, struct multipath *mp);
+int select_fast_io_fail(struct config *conf, struct path *pp);
+int select_dev_loss(struct config *conf, struct path *pp);
+int select_eh_deadline(struct config *conf, struct path *pp);
 int select_reservation_key(struct config *conf, struct multipath *mp);
 int select_retain_hwhandler (struct config *conf, struct multipath * mp);
 int select_detect_prio(struct config *conf, struct path * pp);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 04cfdcdc..2c9be041 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -246,7 +246,6 @@ alloc_multipath (void)
 		mpp->bestpg = 1;
 		mpp->mpcontext = NULL;
 		mpp->no_path_retry = NO_PATH_RETRY_UNDEF;
-		mpp->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
 		dm_multipath_to_gen(mpp)->ops = &dm_gen_multipath_ops;
 	}
 	return mpp;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 3722e31b..a6749367 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -349,6 +349,9 @@ struct path {
 	int marginal;
 	int vpd_vendor_id;
 	int recheck_wwid;
+	int fast_io_fail;
+	unsigned int dev_loss;
+	int eh_deadline;
 	/* configlet pointers */
 	vector hwe;
 	struct gen_path generic_path;
@@ -376,7 +379,6 @@ struct multipath {
 	int minio;
 	int flush_on_last_del;
 	int attribute_flags;
-	int fast_io_fail;
 	int retain_hwhandler;
 	int deferred_remove;
 	bool in_recovery;
@@ -395,8 +397,6 @@ struct multipath {
 	int needs_paths_uevent;
 	int ghost_delay;
 	int ghost_delay_tick;
-	unsigned int dev_loss;
-	int eh_deadline;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

