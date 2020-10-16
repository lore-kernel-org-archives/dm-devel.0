Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E83C433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E0822084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E0822084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-pqdU_fNbM4GLEpROcWte1Q-1; Fri, 16 Oct 2020 06:44:20 -0400
X-MC-Unique: pqdU_fNbM4GLEpROcWte1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E9286417A;
	Fri, 16 Oct 2020 10:44:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F4BD1002391;
	Fri, 16 Oct 2020 10:44:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 43063181A89E;
	Fri, 16 Oct 2020 10:44:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhtL9020237 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 23356124579; Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D65B16C2DA
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04D1E800969
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-313-jZriI_NdMwCdedq4l1eaKg-1;
	Fri, 16 Oct 2020 06:43:50 -0400
X-MC-Unique: jZriI_NdMwCdedq4l1eaKg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3EF45AF2D;
	Fri, 16 Oct 2020 10:43:48 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:21 +0200
Message-Id: <20201016104329.8337-14-mwilck@suse.com>
In-Reply-To: <20201016104329.8337-1-mwilck@suse.com>
References: <20201016104329.8337-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhtL9020237
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 13/21] libmultipath: provide defaults for {get,
	put}_multipath_config
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Add an implementation of get_multipath_config() and put_multipath_config()
to libmultipath. The linker's symbol lookup rules will make sure that
applications can override these functions if they need to. Defining
these functions in libmultipath avoids the need to provide stubs
for these functions in every appliation linking to libmultipath.

libmultipath's internal functions simply refer to a static "struct config".
It must be initialized with init_config() rather than load_config(),
which always allocates a new struct for backward compatibility, and must
be teared down using uninit_config().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c             | 75 ++++++++++++++++++++++++++-----
 libmultipath/config.h             | 21 +++++++--
 libmultipath/libmultipath.version | 10 +++++
 3 files changed, 93 insertions(+), 13 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 5c91a09..01b77df 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -27,6 +27,26 @@
 #include "mpath_cmd.h"
 #include "propsel.h"
 
+static struct config __internal_config;
+struct config *libmp_get_multipath_config(void)
+{
+	if (!__internal_config.hwtable)
+		/* not initialized */
+		return NULL;
+	return &__internal_config;
+}
+
+struct config *get_multipath_config(void)
+	__attribute__((weak, alias("libmp_get_multipath_config")));
+
+void libmp_put_multipath_config(void *conf __attribute__((unused)))
+{
+	/* empty */
+}
+
+void put_multipath_config(void *conf)
+	__attribute__((weak, alias("libmp_put_multipath_config")));
+
 static int
 hwe_strmatch (const struct hwentry *hwe1, const struct hwentry *hwe2)
 {
@@ -574,17 +594,15 @@ restart:
 	return;
 }
 
-struct config *
-alloc_config (void)
+static struct config *alloc_config (void)
 {
 	return (struct config *)MALLOC(sizeof(struct config));
 }
 
-void
-free_config (struct config * conf)
+static void _uninit_config(struct config *conf)
 {
 	if (!conf)
-		return;
+		conf = &__internal_config;
 
 	if (conf->multipath_dir)
 		FREE(conf->multipath_dir);
@@ -650,7 +668,27 @@ free_config (struct config * conf)
 	free_hwtable(conf->hwtable);
 	free_hwe(conf->overrides);
 	free_keywords(conf->keywords);
-	FREE(conf);
+
+	memset(conf, 0, sizeof(*conf));
+}
+
+void uninit_config(void)
+{
+	_uninit_config(&__internal_config);
+}
+
+void free_config(struct config *conf)
+{
+	if (!conf)
+		return;
+	else if (conf == &__internal_config) {
+		condlog(0, "ERROR: %s called for internal config. Use uninit_config() instead",
+			__func__);
+		return;
+	}
+
+	_uninit_config(conf);
+	free(conf);
 }
 
 /* if multipath fails to process the config directory, it should continue,
@@ -719,12 +757,29 @@ static void set_max_checkint_from_watchdog(struct config *conf)
 }
 #endif
 
+static int _init_config (const char *file, struct config *conf);
+
+int init_config(const char *file)
+{
+	return _init_config(file, &__internal_config);
+}
+
 struct config *load_config(const char *file)
 {
 	struct config *conf = alloc_config();
 
+	if (conf && !_init_config(file, conf))
+		return conf;
+
+	free(conf);
+	return NULL;
+}
+
+int _init_config (const char *file, struct config *conf)
+{
+
 	if (!conf)
-		return NULL;
+		conf = &__internal_config;
 
 	/*
 	 * internal defaults
@@ -896,10 +951,10 @@ struct config *load_config(const char *file)
 	    !conf->wwids_file || !conf->prkeys_file)
 		goto out;
 
-	return conf;
+	return 0;
 out:
-	free_config(conf);
-	return NULL;
+	_uninit_config(conf);
+	return 1;
 }
 
 char *get_uid_attribute_by_attrs(struct config *conf,
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ace403b..0329de2 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -252,10 +252,25 @@ void free_mptable (vector mptable);
 int store_hwe (vector hwtable, struct hwentry *);
 
 struct config *load_config (const char *file);
-struct config * alloc_config (void);
 void free_config (struct config * conf);
-extern struct config *get_multipath_config(void);
-extern void put_multipath_config(void *);
+int init_config(const char *file);
+void uninit_config(void);
+
+/*
+ * libmultipath provides default implementations of
+ * get_multipath_config() and put_multipath_config().
+ * Applications using these should use init_config(file, NULL)
+ * to load the configuration, rather than load_config(file).
+ * Likewise, uninit_config() should be used for teardown, but
+ * using free_config() for that is supported, too.
+ * Applications can define their own {get,put}_multipath_config()
+ * functions, which override the library-internal ones, but
+ * could still call libmp_{get,put}_multipath_config().
+ */
+struct config *libmp_get_multipath_config(void);
+struct config *get_multipath_config(void);
+void libmp_put_multipath_config(void *);
+void put_multipath_config(void *);
 
 int parse_uid_attrs(char *uid_attrs, struct config *conf);
 char *get_uid_attribute_by_attrs(struct config *conf,
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 97acdbb..3e780fc 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -251,3 +251,13 @@ global:
 	libmp_dm_task_run;
 	cleanup_mutex;
 } LIBMULTIPATH_2.0.0;
+
+LIBMULTIPATH_2.2.0 {
+global:
+	libmp_get_multipath_config;
+	get_multipath_config;
+	libmp_put_multipath_config;
+	put_multipath_config;
+	init_config;
+	uninit_config;
+} LIBMULTIPATH_2.1.0;
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

