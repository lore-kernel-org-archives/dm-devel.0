Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B9722314
	for <dm-devel@lists.linux.dev>; Thu,  2 Nov 2023 22:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5Nhbprd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698963313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BpKgINVMTKy9vo4g+jpsOQB6JjueO19KLwPqwoXDtNw=;
	b=R5NhbprdE5tdEh2UNgpfi/dhfrcOF5sc6zFOHT0KQg7T08FHc+LsRlgo+bPdkMVPpK1I+l
	6i4HfE2o061RdKG1v/eipiKsZO04fcOueoesNxgZ1Uyw6nxEV4AWmkGKeZkbNwJlhgqbjC
	5V5LYZ4DavM+B8/FrPS2dxhzUA3EM+Y=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-Wt7gP8boOgaNw9lpvHqZog-1; Thu,
 02 Nov 2023 18:15:08 -0400
X-MC-Unique: Wt7gP8boOgaNw9lpvHqZog-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F35D91C113F5;
	Thu,  2 Nov 2023 22:15:07 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBF7F1C060BA;
	Thu,  2 Nov 2023 22:15:07 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A2MF7Fv105381
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 2 Nov 2023 18:15:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A2MF7aL105380;
	Thu, 2 Nov 2023 18:15:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/7] libmultipath: Add max_retries config option
Date: Thu,  2 Nov 2023 18:15:01 -0400
Message-ID: <20231102221507.105371-2-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-1-bmarzins@redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This option lets multipath set a scsi disk's max_retries sysfs value.
Setting this can be helpful for cases where the path checker succeeds,
but IO commands hang and timeout. By default, the SCSI layer will retry
IOs 5 times. Reducing this value will allow multipath to retry the IO
down another path sooner.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c         |  3 +++
 libmultipath/config.h         |  3 +++
 libmultipath/dict.c           | 34 ++++++++++++++++++++++++++++
 libmultipath/discovery.c      | 42 ++++++++++++++++++++++++++++++++++-
 libmultipath/propsel.c        | 18 +++++++++++++++
 libmultipath/propsel.h        |  1 +
 libmultipath/structs.h        |  7 ++++++
 multipath/multipath.conf.5.in | 22 ++++++++++++++++++
 8 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index b7dbc6f5..9d90f512 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -420,6 +420,7 @@ merge_pce(struct pcentry *dst, struct pcentry *src)
 	merge_num(fast_io_fail);
 	merge_num(dev_loss);
 	merge_num(eh_deadline);
+	merge_num(max_retries);
 }
 
 static void
@@ -448,6 +449,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(fast_io_fail);
 	merge_num(dev_loss);
 	merge_num(eh_deadline);
+	merge_num(max_retries);
 	merge_num(user_friendly_names);
 	merge_num(retain_hwhandler);
 	merge_num(detect_prio);
@@ -615,6 +617,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->fast_io_fail = dhwe->fast_io_fail;
 	hwe->dev_loss = dhwe->dev_loss;
 	hwe->eh_deadline = dhwe->eh_deadline;
