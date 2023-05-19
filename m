Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138FFC7EE23
	for <dm-devel@archiver.kernel.org>; Fri, 19 May 2023 23:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684537345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OEET7OUAP9JIvKwNstwTizv0A/IOQVhftbxt02I69Qc=;
	b=aper7IbmWPMXNvZWoBkS8oCEnrtQliL84gx2EqmYz7YQYPXia2bIo4r48DF1FmCHMsLD4a
	brfP5AjoJEijNT7yNO3+jyUGfOFgImMMdDd+6tQW6+dtZhPuV4H+1fAQ12gAeWMrkpkqni
	dyOZl3MtYjkOBtMUn0RiVlQtTIZwbxw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-ukgCfHjTPJOd_Nk44hOIfA-1; Fri, 19 May 2023 19:02:23 -0400
X-MC-Unique: ukgCfHjTPJOd_Nk44hOIfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1291C280016E;
	Fri, 19 May 2023 23:02:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F41FB40D1B60;
	Fri, 19 May 2023 23:02:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB3F219465B7;
	Fri, 19 May 2023 23:02:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E001119465B9
 for <dm-devel@listman.corp.redhat.com>; Fri, 19 May 2023 23:02:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D3C3E4F2DE4; Fri, 19 May 2023 23:02:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D2DC4F2DE3;
 Fri, 19 May 2023 23:02:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 34JN2Iw1023093;
 Fri, 19 May 2023 18:02:18 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 34JN2HBI023092;
 Fri, 19 May 2023 18:02:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 19 May 2023 18:02:12 -0500
Message-Id: <1684537332-23033-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 5/5] libmultipath: add "detect_pgpolicy" config
 option
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This allows configuations to use "group_by_tpg" if alua is autodetected
and another policy if it isn't, so they can work with detect_prio.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c             |  2 ++
 libmultipath/config.h             |  2 ++
 libmultipath/configure.c          |  1 +
 libmultipath/defaults.h           |  1 +
 libmultipath/dict.c               | 11 +++++++++++
 libmultipath/hwtable.c            |  1 +
 libmultipath/libmultipath.version | 10 +++-------
 libmultipath/propsel.c            | 23 ++++++++++++++++++++++-
 libmultipath/propsel.h            |  1 +
 libmultipath/structs.h            |  7 +++++++
 multipath/multipath.conf.5        | 12 ++++++++++++
 11 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 5c5c0726..2e742373 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -452,6 +452,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(retain_hwhandler);
 	merge_num(detect_prio);
 	merge_num(detect_checker);
+	merge_num(detect_pgpolicy);
 	merge_num(deferred_remove);
 	merge_num(delay_watch_checks);
 	merge_num(delay_wait_checks);
@@ -617,6 +618,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->retain_hwhandler = dhwe->retain_hwhandler;
 	hwe->detect_prio = dhwe->detect_prio;
 	hwe->detect_checker = dhwe->detect_checker;
