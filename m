Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB9DEC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 06:07:58 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-Z0-UgE8kOImuJGeGiz9juw-1; Fri, 11 Feb 2022 01:07:54 -0500
X-MC-Unique: Z0-UgE8kOImuJGeGiz9juw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB30F1091DA2;
	Fri, 11 Feb 2022 06:07:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA18D610F5;
	Fri, 11 Feb 2022 06:07:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 098A34CA93;
	Fri, 11 Feb 2022 06:07:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AAIpR8013240 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 05:18:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6B02840885A0; Thu, 10 Feb 2022 10:18:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 665BC40885B5
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 10:18:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45AB0811E78
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 10:18:51 +0000 (UTC)
Received: from relay.smtp-ext.broadcom.com (lpdvsmtp09.broadcom.com
	[192.19.166.228]) by relay.mimecast.com with ESMTP id
	us-mta-659-rz5I5OElNVGoagTyZD2ygQ-1; Thu, 10 Feb 2022 05:18:49 -0500
X-MC-Unique: rz5I5OElNVGoagTyZD2ygQ-1
Received: from localhost.localdomain (unknown [10.157.2.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 63D12C0000E7;
	Thu, 10 Feb 2022 02:18:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 63D12C0000E7
From: Muneendra Kumar <muneendra.kumar@broadcom.com>
To: dm-devel@redhat.com
Date: Wed,  9 Feb 2022 19:28:10 -0800
Message-Id: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21AAIpR8013240
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 11 Feb 2022 01:07:42 -0500
Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>, mkumar@redhat.com,
	martin.wilck@suse.com
Subject: [dm-devel] [PATCH v3] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Notes:
    V3:
    	Addressed the review comments from Martin
    
    V2:
    	Removed the newly added config option and added a new
    	value "fpin" to the marginal_pathgroups option.
    
    	Added support to handle the multipathd reconfigure case.
    
    	Addressed the review comments from Martin

 Makefile.inc                      |  13 +
 libmultipath/Makefile             |   5 +
 libmultipath/dict.c               |  56 +++-
 libmultipath/libmultipath.version |   1 +
 libmultipath/propsel.c            |  47 ++-
 libmultipath/structs.h            |   7 +
 multipath/multipath.conf.5        |  19 +-
 multipathd/Makefile               |  10 +
 multipathd/fpin.h                 |  20 ++
 multipathd/fpin_handlers.c        | 540 ++++++++++++++++++++++++++++++
 multipathd/main.c                 |  43 ++-
 11 files changed, 745 insertions(+), 16 deletions(-)
 create mode 100644 multipathd/fpin.h
 create mode 100644 multipathd/fpin_handlers.c

diff --git a/Makefile.inc b/Makefile.inc
index a7d16dfd..86b13cb3 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -159,6 +159,19 @@ check_file = $(shell \
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
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 58e80e95..77e954ae 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -45,6 +45,11 @@ ifneq ($(call check_func,dm_hold_control_dev,$(DEVMAPPER_INCDIR)/libdevmapper.h)
 	CFLAGS += -DLIBDM_API_HOLD_CONTROL
 endif
 
+ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(LINUX_HEADERS_INCDIR)/scsi/fc/fc_els.h),0)
+	CFLAGS += -DFPIN_EVENT_HANDLER
+endif
+
+
 OBJS = parser.o vector.o devmapper.o callout.o \
 	hwtable.o blacklist.o util.o dmparser.o config.o \
 	structs.o discovery.o propsel.o dict.o \
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7ad9f6e2..2af9764c 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -512,6 +512,59 @@ snprint_def_find_multipaths(struct config *conf, struct strbuf *buff,
 			 find_multipaths_optvals[conf->find_multipaths]);
 }
 
+static const char * const marginal_pathgroups_optvals[] = {
+	[MARGINAL_PATHGROUP_OFF] = "off",
+	[MARGINAL_PATHGROUP_ON] = "on",
+#ifdef FPIN_EVENT_HANDLER
+	[MARGINAL_PATHGROUP_FPIN] = "fpin",
+#endif
+};
+
+static int
+def_marginal_pathgroups_handler(struct config *conf, vector strvec,
+			    const char *file, int line_nr)
+{
+	char *buff;
+	unsigned int i;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+	for (i = MARGINAL_PATHGROUP_OFF;
+	     i < ARRAY_SIZE(marginal_pathgroups_optvals); i++) {
+		if (marginal_pathgroups_optvals[i] != NULL &&
+		    !strcmp(buff, marginal_pathgroups_optvals[i])) {
+			conf->marginal_pathgroups = i;
+			break;
+		}
+	}
+
+	if (i >= ARRAY_SIZE(marginal_pathgroups_optvals)) {
+		if (strcmp(buff, "no") == 0 || strcmp(buff, "0") == 0)
+			conf->marginal_pathgroups = MARGINAL_PATHGROUP_OFF;
+		else if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
+			conf->marginal_pathgroups = MARGINAL_PATHGROUP_ON;
+		/* This can only be true if FPIN_EVENT_HANDLER isn't defined,
+		 * otherwise this check will have already happened above */
+		else if (strcmp(buff, "fpin") == 0)
+			condlog(1, "%s line %d, support for \"fpin\" is not compiled in for marginal_pathgroups", file, line_nr);
+		else
+			condlog(1, "%s line %d, invalid value for marginal_pathgroups: \"%s\"",
+				file, line_nr, buff);
+	}
+	free(buff);
+	return 0;
+}
+
+static int
+snprint_def_marginal_pathgroups(struct config *conf, struct strbuf *buff,
+			    const void *data)
+{
+	return append_strbuf_quoted(buff,
+			 marginal_pathgroups_optvals[conf->marginal_pathgroups]);
+}
+
+
 declare_def_handler(selector, set_str)
 declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
 declare_hw_handler(selector, set_str)
@@ -1526,9 +1579,6 @@ declare_ovr_snprint(all_tg_pt, print_yes_no_undef)
 declare_hw_handler(all_tg_pt, set_yes_no_undef)
 declare_hw_snprint(all_tg_pt, print_yes_no_undef)
 
-declare_def_handler(marginal_pathgroups, set_yes_no)
-declare_def_snprint(marginal_pathgroups, print_yes_no)
-
 declare_def_handler(recheck_wwid, set_yes_no_undef)
 declare_def_snprint_defint(recheck_wwid, print_yes_no_undef, DEFAULT_RECHECK_WWID)
 declare_ovr_handler(recheck_wwid, set_yes_no_undef)
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index b663cb29..216f0eef 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -56,6 +56,7 @@ global:
 	check_foreign;
 	cleanup_charp;
 	cleanup_lock;
+	cleanup_mutex;
 	cleanup_ucharp;
 	close_fd;
 	coalesce_paths;
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a842fc39..1419ec6f 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -83,6 +83,8 @@ static const char cmdline_origin[] =
 	"(setting: multipath command line [-p] flag)";
 static const char autodetect_origin[] =
 	"(setting: storage device autodetected)";
+static const char fpin_marginal_path_origin[] =
+	"(setting: overridden by marginal_path_fpin)";
 static const char marginal_path_origin[] =
 	"(setting: implied by marginal_path check)";
 static const char delay_watch_origin[] =
@@ -1035,9 +1037,12 @@ int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	if (marginal_path_check_enabled(mp)) {
+	if (marginal_path_check_enabled(mp) || (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)) {
 		mp->san_path_err_threshold = NU_NO;
-		origin = marginal_path_origin;
+		if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)
+			origin = fpin_marginal_path_origin;
+		else
+			origin = marginal_path_origin;
 		goto out;
 	}
 	mp_set_mpe(san_path_err_threshold);
@@ -1058,9 +1063,12 @@ int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	if (marginal_path_check_enabled(mp)) {
+	if (marginal_path_check_enabled(mp) || (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)) {
 		mp->san_path_err_forget_rate = NU_NO;
-		origin = marginal_path_origin;
+		if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)
+			origin = fpin_marginal_path_origin;
+		else
+			origin = marginal_path_origin;
 		goto out;
 	}
 	mp_set_mpe(san_path_err_forget_rate);
@@ -1082,9 +1090,12 @@ int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	if (marginal_path_check_enabled(mp)) {
+	if (marginal_path_check_enabled(mp) || (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)) {
 		mp->san_path_err_recovery_time = NU_NO;
-		origin = marginal_path_origin;
+		if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)
+			origin = fpin_marginal_path_origin;
+		else
+			origin = marginal_path_origin;
 		goto out;
 	}
 	mp_set_mpe(san_path_err_recovery_time);
@@ -1106,6 +1117,12 @@ int select_marginal_path_err_sample_time(struct config *conf, struct multipath *
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
+	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN) {
+		mp->marginal_path_err_sample_time = NU_NO;
+		origin = fpin_marginal_path_origin;
+		goto out;
+	}
+
 	mp_set_mpe(marginal_path_err_sample_time);
 	mp_set_ovr(marginal_path_err_sample_time);
 	mp_set_hwe(marginal_path_err_sample_time);
@@ -1129,6 +1146,12 @@ int select_marginal_path_err_rate_threshold(struct config *conf, struct multipat
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
+	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN) {
+		mp->marginal_path_err_rate_threshold = NU_NO;
+		origin = fpin_marginal_path_origin;
+		goto out;
+	}
+
 	mp_set_mpe(marginal_path_err_rate_threshold);
 	mp_set_ovr(marginal_path_err_rate_threshold);
 	mp_set_hwe(marginal_path_err_rate_threshold);
@@ -1146,6 +1169,12 @@ int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multip
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
+	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN) {
+		mp->marginal_path_err_recheck_gap_time = NU_NO;
+		origin = fpin_marginal_path_origin;
+		goto out;
+	}
+
 	mp_set_mpe(marginal_path_err_recheck_gap_time);
 	mp_set_ovr(marginal_path_err_recheck_gap_time);
 	mp_set_hwe(marginal_path_err_recheck_gap_time);
