Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42FFBC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 06:44:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-406-4MMvsAKDOiiDE48RfKlxnw-1; Thu, 25 Nov 2021 01:44:47 -0500
X-MC-Unique: 4MMvsAKDOiiDE48RfKlxnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F95B1853026;
	Thu, 25 Nov 2021 06:44:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 726D35D9CA;
	Thu, 25 Nov 2021 06:44:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4B4B21809C89;
	Thu, 25 Nov 2021 06:44:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AP6KH6J028949 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Nov 2021 01:20:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4472640CFD10; Thu, 25 Nov 2021 06:20:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E0F640CFD01
	for <dm-devel@redhat.com>; Thu, 25 Nov 2021 06:20:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED83F803D78
	for <dm-devel@redhat.com>; Thu, 25 Nov 2021 06:20:16 +0000 (UTC)
Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com
	[192.19.166.228]) by relay.mimecast.com with ESMTP id
	us-mta-441-SeR1hr8pM1Gpar8QfL8BUA-1; Thu, 25 Nov 2021 01:20:15 -0500
X-MC-Unique: SeR1hr8pM1Gpar8QfL8BUA-1
Received: from localhost.localdomain (unknown [10.157.2.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 1868C828A;
	Wed, 24 Nov 2021 22:12:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 1868C828A
From: Muneendra Kumar <muneendra.kumar@broadcom.com>
To: dm-devel@redhat.com
Date: Wed, 24 Nov 2021 15:21:32 -0800
Message-Id: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AP6KH6J028949
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 25 Nov 2021 01:44:00 -0500
Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>, mkumar@redhat.com,
	martin.wilck@suse.com
Subject: [dm-devel] [PATCH] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch incorporates the functionality to handle
FPIN ELS events present as part of FCTransport daemon
(available in EPEL8) into the multipathd. This helps us to
reduce the response time to react and take the necessary actions
on receiving the FPIN events.

This patch currently support FPIN-Li Events.

It adds a new thread to listen for ELS frames from driver and on
receiving the frame payload, push the payload to a list and notify the
fpin_els_li_consumer thread to process it.Once consumer thread is
notified, it returns to listen for more ELS frames from driver.

The consumer thread process the ELS frames and moves the devices paths
which are affected due to link integrity to marginal path groups.
This also sets the associated portstate to marginal.
The paths which are set to marginal path group will be unset
on receiving the RSCN events

Signed-off-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc                            |  13 +
 libmpathpersist/libmpathpersist.version |  12 +-
 libmultipath/Makefile                   |   4 +
 libmultipath/config.c                   |   3 +
 libmultipath/config.h                   |   1 +
 libmultipath/dict.c                     |  31 ++
 libmultipath/libmultipath.version       |   5 +-
 libmultipath/propsel.c                  |  47 +-
 multipath/multipath.conf.5              |  20 +
 multipathd/Makefile                     |  10 +
 multipathd/fpin.h                       |  23 +
 multipathd/fpin_handlers.c              | 566 ++++++++++++++++++++++++
 multipathd/main.c                       |  38 +-
 13 files changed, 756 insertions(+), 17 deletions(-)
 create mode 100644 multipathd/fpin.h
 create mode 100644 multipathd/fpin_handlers.c

diff --git a/Makefile.inc b/Makefile.inc
index d0ec9b44..1241c39b 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -137,6 +137,19 @@ check_file = $(shell \
 	echo "$$found" \
 	)
 
+# Check whether a file contains a variable with name $1 in header file $2
+check_var = $(shell \
+	if grep -Eq "(^|[[:blank:]])$1([[:blank:]]|=|$$)" "$2"; then \
+                found=1; \
+                status="yes"; \
+        else \
+                found=0; \
+                status="no"; \
+        fi; \
+        echo 1>&2 "Checking for ..  $1 in $2 ... $$status"; \
+        echo "$$found" \
+        )
+
 %.o:	%.c
 	@echo building $@ because of $?
 	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index e0748138..fa312f6b 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -10,7 +10,7 @@
  *
  * See libmultipath.version for general policy about version numbers.
  */
-LIBMPATHPERSIST_1.0.0 {
+LIBMPATHPERSIST_2.0.0 {
 global:
 
 	__mpath_persistent_reserve_in;
@@ -28,11 +28,9 @@ global:
 	prout_do_scsi_ioctl;
 	update_map_pr;
 
-local: *;
-};
-
-LIBMPATHPERSIST_1.1.0 {
-global:
+	/* added in 1.1.0 */
 	libmpathpersist_init;
 	libmpathpersist_exit;
-} LIBMPATHPERSIST_1.0.0;
+
+local: *;
+};
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 7f3921c5..3a00d7bd 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -45,6 +45,10 @@ ifneq ($(call check_func,dm_hold_control_dev,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_HOLD_CONTROL
 endif
 
+ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,/usr/include/scsi/fc/fc_els.h),0)
+	CFLAGS += -DFPIN_EVENT_HANDLER
+endif
+
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	hwtable.o blacklist.o util.o dmparser.o config.o \
 	structs.o discovery.o propsel.o dict.o \
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 30046a17..b8a5520a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -906,6 +906,9 @@ int _init_config (const char *file, struct config *conf)
 	/*
 	 * fill the voids left in the config file
 	 */
+	if (conf->fpin_marginal_paths)
+		conf->marginal_pathgroups = YN_YES;
+
 #ifdef USE_SYSTEMD
 	set_max_checkint_from_watchdog(conf);
 #endif
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 933fe0d1..7746aae7 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -186,6 +186,7 @@ struct config {
 	int ghost_delay;
 	int find_multipaths_timeout;
 	int marginal_pathgroups;
+	int fpin_marginal_paths;
 	int skip_delegate;
 	unsigned int sequence_nr;
 	int recheck_wwid;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 1b75be47..0f10495d 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -204,6 +204,33 @@ set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
 	return 0;
 }
 
+static int
+set_fpin_marginal_path_yes_no(vector strvec, void *ptr, const char *file,
+			      int line_nr)
+{
+	char *buff;
+	int *int_ptr = (int *)ptr;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+#ifdef FPIN_EVENT_HANDLER
+	if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
+		*int_ptr = YN_YES;
+	else if (strcmp(buff, "no") == 0 || strcmp(buff, "0") == 0)
+		*int_ptr = YN_NO;
+	else
+		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);
+#else
+	*int_ptr = YN_NO;
+	condlog(1, "%s line %d, FPIN support is not there in the kernel",
+		file, line_nr);
+#endif
+	FREE(buff);
+	return 0;
+}
+
 static int
 set_yes_no_undef(vector strvec, void *ptr, const char *file, int line_nr)
 {
@@ -1530,6 +1557,9 @@ declare_hw_snprint(all_tg_pt, print_yes_no_undef)
 declare_def_handler(marginal_pathgroups, set_yes_no)
 declare_def_snprint(marginal_pathgroups, print_yes_no)
 
+declare_def_handler(fpin_marginal_paths, set_fpin_marginal_path_yes_no)
+declare_def_snprint(fpin_marginal_paths, print_yes_no)
+
 declare_def_handler(recheck_wwid, set_yes_no_undef)
 declare_def_snprint_defint(recheck_wwid, print_yes_no_undef, DEFAULT_RECHECK_WWID)
 declare_ovr_handler(recheck_wwid, set_yes_no_undef)
@@ -1947,6 +1977,7 @@ init_keywords(vector keywords)
 	install_keyword("enable_foreign", &def_enable_foreign_handler,
 			&snprint_def_enable_foreign);
 	install_keyword("marginal_pathgroups", &def_marginal_pathgroups_handler, &snprint_def_marginal_pathgroups);
+	install_keyword("fpin_marginal_paths", &def_fpin_marginal_paths_handler, &snprint_def_fpin_marginal_paths);
 	install_keyword("recheck_wwid", &def_recheck_wwid_handler, &snprint_def_recheck_wwid);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index eb5b5b55..65d29fb0 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_9.0.0 {
+LIBMULTIPATH_10.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -284,6 +284,9 @@ global:
 	/* added in 8.2.0 */
 	check_daemon;
 
+	/* added in 10.0.0 */
+	vector_find_or_add_slot;
+
 local:
 	*;
 };
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index b2876670..8807db6a 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -84,6 +84,8 @@ static const char cmdline_origin[] =
 	"(setting: multipath command line [-p] flag)";
 static const char autodetect_origin[] =
 	"(setting: storage device autodetected)";
+static const char fpin_marginal_path_origin[] =
+	"(setting: overridden by fpin_marginal_paths)";
 static const char marginal_path_origin[] =
 	"(setting: implied by marginal_path check)";
 static const char delay_watch_origin[] =
@@ -1036,9 +1038,12 @@ int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	if (marginal_path_check_enabled(mp)) {
+	if (marginal_path_check_enabled(mp) || conf->fpin_marginal_paths) {
 		mp->san_path_err_threshold = NU_NO;
-		origin = marginal_path_origin;
+		if (conf->fpin_marginal_paths)
+			origin = fpin_marginal_path_origin;
+		else
+			origin = marginal_path_origin;
 		goto out;
 	}
 	mp_set_mpe(san_path_err_threshold);
@@ -1059,9 +1064,12 @@ int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	if (marginal_path_check_enabled(mp)) {
+	if (marginal_path_check_enabled(mp) || conf->fpin_marginal_paths) {
 		mp->san_path_err_forget_rate = NU_NO;
-		origin = marginal_path_origin;
+		if (conf->fpin_marginal_paths)
+			origin = fpin_marginal_path_origin;
+		else
+			origin = marginal_path_origin;
 		goto out;
 	}
 	mp_set_mpe(san_path_err_forget_rate);
@@ -1083,9 +1091,12 @@ int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	if (marginal_path_check_enabled(mp)) {
+	if (marginal_path_check_enabled(mp) || conf->fpin_marginal_paths) {
 		mp->san_path_err_recovery_time = NU_NO;
-		origin = marginal_path_origin;
+		if (conf->fpin_marginal_paths)
+			origin = fpin_marginal_path_origin;
+		else
+			origin = marginal_path_origin;
 		goto out;
 	}
 	mp_set_mpe(san_path_err_recovery_time);
@@ -1107,6 +1118,12 @@ int select_marginal_path_err_sample_time(struct config *conf, struct multipath *
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
+	if (conf->fpin_marginal_paths) {
+		mp->marginal_path_err_sample_time = NU_NO;
+		origin = fpin_marginal_path_origin;
+		goto out;
+	}
+
 	mp_set_mpe(marginal_path_err_sample_time);
 	mp_set_ovr(marginal_path_err_sample_time);
 	mp_set_hwe(marginal_path_err_sample_time);
@@ -1130,6 +1147,12 @@ int select_marginal_path_err_rate_threshold(struct config *conf, struct multipat
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
+	if (conf->fpin_marginal_paths) {
+		mp->marginal_path_err_rate_threshold = NU_NO;
+		origin = fpin_marginal_path_origin;
+		goto out;
+	}
+
 	mp_set_mpe(marginal_path_err_rate_threshold);
 	mp_set_ovr(marginal_path_err_rate_threshold);
 	mp_set_hwe(marginal_path_err_rate_threshold);
@@ -1147,6 +1170,12 @@ int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multip
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
+	if (conf->fpin_marginal_paths) {
+		mp->marginal_path_err_recheck_gap_time = NU_NO;
+		origin = fpin_marginal_path_origin;
+		goto out;
+	}
+
 	mp_set_mpe(marginal_path_err_recheck_gap_time);
 	mp_set_ovr(marginal_path_err_recheck_gap_time);
 	mp_set_hwe(marginal_path_err_recheck_gap_time);
@@ -1165,6 +1194,12 @@ int select_marginal_path_double_failed_time(struct config *conf, struct multipat
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
+	if (conf->fpin_marginal_paths) {
+		mp->marginal_path_double_failed_time = NU_NO;
+		origin = fpin_marginal_path_origin;
+		goto out;
+	}
+
 	mp_set_mpe(marginal_path_double_failed_time);
 	mp_set_ovr(marginal_path_double_failed_time);
 	mp_set_hwe(marginal_path_double_failed_time);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 88d2a1df..a2db9c9f 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1109,6 +1109,26 @@ The default is: \fBno\fR
 .
 .
 .TP
+.B fpin_marginal_paths
+If set to \fIyes\fR,it helps in detecting marginal paths through FC fabric.
+FC fabric sends the impacted ports information through ELS frames.
+This feature parses the ELS frame and moves the devices which are
+affected due to link integrity to marginal path groups.
+This also sets the associated portstate to marginal.
+The paths which are set to marginal path group will be unset
+on receiving the RSCN events.
+It is \fBstrongly discouraged\fR to use more than one of these methods for any
+given multipath map, because the more concurrent methods may interact in
+unpredictable ways. If the fpin_marginal_paths methods is active
+marginal_path and san_path_err parameters are implicitly set to 0.
+Enabling this will also enables the marginal_pathgroups feature by default.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
 .B find_multipaths
 This option controls whether multipath and multipathd try to create multipath
 maps over non-blacklisted devices they encounter. This matters a) when a device is
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 393b6cbb..cd6f7e6d 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -4,6 +4,10 @@ ifneq ($(call check_func,dm_task_get_errno,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_GET_ERRNO
 endif
 
+ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,/usr/include/scsi/fc/fc_els.h),0)
+	CFLAGS += -DFPIN_EVENT_HANDLER
+	FPIN_SUPPORT = 1
+endif
 #
 # debugging stuff
 #
@@ -34,6 +38,12 @@ endif
 OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o waiter.o \
        dmevents.o init_unwinder.o
 
+ifeq ($(FPIN_SUPPORT),1)
+OBJS += fpin_handlers.o
+endif
+
+
+
 EXEC = multipathd
 
 all : $(EXEC)
diff --git a/multipathd/fpin.h b/multipathd/fpin.h
new file mode 100644
index 00000000..88b879a5
--- /dev/null
+++ b/multipathd/fpin.h
@@ -0,0 +1,23 @@
+#ifndef __FPIN_H__
+#define __FPIN_H__
+
+#ifdef FPIN_EVENT_HANDLER
+void *fpin_fabric_notification_receiver(void *unused);
+void *fpin_els_li_consumer(void *data);
+void cleanup_fpin_list(void);
+#else
+static void *fpin_fabric_notification_receiver(__attribute__((unused))void *unused)
+{
+	return NULL;
+}
+static void *fpin_els_li_consumer(__attribute__((unused))void *data)
+{
+	return NULL;
+}
+static void cleanup_fpin_list(void)
+{
+
+}
+#endif
+
+#endif
diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
new file mode 100644
index 00000000..a2a6f671
--- /dev/null
+++ b/multipathd/fpin_handlers.c
@@ -0,0 +1,566 @@
+#include <errno.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <libudev.h>
+#include <scsi/scsi_netlink_fc.h>
+#include <scsi/fc/fc_els.h>
+
+#include "parser.h"
+#include "vector.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "main.h"
+#include "debug.h"
+#include "util.h"
+
+#include "fpin.h"
+#include "devmapper.h"
+
+static pthread_cond_t fpin_li_cond = PTHREAD_COND_INITIALIZER;
+static pthread_mutex_t fpin_li_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+static LIST_HEAD(els_marginal_list_head);
+static LIST_HEAD(fpin_li_marginal_dev_list_head);
+
+
+#define DEF_RX_BUF_SIZE	4096
+#define DEV_NAME_LEN	128
+#define FCH_EVT_LINKUP 0x2
+#define FCH_EVT_LINK_FPIN 0x501
+#define FCH_EVT_RSCN 0x5
+
+#define list_first_entry(ptr, type, member) \
+	list_entry((ptr)->next, type, member)
+
+/* max ELS frame Size */
+#define FC_PAYLOAD_MAXLEN   2048
+
+struct els_marginal_list {
+	uint32_t event_code;
+	uint16_t host_num;
+	uint16_t length;
+	char payload[FC_PAYLOAD_MAXLEN];
+	struct list_head node;
+};
+/* Structure to store the marginal devices info */
+struct marginal_dev_list {
+	char dev_name[DEV_NAME_LEN];
+	uint32_t host_num;
+	struct list_head node;
+};
+
+static void _vector_reset(void *v)
+{
+	vector_reset(v);
+}
+
+static void _udev_device_unref(void *p)
+{
+	udev_device_unref(p);
+}
+
+/*set/unset the path state to marginal*/
+static int fpin_set_pathstate(struct path *pp, vector reload_mps, bool set)
+{
+	const char *action = set ? "set" : "unset";
+
+	if (!pp || !pp->mpp || !pp->mpp->alias)
+		return -1;
+
+	condlog(2, "\n%s: %s  marginal path %s (fpin) dev:%s",
+		action, pp->mpp->alias, pp->dev_t, pp->dev);
+	if (pp->mpp->wait_for_udev) {
+		condlog(3, "\n%s: device not fully created, failing to %s marginal",
+			pp->mpp->alias, action);
+		return -1;
+	}
+	if (set)
+		pp->marginal = 1;
+	else
+		pp->marginal = 0;
+	vector_find_or_add_slot(reload_mps, pp->mpp);
+	return 0;
+
+}
+
+/* This will unset marginal state of a device*/
+static void fpin_path_unsetmarginal(char *devname, struct vectors *vecs, vector reload_mps)
+{
+	struct path *pp;
+
+	pp = find_path_by_dev(vecs->pathvec, devname);
+	if (!pp)
+		pp = find_path_by_devt(vecs->pathvec, devname);
+
+	fpin_set_pathstate(pp, reload_mps, 0);
+}
+
+/*This will set the marginal state of a device*/
+static int fpin_path_setmarginal(struct path *pp, vector reload_mps)
+{
+	return fpin_set_pathstate(pp, reload_mps, 1);
+}
+
+/* Unsets all the devices in the list from marginal state */
+static void
+fpin_unset_marginal_dev(uint32_t host_num, struct vectors *vecs)
+{
+	struct marginal_dev_list *tmp_marg = NULL;
+	struct list_head *current_node = NULL;
+	struct list_head *temp = NULL;
+	struct multipath *mpp;
+	int ret = 0;
+	int i;
+	struct _vector _reload_mps = { .allocated = 0, };
+	struct _vector * const reload_mps = &_reload_mps;
+
+	if (list_empty(&fpin_li_marginal_dev_list_head)) {
+		condlog(3, "Marginal List is empty\n");
+		return;
+	}
+	pthread_cleanup_push(_vector_reset, reload_mps);
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(&vecs->lock);
+	pthread_testcancel();
+	list_for_each_safe(current_node, temp, &fpin_li_marginal_dev_list_head) {
+		tmp_marg = list_entry(current_node,
+				struct marginal_dev_list,
+				node);
+
+		if (tmp_marg->host_num != host_num)
+			continue;
+		condlog(4, " unsetting marginal dev: is %s %d\n",
+				tmp_marg->dev_name, tmp_marg->host_num);
+
+		fpin_path_unsetmarginal(tmp_marg->dev_name, vecs, reload_mps);
+		list_del(current_node);
+		free(tmp_marg);
+	}
+
+	vector_foreach_slot(reload_mps, mpp, i) {
+		ret = reload_and_sync_map(mpp, vecs, 0);
+		if (ret == 2)
+			condlog(2, "map removed during reload");
+	}
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+}
+
+/*
+ * On Receiving the frame from HBA driver, insert the frame into link
+ * integrity frame list which will be picked up later by consumer thread for
+ * processing.
+ */
+static int
+fpin_els_add_li_frame(struct fc_nl_event *fc_event)
+{
+	struct els_marginal_list *els_mrg = NULL;
+	int ret = 0;
+
+	if (fc_event->event_datalen > FC_PAYLOAD_MAXLEN)
+		return -EINVAL;
+
+	pthread_mutex_lock(&fpin_li_mutex);
+	pthread_cleanup_push(cleanup_mutex, &fpin_li_mutex);
+	pthread_testcancel();
+	els_mrg = calloc(sizeof(struct els_marginal_list), 1);
+	if (els_mrg != NULL) {
+		els_mrg->host_num = fc_event->host_no;
+		els_mrg->event_code = fc_event->event_code;
+		els_mrg->length = fc_event->event_datalen;
+		memcpy(els_mrg->payload, &(fc_event->event_data), fc_event->event_datalen);
+		list_add_tail(&els_mrg->node, &els_marginal_list_head);
+		pthread_cond_signal(&fpin_li_cond);
+	} else {
+		condlog(0, "NO Memory to add frame payload\n");
+		ret = -ENOMEM;
+	}
+
+	pthread_cleanup_pop(1);
+	return ret;
+
+}
+
+/*Sets the rport port_state to marginal*/
+static void fpin_set_rport_marginal(struct udev_device *rport_dev)
+{
+	int ret = 0;
+
+	ret = udev_device_set_sysattr_value(rport_dev, "port_state",
+					    "Marginal");
+	if (ret >= 0)
+		condlog(3, "set rport port state to marginal succeeded\n");
+	else
+		condlog(3, "set rport port state to marginal failed: %d\n",
+			ret);
+}
+
+/*Add the marginal devices info into the list*/
+static void
+fpin_add_marginal_dev_info(uint32_t host_num, char *devname)
+{
+	struct marginal_dev_list *newdev = NULL;
+
+	newdev = (struct marginal_dev_list *) calloc(1,
+			sizeof(struct marginal_dev_list));
+	if (newdev != NULL) {
+		newdev->host_num = host_num;
+		strlcpy(newdev->dev_name, devname, DEV_NAME_LEN);
+		condlog(4, "\n%s hostno %d devname %s\n", __func__,
+				host_num, newdev->dev_name);
+		list_add_tail(&(newdev->node),
+				&fpin_li_marginal_dev_list_head);
+	} else {
+		condlog(0, "\n Mem alloc failed to add marginal dev info"
+			   " Unset the marginal state manually after recovery"
+			   " for hostno %d devname %s\n",
+			host_num, devname);
+	}
+}
+
+/*
+ * This function goes through the vecs->pathvec, and for
+ * each path, check that the host  number,
+ * the target WWPN associated with the path matches
+ * with the els wwpn and sets the path and port state to
+ * Marginal
+ */
+static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *vecs,
+		uint64_t els_wwpn)
+{
+	struct path *pp;
+	struct multipath *mpp;
+	int i, k;
+	char rport_id[42];
+	const char *value = NULL;
+	struct udev_device *rport_dev = NULL;
+	uint64_t wwpn;
+	int ret = 0;
+	struct _vector _reload_mps = { .allocated = 0, };
+	struct _vector * const reload_mps = &_reload_mps;
+
+	pthread_cleanup_push(_vector_reset, reload_mps);
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(&vecs->lock);
+	pthread_testcancel();
+
+	vector_foreach_slot(vecs->pathvec, pp, k) {
+		/* Checks the host number and also for the SCSI FCP */
+		if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP || host_num !=  pp->sg_id.host_no)
+			continue;
+		sprintf(rport_id, "rport-%d:%d-%d",
+				pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
+		rport_dev = udev_device_new_from_subsystem_sysname(udev,
+				"fc_remote_ports", rport_id);
+		if (!rport_dev) {
+			condlog(0, "%s: No fc_remote_port device for '%s'", pp->dev,
+					rport_id);
+			continue;
+		}
+		pthread_cleanup_push(_udev_device_unref, rport_dev);
+		value = udev_device_get_sysattr_value(rport_dev, "port_name");
+		if (!value)
+			goto unref;
+
+		if (value)
+			wwpn =  strtol(value, NULL, 16);
+		/*
+		 * If the port wwpn matches sets the path and port state
+		 * to marginal
+		 */
+		if (wwpn == els_wwpn) {
+			ret = fpin_path_setmarginal(pp, reload_mps);
+			if (ret < 0)
+				goto unref;
+			fpin_set_rport_marginal(rport_dev);
+			fpin_add_marginal_dev_info(host_num, pp->dev);
+		}
+unref:
+		pthread_cleanup_pop(1);
+	}
+	vector_foreach_slot(reload_mps, mpp, i) {
+		ret = reload_and_sync_map(mpp, vecs, 0);
+		if (ret == 2)
+			condlog(2, "map removed during reload");
+	}
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+/*
+ * This function loops around all the impacted wwns received as part of els
+ * frame and sets the associated path and port states to marginal.
+ */
+static int
+fpin_parse_li_els_setpath_marginal(uint16_t host_num, struct fc_tlv_desc *tlv,
+		struct vectors *vecs)
+{
+	uint32_t wwn_count = 0, iter = 0;
+	uint64_t wwpn;
+	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
+	int count = 0;
+	int ret = 0;
+
+	/* Update the wwn to list */
+	wwn_count = be32_to_cpu(li_desc->pname_count);
+	condlog(4, "Got wwn count as %d\n", wwn_count);
+
+	for (iter = 0; iter < wwn_count; iter++) {
+		wwpn = be64_to_cpu(li_desc->pname_list[iter]);
+		ret = fpin_chk_wwn_setpath_marginal(host_num, vecs, wwpn);
+		if (ret < 0)
+			condlog(0, "failed to set the path marginal associated with wwpn: 0x%lx\n", wwpn);
+
+		count++;
+	}
+	return count;
+}
+
+/*
+ * This function process the ELS frame received from HBA driver,
+ * and sets the path associated with the port wwn to marginal
+ * and also set the port state to marginal.
+ */
+static int
+fpin_process_els_frame(uint16_t host_num, char *fc_payload, struct vectors *vecs)
+{
+	uint32_t els_cmd = 0;
+	int count = -1;
+	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fc_payload;
+	struct fc_tlv_desc *tlv;
+	uint32_t dtag;
+
+	els_cmd = *(uint32_t *)fc_payload;
+	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
+	dtag = be32_to_cpu(tlv->desc_tag);
+	condlog(4, "Got CMD in add as 0x%x fpin_cmd 0x%x dtag 0x%x\n",
+			els_cmd, fpin->fpin_cmd, dtag);
+
+	switch (fpin->fpin_cmd) {
+	case ELS_FPIN:
+		/*Check the type of fpin by checking the tag info*/
+		switch (dtag) {
+		case ELS_DTAG_LNK_INTEGRITY:
+			/*
+			 * Parse the els frame and set the affected paths and port
+			 * state to marginal
+			 */
+			count = fpin_parse_li_els_setpath_marginal(host_num, tlv, vecs);
+			if (count <= 0) {
+				condlog(4, "Could not find any WWNs, ret = %d\n",
+							count);
+				return count;
+			}
+			break;
+		case ELS_DTAG_PEER_CONGEST:
+			condlog(2, "Rcvd FPIN: Congestion not supported:\n");
+			break;
+		case ELS_DTAG_DELIVERY:
+			condlog(2, "Rcvd FPIN: Delivery notification not supported\n");
+			break;
+		case ELS_DTAG_CONGESTION:
+			condlog(2, "Rcvd FPIN:Transmission delay not supported:\n");
+			break;
+		default:
+			break;
+		}
+		break;
+
+	default:
+		condlog(2, "Invalid command received: 0x%x\n", els_cmd);
+		break;
+	}
+
+	return (count);
+}
+
+/*
+ * This function process the FPIN ELS frame received from HBA driver,
+ * and push the frame to appropriate frame list. Currently we have only FPIN
+ * LI frame list.
+ */
+static int
+fpin_handle_els_frame(struct fc_nl_event *fc_event)
+{
+	int ret = -1;
+	uint32_t els_cmd;
+
+	els_cmd = (uint32_t)fc_event->event_data;
+
+	switch (els_cmd) {
+	case ELS_FPIN:
+		/*Push the Payload to FPIN frame queue. */
+		ret = fpin_els_add_li_frame(fc_event);
+		if (ret != 0)
+			condlog(0, "Failed to process LI frame with error %d\n",
+				ret);
+		break;
+	default:
+		if ((fc_event->event_code == FCH_EVT_LINKUP) ||
+		    (fc_event->event_code == FCH_EVT_RSCN)) {
+			/*Push the Payload to FPIN frame queue. */
+			ret = fpin_els_add_li_frame(fc_event);
+			if (ret != 0)
+				condlog(0, "Failed to process Linkup/RSCN event with error %d evnt %d\n",
+					ret, fc_event->event_code);
+			break;
+		}
+		condlog(2, "Invalid command received: 0x%x\n", els_cmd);
+	}
+	return (ret);
+
+}
+
+/*cleans the global marginal dev list*/
+static void fpin_clean_marginal_dev_list(void)
+{
+	struct marginal_dev_list *tmp_marg = NULL;
+
+	while (!list_empty(&fpin_li_marginal_dev_list_head)) {
+		tmp_marg  = list_first_entry(&fpin_li_marginal_dev_list_head,
+				struct marginal_dev_list, node);
+		list_del(&tmp_marg->node);
+		free(tmp_marg);
+	}
+}
+
+/* Cleans the global els  marginal list */
+static void fpin_clean_els_marginal_list(void *arg)
+{
+	struct list_head *head = (struct list_head *)arg;
+	struct els_marginal_list *els_marg;
+
+	while (!list_empty(head)) {
+		els_marg  = list_first_entry(head, struct els_marginal_list,
+					     node);
+		list_del(&els_marg->node);
+		free(els_marg);
+	}
+}
+
+/* Cleans the global lists */
+void cleanup_fpin_list(void)
+{
+	fpin_clean_marginal_dev_list();
+	fpin_clean_els_marginal_list(&els_marginal_list_head);
+}
+
+/*
+ * This is the FPIN ELS consumer thread. The thread sleeps on pthread cond
+ * variable unless notified by fpin_fabric_notification_receiver thread.
+ * This thread is only to process FPIN-LI ELS frames. A new thread and frame
+ * list will be added if any more ELS frames types are to be supported.
+ */
+void *fpin_els_li_consumer(void *data)
+{
+	struct list_head marginal_list_head;
+	char payload[FC_PAYLOAD_MAXLEN] __attribute__((aligned(sizeof(uint64_t))));
+	int ret = 0;
+	uint16_t host_num;
+	struct els_marginal_list *els_marg;
+	uint32_t event_code;
+	struct vectors *vecs = (struct vectors *)data;
+
+	INIT_LIST_HEAD(&marginal_list_head);
+	pthread_cleanup_push(fpin_clean_els_marginal_list,
+			     (void *)&marginal_list_head);
+	for ( ; ; ) {
+		pthread_mutex_lock(&fpin_li_mutex);
+		if (list_empty(&els_marginal_list_head))
+			pthread_cond_wait(&fpin_li_cond, &fpin_li_mutex);
+
+		if (!list_empty(&els_marginal_list_head)) {
+			condlog(4, "Invoke List splice tail\n");
+			list_splice_tail_init(&els_marginal_list_head, &marginal_list_head);
+			pthread_mutex_unlock(&fpin_li_mutex);
+		} else {
+			pthread_mutex_unlock(&fpin_li_mutex);
+			continue;
+		}
+
+		while (!list_empty(&marginal_list_head)) {
+			els_marg  = list_first_entry(&marginal_list_head,
+							struct els_marginal_list, node);
+			host_num = els_marg->host_num;
+			event_code = els_marg->event_code;
+			memcpy(payload, els_marg->payload, els_marg->length);
+			list_del(&els_marg->node);
+			free(els_marg);
+
+			/* Now finally process FPIN LI ELS Frame */
+			condlog(4, "Got a new Payload buffer, processing it\n");
+			if ((event_code ==  FCH_EVT_LINKUP) || (event_code == FCH_EVT_RSCN))
+				 fpin_unset_marginal_dev(host_num, vecs);
+			else {
+				ret = fpin_process_els_frame(host_num, payload, vecs);
+				if (ret <= 0)
+					condlog(0, "ELS frame processing failed with ret %d\n", ret);
+			}
+		}
+	}
+	pthread_cleanup_pop(1);
+	return NULL;
+}
+
+/*
+ * Listen for ELS frames from driver. on receiving the frame payload,
+ * push the payload to a list, and notify the fpin_els_li_consumer thread to
+ * process it. Once consumer thread is notified, return to listen for more ELS
+ * frames from driver.
+ */
+void *fpin_fabric_notification_receiver(__attribute__((unused))void *unused)
+{
+	int ret;
+	long fd;
+	uint32_t els_cmd;
+	struct fc_nl_event *fc_event = NULL;
+	struct sockaddr_nl fc_local;
+	unsigned char buf[DEF_RX_BUF_SIZE] __attribute__((aligned(sizeof(uint64_t))));
+	size_t plen = 0;
+
+	fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_SCSITRANSPORT);
+	if (fd < 0) {
+		condlog(0, "fc socket error %ld", fd);
+		return NULL;
+	}
+
+	pthread_cleanup_push(close_fd, (void *)fd);
+	memset(&fc_local, 0, sizeof(fc_local));
+	fc_local.nl_family = AF_NETLINK;
+	fc_local.nl_groups = ~0;
+	fc_local.nl_pid = getpid();
+	ret = bind(fd, (struct sockaddr *)&fc_local, sizeof(fc_local));
+	if (ret == -1) {
+		condlog(0, "fc socket bind error %d\n", ret);
+		goto out;
+	}
+	for ( ; ; ) {
+		condlog(4, "Waiting for ELS...\n");
+		ret = read(fd, buf, DEF_RX_BUF_SIZE);
+		condlog(4, "Got a new request %d\n", ret);
+		if (!NLMSG_OK((struct nlmsghdr *)buf, ret)) {
+			condlog(0, "bad els frame read (%d)", ret);
+			continue;
+		}
+		/* Push the frame to appropriate frame list */
+		plen = NLMSG_PAYLOAD((struct nlmsghdr *)buf, 0);
+		fc_event = (struct fc_nl_event *)NLMSG_DATA(buf);
+		if (plen < sizeof(*fc_event)) {
+			condlog(0, "too short (%d) to be an FC event", ret);
+			continue;
+		}
+		els_cmd = (uint32_t)fc_event->event_data;
+		condlog(4, "Got host no as %d, event 0x%x, len %d evntnum %d evntcode %d\n",
+				fc_event->host_no, els_cmd, fc_event->event_datalen,
+				fc_event->event_num, fc_event->event_code);
+		if ((fc_event->event_code == FCH_EVT_LINK_FPIN) ||
+			(fc_event->event_code == FCH_EVT_LINKUP) ||
+			(fc_event->event_code == FCH_EVT_RSCN))
+				fpin_handle_els_frame(fc_event);
+	}
+out:
+	pthread_cleanup_pop(1);
+	return NULL;
+}
diff --git a/multipathd/main.c b/multipathd/main.c
index 1defeaf1..d81ebd92 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -16,6 +16,7 @@
 #include <linux/oom.h>
 #include <libudev.h>
 #include <urcu.h>
+#include "fpin.h"
 #ifdef USE_SYSTEMD
 #include <systemd/sd-daemon.h>
 #endif
@@ -130,9 +131,11 @@ static volatile enum daemon_status running_state = DAEMON_INIT;
 pid_t daemon_pid;
 static pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t config_cond;
-static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_thr;
+static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_thr,
+	fpin_thr, fpin_consumer_thr;
 static bool check_thr_started, uevent_thr_started, uxlsnr_thr_started,
-	uevq_thr_started, dmevent_thr_started;
+	uevq_thr_started, dmevent_thr_started, fpin_thr_started,
+	fpin_consumer_thr_started;
 static int pid_fd = -1;
 
 static inline enum daemon_status get_running_state(void)
@@ -3029,6 +3032,11 @@ static void cleanup_threads(void)
 		pthread_cancel(uevq_thr);
 	if (dmevent_thr_started)
 		pthread_cancel(dmevent_thr);
+	if (fpin_thr_started)
+		pthread_cancel(fpin_thr);
+	if (fpin_consumer_thr_started)
+		pthread_cancel(fpin_consumer_thr);
+
 
 	if (check_thr_started)
 		pthread_join(check_thr, NULL);
@@ -3040,6 +3048,11 @@ static void cleanup_threads(void)
 		pthread_join(uevq_thr, NULL);
 	if (dmevent_thr_started)
 		pthread_join(dmevent_thr, NULL);
+	if (fpin_thr_started)
+		pthread_join(fpin_thr, NULL);
+	if (fpin_consumer_thr_started)
+		pthread_join(fpin_consumer_thr, NULL);
+
 
 	/*
 	 * As all threads are joined now, and we're in DAEMON_SHUTDOWN
@@ -3101,6 +3114,7 @@ static void cleanup_rcu(void)
 static void cleanup_child(void)
 {
 	cleanup_threads();
+	cleanup_fpin_list();
 	cleanup_vecs();
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
@@ -3137,6 +3151,7 @@ child (__attribute__((unused)) void *param)
 	char *envp;
 	enum daemon_status state;
 	int exit_code = 1;
+	int fpin_marginal_paths = 0;
 
 	init_unwinder();
 	mlockall(MCL_CURRENT | MCL_FUTURE);
@@ -3215,7 +3230,9 @@ child (__attribute__((unused)) void *param)
 
 	setscheduler();
 	set_oom_adj();
-
+#ifdef FPIN_EVENT_HANDLER
+	fpin_marginal_paths = conf->fpin_marginal_paths;
+#endif
 	/*
 	 * Startup done, invalidate configuration
 	 */
@@ -3283,6 +3300,21 @@ child (__attribute__((unused)) void *param)
 		goto failed;
 	} else
 		uevq_thr_started = true;
+	if (fpin_marginal_paths) {
+		if ((rc = pthread_create(&fpin_thr, &misc_attr,
+			fpin_fabric_notification_receiver, NULL))) {
+			condlog(0, "failed to create the fpin receiver thread: %d", rc);
+			goto failed;
+		} else
+			fpin_thr_started = true;
+
+		if ((rc = pthread_create(&fpin_consumer_thr,
+			&misc_attr, fpin_els_li_consumer, vecs))) {
+			condlog(0, "failed to create the fpin consumer thread thread: %d", rc);
+			goto failed;
+		} else
+			fpin_consumer_thr_started = true;
+	}
 	pthread_attr_destroy(&misc_attr);
 
 	while (1) {
-- 
2.27.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

