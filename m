Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311A4ECAAD3
	for <dm-devel@archiver.kernel.org>; Thu,  1 Sep 2022 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662048671;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=97+kuMhW3f4Xwnjd12B21S9FaLrxiFn6omM8pcoxCQA=;
	b=VyMyxDJbcV8uMPyT7TeNmNSMPcgVvFmlrnktJeKhdQjjZ+ABvJ/tixNUsyvidgZx0e1LI8
	7ZHtKh1s+xQvxNv0lv8u+rp0pS+nKi9IrmdCqaZw/4EdSVPqG4DY+J6mreGsG31rttXIeZ
	79d3xZrQ6IRYCGuiJYI5Y+boxixe2GI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-6LjFU3nHPjSGby1z2AULDw-1; Thu, 01 Sep 2022 12:11:07 -0400
X-MC-Unique: 6LjFU3nHPjSGby1z2AULDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6DCE18E004D;
	Thu,  1 Sep 2022 16:11:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8D7DD4C819;
	Thu,  1 Sep 2022 16:11:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D904194322D;
	Thu,  1 Sep 2022 16:11:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 20FB31946A5E
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 16:10:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E99E51121320; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E55CF1121314
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC4CE180A2E8
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-227-DZ4QyZGcMYmC9Fp6XsNAYA-1; Thu,
 01 Sep 2022 12:10:11 -0400
X-MC-Unique: DZ4QyZGcMYmC9Fp6XsNAYA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 06B5520217;
 Thu,  1 Sep 2022 16:10:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C1AAC13A79;
 Thu,  1 Sep 2022 16:10:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id mOjJLWDZEGMPDQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Sep 2022 16:10:08 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  1 Sep 2022 18:09:47 +0200
Message-Id: <20220901160952.2167-12-mwilck@suse.com>
In-Reply-To: <20220901160952.2167-1-mwilck@suse.com>
References: <20220901160952.2167-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 11/16] libmultipath: replace close_fd() with
 cleanup_fd_ptr()
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This is a nicer API without ugly casts, and less likely to close
valid file descriptors accidentally. Also, it can be used for
both pthread_cleanup_push and __attribute__((cleanup)).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/libmpathutil.version |  6 +++++-
 libmpathutil/util.c               | 15 ++++++++++-----
 libmpathutil/util.h               |  2 +-
 libmultipath/alias.c              |  4 ++--
 libmultipath/foreign/nvme.c       |  4 ++--
 libmultipath/sysfs.c              | 12 ++++++------
 libmultipath/wwids.c              |  8 ++++----
 multipath/main.c                  |  6 +++---
 multipathd/fpin_handlers.c        |  6 +++---
 9 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index f81fb36..95b169d 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -39,7 +39,6 @@ global:
 	cleanup_charp;
 	cleanup_mutex;
 	cleanup_ucharp;
-	close_fd;
 	convert_dev;
 	dlog;
 	fill_strbuf;
@@ -121,3 +120,8 @@ LIBMPATHUTIL_1.0 {
 	vector_move_up;
 	vector_sort;
 };
+
+LIBMPATHUTIL_1.1 {
+global:
+	cleanup_fd_ptr;
+} LIBMPATHUTIL_1.0;
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 6979e74..1539738 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -387,11 +387,6 @@ void free_scandir_result(struct scandir_result *res)
 	free(res->di);
 }
 
-void close_fd(void *arg)
-{
-	close((long)arg);
-}
-
 void cleanup_free_ptr(void *arg)
 {
 	void **p = arg;
@@ -400,6 +395,16 @@ void cleanup_free_ptr(void *arg)
 		free(*p);
 }
 