+	hwe->detect_pgpolicy = dhwe->detect_pgpolicy;
 	hwe->ghost_delay = dhwe->ghost_delay;
 	hwe->vpd_vendor_id = dhwe->vpd_vendor_id;
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 87947469..014c6849 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -76,6 +76,7 @@ struct hwentry {
 	int retain_hwhandler;
 	int detect_prio;
 	int detect_checker;
+	int detect_pgpolicy;
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
@@ -171,6 +172,7 @@ struct config {
 	int retain_hwhandler;
 	int detect_prio;
 	int detect_checker;
+	int detect_pgpolicy;
 	int force_sync;
 	int deferred_remove;
 	int processed_main_config;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 4a1c28bb..366b166f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -304,6 +304,7 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	pthread_cleanup_push(put_multipath_config, conf);
 
 	select_pgfailback(conf, mpp);
+	select_detect_pgpolicy(conf, mpp);
 	select_pgpolicy(conf, mpp);
 
 	/*
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index a5e9ea0c..090baa5c 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -29,6 +29,7 @@
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
 #define DEFAULT_DETECT_PRIO	DETECT_PRIO_ON
 #define DEFAULT_DETECT_CHECKER	DETECT_CHECKER_ON
+#define DEFAULT_DETECT_PGPOLICY	DETECT_PGPOLICY_OFF
 #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
 #define DEFAULT_DELAY_CHECKS	NU_NO
 #define DEFAULT_ERR_CHECKS	NU_NO
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index dddd3cd6..edd4923d 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -868,6 +868,14 @@ declare_ovr_snprint(detect_checker, print_yes_no_undef)
 declare_hw_handler(detect_checker, set_yes_no_undef)
 declare_hw_snprint(detect_checker, print_yes_no_undef)
 
+declare_def_handler(detect_pgpolicy, set_yes_no_undef)
+declare_def_snprint_defint(detect_pgpolicy, print_yes_no_undef,
+			   DEFAULT_DETECT_PGPOLICY)
+declare_ovr_handler(detect_pgpolicy, set_yes_no_undef)
+declare_ovr_snprint(detect_pgpolicy, print_yes_no_undef)
+declare_hw_handler(detect_pgpolicy, set_yes_no_undef)
+declare_hw_snprint(detect_pgpolicy, print_yes_no_undef)
+
 declare_def_handler(force_sync, set_yes_no)
 declare_def_snprint(force_sync, print_yes_no)
 
@@ -2112,6 +2120,7 @@ init_keywords(vector keywords)
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
 	install_keyword("detect_checker", &def_detect_checker_handler, &snprint_def_detect_checker);
+	install_keyword("detect_pgpolicy", &def_detect_pgpolicy_handler, &snprint_def_detect_pgpolicy);
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
 	install_keyword("strict_timing", &def_strict_timing_handler, &snprint_def_strict_timing);
 	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
@@ -2202,6 +2211,7 @@ init_keywords(vector keywords)
 	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
 	install_keyword("detect_checker", &hw_detect_checker_handler, &snprint_hw_detect_checker);
+	install_keyword("detect_pgpolicy", &hw_detect_pgpolicy_handler, &snprint_hw_detect_pgpolicy);
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
 	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
 	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
@@ -2244,6 +2254,7 @@ init_keywords(vector keywords)
 	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
 	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
 	install_keyword("detect_checker", &ovr_detect_checker_handler, &snprint_ovr_detect_checker);
+	install_keyword("detect_pgpolicy", &ovr_detect_pgpolicy_handler, &snprint_ovr_detect_pgpolicy);
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
 	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
 	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 65bca744..803230c1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -67,6 +67,7 @@
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 		.detect_prio   = DETECT_PRIO_ON,
 		.detect_checker = DETECT_CHECKER_ON,
+		.detect_pgpolicy = DETECT_PGPOLICY_OFF,
 		.deferred_remove = DEFERRED_REMOVE_OFF,
 		.delay_watch_checks = DELAY_CHECKS_OFF,
 		.delay_wait_checks = DELAY_CHECKS_OFF,
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index aba1a30e..8f72c452 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_18.0.0 {
+LIBMULTIPATH_19.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -116,6 +116,7 @@ global:
 	get_refwwid;
 	get_state;
 	get_udev_device;
+	get_uid;
 	get_used_hwes;
 	get_vpd_sgio;
 	group_by_prio;
@@ -141,6 +142,7 @@ global:
 	pathcount;
 	path_discovery;
 	path_get_tpgs;
+	pathinfo;
 	path_offline;
 	print_all_paths;
 	print_foreign_topology;
@@ -235,9 +237,3 @@ global:
 local:
 	*;
 };
-
-LIBMULTIPATH_18.1.0 {
-global:
-	get_uid;
-	pathinfo;
-} LIBMULTIPATH_18.0.0;
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d214281b..12f4825d 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -265,6 +265,21 @@ verify_alua_prio(struct multipath *mp)
 	return true;
 }
 
+int select_detect_pgpolicy(struct config *conf, struct multipath *mp)
+{
+	const char *origin;
+
+	mp_set_ovr(detect_pgpolicy);
+	mp_set_hwe(detect_pgpolicy);
+	mp_set_conf(detect_pgpolicy);
+	mp_set_default(detect_pgpolicy, DEFAULT_DETECT_PGPOLICY);
+out:
+	condlog(3, "%s: detect_pgpolicy = %s %s", mp->alias,
+		(mp->detect_pgpolicy == DETECT_PGPOLICY_ON)? "yes" : "no",
+		 origin);
+	return 0;
+}
+
 int select_pgpolicy(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
@@ -275,13 +290,19 @@ int select_pgpolicy(struct config *conf, struct multipath * mp)
 		origin = cmdline_origin;
 		goto out;
 	}
+	if (mp->detect_pgpolicy == DETECT_PGPOLICY_ON && verify_alua_prio(mp)) {
+		mp->pgpolicy = GROUP_BY_TPG;
+		origin = autodetect_origin;
+		goto out;
+	}
 	mp_set_mpe(pgpolicy);
 	mp_set_ovr(pgpolicy);
 	mp_set_hwe(pgpolicy);
 	mp_set_conf(pgpolicy);
 	mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
 out:
-	if (mp->pgpolicy == GROUP_BY_TPG && !verify_alua_prio(mp)) {
+	if (mp->pgpolicy == GROUP_BY_TPG && origin != autodetect_origin &&
+	    !verify_alua_prio(mp)) {
 		mp->pgpolicy = DEFAULT_PGPOLICY;
 		origin = "(setting: emergency fallback - not all paths use alua prio)";
 		log_prio = 1;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 152ca44c..513ee6ac 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -1,5 +1,6 @@
 int select_rr_weight (struct config *conf, struct multipath * mp);
 int select_pgfailback (struct config *conf, struct multipath * mp);
+int select_detect_pgpolicy (struct config *conf, struct multipath * mp);
 int select_pgpolicy (struct config *conf, struct multipath * mp);
 int select_selector (struct config *conf, struct multipath * mp);
 int select_alias (struct config *conf, struct multipath * mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 0eea19b4..682a7e17 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -143,6 +143,12 @@ enum detect_checker_states {
 	DETECT_CHECKER_ON = YNU_YES,
 };
 
+enum detect_pgpolicy_states {
+	DETECT_PGPOLICY_UNDEF = YNU_UNDEF,
+	DETECT_PGPOLICY_OFF = YNU_NO,
+	DETECT_PGPOLICY_ON = YNU_YES,
+};
+
 enum deferred_remove_states {
 	DEFERRED_REMOVE_UNDEF = YNU_UNDEF,
 	DEFERRED_REMOVE_OFF = YNU_NO,
@@ -389,6 +395,7 @@ enum prflag_value {
 struct multipath {
 	char wwid[WWID_SIZE];
 	char alias_old[WWID_SIZE];
+	int detect_pgpolicy;
 	int pgpolicy;
 	pgpolicyfn *pgpolicyfn;
 	int nextpg;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b65a543d..9f8be510 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -242,6 +242,18 @@ The default is: \fBfailover\fR
 .
 .
 .TP
+.B detect_pgpolicy
+If set to \fIyes\fR and all path devcices are configured with either the
+\fIalua\fR or \fIsysfs\fR prioritizer, the multipath device will automatically
+use the \fIgroup_by_tpg\fR path_grouping_policy. If set to \fIno\fR, the
+path_grouping_policy will be selected as usual.
+.RS
+.TP
+The default is: \fIno\fR
+.RE
+.
+.
+.TP
 .B pg_timeout
 (Deprecated) This option is not supported any more, and the value is ignored.
 .
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

