Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169F2C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zS5QysySWVcWnBks3IE/RI71d6BjHqIo/qMfz95FzkY=;
	b=A+n+HU/3Vemjeo9Sllsr4Ll2Czp7KoEjFy8FXeI+3qW2nUV9/cDzBV7sQA7okAGnFPAj27
	ONNF2kPfMerYsK6TpPRF5zl4+6lP6qIQp6a3WAcCRyIkvEJOPBrG8iVrvdBd4n3uSvTTxH
	wSk/CKlwVojW5EL5ofrFxnQqpM5a3lU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-1S5Zlj-nOcOtw9IgipDpEQ-1; Wed, 06 Jul 2022 10:38:50 -0400
X-MC-Unique: 1S5Zlj-nOcOtw9IgipDpEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D6599693B0;
	Wed,  6 Jul 2022 14:38:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1229040CF8E7;
	Wed,  6 Jul 2022 14:38:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DDE7E1947065;
	Wed,  6 Jul 2022 14:38:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01095194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D633F112131E; Wed,  6 Jul 2022 14:38:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D20FB1121315
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6709872911
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:42 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-emA_MEUeONKvDFYTuVzJcA-1; Wed, 06 Jul 2022 10:38:41 -0400
X-MC-Unique: emA_MEUeONKvDFYTuVzJcA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id E6B9B1FF38;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BB71F134CF;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id gDUyLG6exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:38 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:14 +0200
Message-Id: <20220706143822.30182-7-mwilck@suse.com>
In-Reply-To: <20220706143822.30182-1-mwilck@suse.com>
References: <20220706143822.30182-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 06/14] libmultipath: get rid of PATH_SIZE
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

replace PATH_SIZE with the system limit PATH_MAX. In some places,
PATH_SIZE was used for file names. Use FILE_NAME_SIZE in these cases.
Also, use a constant for "multipathd.service" in systemd_service_enabled_in().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.h    | 3 ---
 libmultipath/sysfs.c      | 8 ++++----
 libmultipath/util.c       | 8 +++++---
 multipathd/cli_handlers.c | 2 +-
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a6a0944..dfa12ff 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -17,7 +17,6 @@
 #define FILE_NAME_SIZE		256
 #define CALLOUT_MAX_SIZE	256
 #define BLK_DEV_SIZE		33
-#define PATH_SIZE		512
 #define NAME_SIZE		512
 #define HOST_NAME_LEN		16
 #define SLOT_NAME_SIZE		40
@@ -519,6 +518,4 @@ int pathcmp (const struct pathgroup *, const struct pathgroup *);
 int add_feature (char **, const char *);
 int remove_feature (char **, const char *);
 
-extern char sysfs_path[PATH_SIZE];
-
 #endif /* _STRUCTS_H */
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 1f0f207..e48b05e 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -48,7 +48,7 @@ static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_
 				      char *value, size_t value_len, bool binary)
 {
 	const char *syspath;
-	char devpath[PATH_SIZE];
+	char devpath[PATH_MAX];
 	int fd;
 	ssize_t size = -1;
 
@@ -112,7 +112,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			     const char * value, size_t value_len)
 {
 	const char *syspath;
-	char devpath[PATH_SIZE];
+	char devpath[PATH_MAX];
 	int fd;
 	ssize_t size = -1;
 
@@ -184,7 +184,7 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 int sysfs_check_holders(char * check_devt, char * new_devt)
 {
 	unsigned int major, new_minor, table_minor;
-	char path[PATH_MAX], check_dev[PATH_SIZE];
+	char path[PATH_MAX], check_dev[FILE_NAME_SIZE];
 	char * table_name;
 	DIR *dirfd;
 	struct dirent *holder;
@@ -194,7 +194,7 @@ int sysfs_check_holders(char * check_devt, char * new_devt)
 		return 0;
 	}
 
-	if (devt2devname(check_dev, PATH_SIZE, check_devt)) {
+	if (devt2devname(check_dev, sizeof(check_dev), check_devt)) {
 		condlog(1, "can't get devname for %s", check_devt);
 		return 0;
 	}
diff --git a/libmultipath/util.c b/libmultipath/util.c
index ce5ea73..e7e7d4c 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -242,13 +242,15 @@ setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
 
 int systemd_service_enabled_in(const char *dev, const char *prefix)
 {
-	char path[PATH_SIZE], file[PATH_MAX], service[PATH_SIZE];
+	static const char service[] = "multipathd.service";
+	char path[PATH_MAX], file[PATH_MAX];
 	DIR *dirfd;
 	struct dirent *d;
 	int found = 0;
 
-	snprintf(service, PATH_SIZE, "multipathd.service");
-	snprintf(path, PATH_SIZE, "%s/systemd/system", prefix);
+	if (safe_sprintf(path, "%s/systemd/system", prefix))
+		return 0;
+
 	condlog(3, "%s: checking for %s in %s", dev, service, path);
 
 	dirfd = opendir(path);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index d79cdd7..db4d441 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -688,7 +688,7 @@ cli_add_map (void * v, struct strbuf *reply, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 	int major = -1, minor = -1;
-	char dev_path[PATH_SIZE];
+	char dev_path[FILE_NAME_SIZE];
 	char *refwwid, *alias = NULL;
 	int rc, count = 0;
 	struct config *conf;
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

