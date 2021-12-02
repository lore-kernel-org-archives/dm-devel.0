Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C2E0C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:10:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-3zoQ17NTNpC68SRNEkrIzA-1; Thu, 02 Dec 2021 11:10:46 -0500
X-MC-Unique: 3zoQ17NTNpC68SRNEkrIzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D4C010144E3;
	Thu,  2 Dec 2021 16:10:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 144CD10016F5;
	Thu,  2 Dec 2021 16:10:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C3FD84A708;
	Thu,  2 Dec 2021 16:10:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7aBa006837 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 671AE492C3B; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63403492C38
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B1F7185A7B2
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-187-GeumzkesMZ6dtrVG3pLfVg-1; Thu, 02 Dec 2021 11:07:34 -0500
X-MC-Unique: GeumzkesMZ6dtrVG3pLfVg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 12FA91FDFB;
	Thu,  2 Dec 2021 16:07:33 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CCBE913E82;
	Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id iI/vL0TvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:32 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:52 +0100
Message-Id: <20211202160652.4576-13-mwilck@suse.com>
In-Reply-To: <20211202160652.4576-1-mwilck@suse.com>
References: <20211202160652.4576-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7aBa006837
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 11/11] libmultipath.version: sort symbols
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

Give up the habit of indicating in which library version the
symbols were added, which has no real benefit. The only "sections"
that are kept are those listing symbols that are only used by
dlopen'd .so files.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 81 +++++++++++--------------------
 1 file changed, 28 insertions(+), 53 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 7f845ed..9c7ffa7 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,8 +43,10 @@ global:
 	alloc_path_layout;
 	alloc_path_with_pathinfo;
 	alloc_strvec;
+	append_strbuf_str;
 	change_foreign;
 	check_alias_settings;
+	check_daemon;
 	checker_clear_message;
 	checker_disable;
 	checker_enable;
@@ -52,7 +54,9 @@ global:
 	checker_name;
 	checker_state_name;
 	check_foreign;
+	cleanup_charp;
 	cleanup_lock;
+	cleanup_ucharp;
 	close_fd;
 	coalesce_paths;
 	convert_dev;
@@ -75,6 +79,7 @@ global:
 	dm_is_mpath;
 	dm_mapname;
 	dm_map_present;
+	dm_prereq;
 	dm_queue_if_no_path;
 	dm_reassign;
 	dm_reinstate_path;
@@ -103,16 +108,21 @@ global:
 	free_pathvec;
 	free_strvec;
 	get_monotonic_time;
+	get_multipath_config;
 	get_multipath_layout;
 	get_path_layout;
 	get_pgpolicy_id;
 	get_refwwid;
 	get_state;
+	get_strbuf_len;
+	get_strbuf_str;
 	get_udev_device;
 	get_uid;
 	get_used_hwes;
+	get_vpd_sgio;
 	group_by_prio;
 	init_checkers;
+	init_config;
 	init_foreign;
 	init_prio;
 	io_err_stat_handle_pathfail;
@@ -120,11 +130,18 @@ global:
 	is_quote;
 	libmp_dm_task_create;
 	libmp_get_version;
+	libmp_get_multipath_config;
+	libmp_dm_task_run;
+	libmp_put_multipath_config;
 	libmp_udev_set_sync_support;
+	libmp_verbosity;
+	libmultipath_exit;
+	libmultipath_init;
 	load_config;
 	log_thread_reset;
 	log_thread_start;
 	log_thread_stop;
+	logsink;
 	need_io_err_check;
 	normalize_timespec;
 	orphan_path;
@@ -137,7 +154,9 @@ global:
 	print_all_paths;
 	print_foreign_topology;
 	_print_multipath_topology;
+	print_strbuf;
 	pthread_cond_init_mono;
+	put_multipath_config;
 	recv_packet;
 	reinstate_paths;
 	remember_wwid;
@@ -147,6 +166,7 @@ global:
 	remove_wwid;
 	replace_wwids;
 	reset_checker_classes;
+	reset_strbuf;
 	select_all_tg_pt;
 	select_action;
 	select_find_multipaths_timeout;
@@ -161,7 +181,9 @@ global:
 	setup_map;
 	setup_thread_attr;
 	should_multipath;
+	skip_libmp_dm_init;
 	snprint_blacklist_report;
+	__snprint_config;
 	snprint_config;
 	snprint_devices;
 	snprint_foreign_multipaths;
@@ -185,13 +207,17 @@ global:
 	sysfs_attr_set_value;
 	sysfs_get_size;
 	sysfs_is_multipathed;
+	timespeccmp;
 	timespecsub;
 	trigger_paths_udev_change;
+	truncate_strbuf;
+	udev;
 	uevent_dispatch;
 	uevent_get_dm_str;
 	uevent_get_env_positive_int;
 	uevent_is_mpath;
 	uevent_listen;
+	uninit_config;
 	update_mpp_paths;
 	update_multipath_strings;
 	update_multipath_table;
@@ -213,6 +239,7 @@ global:
 	start_checker_thread;
 
 	/* prioritizers */
+	fill_strbuf;
 	get_asymmetric_access_state;
 	get_next_string;
 	get_prio_timeout;
@@ -223,6 +250,7 @@ global:
 	libmp_nvme_identify_ns;
 	log_nvme_errcode;
 	nvme_id_ctrl_ana;
+	set_wakeup_fn;
 	snprint_host_wwnn;
 	snprint_host_wwpn;
 	snprint_path_serial;
@@ -234,59 +262,6 @@ global:
 	free_scandir_result;
 	sysfs_attr_get_value;
 
-	/* added in 2.1.0 */
-	libmp_dm_task_run;
-
-	/* added in 2.2.0 */
-	libmp_get_multipath_config;
-	get_multipath_config;
-	libmp_put_multipath_config;
-	put_multipath_config;
-	init_config;
-	uninit_config;
-
-	/* added in 2.3.0 */
-	udev;
-	logsink;
-	libmultipath_init;
-	libmultipath_exit;
-
-	/* added in 4.1.0 */
-	libmp_verbosity;
-
-	/* added in 4.2.0 */
-	dm_prereq;
-	skip_libmp_dm_init;
-
-	/* added in 4.4.0 */
-
-	/* added in 4.5.0 */
-	get_vpd_sgio;
-
-	/* added in 7.0.0 */
-	cleanup_charp;
-	cleanup_ucharp;
-
-	/* added in 8.1.0 */
-	reset_strbuf;
-	append_strbuf_str;
-	get_strbuf_len;
-	get_strbuf_str;
-	fill_strbuf;
-	print_strbuf;
-	truncate_strbuf;
-
-	/* added in 8.2.0 */
-	check_daemon;
-
-	/* added in 9.1.0 */
-	timespeccmp;
-
-	/* added in 10.0.0 */
-	set_wakeup_fn;
-
-	/* added in 10.1.0 */
-	__snprint_config;
 local:
 	*;
 };
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