@@ -1164,6 +1193,12 @@ int select_marginal_path_double_failed_time(struct config *conf, struct multipat
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
+	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN) {
+		mp->marginal_path_double_failed_time = NU_NO;
+		origin = fpin_marginal_path_origin;
+		goto out;
+	}
+
 	mp_set_mpe(marginal_path_double_failed_time);
 	mp_set_ovr(marginal_path_double_failed_time);
 	mp_set_hwe(marginal_path_double_failed_time);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 7f621941..205cf64e 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -111,6 +111,12 @@ enum find_multipaths_states {
 	__FIND_MULTIPATHS_LAST,
 };
 
+enum marginal_pathgroups_mode {
+	MARGINAL_PATHGROUP_OFF = YN_NO,
+	MARGINAL_PATHGROUP_ON = YN_YES,
+	MARGINAL_PATHGROUP_FPIN,
+};
+
 enum flush_states {
 	FLUSH_UNDEF = YNU_UNDEF,
 	FLUSH_DISABLED = YNU_NO,
@@ -419,6 +425,7 @@ struct multipath {
 	unsigned char prflag;
 	int all_tg_pt;
 	struct gen_multipath generic_mp;
+	bool fpin_must_reload;
 };
 
 static inline int marginal_path_check_enabled(const struct multipath *mpp)
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 80fa2920..746bb60c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1088,20 +1088,26 @@ The default is: \fBno\fR
 .
 .TP
 .B marginal_pathgroups
-If set to \fIno\fR, the \fIdelay_*_checks\fR, \fImarginal_path_*\fR, and
+If set to \fIoff\fR, the \fIdelay_*_checks\fR, \fImarginal_path_*\fR, and
 \fIsan_path_err_*\fR options will keep marginal, or \(dqshaky\(dq, paths from
 being reinstated until they have been monitored for some time. This can cause
 situations where all non-marginal paths are down, and no paths are usable
 until multipathd detects this and reinstates a marginal path. If the multipath
 device is not configured to queue IO in this case, it can cause IO errors to
 occur, even though there are marginal paths available.  However, if this
-option is set to \fIyes\fR, when one of the marginal path detecting methods
+option is set to \fIon\fR, when one of the marginal path detecting methods
 determines that a path is marginal, it will be reinstated and placed in a
 separate pathgroup that will only be used after all the non-marginal pathgroups
 have been tried first. This prevents the possibility of IO errors occurring
 while marginal paths are still usable. After the path has been monitored
 for the configured time, and is declared healthy, it will be returned to its
-normal pathgroup. See "Shaky paths detection" below for more information.
+normal pathgroup.
+However if this option is set to \fIfpin\fR multipathd will receive fpin
+notifications, set path states to "marginal" accordingly, and regroup paths
+as described for "marginal_pathgroups yes". This option can't be used in combination
+with other options for "Shaky path detection" (see below).If it is set to fpin,
+marginal_path_xyz and san_path_err_xyz parameters are implicitly set to 0.
+See "Shaky paths detection" below for more information.
 .RS
 .TP
 The default is: \fBno\fR
@@ -1841,6 +1847,13 @@ increase and the threshold is never reached. Ticks are the time between
 path checks by multipathd, which is variable and controlled by the
 \fIpolling_interval\fR and \fImax_polling_interval\fR parameters.
 .
+.TP
+.B \(dqFPIN \(dq failure tracking
+Fibre channel fabrics can notify hosts about fabric-level issues such
+as integrity failures or congestion with so-called Fabric Performance
+Impact Notifications (FPINs).On receiving the fpin notifications through ELS
+multipathd will move the affected path and port states to marginal.
+.
 .RS 8
 .LP
 This method is \fBdeprecated\fR in favor of the \(dqmarginal_path\(dq failure
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 9f61b4ac..9a491445 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -4,6 +4,10 @@ ifneq ($(call check_func,dm_task_get_errno,$(DEVMAPPER_INCDIR)/libdevmapper.h),0
 	CFLAGS += -DLIBDM_API_GET_ERRNO
 endif
 
+ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(LINUX_HEADERS_INCDIR)/scsi/fc/fc_els.h),0)
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
index 00000000..bfcc1ce2
--- /dev/null
+++ b/multipathd/fpin.h
@@ -0,0 +1,20 @@
+#ifndef __FPIN_H__
+#define __FPIN_H__
+
+#ifdef FPIN_EVENT_HANDLER
+void *fpin_fabric_notification_receiver(void *unused);
+void *fpin_els_li_consumer(void *data);
+void fpin_clean_marginal_dev_list(__attribute__((unused)) void *arg);
+#else
+static void *fpin_fabric_notification_receiver(__attribute__((unused))void *unused)
+{
+	return NULL;
+}
+static void *fpin_els_li_consumer(__attribute__((unused))void *data)
+{
+	return NULL;
+}
+/* fpin_clean_marginal_dev_list() is never called */
+#endif
+
+#endif
diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
new file mode 100644
index 00000000..2a94024d
--- /dev/null
+++ b/multipathd/fpin_handlers.c
@@ -0,0 +1,540 @@
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
+#include "sysfs.h"
+
+#include "fpin.h"
+#include "devmapper.h"
+
+static pthread_cond_t fpin_li_cond = PTHREAD_COND_INITIALIZER;
+static pthread_mutex_t fpin_li_mutex = PTHREAD_MUTEX_INITIALIZER;
+static pthread_mutex_t fpin_li_marginal_dev_mutex = PTHREAD_MUTEX_INITIALIZER;
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
+	char dev_t[BLK_DEV_SIZE];
+	uint32_t host_num;
+	struct list_head node;
+};
+
+static void _udev_device_unref(void *p)
+{
+	udev_device_unref(p);
+}
+
+
+/*set/unset the path state to marginal*/
+static int fpin_set_pathstate(struct path *pp, bool set)
+{
+	const char *action = set ? "set" : "unset";
+
+	if (!pp || !pp->mpp || !pp->mpp->alias)
+		return -1;
+
+	condlog(3, "\n%s: %s  marginal path %s (fpin)",
+		action, pp->mpp->alias, pp->dev_t);
+	pp->marginal = set;
+	pp->mpp->fpin_must_reload = true;
+	return 0;
+}
+
+/* This will unset marginal state of a device*/
+static void fpin_path_unsetmarginal(char *devname, struct vectors *vecs)
+{
+	struct path *pp;
+
+	pp = find_path_by_dev(vecs->pathvec, devname);
+	if (!pp)
+		pp = find_path_by_devt(vecs->pathvec, devname);
+
+	fpin_set_pathstate(pp, false);
+}
+
+/*This will set the marginal state of a device*/
+static int fpin_path_setmarginal(struct path *pp)
+{
+	return fpin_set_pathstate(pp, true);
+}
+
+/* Unsets all the devices in the list from marginal state */
+static void
+fpin_unset_marginal_dev(uint32_t host_num, struct vectors *vecs)
+{
+	struct marginal_dev_list *tmp_marg = NULL;
+	struct marginal_dev_list *marg = NULL;
+	struct multipath *mpp;
+	int ret = 0;
+	int i;
+
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(&vecs->lock);
+	pthread_testcancel();
+
+	pthread_mutex_lock(&fpin_li_marginal_dev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &fpin_li_marginal_dev_mutex);
+	pthread_testcancel();
+	if (list_empty(&fpin_li_marginal_dev_list_head)) {
+		condlog(4, "Marginal List is empty\n");
+		goto empty;
+	}
+	list_for_each_entry_safe(marg, tmp_marg, &fpin_li_marginal_dev_list_head, node) {
+		if (marg->host_num != host_num)
+			continue;
+		condlog(4, " unsetting marginal dev: is %s %d\n",
+				tmp_marg->dev_t, tmp_marg->host_num);
+		fpin_path_unsetmarginal(marg->dev_t, vecs);
+		list_del(&marg->node);
+		free(marg);
+	}
+empty:
+	pthread_cleanup_pop(1);
+	/* walk backwards because reload_and_sync_map() can remove mpp */
+	vector_foreach_slot_backwards(vecs->mpvec, mpp, i) {
+		if (mpp->fpin_must_reload) {
+			ret = reload_and_sync_map(mpp, vecs, 0);
+			if (ret == 2)
+				condlog(2, "map removed during reload");
+			else
+				mpp->fpin_must_reload = false;
+		}
+	}
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
+	els_mrg = calloc(1, sizeof(struct els_marginal_list));
+	if (els_mrg != NULL) {
+		els_mrg->host_num = fc_event->host_no;
+		els_mrg->event_code = fc_event->event_code;
+		els_mrg->length = fc_event->event_datalen;
+		memcpy(els_mrg->payload, &(fc_event->event_data), fc_event->event_datalen);
+		list_add_tail(&els_mrg->node, &els_marginal_list_head);
+		pthread_cond_signal(&fpin_li_cond);
+	} else
+		ret = -ENOMEM;
+	pthread_cleanup_pop(1);
+	return ret;
+
+}
+
+/*Sets the rport port_state to marginal*/
+static void fpin_set_rport_marginal(struct udev_device *rport_dev)
+{
+	sysfs_attr_set_value(rport_dev, "port_state",
+				"Marginal", strlen("Marginal"));
+}
+
+/*Add the marginal devices info into the list*/
+static void
+fpin_add_marginal_dev_info(uint32_t host_num, char *devname)
+{
+	struct marginal_dev_list *newdev = NULL;
+
+	newdev = calloc(1, sizeof(struct marginal_dev_list));
+	if (newdev != NULL) {
+		newdev->host_num = host_num;
+		strlcpy(newdev->dev_t, devname, BLK_DEV_SIZE);
+		condlog(4, "\n%s hostno %d devname %s\n", __func__,
+				host_num, newdev->dev_t);
+		pthread_mutex_lock(&fpin_li_marginal_dev_mutex);
+		list_add_tail(&(newdev->node),
+				&fpin_li_marginal_dev_list_head);
+		pthread_mutex_unlock(&fpin_li_marginal_dev_mutex);
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
+
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
+			condlog(2, "%s: No fc_remote_port device for '%s'", pp->dev,
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
+			ret = fpin_path_setmarginal(pp);
+			if (ret < 0)
+				goto unref;
+			fpin_set_rport_marginal(rport_dev);
+			fpin_add_marginal_dev_info(host_num, pp->dev);
+		}
+unref:
+		pthread_cleanup_pop(1);
+	}
+	/* walk backwards because reload_and_sync_map() can remove mpp */
+	vector_foreach_slot_backwards(vecs->mpvec, mpp, i) {
+		if (mpp->fpin_must_reload) {
+			ret = reload_and_sync_map(mpp, vecs, 0);
+			if (ret == 2)
+				condlog(2, "map removed during reload");
+			else
+				mpp->fpin_must_reload = false;
+		}
+	}
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
+			condlog(2, "failed to set the path marginal associated with wwpn: 0x%lx\n", wwpn);
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
+
+	int count = -1;
+	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fc_payload;
+	struct fc_tlv_desc *tlv;
+
+	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
+
+	/*
+	 * Parse the els frame and set the affected paths and port
+	 * state to marginal
+	 */
+	count = fpin_parse_li_els_setpath_marginal(host_num, tlv, vecs);
+	if (count <= 0)
+		condlog(4, "Could not find any WWNs, ret = %d\n",
+					count);
+	return count;
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
+	struct fc_els_fpin *fpin = (struct fc_els_fpin *)&fc_event->event_data;
+	struct fc_tlv_desc *tlv;
+	uint32_t dtag;
+
+	els_cmd = (uint32_t)fc_event->event_data;
+	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
+	dtag = be32_to_cpu(tlv->desc_tag);
+	condlog(4, "Got CMD in add as 0x%x fpin_cmd 0x%x dtag 0x%x\n",
+			els_cmd, fpin->fpin_cmd, dtag);
+
+	if ((fc_event->event_code == FCH_EVT_LINK_FPIN) ||
+			(fc_event->event_code == FCH_EVT_LINKUP) ||
+			(fc_event->event_code == FCH_EVT_RSCN)) {
+
+		if (els_cmd == ELS_FPIN) {
+			/*
+			 * Check the type of fpin by checking the tag info
+			 * At present we are supporting only LI events
+			 */
+			if (dtag == ELS_DTAG_LNK_INTEGRITY) {
+				/*Push the Payload to FPIN frame queue. */
+				ret = fpin_els_add_li_frame(fc_event);
+				if (ret != 0)
+					condlog(0, "Failed to process LI frame with error %d\n",
+							ret);
+			} else {
+				condlog(4, "Unsupported FPIN received 0x%x\n", dtag);
+				return ret;
+			}
+		} else {
+			/*Push the Payload to FPIN frame queue. */
+			ret = fpin_els_add_li_frame(fc_event);
+			if (ret != 0)
+				condlog(0, "Failed to process Linkup/RSCN event with error %d evnt %d\n",
+						ret, fc_event->event_code);
+		}
+	} else
+		condlog(4, "Invalid command received: 0x%x\n", els_cmd);
+	return ret;
+}
+
+/*cleans the global marginal dev list*/
+void fpin_clean_marginal_dev_list(__attribute__((unused)) void *arg)
+{
+	struct marginal_dev_list *tmp_marg = NULL;
+
+	pthread_mutex_lock(&fpin_li_marginal_dev_mutex);
+	while (!list_empty(&fpin_li_marginal_dev_list_head)) {
+		tmp_marg  = list_first_entry(&fpin_li_marginal_dev_list_head,
+				struct marginal_dev_list, node);
+		list_del(&tmp_marg->node);
+		free(tmp_marg);
+	}
+	pthread_mutex_unlock(&fpin_li_marginal_dev_mutex);
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
+static void rcu_unregister(__attribute__((unused)) void *param)
+{
+	rcu_unregister_thread();
+}
+/*
+ * This is the FPIN ELS consumer thread. The thread sleeps on pthread cond
+ * variable unless notified by fpin_fabric_notification_receiver thread.
+ * This thread is only to process FPIN-LI ELS frames. A new thread and frame
+ * list will be added if any more ELS frames types are to be supported.
+ */
+void *fpin_els_li_consumer(void *data)
+{
+	struct list_head marginal_list_head;
+	int ret = 0;
+	uint16_t host_num;
+	struct els_marginal_list *els_marg;
+	uint32_t event_code;
+	struct vectors *vecs = (struct vectors *)data;
+
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
+	pthread_cleanup_push(fpin_clean_marginal_dev_list, NULL);
+	INIT_LIST_HEAD(&marginal_list_head);
+	pthread_cleanup_push(fpin_clean_els_marginal_list,
+				(void *)&marginal_list_head);
+	for ( ; ; ) {
+		pthread_mutex_lock(&fpin_li_mutex);
+		pthread_cleanup_push(cleanup_mutex, &fpin_li_mutex);
+		pthread_testcancel();
+		while (list_empty(&els_marginal_list_head))
+			pthread_cond_wait(&fpin_li_cond, &fpin_li_mutex);
+
+		if (!list_empty(&els_marginal_list_head)) {
+			condlog(4, "Invoke List splice tail\n");
+			list_splice_tail_init(&els_marginal_list_head, &marginal_list_head);
+		}
+		pthread_cleanup_pop(1);
+
+		while (!list_empty(&marginal_list_head)) {
+			els_marg  = list_first_entry(&marginal_list_head,
+							struct els_marginal_list, node);
+			host_num = els_marg->host_num;
+			event_code = els_marg->event_code;
+			/* Now finally process FPIN LI ELS Frame */
+			condlog(4, "Got a new Payload buffer, processing it\n");
+			if ((event_code ==  FCH_EVT_LINKUP) || (event_code == FCH_EVT_RSCN))
+				 fpin_unset_marginal_dev(host_num, vecs);
+			else {
+				ret = fpin_process_els_frame(host_num, els_marg->payload, vecs);
+				if (ret <= 0)
+					condlog(0, "ELS frame processing failed with ret %d\n", ret);
+			}
+			list_del(&els_marg->node);
+			free(els_marg);
+
+		}
+	}
+
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+	return NULL;
+}
+
+static void receiver_cleanup_list(__attribute__((unused)) void *arg)
+{
+	pthread_mutex_lock(&fpin_li_mutex);
+	fpin_clean_els_marginal_list(&els_marginal_list_head);
+	pthread_mutex_unlock(&fpin_li_mutex);
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
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
+
+	pthread_cleanup_push(receiver_cleanup_list, NULL);
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
+		if (ret < 0) {
+			condlog(0, "failed to read the els frame (%d)", ret);
+			continue;
+		}
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
+		fpin_handle_els_frame(fc_event);
+	}
+out:
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+	return NULL;
+}
diff --git a/multipathd/main.c b/multipathd/main.c
index 44ca5b12..6bc5178d 100644
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
@@ -132,9 +133,11 @@ static bool __delayed_reconfig;
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
@@ -2879,7 +2882,9 @@ reconfigure (struct vectors * vecs)
 	conf->sequence_nr = old->sequence_nr + 1;
 	rcu_assign_pointer(multipath_conf, conf);
 	call_rcu(&old->rcu, rcu_free_config);
-
+#ifdef FPIN_EVENT_HANDLER
+	fpin_clean_marginal_dev_list(NULL);
+#endif
 	configure(vecs);
 
 
@@ -3098,6 +3103,11 @@ static void cleanup_threads(void)
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
@@ -3109,6 +3119,11 @@ static void cleanup_threads(void)
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
@@ -3202,6 +3217,7 @@ child (__attribute__((unused)) void *param)
 	char *envp;
 	enum daemon_status state;
 	int exit_code = 1;
+	int fpin_marginal_paths = 0;
 
 	init_unwinder();
 	mlockall(MCL_CURRENT | MCL_FUTURE);
@@ -3280,7 +3296,10 @@ child (__attribute__((unused)) void *param)
 
 	setscheduler();
 	set_oom_adj();
-
+#ifdef FPIN_EVENT_HANDLER
+	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)
+		fpin_marginal_paths = 1;
+#endif
 	/*
 	 * Startup done, invalidate configuration
 	 */
@@ -3348,6 +3367,22 @@ child (__attribute__((unused)) void *param)
 		goto failed;
 	} else
 		uevq_thr_started = true;
+
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

