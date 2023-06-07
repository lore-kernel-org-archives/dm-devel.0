Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2236C83003
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 20:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686170899;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=okowIUmCVEXlaUiZ8h9S8HX6Yl+TKB4+1FOSzxeh7VI=;
	b=AzQXs3cLy0E5RafSirGnHupXFnZdjmzz4tZLttrWi//jsGHuU8xXpW3yZBlaJh96FBceM9
	Dvr6e9xD5v23YREp+/czY8M2G7juosHQTxtp9V0+kTRA5f7T5JSdbKFmkFG2wAF4vvfdpR
	UEntNuguZAF+dR02AlXO8L5fBVSlwrA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-kfDr6Vw5OhWmOw-M7LOLGQ-1; Wed, 07 Jun 2023 16:48:15 -0400
X-MC-Unique: kfDr6Vw5OhWmOw-M7LOLGQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 049078030CD;
	Wed,  7 Jun 2023 20:48:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E87AA2026D6A;
	Wed,  7 Jun 2023 20:48:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DAE5119452C3;
	Wed,  7 Jun 2023 20:48:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 40CD019452C3
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 20:48:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 14A1D400F4E; Wed,  7 Jun 2023 20:48:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E9A23403176;
 Wed,  7 Jun 2023 20:48:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 357Km2GM005817;
 Wed, 7 Jun 2023 15:48:02 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 357Km11d005816;
 Wed, 7 Jun 2023 15:48:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  7 Jun 2023 15:47:48 -0500
Message-Id: <1686170873-5754-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686170873-5754-1-git-send-email-bmarzins@redhat.com>
References: <1686170873-5754-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH V3 06/11] libmultipath: add
 "detect_pgpolicy_use_tpg" config option
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If this and "detect_pgpolicy" are both selected and ALUA is
autodetected, the multipath device will use the "group_by_tpg" policy
instead of the "group_by_prio" policy.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c             |  2 ++
 libmultipath/config.h             |  2 ++
 libmultipath/configure.c          |  1 +
 libmultipath/defaults.h           |  1 +
 libmultipath/dict.c               | 11 +++++++++++
 libmultipath/hwtable.c            |  1 +
 libmultipath/libmultipath.version | 10 +++-------
 libmultipath/propsel.c            | 24 ++++++++++++++++++++++--
 libmultipath/propsel.h            |  1 +
 libmultipath/structs.h            |  7 +++++++
 multipath/multipath.conf.5        | 13 +++++++++++++
 11 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 2e742373..7b207590 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -453,6 +453,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(detect_prio);
 	merge_num(detect_checker);
 	merge_num(detect_pgpolicy);
+	merge_num(detect_pgpolicy_use_tpg);
 	merge_num(deferred_remove);
 	merge_num(delay_watch_checks);
 	merge_num(delay_wait_checks);
@@ -619,6 +620,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->detect_prio = dhwe->detect_prio;
 	hwe->detect_checker = dhwe->detect_checker;
 	hwe->detect_pgpolicy = dhwe->detect_pgpolicy;
