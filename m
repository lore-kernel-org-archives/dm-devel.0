Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06542143C47
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 22:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713911144; cv=none; b=VJUz/ZKtriOWe6Dwh09mV6IbWHSKmAOJ/A3GaVK81rxrmAUDfqSyODTxRWJRRUhxj32BSOXe65Z6/nmP+P8tS/TiW3XagTKi/S9bGW9a11Wzd9C3mWCigBwC8FbsvqTOycpWBM12xZaMdsd6BDaw2IBWc3XEOJJLNgOoptuEcNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713911144; c=relaxed/simple;
	bh=V5BC7EAQDTOm56BNN2h8Hp/z4WdcIj9BTWYOFeL9HAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nFvAHNL7EHn4UYiKaNhQdPTGeQjEWXiuKqwKKG1NJUg4yEoPEzBtNcrzw8P8rDtX7e6wMq0vzUJfD4T9Mlsg44gW2pa3V8nTUKH12dMVN47KICKrJ60r5FHmahpcXJpu3/EeWrj+m1u7VBEJBPjQbksDJJyTpjyoDaD4CCMdD5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KW1sYsE0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KW1sYsE0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713911140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EU4dDwotVabrkKriXUverhslh7dNTNXNzxv51B2vhrg=;
	b=KW1sYsE0/PZOtVFmqdGqyXn/+jiS4Ji5dCsr0pLVe/Vy2T8kbzh2cGr6R0bI+1hT+xg0ac
	biwgXxxqBqjZrYONSB0Z+fBQ82VAsXbWRVx9VmDSwkiHTB2zuljZi24SUxPnCAarVqi0KQ
	pLjw3ByNv/Kioy5S4kLvw8fX3mmFIUI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-4CH7lZP7NTyLjijCpU35Pw-1; Tue, 23 Apr 2024 18:25:37 -0400
X-MC-Unique: 4CH7lZP7NTyLjijCpU35Pw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2663180D730;
	Tue, 23 Apr 2024 22:25:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FAE82166B31;
	Tue, 23 Apr 2024 22:25:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43NMParR2096506
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 18:25:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43NMPaY22096505;
	Tue, 23 Apr 2024 18:25:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/3] libmultipath: change flush_on_last_del to fix a multipathd hang
