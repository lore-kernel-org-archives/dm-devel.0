Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EF8C2BBD4
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 22:51:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 19E0D23A24
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 22:51:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19E0D23A24
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608245498;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j11QQddkM2zOiQ8qe2nyhrmhcEzQOTNFN0caE1ZkP6U=;
	b=XsOV4n4LJhpgk0zT3jtAiBUqjnGBecCtm/RepX4RT9VfcFHqj2XVU0pJE+mED+AJxx6M4l
	XoeUwuPC7r9kUk7fWhBzcuLetKbaTaatPU0J75XSxS58Se+3DQZ6WLpoqlSJrFCmpY4dlC
	+o0vC8RaLoupOs59pxGdisit1J6T5r0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-anKl79ILP02fJwgmqtU6uw-1; Thu, 17 Dec 2020 17:51:35 -0500
X-MC-Unique: anKl79ILP02fJwgmqtU6uw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1337D1005504;
	Thu, 17 Dec 2020 22:51:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED55B60C61;
	Thu, 17 Dec 2020 22:51:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BF1B21809CA0;
	Thu, 17 Dec 2020 22:51:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHMpBxI008336 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 17:51:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6F4E219EF2; Thu, 17 Dec 2020 22:51:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E26402BFE4;
	Thu, 17 Dec 2020 22:51:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BHMp6Jg001859; 
	Thu, 17 Dec 2020 16:51:06 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BHMp6Tv001858;
	Thu, 17 Dec 2020 16:51:06 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 17 Dec 2020 16:51:00 -0600
Message-Id: <1608245463-1746-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608245463-1746-1-git-send-email-bmarzins@redhat.com>
References: <1608245463-1746-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 2/5] libmultipath: add eh_deadline
	multipath.conf parameter
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are times a fc rport is never lost, meaning that fast_io_fail_tmo
and dev_loss_tmo never trigger, but scsi commands still hang. This can
cause problems in cases where users have strict timing requirements, and
the easiest way to solve these issues is to set eh_deadline. Since it's
already possible to set fast_io_fail_tmo and dev_loss_tmo from
multipath.conf, and have multipath take care of setting it correctly for
the scsi devices in sysfs, it makes sense to allow users to set
eh_deadline here as well.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  2 ++
 libmultipath/config.h      |  2 ++
 libmultipath/configure.c   |  1 +
 libmultipath/dict.c        | 10 +++++++
 libmultipath/discovery.c   | 60 +++++++++++++++++++++++++++++++++-----
 libmultipath/propsel.c     | 17 +++++++++++
 libmultipath/propsel.h     |  1 +
 libmultipath/structs.h     |  7 +++++
 multipath/multipath.conf.5 | 16 ++++++++++
 9 files changed, 109 insertions(+), 7 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 49e7fb81..9f3cb38d 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -424,6 +424,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(flush_on_last_del);
 	merge_num(fast_io_fail);
 	merge_num(dev_loss);
+	merge_num(eh_deadline);
 	merge_num(user_friendly_names);
 	merge_num(retain_hwhandler);
 	merge_num(detect_prio);
@@ -579,6 +580,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->flush_on_last_del = dhwe->flush_on_last_del;
 	hwe->fast_io_fail = dhwe->fast_io_fail;
 	hwe->dev_loss = dhwe->dev_loss;
