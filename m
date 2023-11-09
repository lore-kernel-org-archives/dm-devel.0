Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A8A39850
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 23:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVCpBEhI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699573584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o6MtGi1rYqYhZoM5H4620s3hEm9xPzPVp4kylBbrVUE=;
	b=EVCpBEhI9mDa8SEzSUzaYQqstcEYbB7/TpDBpzppnyTi3gAtLTZKqY85Ocppb6PfbzHP2e
	yBKZkn7yA+cdPX9SQNw/buPGdQl8tOZu4m/dNoarTPqOJKII0rmkel1b7Dltn/sIToDfVH
	cDB7jNDp/RE7kA/JKlMV/zo/0FpwFZQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-9uxTOOBwMMWEnX1APoQwaA-1; Thu, 09 Nov 2023 18:46:19 -0500
X-MC-Unique: 9uxTOOBwMMWEnX1APoQwaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85AC5101A54C;
	Thu,  9 Nov 2023 23:46:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 770D11C060AE;
	Thu,  9 Nov 2023 23:46:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A9NkHGq100135
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Nov 2023 18:46:17 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A9NkHIk100134;
	Thu, 9 Nov 2023 18:46:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 1/6] libmultipath: Add max_retries config option
Date: Thu,  9 Nov 2023 18:46:11 -0500
Message-ID: <20231109234616.100125-2-bmarzins@redhat.com>
In-Reply-To: <20231109234616.100125-1-bmarzins@redhat.com>
References: <20231109234616.100125-1-bmarzins@redhat.com>
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
 libmultipath/config.h         |  1 +
 libmultipath/dict.c           | 25 +++++++++++++++++++++
 libmultipath/discovery.c      | 41 ++++++++++++++++++++++++++++++++++-
 libmultipath/structs.h        |  6 +++++
 multipath/multipath.conf.5.in | 14 ++++++++++++
 5 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 8c22ce75..417e5834 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -162,6 +162,7 @@ struct config {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int eh_deadline;
+	int max_retries;
 	int log_checker_err;
 	int allow_queueing;
 	int allow_usb_devices;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 044067af..e268673f 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1152,6 +1152,30 @@ declare_hw_snprint(eh_deadline, print_undef_off_zero)
 declare_pc_handler(eh_deadline, set_undef_off_zero)
 declare_pc_snprint(eh_deadline, print_undef_off_zero)
 
+static int
+def_max_retries_handler(struct config *conf, vector strvec, const char *file,
+			int line_nr)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (strcmp(buff, "off") == 0)
+		conf->max_retries = MAX_RETRIES_OFF;
+	else if (strcmp(buff, "0") == 0)
+		conf->max_retries = MAX_RETRIES_ZERO;
+	else
+		do_set_int(strvec, &conf->max_retries, 1, 5, file, line_nr,
+			   buff);
+
+	free(buff);
+	return 0;
+}
+
+declare_def_snprint(max_retries, print_undef_off_zero)
+
 static int
 set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
 {
@@ -2079,6 +2103,7 @@ init_keywords(vector keywords)
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	install_keyword("eh_deadline", &def_eh_deadline_handler, &snprint_def_eh_deadline);
+	install_keyword("max_retries", &def_max_retries_handler, &snprint_def_max_retries);
 	install_keyword("bindings_file", &deprecated_bindings_file_handler, &snprint_deprecated);
 	install_keyword("wwids_file", &deprecated_wwids_file_handler, &snprint_deprecated);
 	install_keyword("prkeys_file", &deprecated_prkeys_file_handler, &snprint_deprecated);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 84ce5fe7..6fd4dabb 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -614,6 +614,43 @@ sysfs_set_eh_deadline(struct path *pp)
 	return (ret <= 0);
 }
 
+static int
+sysfs_set_max_retries(struct config *conf, struct path *pp)
+{
+	struct udev_device *parent;
+	char value[16];
+	STRBUF_ON_STACK(buf);
+	int ret, len;
+
+	if (conf->max_retries == MAX_RETRIES_UNSET)
+		return 0;
+
+	if (!pp->udev || pp->sg_id.host_no < 0)
+		return 1;
+
+	len = sprintf(value, "%d", (conf->max_retries == MAX_RETRIES_OFF)? -1 :
+				   (conf->max_retries == MAX_RETRIES_ZERO)? 0 :
+				   conf->max_retries);
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
@@ -878,7 +915,8 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
 
 		if (pp->dev_loss == DEV_LOSS_TMO_UNSET &&
 		    pp->fast_io_fail == MP_FAST_IO_FAIL_UNSET &&
-		    pp->eh_deadline == EH_DEADLINE_UNSET)
+		    pp->eh_deadline == EH_DEADLINE_UNSET &&
+		    conf->max_retries == MAX_RETRIES_UNSET)
 			continue;
 
 		if (pp->bus != SYSFS_BUS_SCSI) {
@@ -886,6 +924,7 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
 			continue;
 		}
 		sysfs_set_eh_deadline(pp);
+		sysfs_set_max_retries(conf, pp);
 
 		if (pp->dev_loss == DEV_LOSS_TMO_UNSET &&
 		    pp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 17e13ee7..63551b80 100644
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
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 226d0019..014d6dd1 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -793,6 +793,20 @@ The default is: \fB<unset>\fR
 .
 .
 .TP
+.B max_retries
+Specify the maximum number of times the SCSI layer will retry IO commands for
+some types of SCSI errors before returning failure. Setting this can be helpful
+for cases where IO commands hang and timeout. By default, the SCSI layer will
+retry IOs 5 times. Reducing this value will allow multipath to retry the IO
+down another path sooner. Valid values are
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
-- 
2.41.0