+	hwe->detect_pgpolicy_use_tpg = dhwe->detect_pgpolicy_use_tpg;
 	hwe->ghost_delay = dhwe->ghost_delay;
 	hwe->vpd_vendor_id = dhwe->vpd_vendor_id;
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 014c6849..0a2c297b 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -77,6 +77,7 @@ struct hwentry {
 	int detect_prio;
 	int detect_checker;
 	int detect_pgpolicy;
+	int detect_pgpolicy_use_tpg;
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
@@ -173,6 +174,7 @@ struct config {
 	int detect_prio;
 	int detect_checker;
 	int detect_pgpolicy;
+	int detect_pgpolicy_use_tpg;
 	int force_sync;
 	int deferred_remove;
 	int processed_main_config;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 366b166f..ac99edc8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -305,6 +305,7 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 
 	select_pgfailback(conf, mpp);
 	select_detect_pgpolicy(conf, mpp);
+	select_detect_pgpolicy_use_tpg(conf, mpp);
 	select_pgpolicy(conf, mpp);
 
 	/*
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 8f2d2f05..b3f11d4c 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -30,6 +30,7 @@
 #define DEFAULT_DETECT_PRIO	DETECT_PRIO_ON
 #define DEFAULT_DETECT_CHECKER	DETECT_CHECKER_ON
 #define DEFAULT_DETECT_PGPOLICY	DETECT_PGPOLICY_ON
+#define DEFAULT_DETECT_PGPOLICY_USE_TPG	DETECT_PGPOLICY_USE_TPG_OFF
 #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
 #define DEFAULT_DELAY_CHECKS	NU_NO
 #define DEFAULT_ERR_CHECKS	NU_NO
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index edd4923d..6b3e04a3 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -876,6 +876,14 @@ declare_ovr_snprint(detect_pgpolicy, print_yes_no_undef)
 declare_hw_handler(detect_pgpolicy, set_yes_no_undef)
 declare_hw_snprint(detect_pgpolicy, print_yes_no_undef)
 
+declare_def_handler(detect_pgpolicy_use_tpg, set_yes_no_undef)
+declare_def_snprint_defint(detect_pgpolicy_use_tpg, print_yes_no_undef,
+			   DEFAULT_DETECT_PGPOLICY_USE_TPG)
+declare_ovr_handler(detect_pgpolicy_use_tpg, set_yes_no_undef)
+declare_ovr_snprint(detect_pgpolicy_use_tpg, print_yes_no_undef)
+declare_hw_handler(detect_pgpolicy_use_tpg, set_yes_no_undef)
+declare_hw_snprint(detect_pgpolicy_use_tpg, print_yes_no_undef)
+
 declare_def_handler(force_sync, set_yes_no)
 declare_def_snprint(force_sync, print_yes_no)
 
@@ -2121,6 +2129,7 @@ init_keywords(vector keywords)
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
 	install_keyword("detect_checker", &def_detect_checker_handler, &snprint_def_detect_checker);
 	install_keyword("detect_pgpolicy", &def_detect_pgpolicy_handler, &snprint_def_detect_pgpolicy);
+	install_keyword("detect_pgpolicy_use_tpg", &def_detect_pgpolicy_use_tpg_handler, &snprint_def_detect_pgpolicy_use_tpg);
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
 	install_keyword("strict_timing", &def_strict_timing_handler, &snprint_def_strict_timing);
 	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
@@ -2212,6 +2221,7 @@ init_keywords(vector keywords)
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
 	install_keyword("detect_checker", &hw_detect_checker_handler, &snprint_hw_detect_checker);
 	install_keyword("detect_pgpolicy", &hw_detect_pgpolicy_handler, &snprint_hw_detect_pgpolicy);
+	install_keyword("detect_pgpolicy_use_tpg", &hw_detect_pgpolicy_use_tpg_handler, &snprint_hw_detect_pgpolicy_use_tpg);
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
 	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
 	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
@@ -2255,6 +2265,7 @@ init_keywords(vector keywords)
 	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
 	install_keyword("detect_checker", &ovr_detect_checker_handler, &snprint_ovr_detect_checker);
 	install_keyword("detect_pgpolicy", &ovr_detect_pgpolicy_handler, &snprint_ovr_detect_pgpolicy);
+	install_keyword("detect_pgpolicy_use_tpg", &ovr_detect_pgpolicy_use_tpg_handler, &snprint_ovr_detect_pgpolicy_use_tpg);
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
 	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
 	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0b3e7c49..ae6aac79 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -68,6 +68,7 @@
 		.detect_prio   = DETECT_PRIO_ON,
 		.detect_checker = DETECT_CHECKER_ON,
 		.detect_pgpolicy = DETECT_PGPOLICY_ON,
+		.detect_pgpolicy_use_tpg = DETECT_PGPOLICY_USE_TPG_OFF,
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
index 10b84948..df10a68f 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -280,6 +280,22 @@ out:
 	return 0;
 }
 
+int select_detect_pgpolicy_use_tpg(struct config *conf, struct multipath *mp)
+{
+	const char *origin;
+
+	mp_set_ovr(detect_pgpolicy_use_tpg);
+	mp_set_hwe(detect_pgpolicy_use_tpg);
+	mp_set_conf(detect_pgpolicy_use_tpg);
+	mp_set_default(detect_pgpolicy_use_tpg,
+		       DEFAULT_DETECT_PGPOLICY_USE_TPG);
+out:
+	condlog(3, "%s: detect_pgpolicy_use_tpg = %s %s", mp->alias,
+		(mp->detect_pgpolicy_use_tpg == DETECT_PGPOLICY_USE_TPG_ON)?
+		"yes" : "no", origin);
+	return 0;
+}
+
 int select_pgpolicy(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
@@ -291,7 +307,10 @@ int select_pgpolicy(struct config *conf, struct multipath * mp)
 		goto out;
 	}
 	if (mp->detect_pgpolicy == DETECT_PGPOLICY_ON && verify_alua_prio(mp)) {
-		mp->pgpolicy = GROUP_BY_PRIO;
+		if (mp->detect_pgpolicy_use_tpg == DETECT_PGPOLICY_USE_TPG_ON)
+			mp->pgpolicy = GROUP_BY_TPG;
+		else
+			mp->pgpolicy = GROUP_BY_PRIO;
 		origin = autodetect_origin;
 		goto out;
 	}
@@ -301,7 +320,8 @@ int select_pgpolicy(struct config *conf, struct multipath * mp)
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
index 513ee6ac..73615c2f 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -1,6 +1,7 @@
 int select_rr_weight (struct config *conf, struct multipath * mp);
 int select_pgfailback (struct config *conf, struct multipath * mp);
 int select_detect_pgpolicy (struct config *conf, struct multipath * mp);
+int select_detect_pgpolicy_use_tpg (struct config *conf, struct multipath * mp);
 int select_pgpolicy (struct config *conf, struct multipath * mp);
 int select_selector (struct config *conf, struct multipath * mp);
 int select_alias (struct config *conf, struct multipath * mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 682a7e17..97f9de5a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -149,6 +149,12 @@ enum detect_pgpolicy_states {
 	DETECT_PGPOLICY_ON = YNU_YES,
 };
 
+enum detect_pgpolicy_use_tpg_states {
+	DETECT_PGPOLICY_USE_TPG_UNDEF = YNU_UNDEF,
+	DETECT_PGPOLICY_USE_TPG_OFF = YNU_NO,
+	DETECT_PGPOLICY_USE_TPG_ON = YNU_YES,
+};
+
 enum deferred_remove_states {
 	DEFERRED_REMOVE_UNDEF = YNU_UNDEF,
 	DEFERRED_REMOVE_OFF = YNU_NO,
@@ -396,6 +402,7 @@ struct multipath {
 	char wwid[WWID_SIZE];
 	char alias_old[WWID_SIZE];
 	int detect_pgpolicy;
+	int detect_pgpolicy_use_tpg;
 	int pgpolicy;
 	pgpolicyfn *pgpolicyfn;
 	int nextpg;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 3b25b5d4..8a0ff0d8 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -254,6 +254,19 @@ The default is: \fIyes\fR
 .
 .
 .TP
+.B detect_pgpolicy_use_tpg
+If both this and \fIdetect_pgpolicy\fR are set to \fIyes\fR and all path
+devcices are configured with either the \fIalua\fR or \fIsysfs\fR prioritizer,
+the multipath device will automatically use the \fIgroup_by_tpg\fR
+path_grouping_policy. If set to \fIno\fR, the path_grouping_policy will be
+selected by the method described for \fIdetect_pgpolicy\fR above.
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