+void cleanup_fd_ptr(void *arg)
+{
+	int *fd = arg;
+
+	if (*fd >= 0) {
+		close(*fd);
+		*fd = -1;
+	}
+}
+
 void cleanup_mutex(void *arg)
 {
 	pthread_mutex_unlock(arg);
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index bede49d..7e34c56 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -46,7 +46,7 @@ int should_exit(void);
 #define pthread_cleanup_push_cast(f, arg)		\
 	pthread_cleanup_push(((void (*)(void *))&f), (arg))
 
-void close_fd(void *arg);
+void cleanup_fd_ptr(void *arg);
 void cleanup_free_ptr(void *arg);
 void cleanup_mutex(void *arg);
 
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index af3e24f..0520122 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -573,7 +573,7 @@ static int fix_bindings_file(const struct config *conf,
 			     const Bindings *bindings)
 {
 	int rc;
-	long fd;
+	int fd = -1;
 	char tempname[PATH_MAX];
 	mode_t old_umask;
 
@@ -586,7 +586,7 @@ static int fix_bindings_file(const struct config *conf,
 		return -1;
 	}
 	umask(old_umask);
-	pthread_cleanup_push(close_fd, (void*)fd);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
 	rc = write_bindings_file(bindings, fd);
 	pthread_cleanup_pop(1);
 	if (rc == -1) {
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 9a05b33..edc9bd8 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -599,7 +599,7 @@ static void test_ana_support(struct nvme_map *map, struct udev_device *ctl)
 {
 	const char *dev_t;
 	char sys_path[64];
-	long fd;
+	int fd = -1;
 	int rc;
 
 	if (map->ana_supported != YNU_UNDEF)
@@ -615,7 +615,7 @@ static void test_ana_support(struct nvme_map *map, struct udev_device *ctl)
 		return;
 	}
 
-	pthread_cleanup_push(close_fd, (void *)fd);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
 	rc = nvme_id_ctrl_ana(fd, NULL);
 	if (rc < 0)
 		condlog(2, "%s: error in nvme_id_ctrl: %s", __func__,
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 6494638..afde849 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -49,7 +49,7 @@ static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_
 {
 	const char *syspath;
 	char devpath[PATH_MAX];
-	long fd;
+	int fd = -1;
 	ssize_t size = -1;
 
 	if (!dev || !attr_name || !value || !value_len) {
@@ -74,7 +74,7 @@ static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_
 			__func__, devpath, strerror(errno));
 		return -errno;
 	}
-	pthread_cleanup_push(close_fd, (void *)fd);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
 
 	size = read(fd, value, value_len);
 	if (size < 0) {
@@ -114,7 +114,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 {
 	const char *syspath;
 	char devpath[PATH_MAX];
-	long fd;
+	int fd = -1;
 	ssize_t size = -1;
 
 	if (!dev || !attr_name || !value || !value_len) {
@@ -140,7 +140,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			__func__, devpath, strerror(errno));
 		return -errno;
 	}
-	pthread_cleanup_push(close_fd, (void *)fd);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
 
 	size = write(fd, value, value_len);
 	if (size < 0) {
@@ -272,7 +272,7 @@ bool sysfs_is_multipathed(struct path *pp, bool set_wwid)
 	sr.n = r;
 	pthread_cleanup_push_cast(free_scandir_result, &sr);
 	for (i = 0; i < r && !found; i++) {
-		long fd;
+		int fd = -1;
 		int nr;
 		char uuid[WWID_SIZE + UUID_PREFIX_LEN];
 
@@ -286,7 +286,7 @@ bool sysfs_is_multipathed(struct path *pp, bool set_wwid)
 			continue;
 		}
 
-		pthread_cleanup_push(close_fd, (void *)fd);
+		pthread_cleanup_push(cleanup_fd_ptr, &fd);
 		nr = read(fd, uuid, sizeof(uuid));
 		if (nr > (int)UUID_PREFIX_LEN &&
 		    !memcmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN)) {
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 61d9c39..89bb60c 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -90,7 +90,7 @@ int
 replace_wwids(vector mp)
 {
 	int i, can_write;
-	long fd;
+	int fd = -1;
 	struct multipath * mpp;
 	size_t len;
 	int ret = -1;
@@ -103,7 +103,7 @@ replace_wwids(vector mp)
 	if (fd < 0)
 		goto out;
 
-	pthread_cleanup_push(close_fd, (void*)fd);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
 	if (!can_write) {
 		condlog(0, "cannot replace wwids. wwids file is read-only");
 		goto out_file;
@@ -196,7 +196,7 @@ do_remove_wwid(int fd, char *str) {
 
 int
 remove_wwid(char *wwid) {
-	long fd;
+	int fd = -1;
 	int len, can_write;
 	char *str;
 	int ret = -1;
@@ -226,7 +226,7 @@ remove_wwid(char *wwid) {
 		goto out;
 	}
 
-	pthread_cleanup_push(close_fd, (void*)fd);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
 	if (!can_write) {
 		ret = -1;
 		condlog(0, "cannot remove wwid. wwids file is read-only");
diff --git a/multipath/main.c b/multipath/main.c
index 8e5154a..fbff6b7 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -321,7 +321,7 @@ static int find_multipaths_check_timeout(const struct path *pp, long tmo,
 	char path[PATH_MAX];
 	struct timespec now, ftimes[2], tdiff;
 	struct stat st;
-	long fd;
+	int fd = -1;
 	int r, retries = 0;
 
 	clock_gettime(CLOCK_REALTIME, &now);
@@ -339,7 +339,7 @@ static int find_multipaths_check_timeout(const struct path *pp, long tmo,
 retry:
 	fd = open(path, O_RDONLY);
 	if (fd != -1) {
-		pthread_cleanup_push(close_fd, (void *)fd);
+		pthread_cleanup_push(cleanup_fd_ptr, &fd);
 		r = fstat(fd, &st);
 		pthread_cleanup_pop(1);
 
@@ -355,7 +355,7 @@ retry:
 			return FIND_MULTIPATHS_ERROR;
 		};
 
-		pthread_cleanup_push(close_fd, (void *)fd);
+		pthread_cleanup_push(cleanup_fd_ptr, &fd);
 		/*
 		 * We just created the file. Set st_mtim to our desired
 		 * expiry time.
diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index 0019572..a7da2c9 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -488,7 +488,7 @@ static void receiver_cleanup_list(__attribute__((unused)) void *arg)
 void *fpin_fabric_notification_receiver(__attribute__((unused))void *unused)
 {
 	int ret;
-	long fd;
+	int fd = -1;
 	uint32_t els_cmd;
 	struct fc_nl_event *fc_event = NULL;
 	struct sockaddr_nl fc_local;
@@ -501,11 +501,11 @@ void *fpin_fabric_notification_receiver(__attribute__((unused))void *unused)
 	pthread_cleanup_push(receiver_cleanup_list, NULL);
 	fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_SCSITRANSPORT);
 	if (fd < 0) {
-		condlog(0, "fc socket error %ld", fd);
+		condlog(0, "fc socket error %d", fd);
 		return NULL;
 	}
 
-	pthread_cleanup_push(close_fd, (void *)fd);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
 	memset(&fc_local, 0, sizeof(fc_local));
 	fc_local.nl_family = AF_NETLINK;
 	fc_local.nl_groups = ~0;
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

