Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A882E405
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 01:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709171897; cv=none; b=QFbdgZWpZcw41AnN+HHCjstVf9JhiuE66gmehVz0sKotjOQZLjY5qhUwDfDJlpke5TSrP5ANnhZGB9sEpI0be+Xq3vQt2IXOzB97w/zVwEGnpASkyY1IzOCLeABIKTvYaN0nC7GNEVzuiC2OTZOvmXECMnxv2/USR0tvMxdoMSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709171897; c=relaxed/simple;
	bh=BWvAoE12kLJCv0Sv1cKtJoh71tHxBu15t0iTp0UibAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6qsD6dK3X98rgiGchnP3D8bYZHDX6RlVtym+QiZnPeSdkjGHoG2k8ZSwEcMlzb89JqkKZBFbntEo/lV3W7Sm+xVOQ4bgIUsWKOZgcplR2d0zluh6AumEQl9XEzmG9uZztgkf0tXywZkc+Sgn0aySQpvp0iA/7e92zsoDlNYP9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UmGn/w41; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UmGn/w41"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709171893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wcBruiI/NeFek+883tzJCfBHVIpByvV+0nZlEDig9Yc=;
	b=UmGn/w41xtFSuI65vLenKIZ+qg0BecPVdyA2dF/T4HlKQ323Pqg5yF6ZBREn0anSPVmJRX
	x708PCguqJUh0Ix7agHmA9zur2RAZYBpg5Us9+u9J4tqtZK/hfweeO7Ub5MsJ+QXWH621B
	Lq+/ndA/tLPWVBeubOyP4v27BXewB48=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-QrdpCPGZNiqu44BkRWAdkQ-1; Wed, 28 Feb 2024 20:58:11 -0500
X-MC-Unique: QrdpCPGZNiqu44BkRWAdkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED1C986D4D0;
	Thu, 29 Feb 2024 01:58:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E55652166B33;
	Thu, 29 Feb 2024 01:58:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41T1wAdd686437
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Feb 2024 20:58:10 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41T1wAot686436;
	Wed, 28 Feb 2024 20:58:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        sushmbha <sushmita.bhattacharya@oracle.com>
Subject: [PATCH 2/2] multipathd: Add sched_prio defaults section option
Date: Wed, 28 Feb 2024 20:58:09 -0500
Message-ID: <20240229015809.686418-3-bmarzins@redhat.com>
In-Reply-To: <20240229015809.686418-1-bmarzins@redhat.com>
References: <20240229015809.686418-1-bmarzins@redhat.com>
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

Currently multipathd always tries to run as a realtime process with a
priority of 99. This is excessive. As a first step towards fixing this,
make it possible to lower the priority keep multipathd from making
itself a realtime process.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c         |  1 +
 libmultipath/config.h         |  1 +
 libmultipath/defaults.h       |  1 +
 libmultipath/dict.c           | 23 +++++++++++++++++++++++
 multipath/multipath.conf.5.in | 13 +++++++++++++
 multipathd/main.c             |  9 +++++----
 6 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 83fa7369..636200e2 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -932,6 +932,7 @@ int _init_config (const char *file, struct config *conf)
 	conf->ghost_delay = DEFAULT_GHOST_DELAY;
 	conf->all_tg_pt = DEFAULT_ALL_TG_PT;
 	conf->recheck_wwid = DEFAULT_RECHECK_WWID;
+	conf->sched_prio = DEFAULT_SCHED_PRIO;
 	/*
 	 * preload default hwtable
 	 */
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 384193ab..2e604557 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -203,6 +203,7 @@ struct config {
 	unsigned int sequence_nr;
 	int recheck_wwid;
 	int auto_resize;
+	int sched_prio;
 
 	char * selector;
 	struct _vector uid_attrs;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 64b633f2..bd7a09a3 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -59,6 +59,7 @@
 #define DEFAULT_AUTO_RESIZE AUTO_RESIZE_NEVER
 /* Enable no foreign libraries by default */
 #define DEFAULT_ENABLE_FOREIGN "NONE"
+#define DEFAULT_SCHED_PRIO 99
 
 #define CHECKINT_UNDEF		UINT_MAX
 #define DEFAULT_CHECKINT	5
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 5af036b7..11df9540 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1699,6 +1699,28 @@ print_auto_resize(struct strbuf *buff, long v)
 
 declare_def_snprint(auto_resize, print_auto_resize)
 
+static int
+def_sched_prio_handler(struct config *conf, vector strvec, const char *file,
+		      int line_nr)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (strcmp(buff, "undef") == 0)
+		conf->sched_prio = 0;
+	else
+		do_set_int(strvec, &conf->sched_prio, 1, 99, file, line_nr,
+			   buff);
+
+	free(buff);
+	return 0;
+}
+
+declare_def_snprint(sched_prio, print_nonzero)
+
 static int
 hw_vpd_vendor_handler(struct config *conf, vector strvec, const char *file,
 		      int line_nr)
@@ -2176,6 +2198,7 @@ init_keywords(vector keywords)
 	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
 	install_keyword("ghost_delay", &def_ghost_delay_handler, &snprint_def_ghost_delay);
 	install_keyword("auto_resize", &def_auto_resize_handler, &snprint_def_auto_resize);
+	install_keyword("sched_prio", &def_sched_prio_handler, &snprint_def_sched_prio);
 	install_keyword("find_multipaths_timeout",
 			&def_find_multipaths_timeout_handler,
 			&snprint_def_find_multipaths_timeout);
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index c788c180..9c4b4b45 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1375,6 +1375,19 @@ The default is: \fBno\fR
 .RE
 .
 .
+.TP
+.B sched_prio
+Sets the real-time scheduling priority for multipathd. If set to \fIundef\fR,
+multipathd will not attempt to change the scheduling policy or priority it
+was started with. If set from \fI1\fR to \fI99\fR, multipathd will set its
+scheduling policy to the SCHED_RR real-time round robin policy and set is
+priority to the specified value.
+.RS
+.TP
+The default is: \fB99\fR
+.RE
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist and blacklist_exceptions sections"
 .\" ----------------------------------------------------------------------------
diff --git a/multipathd/main.c b/multipathd/main.c
index 85ac540f..ab1e6dc3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3168,11 +3168,11 @@ signal_init(void)
 }
 
 static void
-setscheduler (void)
+setscheduler (int sched_prio)
 {
 	int res;
-	static struct sched_param sched_param = {
-		.sched_priority = 99
+	struct sched_param sched_param = {
+		.sched_priority = sched_prio
 	};
 
 	res = sched_setscheduler (0, SCHED_RR, &sched_param);
@@ -3471,7 +3471,8 @@ child (__attribute__((unused)) void *param)
 	if (!vecs)
 		goto failed;
 
-	setscheduler();
+	if (conf->sched_prio)
+		setscheduler(conf->sched_prio);
 	set_oom_adj();
 #ifdef FPIN_EVENT_HANDLER
 	if (conf->marginal_pathgroups == MARGINAL_PATHGROUP_FPIN)
-- 
2.43.0

