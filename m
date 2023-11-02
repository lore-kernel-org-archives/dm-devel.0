Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C8422306
	for <dm-devel@lists.linux.dev>; Thu,  2 Nov 2023 22:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YzKfdBNb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698963311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5klUfv0qZ7Syso87DLDp0l1eHcgKTNuw9FeoBJXq094=;
	b=YzKfdBNbCycUGxVXpfqNYeT+9zEcbgVMp4AFAUht2/QBq4/UxCi6G0t1cq7M+USePsi07Y
	2xysNMoh+Hsbj48RznsFxL2X6wlqHEATDHP+dZytOBco51OKS29N/PDTVrOPU+117fIN7F
	/GF8/ur4Qsy2YyoWrFgB+6YyDbWKa68=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-2HzPPQ7fM0i1HjHjYDD8AQ-1; Thu,
 02 Nov 2023 18:15:09 -0400
X-MC-Unique: 2HzPPQ7fM0i1HjHjYDD8AQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B914D1C113F8;
	Thu,  2 Nov 2023 22:15:08 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1DC725C0;
	Thu,  2 Nov 2023 22:15:08 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A2MF8rb105401
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 2 Nov 2023 18:15:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A2MF8NX105400;
	Thu, 2 Nov 2023 18:15:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 6/7] multipathd: Add auto_resize config option
Date: Thu,  2 Nov 2023 18:15:06 -0400
Message-ID: <20231102221507.105371-7-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-1-bmarzins@redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This option gives multipathd the ability to automatically resize a
device when it detects that all of the path devices have changed. By
default it is set to never, and multipathd will continue to work like it
always has, where a users must manually resize a multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c         |  2 ++
 libmultipath/config.h         |  3 +++
 libmultipath/configure.c      |  1 +
 libmultipath/defaults.h       |  1 +
 libmultipath/dict.c           | 48 +++++++++++++++++++++++++++++++++++
 libmultipath/dict.h           |  1 +
 libmultipath/hwtable.c        |  1 +
 libmultipath/propsel.c        | 17 +++++++++++++
 libmultipath/propsel.h        |  1 +
 libmultipath/structs.h        |  8 ++++++
 multipath/multipath.conf.5.in | 16 ++++++++++++
 multipathd/main.c             | 24 +++++++++++++++++-
 12 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 9d90f512..e6024955 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -464,6 +464,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(ghost_delay);
 	merge_num(all_tg_pt);
 	merge_num(recheck_wwid);
+	merge_num(auto_resize);
 	merge_num(vpd_vendor_id);
 	merge_num(san_path_err_threshold);
 	merge_num(san_path_err_forget_rate);
@@ -519,6 +520,7 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 	merge_num(skip_kpartx);
 	merge_num(max_sectors_kb);
 	merge_num(ghost_delay);
