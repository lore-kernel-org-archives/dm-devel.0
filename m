Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09FEC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:33:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 470D664D79
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 470D664D79
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614148435;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dhe6lq1VunfGoTXRgoCRDivCxXXfyg3BDhfDns6lpPA=;
	b=WJtTU/P2P2tv6hB46aSn6GVFVN91xiZQ6AZJteFPILCoyc6GoUHhGpjvrt1K2d5hllrJ6e
	lpBX5/SKvt+RTIh/DrPFuNZ3ISjYk0vP1MVDL8x1HGXIws+Fx3njiEIrVYoEdQzBMmsUIH
	zw7o4Ssh5GgtVs0eFe6TXfWUFVfxKWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-TtDNSNgGNgGd9OjybDPaHw-1; Wed, 24 Feb 2021 01:33:53 -0500
X-MC-Unique: TtDNSNgGNgGd9OjybDPaHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83B2A1005501;
	Wed, 24 Feb 2021 06:33:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6758A60C5F;
	Wed, 24 Feb 2021 06:33:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3838D18095CD;
	Wed, 24 Feb 2021 06:33:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O6XYFJ029063 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 01:33:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E975460C61; Wed, 24 Feb 2021 06:33:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D889660C5F;
	Wed, 24 Feb 2021 06:33:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 11O6XUu6019897; 
	Wed, 24 Feb 2021 00:33:30 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 11O6XU63019896;
	Wed, 24 Feb 2021 00:33:30 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 Feb 2021 00:33:22 -0600
Message-Id: <1614148402-19847-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
References: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Chongyun Wu <wucy11@chinatelecom.cn>, Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 3/3] multipathd: add recheck_wwid option to
	verify the path wwid
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

There are cases where the wwid of a path changes due to LUN remapping
without triggering uevent for the changed path. Multipathd has no method
for trying to catch these cases, and corruption has resulted because of
it.

In order to have a better chance at catching these cases, multipath now
has a recheck_wwid option. If this is set to "yes", when a failed path
has become active again, multipathd will recheck its wwid. If multipathd
notices that a path's wwid has changed, it will remove and re-add the
path, just like the existing wwid checking code for change events does.
In cases where the no uevent occurs, both the udev database entry and
sysfs will have the old wwid, so the only way to get a current wwid is
to ask the device directly. Currently multipath only has code to
directly get the wwid for scsi devices, so this option only effects scsi
devices, and they must be configured to be able to use the uid_fallback
methods. To make sure both the sysfs and udev database values are
updated, multipathd triggers a both a rescan of the device and a udev
add event.

Co-developed-by: Chongyun Wu <wucy11@chinatelecom.cn>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c             |  2 +
 libmultipath/config.h             |  2 +
 libmultipath/configure.c          |  4 +-
 libmultipath/configure.h          |  2 +
 libmultipath/defaults.h           |  1 +
 libmultipath/dict.c               | 11 +++++
 libmultipath/discovery.c          |  7 ++-
 libmultipath/discovery.h          |  1 +
 libmultipath/libmultipath.version |  6 +++
 libmultipath/propsel.c            | 21 +++++++++
 libmultipath/propsel.h            |  1 +
 libmultipath/structs.h            |  7 +++
 multipath/multipath.conf.5        | 14 ++++++
 multipathd/cli_handlers.c         |  9 ++++
 multipathd/main.c                 | 78 +++++++++++++++++++++++++++++++
 multipathd/main.h                 |  2 +
 16 files changed, 164 insertions(+), 4 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index be310159..30046a17 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -436,6 +436,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(max_sectors_kb);
 	merge_num(ghost_delay);
 	merge_num(all_tg_pt);
+	merge_num(recheck_wwid);
 	merge_num(vpd_vendor_id);
 	merge_num(san_path_err_threshold);
 	merge_num(san_path_err_forget_rate);
@@ -867,6 +868,7 @@ int _init_config (const char *file, struct config *conf)
 	conf->remove_retries = 0;
 	conf->ghost_delay = DEFAULT_GHOST_DELAY;
 	conf->all_tg_pt = DEFAULT_ALL_TG_PT;
+	conf->recheck_wwid = DEFAULT_RECHECK_WWID;
 	/*
 	 * preload default hwtable
 	 */
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 9ce37f16..933fe0d1 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -83,6 +83,7 @@ struct hwentry {
 	int ghost_delay;
 	int all_tg_pt;
 	int vpd_vendor_id;
+	int recheck_wwid;
 	char * bl_product;
 };
 