+	hwe->max_retries = dhwe->max_retries;
 	hwe->user_friendly_names = dhwe->user_friendly_names;
 	hwe->retain_hwhandler = dhwe->retain_hwhandler;
 	hwe->detect_prio = dhwe->detect_prio;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 8c22ce75..197a567f 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -47,6 +47,7 @@ struct pcentry {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int eh_deadline;
+	int max_retries;
 };
 
 struct hwentry {
@@ -72,6 +73,7 @@ struct hwentry {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int eh_deadline;
+	int max_retries;
 	int user_friendly_names;
 	int retain_hwhandler;
 	int detect_prio;
@@ -162,6 +164,7 @@ struct config {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int eh_deadline;
+	int max_retries;
 	int log_checker_err;
 	int allow_queueing;
 	int allow_usb_devices;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 044067af..fc438947 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1152,6 +1152,36 @@ declare_hw_snprint(eh_deadline, print_undef_off_zero)
 declare_pc_handler(eh_deadline, set_undef_off_zero)
 declare_pc_snprint(eh_deadline, print_undef_off_zero)
 
+static int
+set_max_retries(vector strvec, void *ptr, const char *file, int line_nr)
+{
+	char * buff;
+	int *int_ptr = (int *)ptr;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (strcmp(buff, "off") == 0)
+		*int_ptr = UOZ_OFF;
+	else if (strcmp(buff, "0") == 0)
+		*int_ptr = UOZ_ZERO;
+	else
+		do_set_int(strvec, int_ptr, 1, 5, file, line_nr, buff);
+
+	free(buff);
+	return 0;
+}
+
+declare_def_handler(max_retries, set_max_retries)
+declare_def_snprint(max_retries, print_undef_off_zero)
+declare_ovr_handler(max_retries, set_max_retries)
+declare_ovr_snprint(max_retries, print_undef_off_zero)
+declare_hw_handler(max_retries, set_max_retries)
+declare_hw_snprint(max_retries, print_undef_off_zero)
+declare_pc_handler(max_retries, set_max_retries)
+declare_pc_snprint(max_retries, print_undef_off_zero)
+
 static int
 set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
 {
@@ -2079,6 +2109,7 @@ init_keywords(vector keywords)
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	install_keyword("eh_deadline", &def_eh_deadline_handler, &snprint_def_eh_deadline);
+	install_keyword("max_retries", &def_max_retries_handler, &snprint_def_max_retries);
 	install_keyword("bindings_file", &deprecated_bindings_file_handler, &snprint_deprecated);
 	install_keyword("wwids_file", &deprecated_wwids_file_handler, &snprint_deprecated);
 	install_keyword("prkeys_file", &deprecated_prkeys_file_handler, &snprint_deprecated);
@@ -2176,6 +2207,7 @@ init_keywords(vector keywords)
 	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
 	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
 	install_keyword("eh_deadline", &hw_eh_deadline_handler, &snprint_hw_eh_deadline);
+	install_keyword("max_retries", &hw_max_retries_handler, &snprint_hw_max_retries);
 	install_keyword("user_friendly_names", &hw_user_friendly_names_handler, &snprint_hw_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
@@ -2220,6 +2252,7 @@ init_keywords(vector keywords)
 	install_keyword("fast_io_fail_tmo", &ovr_fast_io_fail_handler, &snprint_ovr_fast_io_fail);
 	install_keyword("dev_loss_tmo", &ovr_dev_loss_handler, &snprint_ovr_dev_loss);
 	install_keyword("eh_deadline", &ovr_eh_deadline_handler, &snprint_ovr_eh_deadline);
+	install_keyword("max_retries", &ovr_max_retries_handler, &snprint_ovr_max_retries);
 	install_keyword("user_friendly_names", &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
 	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
@@ -2248,6 +2281,7 @@ init_keywords(vector keywords)
 	install_keyword("fast_io_fail_tmo", &pc_fast_io_fail_handler, &snprint_pc_fast_io_fail);
 	install_keyword("dev_loss_tmo", &pc_dev_loss_handler, &snprint_pc_dev_loss);
 	install_keyword("eh_deadline", &pc_eh_deadline_handler, &snprint_pc_eh_deadline);
+	install_keyword("max_retries", &pc_max_retries_handler, &snprint_pc_max_retries);
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 84ce5fe7..ee261d90 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -614,6 +614,43 @@ sysfs_set_eh_deadline(struct path *pp)
 	return (ret <= 0);
 }
 
+static int
+sysfs_set_max_retries(struct path *pp)
+{
+	struct udev_device *parent;
+	char value[16];
+	STRBUF_ON_STACK(buf);
+	int ret, len;
+
+	if (pp->max_retries == MAX_RETRIES_UNSET)
+		return 0;
+
+	if (!pp->udev || pp->sg_id.host_no < 0)
+		return 1;
+
+	len = sprintf(value, "%d", (pp->max_retries == MAX_RETRIES_OFF)? -1 :
+				   (pp->max_retries == MAX_RETRIES_ZERO)? 0 :
+				   pp->max_retries);
+
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev,
+			"scsi", "scsi_device");
+	if (!parent)
+		return 1;
+
+	if (print_strbuf(&buf, "scsi_disk/%i:%i:%i:%" PRIu64 "/max_retries",
+			 pp->sg_id.host_no, pp->sg_id.channel,
+			 pp->sg_id.scsi_id, pp->sg_id.lun) < 0)
+		return 1;
+
+	ret = sysfs_attr_set_value(parent, get_strbuf_str(&buf), value, len);
+	if (len != ret)
+		log_sysfs_attr_set_value(3, ret,
+					 "%s/%s: failed to set value to %s",
+					 udev_device_get_sysname(parent),
+					 get_strbuf_str(&buf), value);
+	return (len != ret);
+}
+
 static void
 sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 {
@@ -875,10 +912,12 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
 		select_fast_io_fail(conf, pp);
 		select_dev_loss(conf, pp);
 		select_eh_deadline(conf, pp);
+		select_max_retries(conf, pp);
 
 		if (pp->dev_loss == DEV_LOSS_TMO_UNSET &&
 		    pp->fast_io_fail == MP_FAST_IO_FAIL_UNSET &&
-		    pp->eh_deadline == EH_DEADLINE_UNSET)
+		    pp->eh_deadline == EH_DEADLINE_UNSET &&
+		    pp->max_retries == MAX_RETRIES_UNSET)
 			continue;
 
 		if (pp->bus != SYSFS_BUS_SCSI) {
@@ -886,6 +925,7 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
 			continue;
 		}
 		sysfs_set_eh_deadline(pp);
+		sysfs_set_max_retries(pp);
 
 		if (pp->dev_loss == DEV_LOSS_TMO_UNSET &&
 		    pp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 44241e2a..15abb9e5 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -960,6 +960,24 @@ out:
 	return 0;
 }
 
+int select_max_retries(struct config *conf, struct path *pp)
+{
+	const char *origin;
+	STRBUF_ON_STACK(buff);
+
+	pp_set_ovr_pce(max_retries);
+	pp_set_hwe(max_retries);
+	pp_set_conf(max_retries);
+	pp->max_retries = MAX_RETRIES_UNSET;
+	/* not changing sysfs in default cause, so don't print anything */
+	return 0;
+out:
+	print_undef_off_zero(&buff, pp->max_retries);
+	condlog(3, "%s: max_retries = %s %s", pp->dev,
+		get_strbuf_str(&buff), origin);
+	return 0;
+}
+
 int select_flush_on_last_del(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 73615c2f..7203509e 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -21,6 +21,7 @@ int select_gid(struct config *conf, struct multipath *mp);
 int select_fast_io_fail(struct config *conf, struct path *pp);
 int select_dev_loss(struct config *conf, struct path *pp);
 int select_eh_deadline(struct config *conf, struct path *pp);
+int select_max_retries(struct config *conf, struct path *pp);
 int select_reservation_key(struct config *conf, struct multipath *mp);
 int select_retain_hwhandler (struct config *conf, struct multipath * mp);
 int select_detect_prio(struct config *conf, struct path * pp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 17e13ee7..c20e99ce 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -295,6 +295,12 @@ enum eh_deadline_states {
 	EH_DEADLINE_ZERO = UOZ_ZERO,
 };
 
+enum max_retries_states {
+	MAX_RETRIES_UNSET = UOZ_UNDEF,
+	MAX_RETRIES_OFF = UOZ_OFF,
+	MAX_RETRIES_ZERO = UOZ_ZERO,
+};
+
 enum recheck_wwid_states {
 	RECHECK_WWID_UNDEF = YNU_UNDEF,
 	RECHECK_WWID_OFF = YNU_NO,
@@ -381,6 +387,7 @@ struct path {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int eh_deadline;
+	int max_retries;
 	bool is_checked;
 	bool can_use_env_uid;
 	unsigned int checker_timeout;
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 226d0019..41f3927e 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -793,6 +793,22 @@ The default is: \fB<unset>\fR
 .
 .
 .TP
+.B max_retries
+Specify the maximum number of times the SCSI layer will retry IO commands
+before returning failure. Setting this can be helpful for cases where the path
+checker succeeds, but IO commands hang and timeout. By default, the SCSI layer
+will retry IOs 5 times. Reducing this value will allow multipath to retry the IO
+down another path sooner. \fBNote:\fR If it is necessary to set this value, it
+is also recommended to set up shaky paths detection. See "Shaky paths detection"
+below. Valid values are
+\fB0\fR through \fB5\fR.
+.RS
+.TP
+The default is: \fB<unset>\fR
+.RE
+.
+.
+.TP
 .B bindings_file
 (Deprecated) This option is not supported any more, and will be ignored.
 .RS
@@ -1687,6 +1703,8 @@ section:
 .TP
 .B eh_deadline
 .TP
+.B max_retries
+.TP
 .B flush_on_last_del
 .TP
 .B user_friendly_names
@@ -1773,6 +1791,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B eh_deadline
 .TP
+.B max_retries
+.TP
 .B user_friendly_names
 .TP
 .B retain_attached_hw_handler
@@ -1844,6 +1864,8 @@ from the \fIoverrides\fR, \fIdevices\fR, or \fIdefaults\fR section:
 .B dev_loss_tmo
 .TP
 .B eh_deadline
+.TP
+.B max_retries
 .PD
 .
 .
-- 
2.41.0

