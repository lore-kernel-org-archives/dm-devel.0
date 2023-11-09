Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682D538FB0
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 23:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FvONjeJ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699573580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2auLjbq6kkDadlUtvj4zT950ncLwQNKwKOOfxs9/FM=;
	b=FvONjeJ0lm973x7P75tnisrQTNw52EtW+nwLAF1vqKPDA5JGWP7jzMTTHb4c3ebovBoEko
	cW5J7BlkqmWOr/guyizROESvOptk/EF5E/lWW2sIyudA4YSp6Z6GkKrVnJfklcjOdg+ksC
	k3J3OLX+gjPmU2zqMk2yPCZh8oWB6S4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-yr9IMp7WN_C05FEN0LALOQ-1; Thu,
 09 Nov 2023 18:46:18 -0500
X-MC-Unique: yr9IMp7WN_C05FEN0LALOQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 438FA280666A;
	Thu,  9 Nov 2023 23:46:18 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B72E25C1;
	Thu,  9 Nov 2023 23:46:18 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A9NkIvQ100155
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Nov 2023 18:46:18 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A9NkI2w100154;
	Thu, 9 Nov 2023 18:46:18 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 6/6] multipathd: Add auto_resize config option
Date: Thu,  9 Nov 2023 18:46:16 -0500
Message-ID: <20231109234616.100125-7-bmarzins@redhat.com>
In-Reply-To: <20231109234616.100125-1-bmarzins@redhat.com>
References: <20231109234616.100125-1-bmarzins@redhat.com>
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
 libmultipath/config.h         |  1 +
 libmultipath/defaults.h       |  1 +
 libmultipath/dict.c           | 38 +++++++++++++++++++++++++++++++++++
 libmultipath/dict.h           |  1 +
 libmultipath/structs.h        |  7 +++++++
 multipath/multipath.conf.5.in | 15 ++++++++++++++
 multipathd/main.c             | 28 ++++++++++++++++++++++++++
 7 files changed, 91 insertions(+)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 417e5834..384193ab 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -202,6 +202,7 @@ struct config {
 	int skip_delegate;
 	unsigned int sequence_nr;
 	int recheck_wwid;
+	int auto_resize;
 
 	char * selector;
 	struct _vector uid_attrs;
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
index e268673f..0a160e92 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1664,6 +1664,43 @@ declare_hw_snprint(recheck_wwid, print_yes_no_undef)
 
 declare_def_range_handler(uxsock_timeout, DEFAULT_REPLY_TIMEOUT, INT_MAX)
 
+static int
+def_auto_resize_handler(struct config *conf, vector strvec, const char *file,
+			int line_nr)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (strcmp(buff, "never") == 0)
+		conf->auto_resize = AUTO_RESIZE_NEVER;
+	else if (strcmp(buff, "grow_only") == 0)
+		conf->auto_resize = AUTO_RESIZE_GROW_ONLY;
+	else if (strcmp(buff, "grow_shrink") == 0)
+		conf->auto_resize = AUTO_RESIZE_GROW_SHRINK;
+	else
+		condlog(1, "%s line %d, invalid value for auto_resize: \"%s\"",
+			file, line_nr, buff);
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
+declare_def_snprint(auto_resize, print_auto_resize)
+
 static int
 hw_vpd_vendor_handler(struct config *conf, vector strvec, const char *file,
 		      int line_nr)
@@ -2140,6 +2177,7 @@ init_keywords(vector keywords)
 	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
 	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
 	install_keyword("ghost_delay", &def_ghost_delay_handler, &snprint_def_ghost_delay);
+	install_keyword("auto_resize", &def_auto_resize_handler, &snprint_def_auto_resize);
 	install_keyword("find_multipaths_timeout",
 			&def_find_multipaths_timeout_handler,
 			&snprint_def_find_multipaths_timeout);
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
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 63551b80..a1aac1b4 100644
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
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 014d6dd1..eddef0f7 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1331,6 +1331,21 @@ The default is: \fBno\fR
 .
 .
 .TP
+.B auto_resize
+Controls when multipathd will automatically resize a multipath device.  If set
+to \fInever\fR, multipath devices must always be manually resized by either
+running \fBmultipathd resize map <name>\fR.  If set to \fIgrow_only\fR, when
+multipathd detects that all of a multipath device's paths have increased in
+size, it will automatically grow the multipath device to the new size. If set
+to \fIgrow_shrink\fR, multipathd will also automatically shrink the device
+once it detects all of its paths have decreased in size.
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
index 3b4c5b09..230c9d10 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1590,6 +1590,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	if (pp) {
 		struct multipath *mpp = pp->mpp;
 		char wwid[WWID_SIZE];
+		int auto_resize;
+
+		conf = get_multipath_config();
+		auto_resize = conf->auto_resize;
+		put_multipath_config(conf);
 
 		if (pp->initialized == INIT_REQUESTED_UDEV) {
 			needs_reinit = 1;
@@ -1648,6 +1653,29 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				}
 			}
 		}
+		if (auto_resize != AUTO_RESIZE_NEVER &&
+		    !mpp->wait_for_udev) {
+			struct pathgroup *pgp;
+			struct path *pp2;
+			unsigned int i, j;
+			unsigned long long orig_size = mpp->size;
+
+			if (!pp->size || pp->size == mpp->size ||
+			    (pp->size < mpp->size &&
+			     auto_resize == AUTO_RESIZE_GROW_ONLY))
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