+	merge_num(auto_resize);
 	merge_num(uid);
 	merge_num(gid);
 	merge_num(mode);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 197a567f..3be8e507 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -96,6 +96,7 @@ struct hwentry {
 	int all_tg_pt;
 	int vpd_vendor_id;
 	int recheck_wwid;
+	int auto_resize;
 	char * bl_product;
 
 	vector pctable;
@@ -135,6 +136,7 @@ struct mpentry {
 	int skip_kpartx;
 	int max_sectors_kb;
 	int ghost_delay;
+	int auto_resize;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
@@ -204,6 +206,7 @@ struct config {
 	int skip_delegate;
 	unsigned int sequence_nr;
 	int recheck_wwid;
+	int auto_resize;
 
 	char * selector;
 	struct _vector uid_attrs;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d8094903..592761b2 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -355,6 +355,7 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	select_max_sectors_kb(conf, mpp);
 	select_ghost_delay(conf, mpp);
 	select_flush_on_last_del(conf, mpp);
+	select_auto_resize(conf, mpp);
 
 	sysfs_set_scsi_tmo(conf, mpp);
 	marginal_pathgroups = conf->marginal_pathgroups;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index d01f9712..64b633f2 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -56,6 +56,7 @@
 #define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
 #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
 #define DEFAULT_RECHECK_WWID RECHECK_WWID_OFF
+#define DEFAULT_AUTO_RESIZE AUTO_RESIZE_NEVER
 /* Enable no foreign libraries by default */
 #define DEFAULT_ENABLE_FOREIGN "NONE"
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index fc438947..037d717c 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1670,6 +1670,50 @@ declare_hw_snprint(recheck_wwid, print_yes_no_undef)
 
 declare_def_range_handler(uxsock_timeout, DEFAULT_REPLY_TIMEOUT, INT_MAX)
 
+static int
+set_auto_resize(vector strvec, void *ptr, const char *file, int line_nr)
+{
+	char * buff;
+	int *int_ptr = (int *)ptr;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (strcmp(buff, "never") == 0)
+		*int_ptr = AUTO_RESIZE_NEVER;
+	else if (strcmp(buff, "grow_only") == 0)
+		*int_ptr = AUTO_RESIZE_GROW_ONLY;
+	else if (strcmp(buff, "grow_shrink") == 0)
+		*int_ptr = AUTO_RESIZE_GROW_SHRINK;
+	else
+		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);
+
+	free(buff);
+	return 0;
+}
+
+int
+print_auto_resize(struct strbuf *buff, long v)
+{
+	if (!v)
+		return 0;
+	return append_strbuf_quoted(buff,
+			v == AUTO_RESIZE_GROW_ONLY ? "grow_only" :
+			v == AUTO_RESIZE_GROW_SHRINK ? "grow_shrink" :
+			"never");
+}
+
+declare_def_handler(auto_resize, set_auto_resize)
+declare_def_snprint(auto_resize, print_auto_resize)
+declare_ovr_handler(auto_resize, set_auto_resize)
+declare_ovr_snprint(auto_resize, print_auto_resize)
+declare_hw_handler(auto_resize, set_auto_resize)
+declare_hw_snprint(auto_resize, print_auto_resize)
+declare_mp_handler(auto_resize, set_auto_resize)
+declare_mp_snprint(auto_resize, print_auto_resize)
+
 static int
 hw_vpd_vendor_handler(struct config *conf, vector strvec, const char *file,
 		      int line_nr)
@@ -2146,6 +2190,7 @@ init_keywords(vector keywords)
 	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
 	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
 	install_keyword("ghost_delay", &def_ghost_delay_handler, &snprint_def_ghost_delay);
+	install_keyword("auto_resize", &def_auto_resize_handler, &snprint_def_auto_resize);
 	install_keyword("find_multipaths_timeout",
 			&def_find_multipaths_timeout_handler,
 			&snprint_def_find_multipaths_timeout);
@@ -2227,6 +2272,7 @@ init_keywords(vector keywords)
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
 	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
 	install_keyword("ghost_delay", &hw_ghost_delay_handler, &snprint_hw_ghost_delay);
+	install_keyword("auto_resize", &hw_auto_resize_handler, &snprint_hw_auto_resize);
 	install_keyword("all_tg_pt", &hw_all_tg_pt_handler, &snprint_hw_all_tg_pt);
 	install_keyword("vpd_vendor", &hw_vpd_vendor_handler, &snprint_hw_vpd_vendor);
 	install_keyword("recheck_wwid", &hw_recheck_wwid_handler, &snprint_hw_recheck_wwid);
@@ -2273,6 +2319,7 @@ init_keywords(vector keywords)
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
 	install_keyword("ghost_delay", &ovr_ghost_delay_handler, &snprint_ovr_ghost_delay);
+	install_keyword("auto_resize", &ovr_auto_resize_handler, &snprint_ovr_auto_resize);
 	install_keyword("all_tg_pt", &ovr_all_tg_pt_handler, &snprint_ovr_all_tg_pt);
 	install_keyword("recheck_wwid", &ovr_recheck_wwid_handler, &snprint_ovr_recheck_wwid);
 	install_keyword_multi("protocol", &protocol_handler, NULL);
@@ -2319,5 +2366,6 @@ init_keywords(vector keywords)
 	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
 	install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
 	install_keyword("ghost_delay", &mp_ghost_delay_handler, &snprint_mp_ghost_delay);
+	install_keyword("auto_resize", &mp_auto_resize_handler, &snprint_mp_auto_resize);
 	install_sublevel_end();
 }
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 15d9cbac..7e2dfbe0 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -17,4 +17,5 @@ int print_no_path_retry(struct strbuf *buff, long v);
 int print_undef_off_zero(struct strbuf *buff, long v);
 int print_dev_loss(struct strbuf *buff, unsigned long v);
 int print_off_int_undef(struct strbuf *buff, long v);
+int print_auto_resize(struct strbuf *buff, long v);
 #endif /* _DICT_H */
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ae6aac79..27a8c9b4 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -75,6 +75,7 @@
 		.skip_kpartx   = SKIP_KPARTX_OFF,
 		.max_sectors_kb = MAX_SECTORS_KB_UNDEF,
 		.ghost_delay   = GHOST_DELAY_OFF,
+		.auto_resize   = AUTO_RESIZE_NEVER,
 	},
 #endif
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 15abb9e5..2489c00c 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -1423,6 +1423,23 @@ out:
 	return 0;
 }
 