+	hwe->eh_deadline = dhwe->eh_deadline;
 	hwe->user_friendly_names = dhwe->user_friendly_names;
 	hwe->retain_hwhandler = dhwe->retain_hwhandler;
 	hwe->detect_prio = dhwe->detect_prio;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 661dd586..9ce37f16 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -63,6 +63,7 @@ struct hwentry {
 	int flush_on_last_del;
 	int fast_io_fail;
 	unsigned int dev_loss;
+	int eh_deadline;
 	int user_friendly_names;
 	int retain_hwhandler;
 	int detect_prio;
@@ -148,6 +149,7 @@ struct config {
 	int attribute_flags;
 	int fast_io_fail;
 	unsigned int dev_loss;
+	int eh_deadline;
 	int log_checker_err;
 	int allow_queueing;
 	int allow_usb_devices;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3dbc1f16..4da705d2 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -368,6 +368,7 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	select_gid(conf, mpp);
 	select_fast_io_fail(conf, mpp);
 	select_dev_loss(conf, mpp);
+	select_eh_deadline(conf, mpp);
 	select_reservation_key(conf, mpp);
 	select_deferred_remove(conf, mpp);
 	select_marginal_path_err_sample_time(conf, mpp);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index f4357da1..bab96146 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -899,6 +899,13 @@ declare_ovr_snprint(dev_loss, print_dev_loss)
 declare_hw_handler(dev_loss, set_dev_loss)
 declare_hw_snprint(dev_loss, print_dev_loss)
 
+declare_def_handler(eh_deadline, set_undef_off_zero)
+declare_def_snprint(eh_deadline, print_undef_off_zero)
+declare_ovr_handler(eh_deadline, set_undef_off_zero)
+declare_ovr_snprint(eh_deadline, print_undef_off_zero)
+declare_hw_handler(eh_deadline, set_undef_off_zero)
+declare_hw_snprint(eh_deadline, print_undef_off_zero)
+
 static int
 set_pgpolicy(vector strvec, void *ptr)
 {
@@ -1771,6 +1778,7 @@ init_keywords(vector keywords)
 	install_keyword("gid", &def_gid_handler, &snprint_def_gid);
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
+	install_keyword("eh_deadline", &def_eh_deadline_handler, &snprint_def_eh_deadline);
 	install_keyword("bindings_file", &def_bindings_file_handler, &snprint_def_bindings_file);
 	install_keyword("wwids_file", &def_wwids_file_handler, &snprint_def_wwids_file);
 	install_keyword("prkeys_file", &def_prkeys_file_handler, &snprint_def_prkeys_file);
@@ -1880,6 +1888,7 @@ init_keywords(vector keywords)
 	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
 	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
 	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
+	install_keyword("eh_deadline", &hw_eh_deadline_handler, &snprint_hw_eh_deadline);
 	install_keyword("user_friendly_names", &hw_user_friendly_names_handler, &snprint_hw_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
@@ -1920,6 +1929,7 @@ init_keywords(vector keywords)
 	install_keyword("flush_on_last_del", &ovr_flush_on_last_del_handler, &snprint_ovr_flush_on_last_del);
 	install_keyword("fast_io_fail_tmo", &ovr_fast_io_fail_handler, &snprint_ovr_fast_io_fail);
 	install_keyword("dev_loss_tmo", &ovr_dev_loss_handler, &snprint_ovr_dev_loss);
+	install_keyword("eh_deadline", &ovr_eh_deadline_handler, &snprint_ovr_eh_deadline);
 	install_keyword("user_friendly_names", &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
 	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c74f13bf..add7bb97 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -587,6 +587,42 @@ sysfs_get_asymmetric_access_state(struct path *pp, char *buff, int buflen)
 	return !!preferred;
 }
 
+static int
+sysfs_set_eh_deadline(struct multipath *mpp, struct path *pp)
+{
+	struct udev_device *hostdev;
+	char host_name[HOST_NAME_LEN], value[16];
+	int ret, len;
+
+	if (mpp->eh_deadline == EH_DEADLINE_UNSET)
+		return 0;
+
+	sprintf(host_name, "host%d", pp->sg_id.host_no);
+	hostdev = udev_device_new_from_subsystem_sysname(udev,
+			"scsi_host", host_name);
+	if (!hostdev)
+		return 1;
+
+	if (mpp->eh_deadline == EH_DEADLINE_OFF)
+		len = sprintf(value, "off");
+	else if (mpp->eh_deadline == EH_DEADLINE_ZERO)
+		len = sprintf(value, "0");
+	else
+		len = sprintf(value, "%d", mpp->eh_deadline);
+
+	ret = sysfs_attr_set_value(hostdev, "eh_deadline",
+				   value, len + 1);
+	/*
+	 * not all scsi drivers support setting eh_deadline, so failing
+	 * is totally reasonable
+	 */
+	if (ret <= 0)
+		condlog(3, "%s: failed to set eh_deadline to %s, error %d", udev_device_get_sysname(hostdev), value, -ret);
+
+	udev_device_unref(hostdev);
+	return (ret <= 0);
+}
+
 static void
 sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 {
@@ -596,6 +632,10 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	unsigned int tmo;
 	int ret;
 
+	if (mpp->dev_loss == DEV_LOSS_TMO_UNSET &&
+	    mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
+		return;
+
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
 	rport_dev = udev_device_new_from_subsystem_sysname(udev,
@@ -703,6 +743,11 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 	char session_id[64];
 	char value[11];
 
+	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET)
+		condlog(3, "%s: ignoring dev_loss_tmo on iSCSI", pp->dev);
+	if (mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
+		return;
+
 	sprintf(session_id, "session%d", pp->sg_id.transport_id);
 	session_dev = udev_device_new_from_subsystem_sysname(udev,
 				"iscsi_session", session_id);
@@ -714,9 +759,6 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
 		pp->sg_id.channel, pp->sg_id.scsi_id, session_id);
 
-	if (mpp->dev_loss != DEV_LOSS_TMO_UNSET) {
-		condlog(3, "%s: ignoring dev_loss_tmo on iSCSI", pp->dev);
-	}
 	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF) {
 			condlog(3, "%s: can't switch off fast_io_fail_tmo "
@@ -744,6 +786,8 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 	char end_dev_id[64];
 	char value[11];
 
+	if (mpp->dev_loss == DEV_LOSS_TMO_UNSET)
+		return;
 	sprintf(end_dev_id, "end_device-%d:%d",
 		pp->sg_id.host_no, pp->sg_id.transport_id);
 	sas_dev = udev_device_new_from_subsystem_sysname(udev,
@@ -801,7 +845,8 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 		mpp->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	}
 	if (mpp->dev_loss == DEV_LOSS_TMO_UNSET &&
-	    mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
+	    mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET &&
+	    mpp->eh_deadline == EH_DEADLINE_UNSET)
 		return 0;
 
 	vector_foreach_slot(mpp->paths, pp, i) {
@@ -814,17 +859,18 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
 		switch (pp->sg_id.proto_id) {
 		case SCSI_PROTOCOL_FCP:
 			sysfs_set_rport_tmo(mpp, pp);
-			continue;
+			break;
 		case SCSI_PROTOCOL_ISCSI:
 			sysfs_set_session_tmo(mpp, pp);
-			continue;
+			break;
 		case SCSI_PROTOCOL_SAS:
 			sysfs_set_nexus_loss_tmo(mpp, pp);
-			continue;
+			break;
 		default:
 			if (!err_path)
 				err_path = pp;
 		}
+		sysfs_set_eh_deadline(mpp, pp);
 	}
 
 	if (err_path) {
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 67d025cf..fa4ac5d9 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -775,6 +775,23 @@ out:
 	return 0;
 }
 
+int select_eh_deadline(struct config *conf, struct multipath *mp)
+{
+	const char *origin;
+	char buff[12];
+
+	mp_set_ovr(eh_deadline);
+	mp_set_hwe(eh_deadline);
+	mp_set_conf(eh_deadline);
+	mp->eh_deadline = EH_DEADLINE_UNSET;
+	/* not changing sysfs in default cause, so don't print anything */
+	return 0;
+out:
+	print_undef_off_zero(buff, 12, mp->eh_deadline);
+	condlog(3, "%s: eh_deadline = %s %s", mp->alias, buff, origin);
+	return 0;
+}
+
 int select_flush_on_last_del(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 3d6edd8a..a68bacf0 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -17,6 +17,7 @@ int select_uid(struct config *conf, struct multipath *mp);
 int select_gid(struct config *conf, struct multipath *mp);
 int select_fast_io_fail(struct config *conf, struct multipath *mp);
 int select_dev_loss(struct config *conf, struct multipath *mp);
+int select_eh_deadline(struct config *conf, struct multipath *mp);
 int select_reservation_key(struct config *conf, struct multipath *mp);
 int select_retain_hwhandler (struct config *conf, struct multipath * mp);
 int select_detect_prio(struct config *conf, struct path * pp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index cfa7b649..d6ff6762 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -236,6 +236,12 @@ enum fast_io_fail_states {
 	MP_FAST_IO_FAIL_ZERO = UOZ_ZERO,
 };
 
+enum eh_deadline_states {
+	EH_DEADLINE_UNSET = UOZ_UNDEF,
+	EH_DEADLINE_OFF = UOZ_OFF,
+	EH_DEADLINE_ZERO = UOZ_ZERO,
+};
+
 struct vpd_vendor_page {
 	int pg;
 	const char *name;
@@ -356,6 +362,7 @@ struct multipath {
 	int ghost_delay;
 	int ghost_delay_tick;
 	unsigned int dev_loss;
+	int eh_deadline;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 7242d39b..ea66a01e 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -717,6 +717,22 @@ The default is: \fB600\fR
 .
 .
 .TP
+.B eh_deadline
+Specify the maximum number of seconds the SCSI layer will spend doing error
+handling when scsi devices fail. After this timeout the scsi layer will perform
+a full HBA reset. Setting this may be necessary in cases where the rport is
+never lost, so \fIfast_io_fail_tmo\fR and \fIdev_loss_tmo\fR will never
+trigger, but (frequently do to load) scsi commands still hang. \fBNote:\fR when
+the scsi error handler performs the HBA reset, all target paths on that HBA
+will be affected. eh_deadline should only be set in cases where all targets on
+the affected HBAs are multipathed.
+.RS
+.TP
+The default is: \fB<unset>\fR
+.RE
+.
+.
+.TP
 .B bindings_file
 The full pathname of the binding file to be used when the user_friendly_names
 option is set.
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