@@ -187,6 +188,7 @@ struct config {
 	int marginal_pathgroups;
 	int skip_delegate;
 	unsigned int sequence_nr;
+	int recheck_wwid;
 
 	char * multipath_dir;
 	char * selector;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 598efe05..6ca1f4bb 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -527,8 +527,8 @@ get_udev_for_mpp(const struct multipath *mpp)
 	return udd;
 }
 
-static void trigger_partitions_udev_change(struct udev_device *dev,
-					   const char *action, int len)
+void trigger_partitions_udev_change(struct udev_device *dev,
+				    const char *action, int len)
 {
 	struct udev_enumerate *part_enum;
 	struct udev_list_entry *item;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 6b23ccbb..70cf77a3 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -58,3 +58,5 @@ int get_refwwid (enum mpath_cmds cmd, const char *dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
 struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
 void trigger_paths_udev_change(struct multipath *mpp, bool is_mpath);
+void trigger_partitions_udev_change(struct udev_device *dev, const char *action,
+				    int len);
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 947ba467..c27946c7 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -53,6 +53,7 @@
 #define DEFAULT_FIND_MULTIPATHS_TIMEOUT -10
 #define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
 #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
+#define DEFAULT_RECHECK_WWID RECHECK_WWID_OFF
 /* Enable no foreign libraries by default */
 #define DEFAULT_ENABLE_FOREIGN "NONE"
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index bab96146..dd08abf5 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1401,6 +1401,14 @@ declare_hw_snprint(all_tg_pt, print_yes_no_undef)
 declare_def_handler(marginal_pathgroups, set_yes_no)
 declare_def_snprint(marginal_pathgroups, print_yes_no)
 
+declare_def_handler(recheck_wwid, set_yes_no_undef)
+declare_def_snprint_defint(recheck_wwid, print_yes_no_undef, DEFAULT_RECHECK_WWID)
+declare_ovr_handler(recheck_wwid, set_yes_no_undef)
+declare_ovr_snprint(recheck_wwid, print_yes_no_undef)
+declare_hw_handler(recheck_wwid, set_yes_no_undef)
+declare_hw_snprint(recheck_wwid, print_yes_no_undef)
+
+
 static int
 def_uxsock_timeout_handler(struct config *conf, vector strvec)
 {
@@ -1819,6 +1827,7 @@ init_keywords(vector keywords)
 	install_keyword("enable_foreign", &def_enable_foreign_handler,
 			&snprint_def_enable_foreign);
 	install_keyword("marginal_pathgroups", &def_marginal_pathgroups_handler, &snprint_def_marginal_pathgroups);
+	install_keyword("recheck_wwid", &def_recheck_wwid_handler, &snprint_def_recheck_wwid);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
@@ -1908,6 +1917,7 @@ init_keywords(vector keywords)
 	install_keyword("ghost_delay", &hw_ghost_delay_handler, &snprint_hw_ghost_delay);
 	install_keyword("all_tg_pt", &hw_all_tg_pt_handler, &snprint_hw_all_tg_pt);
 	install_keyword("vpd_vendor", &hw_vpd_vendor_handler, &snprint_hw_vpd_vendor);
+	install_keyword("recheck_wwid", &hw_recheck_wwid_handler, &snprint_hw_recheck_wwid);
 	install_sublevel_end();
 
 	install_keyword_root("overrides", &overrides_handler);
@@ -1949,6 +1959,7 @@ init_keywords(vector keywords)
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
 	install_keyword("ghost_delay", &ovr_ghost_delay_handler, &snprint_ovr_ghost_delay);
 	install_keyword("all_tg_pt", &ovr_all_tg_pt_handler, &snprint_ovr_all_tg_pt);
+	install_keyword("recheck_wwid", &ovr_recheck_wwid_handler, &snprint_ovr_recheck_wwid);
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 40727fa3..f216a724 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2127,7 +2127,7 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 	return len;
 }
 
-static bool has_uid_fallback(struct path *pp)
+bool has_uid_fallback(struct path *pp)
 {
 	/*
 	 * Falling back to direct WWID determination is dangerous
@@ -2162,6 +2162,7 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
 		select_getuid(conf, pp);
+		select_recheck_wwid(conf, pp);
 		pthread_cleanup_pop(1);
 	}
 
@@ -2293,8 +2294,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
 		/* uid_attribute is required for filter_property() */
-		if (pp->udev && !pp->uid_attribute)
+		if (pp->udev && !pp->uid_attribute) {
 			select_getuid(conf, pp);
+			select_recheck_wwid(conf, pp);
+		}
 
 		if (filter_property(conf, pp->udev, 4, pp->uid_attribute) > 0 ||
 		    filter_device(conf->blist_device, conf->elist_device,
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index d3193daf..a5446b4d 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -54,6 +54,7 @@ ssize_t sysfs_get_inquiry(struct udev_device *udev,
 			  unsigned char *buff, size_t len);
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
+bool has_uid_fallback(struct path *pp);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev,
 	    int allow_fallback);
 bool is_vpd_page_supported(int fd, int pg);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 2228f4ec..e9b4608f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -280,3 +280,9 @@ LIBMULTIPATH_4.4.0 {
 global:
 	get_next_string;
 } LIBMULTIPATH_4.3.0;
+
+LIBMULITIPATH_4.5.0 {
+global:
+	get_vpd_sgio;
+	trigger_partitions_udev_change;
+} LIBMULTIPATH_4.4.0;
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f771a830..b7b33791 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -581,6 +581,27 @@ out:
 	return 0;
 }
 
+/* must be called after select_getuid */
+int select_recheck_wwid(struct config *conf, struct path * pp)
+{
+	const char *origin;
+
+	pp_set_ovr(recheck_wwid);
+	pp_set_hwe(recheck_wwid);
+	pp_set_conf(recheck_wwid);
+	pp_set_default(recheck_wwid, DEFAULT_RECHECK_WWID);
+out:
+	if (pp->recheck_wwid == RECHECK_WWID_ON &&
+	    (pp->bus != SYSFS_BUS_SCSI || pp->getuid != NULL ||
+	     !has_uid_fallback(pp))) {
+		pp->recheck_wwid = RECHECK_WWID_OFF;
+		origin = "(setting: unsupported by device type/config)";
+	}
+	condlog(3, "%s: recheck_wwid = %i %s", pp->dev, pp->recheck_wwid,
+		origin);
+	return 0;
+}
+
 void
 detect_prio(struct config *conf, struct path * pp)
 {
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index a68bacf0..72a7e33c 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -7,6 +7,7 @@ int select_features (struct config *conf, struct multipath * mp);
 int select_hwhandler (struct config *conf, struct multipath * mp);
 int select_checker(struct config *conf, struct path *pp);
 int select_getuid (struct config *conf, struct path * pp);
+int select_recheck_wwid(struct config *conf, struct path * pp);
 int select_prio (struct config *conf, struct path * pp);
 int select_find_multipaths_timeout(struct config *conf, struct path *pp);
 int select_no_path_retry(struct config *conf, struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d6ff6762..c8447e56 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -242,6 +242,12 @@ enum eh_deadline_states {
 	EH_DEADLINE_ZERO = UOZ_ZERO,
 };
 
+enum recheck_wwid_states {
+	RECHECK_WWID_UNDEF = YNU_UNDEF,
+	RECHECK_WWID_OFF = YNU_NO,
+	RECHECK_WWID_ON = YNU_YES,
+};
+
 struct vpd_vendor_page {
 	int pg;
 	const char *name;
@@ -316,6 +322,7 @@ struct path {
 	int find_multipaths_timeout;
 	int marginal;
 	int vpd_vendor_id;
+	int recheck_wwid;
 	/* configlet pointers */
 	vector hwe;
 	struct gen_path generic_path;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 8ef3a747..37030765 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1273,6 +1273,20 @@ The default is: \fB\(dqNONE\(dq\fR
 .RE
 .
 .
+.TP
+.B recheck_wwid
+If set to \fIyes\fR, when a failed path is restored, its wwid is rechecked. If
+the wwid has changed, the path is removed from the current multipath device,
+and re-added as a new path. Multipathd will also recheck a path's wwid if it is
+manually re-added. This option only works for SCSI devices that are configured
+to use the default uid_attribute, \fIID_SERIAL\fR, or sysfs for getting their
+wwid.
+.RS
+.TP
+The default is \fBno\fR
+.RE
+.
+.
 
 .
 .\" ----------------------------------------------------------------------------
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 54635738..7f3e61f6 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -715,6 +715,15 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 	pp = find_path_by_dev(vecs->pathvec, param);
 	if (pp && pp->initialized != INIT_REMOVED) {
 		condlog(2, "%s: path already in pathvec", param);
+
+		if (pp->recheck_wwid == RECHECK_WWID_ON &&
+		    check_path_wwid_change(pp)) {
+			condlog(0, "%s: wwid changed. Removing device",
+				pp->dev);
+			handle_path_wwid_change(pp, vecs);
+			return 1;
+		}
+
 		if (pp->mpp)
 			return 0;
 	} else if (pp) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 19679848..637a53bf 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -823,6 +823,73 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 	return flush_map(mpp, vecs, 0);
 }
 
+static void
+rescan_path(struct udev_device *parent)
+{
+	while(parent) {
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "scsi", 4))
+			break;
+		parent = udev_device_get_parent(parent);
+	}
+	if (parent)
+		sysfs_attr_set_value(parent, "rescan", "1", strlen("1"));
+}
+
+void
+handle_path_wwid_change(struct path *pp, struct vectors *vecs)
+{
+	struct udev_device *udd;
+
+	if (!pp || !pp->udev)
+		return;
+
+	udd = udev_device_ref(pp->udev);
+	if (ev_remove_path(pp, vecs, 1) != 0 && pp->mpp) {
+		pp->dmstate = PSTATE_FAILED;
+		dm_fail_path(pp->mpp->alias, pp->dev_t);
+	}
+	rescan_path(udd);
+	sysfs_attr_set_value(udd, "uevent", "add", strlen("add"));
+	trigger_partitions_udev_change(udd, "add", strlen("add"));
+	udev_device_unref(udd);
+}
+
+bool
+check_path_wwid_change(struct path *pp)
+{
+	char wwid[WWID_SIZE];
+	int len = 0;
+	size_t i;
+
+	if (!strlen(pp->wwid))
+		return false;
+
+	/* Get the real fresh device wwid by sgio. sysfs still has old
+	 * data, so only get_vpd_sgio will work to get the new wwid */
+	len = get_vpd_sgio(pp->fd, 0x83, 0, wwid, WWID_SIZE);
+
+	if (len <= 0) {
+		condlog(2, "%s: failed to check wwid by sgio: len = %d",
+			pp->dev, len);
+		return false;
+	}
+
+	/*Strip any trailing blanks */
+	for (i = strlen(pp->wwid); i > 0 && pp->wwid[i-1] == ' '; i--);
+		/* no-op */
+	pp->wwid[i] = '\0';
+	condlog(4, "%s: Got wwid %s by sgio", pp->dev, wwid);
+
+	if (strncmp(wwid, pp->wwid, WWID_SIZE)) {
+		condlog(0, "%s: wwid '%s' doesn't match wwid '%s' from device",
+			pp->dev, pp->wwid, wwid);
+		return true;
+	}
+
+	return false;
+}
+
 static int
 uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
@@ -1296,6 +1363,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			condlog(0, "%s: path wwid changed from '%s' to '%s'",
 				uev->kernel, wwid, pp->wwid);
 			ev_remove_path(pp, vecs, 1);
+			rescan_path(uev->udev);
 			needs_reinit = 1;
 			goto out;
 		} else {
@@ -2197,6 +2265,16 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		return 0;
 	set_no_path_retry(pp->mpp);
 
+	if (pp->recheck_wwid == RECHECK_WWID_ON &&
+	    (newstate == PATH_UP || newstate == PATH_GHOST) &&
+	    ((pp->state != PATH_UP && pp->state != PATH_GHOST) ||
+	     pp->dmstate == PSTATE_FAILED) &&
+	    check_path_wwid_change(pp)) {
+		condlog(0, "%s: path wwid change detected. Removing", pp->dev);
+		handle_path_wwid_change(pp, vecs);
+		return 0;
+	}
+
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 	    (san_path_check_enabled(pp->mpp) ||
 	     marginal_path_check_enabled(pp->mpp))) {
diff --git a/multipathd/main.h b/multipathd/main.h
index 5abbe97b..ddd953f9 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -50,4 +50,6 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset);
 int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs,
 			int refresh);
 
+void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
+bool check_path_wwid_change(struct path *pp);
 #endif /* MAIN_H */
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