+int select_auto_resize (struct config *conf, struct multipath * mp)
+{
+	const char *origin;
+	STRBUF_ON_STACK(buff);
+
+	mp_set_mpe(auto_resize);
+	mp_set_ovr(auto_resize);
+	mp_set_hwe(auto_resize);
+	mp_set_conf(auto_resize);
+	mp_set_default(auto_resize, DEFAULT_AUTO_RESIZE);
+out:
+	if (print_auto_resize(&buff, mp->auto_resize) != 0)
+		condlog(3, "%s: auto_resize = %s %s", mp->alias,
+			get_strbuf_str(&buff), origin);
+	return 0;
+}
+
 int select_find_multipaths_timeout(struct config *conf, struct path *pp)
 {
 	const char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 7203509e..e6941190 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -38,6 +38,7 @@ int select_marginal_path_err_rate_threshold(struct config *conf, struct multipat
 int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multipath *mp);
 int select_marginal_path_double_failed_time(struct config *conf, struct multipath *mp);
 int select_ghost_delay(struct config *conf, struct multipath * mp);
+int select_auto_resize(struct config *conf, struct multipath * mp);
 void reconcile_features_with_options(const char *id, char **features,
 				     int* no_path_retry,
 				     int *retain_hwhandler);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c20e99ce..b75e7778 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -179,6 +179,13 @@ enum queue_mode_states {
 	QUEUE_MODE_RQ,
 };
 
+enum auto_resize_state {
+	AUTO_RESIZE_UNDEF = 0,
+	AUTO_RESIZE_NEVER,
+	AUTO_RESIZE_GROW_ONLY,
+	AUTO_RESIZE_GROW_SHRINK,
+};
+
 #define PROTOCOL_UNSET -1
 
 enum scsi_protocol {
@@ -447,6 +454,7 @@ struct multipath {
 	int ghost_delay;
 	int ghost_delay_tick;
 	int queue_mode;
+	int auto_resize;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 41f3927e..c90383cf 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1333,6 +1333,22 @@ The default is: \fBno\fR
 .
 .
 .TP
+.B auto_resize
+Controls when multipathd will automatically resize a multipath device.  If set
+to \fInever\fR, multipath devices must always be manually resized by either
+running \fBmultipathd resize map <name>\fR or \fRmultipath -r <name>\fR.  If
+set to \fIgrow_only\fR, when multipathd detects that all of a multipath
+device's paths have increased in size, it will automatically grow the multipath
+device to the new size. If set to \fIgrow_shrink\fR, multipathd will also
+automatically shrink the device once it detects all of its paths have decreased
+in size.
+.RS
+.TP
+The default is: \fBnever\fR
+.RE
+.
+.
+.TP
 .B enable_foreign
 Enables or disables foreign libraries (see section
 .I FOREIGN MULTIPATH SUPPORT
diff --git a/multipathd/main.c b/multipathd/main.c
index 3b4c5b09..ac733491 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1633,7 +1633,6 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		ro = uevent_get_disk_ro(uev);
 		if (needs_ro_update(mpp, ro)) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
-
 			if (mpp->wait_for_udev)
 				mpp->wait_for_udev = 2;
 			else {
@@ -1648,6 +1647,29 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				}
 			}
 		}
+		if (mpp->auto_resize != AUTO_RESIZE_NEVER &&
+		    !mpp->wait_for_udev) {
+			struct pathgroup *pgp;
+			struct path *pp2;
+			unsigned int i, j;
+			unsigned long long orig_size = mpp->size;
+
+			if (!pp->size || pp->size == mpp->size ||
+                            (pp->size < mpp->size &&
+			     mpp->auto_resize == AUTO_RESIZE_GROW_ONLY))
+				goto out;
+
+			vector_foreach_slot(mpp->pg, pgp, i)
+				vector_foreach_slot (pgp->paths, pp2, j)
+					if (pp2->size && pp2->size != pp->size)
+						goto out;
+			retval = resize_map(mpp, pp->size, vecs);
+			if (retval == 2)
+				condlog(2, "%s: map removed during resize", pp->dev);
+			else if (retval == 0)
+				condlog(2, "%s: resized map from %llu to %llu",
+					mpp->alias, orig_size, pp->size);
+		}
 	}
 out:
 	lock_cleanup_pop(vecs->lock);
-- 
2.41.0