Date: Tue, 23 Apr 2024 18:25:35 -0400
Message-ID: <20240423222536.2096486-3-bmarzins@redhat.com>
In-Reply-To: <20240423222536.2096486-1-bmarzins@redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Commit 9bd3482e ("multipathd: make flush_map() delete maps like the
multipath command") Fixed an issue where deleting a queueing multipath
device through multipathd could hang because the multipath device had
outstanding IO, even thought the only openers of it at the time of
deletion were the kpartx partition devices. However it is still possible
to hang multipathd, because autoremoving the device when all paths have
been deleted doesn't disable queueing. To reproduce this hang:

1. create a multipath device with a kpartx partition on top of it and
no_path_retry set to either "queue" or something long enough to run all
the commands in the reproduce before it expires.
2. disable all the paths to the device with something like
3. Write directly to the multipath device with something like
4. delete all the paths to the device with something like

Multipathd will be hung trying to delete the kpartx device because, as
the last opener, it must flush the multipath device before closing it.
Because it hangs holding the vecs_lock, multipathd will never disable
queueing on the device, so it will hang forever, even if no_path_retry
is set to a number.

Mulitpath can currently be configured to avoid this hang by setting

flush_on_last_del yes

However there are good reasons why users wouldn't want to set that. They
may need to be able to survive having all paths temporarily get deleted.
I should note that this is a pretty rare corner case, since multipath
automatically sets dev_loss_tmo so that it should not trigger before
queueing is disabled.

This commit avoids the hang by changing the possible values for
flush_on_last_del to "never", "unused", and "always", and sets the
default to "unused".  "always" works like "yes" did, "never" will not
disable queueing, and "unused" will only disable queueing if nothing has
the kpartx devices or the multipath device open. In order to be safe, if
the device has queue_if_no_paths set, and the remove is not a deferred
one (and in case of "unused", the device is in-use) the autoremove will
be skipped. Also, instead of just trusting the lack of
"queue_if_no_paths" in the current mpp->features, multipathd will tell
the kernel to disable queueing, just to be sure it actually is.

I chose "unused" as the default because this should generally only cause
multipathd to work differently from the users perspective when nothing
has the multipath device open but it is queueing and there is
outstanding IO. Without this change, it would have hung instead of
failing the outstanding IO. However, I do understand that an argument
could be made that "never" makes more sense as default, even though it
will cause multipathd to skip autoremoves in cases where it wouldn't
before.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h       |  2 +-
 libmultipath/dict.c           | 72 +++++++++++++++++++++++++++++++----
 libmultipath/dict.h           |  1 +
 libmultipath/hwtable.c        |  6 +--
 libmultipath/propsel.c        |  4 +-
 libmultipath/structs.h        |  7 ++--
 multipath/multipath.conf.5.in | 20 +++++++---
 multipathd/main.c             | 42 +++++++++++++++++---
 8 files changed, 127 insertions(+), 27 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 64b633f2..ed08c251 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -43,7 +43,7 @@
 #define DEFAULT_PRIO		PRIO_CONST
 #define DEFAULT_PRIO_ARGS	""
 #define DEFAULT_CHECKER		TUR
-#define DEFAULT_FLUSH		FLUSH_DISABLED
+#define DEFAULT_FLUSH		FLUSH_UNUSED
 #define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
 #define DEFAULT_FORCE_SYNC	0
 #define UNSET_PARTITION_DELIM "/UNSET/"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 5af036b7..546103f2 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -791,14 +791,70 @@ declare_def_snprint(checker_timeout, print_nonzero)
 declare_def_handler(allow_usb_devices, set_yes_no)
 declare_def_snprint(allow_usb_devices, print_yes_no)
 
-declare_def_handler(flush_on_last_del, set_yes_no_undef)
-declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef, DEFAULT_FLUSH)
-declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
-declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)
-declare_hw_handler(flush_on_last_del, set_yes_no_undef)
-declare_hw_snprint(flush_on_last_del, print_yes_no_undef)
-declare_mp_handler(flush_on_last_del, set_yes_no_undef)
-declare_mp_snprint(flush_on_last_del, print_yes_no_undef)
+
+static const char * const flush_on_last_del_optvals[] = {
+	[FLUSH_NEVER] = "never",
+	[FLUSH_ALWAYS] = "always",
+	[FLUSH_UNUSED] = "unused",
+};
+
+static int
+set_flush_on_last_del(vector strvec, void *ptr, const char *file, int line_nr)
+{
+	int i;
+	int *flush_val_ptr = (int *)ptr;
+	char *buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	for (i = FLUSH_NEVER; i <= FLUSH_UNUSED; i++) {
+		if (flush_on_last_del_optvals[i] != NULL &&
+		    !strcmp(buff, flush_on_last_del_optvals[i])) {
+			*flush_val_ptr = i;
+			break;
+		}
+	}
+
+	if (i > FLUSH_UNUSED) {
+		bool deprecated = true;
+		if (strcmp(buff, "no") == 0 || strcmp(buff, "0") == 0)
+			*flush_val_ptr = FLUSH_UNUSED;
+		else if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
+			*flush_val_ptr = FLUSH_ALWAYS;
+		else {
+			deprecated = false;
+			condlog(1, "%s line %d, invalid value for flush_on_last_del: \"%s\"",
+				file, line_nr, buff);
+		}
+		if (deprecated)
+			condlog(2, "%s line %d, \"%s\" is a deprecated value for flush_on_last_del and is treated as \"%s\"",
+				file, line_nr, buff,
+				flush_on_last_del_optvals[*flush_val_ptr]);
+	}
+
+	free(buff);
+	return 0;
+}
+
+int
+print_flush_on_last_del(struct strbuf *buff, long v)
+{
+	if (v == FLUSH_UNDEF)
+		return 0;
+	return append_strbuf_quoted(buff, flush_on_last_del_optvals[(int)v]);
+}
+
+declare_def_handler(flush_on_last_del, set_flush_on_last_del)
+declare_def_snprint_defint(flush_on_last_del, print_flush_on_last_del,
+			   DEFAULT_FLUSH)
+declare_ovr_handler(flush_on_last_del, set_flush_on_last_del)
+declare_ovr_snprint(flush_on_last_del, print_flush_on_last_del)
+declare_hw_handler(flush_on_last_del, set_flush_on_last_del)
+declare_hw_snprint(flush_on_last_del, print_flush_on_last_del)
+declare_mp_handler(flush_on_last_del, set_flush_on_last_del)
+declare_mp_snprint(flush_on_last_del, print_flush_on_last_del)
 
 declare_def_handler(user_friendly_names, set_yes_no_undef)
 declare_def_snprint_defint(user_friendly_names, print_yes_no_undef,
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 7e2dfbe0..e1794537 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -18,4 +18,5 @@ int print_undef_off_zero(struct strbuf *buff, long v);
 int print_dev_loss(struct strbuf *buff, unsigned long v);
 int print_off_int_undef(struct strbuf *buff, long v);
 int print_auto_resize(struct strbuf *buff, long v);
+int print_flush_on_last_del(struct strbuf *buff, long v);
 #endif /* _DICT_H */
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 640bf347..ce600030 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -60,7 +60,7 @@
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 1000,
 		.minio_rq      = 1,
-		.flush_on_last_del = FLUSH_DISABLED,
+		.flush_on_last_del = FLUSH_UNUSED,
 		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
 		.fast_io_fail  = 5,
 		.dev_loss      = 600,
@@ -829,7 +829,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.flush_on_last_del = FLUSH_ENABLED,
+		.flush_on_last_del = FLUSH_ALWAYS,
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.prio_name     = PRIO_ONTAP,
 		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
@@ -1160,7 +1160,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_FAIL,
 		.minio         = 1,
 		.minio_rq      = 1,
-		.flush_on_last_del = FLUSH_ENABLED,
+		.flush_on_last_del = FLUSH_ALWAYS,
 		.fast_io_fail  = 15,
 	},
 	/*
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 44241e2a..e2dcb316 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -963,6 +963,7 @@ out:
 int select_flush_on_last_del(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
+	STRBUF_ON_STACK(buff);
 
 	mp_set_mpe(flush_on_last_del);
 	mp_set_ovr(flush_on_last_del);
@@ -970,8 +971,9 @@ int select_flush_on_last_del(struct config *conf, struct multipath *mp)
 	mp_set_conf(flush_on_last_del);
 	mp_set_default(flush_on_last_del, DEFAULT_FLUSH);
 out:
+	print_flush_on_last_del(&buff, mp->flush_on_last_del);
 	condlog(3, "%s: flush_on_last_del = %s %s", mp->alias,
-		(mp->flush_on_last_del == FLUSH_ENABLED)? "yes" : "no", origin);
+		get_strbuf_str(&buff), origin);
 	return 0;
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 734905e2..a32f6d41 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -109,9 +109,10 @@ enum marginal_pathgroups_mode {
 };
 
 enum flush_states {
-	FLUSH_UNDEF = YNU_UNDEF,
-	FLUSH_DISABLED = YNU_NO,
-	FLUSH_ENABLED = YNU_YES,
+	FLUSH_UNDEF,
+	FLUSH_NEVER,
+	FLUSH_ALWAYS,
+	FLUSH_UNUSED,
 };
 
 enum log_checker_err_states {
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index c788c180..1463e1ea 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -707,12 +707,22 @@ The default is: \fBno\fR
 .TP
 .B flush_on_last_del
 If set to
-.I yes
+.I always
 , multipathd will disable queueing when the last path to a device has been
-deleted.
-.RS
-.TP
-The default is: \fBno\fR
+deleted. If set to
+.I never
+, multipathd will not disable queueing when the last path to a device has
+been deleted. Since multipath cannot safely remove a device while queueing
+is enabled, setting this to \fInever\fR means that multipathd will not
+automatically remove an unused multipath device whose paths are all deleted if
+it is currently set to queue_if_no_path. If set to
+.I unused
+, multipathd will only disable queueing when the last path is removed if
+nothing currently has the multipath device or any of the kpartx parition
+devices on top of it open.
+.RS
+.TP
+The default is: \fBunused\fR
 .RE
 .
 .
diff --git a/multipathd/main.c b/multipathd/main.c
index dd17d5c3..20780e7c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -583,13 +583,43 @@ int update_multipath (struct vectors *vecs, char *mapname)
 
 static bool
 flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
-	int r;
-
+	int r, in_use = 1;
+	int deferred_remove = 0;
+	bool is_queueing = true;
+
+	if (mpp->features)
+		is_queueing = strstr(mpp->features, "queue_if_no_path");
+
+	#ifdef LIBDM_API_DEFERRED
+	deferred_remove = mpp->deferred_remove;
+	#endif
+
+	/* It's not safe to do a non-deferred remove of a map that has
+	 * "queue_if_no_path" set, since there could be outstanding IO which
+	 * will cause multipathd to hang while attempting the remove */
+	if (mpp->flush_on_last_del == FLUSH_NEVER &&
+	    !do_deferred(deferred_remove) && is_queueing) {
+		condlog(2, "%s: map is queueing, can't remove", mpp->alias);
+		return false;
+	}
+	if (mpp->flush_on_last_del == FLUSH_UNUSED &&
+	    !do_deferred(deferred_remove) &&
+            (in_use = partmap_in_use(mpp->alias, NULL)) && is_queueing) {
+		condlog(2, "%s: map in use and queueing, can't remove",
+			mpp->alias);
+		return false;
+	}
 	/*
-	 * flush_map will fail if the device is open
+	 * This will flush FLUSH_NEVER devices and FLUSH_UNUSED devices
+	 * that are in use, but only if this is not a deferred remove, and
+	 * they are already marked as not queueing. That is just to make
+	 * absolutely certain that they really are not queueing like they
+	 * claim.
 	 */
-	if (mpp->flush_on_last_del == FLUSH_ENABLED) {
-		condlog(2, "%s Last path deleted, disabling queueing",
+	if (mpp->flush_on_last_del == FLUSH_ALWAYS ||
+	    !do_deferred(deferred_remove) || !in_use) {
+		condlog(is_queueing ? 2 : 3,
+			"%s Last path deleted, disabling queueing",
 			mpp->alias);
 		mpp->retry_tick = 0;
 		mpp->no_path_retry = NO_PATH_RETRY_FAIL;
@@ -597,7 +627,7 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 		mpp->stat_map_failures++;
 		dm_queue_if_no_path(mpp, 0);
 	}
-	r = dm_flush_map_nopaths(mpp->alias, mpp->deferred_remove);
+	r = dm_flush_map_nopaths(mpp->alias, deferred_remove);
 	if (r != DM_FLUSH_OK) {
 		if (r == DM_FLUSH_DEFERRED) {
 			condlog(2, "%s: devmap deferred remove", mpp->alias);
-- 
2.43.0

