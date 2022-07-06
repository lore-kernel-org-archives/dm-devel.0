Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6DB8CCA473
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N5e8PlXMkFKBWUBlCCRs9af5bEQbNOehmiRBqIbTSAU=;
	b=YuYJxCeHrXZAxwOyQWont6GBIPqap9Cr/n4ySPvFla3mDrtnxwTjJZnCL/KS4BMci59Ej2
	USxGY6yWS9kaHfXQehVFNhw9KFWohDXeiLHgtdZYQ/0Brzg2q6BnTUn5QvFhMLoZ9+qqui
	xW1aF/Q7oLQJJk7Xo3TVkdD7ty0Kaog=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-uH54D8paPKWqs7o-Evx28g-1; Wed, 06 Jul 2022 10:38:52 -0400
X-MC-Unique: uH54D8paPKWqs7o-Evx28g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B89E8117B0;
	Wed,  6 Jul 2022 14:38:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61B9DC44AE6;
	Wed,  6 Jul 2022 14:38:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD5F1194706D;
	Wed,  6 Jul 2022 14:38:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AFB131947068
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 91455C44AE5; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C858C44AE3
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 748E5294EDE6
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:48 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-zIxMINL7MWyCXNBTZNjjfg-1; Wed, 06 Jul 2022 10:38:47 -0400
X-MC-Unique: zIxMINL7MWyCXNBTZNjjfg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id B13771FF37;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8482F134CF;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id iH7GHm6exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:38 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:13 +0200
Message-Id: <20220706143822.30182-6-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 05/14] libmultipath: sanitize error checking in
 sysfs accessors
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

udev_device_get_syspath() may return NULL; check for it, and check
for pathname overflow. Disallow a zero buffer length. The fstat()
calls were superfluous, as a read() or write() on the fd would
return the respective error codes depending on file type or permissions,
the extra system call and code complexity adds no value.

Log levels should be moderate in sysfs.c, because it depends
on the caller whether errors getting/setting certain attributes are
fatal.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/sysfs.c | 94 ++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 55 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 4db911c..1f0f207 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -47,46 +47,38 @@
 static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 				      char *value, size_t value_len, bool binary)
 {
+	const char *syspath;
 	char devpath[PATH_SIZE];
-	struct stat statbuf;
 	int fd;
 	ssize_t size = -1;
 
-	if (!dev || !attr_name || !value)
-		return 0;
+	if (!dev || !attr_name || !value || !value_len) {
+		condlog(1, "%s: invalid parameters", __func__);
+		return -EINVAL;
+	}
 
-	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
-		 attr_name);
+	syspath = udev_device_get_syspath(dev);
+	if (!syspath) {
+		condlog(3, "%s: invalid udevice", __func__);
+		return -EINVAL;
+	}
+	if (safe_sprintf(devpath, "%s/%s", syspath, attr_name)) {
+		condlog(3, "%s: devpath overflow", __func__);
+		return -EOVERFLOW;
+	}
 	condlog(4, "open '%s'", devpath);
 	/* read attribute value */
 	fd = open(devpath, O_RDONLY);
 	if (fd < 0) {
-		condlog(4, "attribute '%s' can not be opened: %s",
-			devpath, strerror(errno));
+		condlog(3, "%s: attribute '%s' can not be opened: %s",
+			__func__, devpath, strerror(errno));
 		return -errno;
 	}
-	if (fstat(fd, &statbuf) < 0) {
-		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
-		close(fd);
-		return -ENXIO;
-	}
-	/* skip directories */
-	if (S_ISDIR(statbuf.st_mode)) {
-		condlog(4, "%s is a directory", devpath);
-		close(fd);
-		return -EISDIR;
-	}
-	/* skip non-writeable files */
-	if ((statbuf.st_mode & S_IRUSR) == 0) {
-		condlog(4, "%s is not readable", devpath);
-		close(fd);
-		return -EPERM;
-	}
-
 	size = read(fd, value, value_len);
 	if (size < 0) {
-		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
 		size = -errno;
+		condlog(3, "%s: read from %s failed: %s", __func__, devpath,
+			strerror(errno));
 		if (!binary)
 			value[0] = '\0';
 	} else if (!binary && size == (ssize_t)value_len) {
@@ -119,51 +111,43 @@ ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			     const char * value, size_t value_len)
 {
+	const char *syspath;
 	char devpath[PATH_SIZE];
-	struct stat statbuf;
 	int fd;
 	ssize_t size = -1;
 
-	if (!dev || !attr_name || !value || !value_len)
-		return 0;
+	if (!dev || !attr_name || !value || !value_len) {
+		condlog(1, "%s: invalid parameters", __func__);
+		return -EINVAL;
+	}
+
+	syspath = udev_device_get_syspath(dev);
+	if (!syspath) {
+		condlog(3, "%s: invalid udevice", __func__);
+		return -EINVAL;
+	}
+	if (safe_sprintf(devpath, "%s/%s", syspath, attr_name)) {
+		condlog(3, "%s: devpath overflow", __func__);
+		return -EOVERFLOW;
+	}
 
-	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
-		 attr_name);
 	condlog(4, "open '%s'", devpath);
 	/* write attribute value */
 	fd = open(devpath, O_WRONLY);
 	if (fd < 0) {
-		condlog(4, "attribute '%s' can not be opened: %s",
-			devpath, strerror(errno));
+		condlog(2, "%s: attribute '%s' can not be opened: %s",
+			__func__, devpath, strerror(errno));
 		return -errno;
 	}
-	if (fstat(fd, &statbuf) != 0) {
-		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
-		close(fd);
-		return -errno;
-	}
-
-	/* skip directories */
-	if (S_ISDIR(statbuf.st_mode)) {
-		condlog(4, "%s is a directory", devpath);
-		close(fd);
-		return -EISDIR;
-	}
-
-	/* skip non-writeable files */
-	if ((statbuf.st_mode & S_IWUSR) == 0) {
-		condlog(4, "%s is not writeable", devpath);
-		close(fd);
-		return -EPERM;
-	}
 
 	size = write(fd, value, value_len);
 	if (size < 0) {
-		condlog(4, "write to %s failed: %s", devpath, strerror(errno));
 		size = -errno;
+		condlog(3, "%s: write to %s failed: %s", __func__, 
+			devpath, strerror(errno));
 	} else if (size < (ssize_t)value_len) {
-		condlog(4, "tried to write %ld to %s. Wrote %ld",
-			(long)value_len, devpath, (long)size);
+		condlog(3, "%s: underflow writing %zu bytes to %s. Wrote %zd bytes",
+			__func__, value_len, devpath, size);
 		size = 0;
 	}
 
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

