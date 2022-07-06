Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119EDCCA481
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aJqxpcI4CzORytCtjElF8iutEEGwrdBXweE3Fj/BIVQ=;
	b=hPyDrpY9b71lx4k8K9drKWwqJWpD1vaJhCBlenGfOYA8KA41XshtrU7fzChs7QwQrBtXUp
	yg5mZHN9nMCV7wVkrAjBUezUpeONEe/kjidUkO0JDid6dIgiaXVYgL4ROfBs+hLdazxSS+
	sEsiA4BhHDKtiQ7w0BlVNpdBuJjpp4E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-FC2Wt7HWN_O3FoV5vzd1Yw-1; Wed, 06 Jul 2022 10:38:56 -0400
X-MC-Unique: FC2Wt7HWN_O3FoV5vzd1Yw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D6EB833A09;
	Wed,  6 Jul 2022 14:38:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3EA4141511D;
	Wed,  6 Jul 2022 14:38:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8286A1947072;
	Wed,  6 Jul 2022 14:38:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD43D1947063
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1602492C3B; Wed,  6 Jul 2022 14:38:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CCF3340315A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B49FA18E0048
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:44 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-yTDWW87UMrulFzYcGWUiIg-1; Wed, 06 Jul 2022 10:38:40 -0400
X-MC-Unique: yTDWW87UMrulFzYcGWUiIg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 7C5E81FF35;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4E9EC134CF;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id gHOgEW6exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:38 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:12 +0200
Message-Id: <20220706143822.30182-5-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 04/14] libmultipath: common code path for
 sysfs_attr_get_value()
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The code for sysfs_attr_get_value and sysfs_bin_attr_get_value() was
almost identical. Use a common code path.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/sysfs.c | 70 +++++++++++---------------------------------
 1 file changed, 17 insertions(+), 53 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 3ec9251..4db911c 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -44,8 +44,8 @@
  * as libudev lacks the capability to update an attribute value.
  * So for modified attributes we need to implement our own function.
  */
-ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
-			     char * value, size_t value_len)
+static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
+				      char *value, size_t value_len, bool binary)
 {
 	char devpath[PATH_SIZE];
 	struct stat statbuf;
@@ -87,12 +87,14 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	if (size < 0) {
 		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
 		size = -errno;
-		value[0] = '\0';
-	} else if (size == (ssize_t)value_len) {
+		if (!binary)
+			value[0] = '\0';
+	} else if (!binary && size == (ssize_t)value_len) {
+		condlog(3, "%s: overflow reading from %s (required len: %zu)",
+			__func__, devpath, size);
 		value[size - 1] = '\0';
-		condlog(4, "overflow while reading from %s", devpath);
 		size = 0;
-	} else {
+	} else if (!binary) {
 		value[size] = '\0';
 		size = strchop(value);
 	}
@@ -101,55 +103,17 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	return size;
 }
 
-ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
-				 unsigned char * value, size_t value_len)
+ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
+			     char *value, size_t value_len)
 {
-	char devpath[PATH_SIZE];
-	struct stat statbuf;
-	int fd;
-	ssize_t size = -1;
+	return __sysfs_attr_get_value(dev, attr_name, value, value_len, false);
+}
 
-	if (!dev || !attr_name || !value)
-		return 0;
-
-	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
-		 attr_name);
-	condlog(4, "open '%s'", devpath);
-	/* read attribute value */
-	fd = open(devpath, O_RDONLY);
-	if (fd < 0) {
-		condlog(4, "attribute '%s' can not be opened: %s",
-			devpath, strerror(errno));
-		return -errno;
-	}
-	if (fstat(fd, &statbuf) != 0) {
-		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
-		close(fd);
-		return -ENXIO;
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
-	if ((statbuf.st_mode & S_IRUSR) == 0) {
-		condlog(4, "%s is not readable", devpath);
-		close(fd);
-		return -EPERM;
-	}
-
-	size = read(fd, value, value_len);
-	if (size < 0) {
-		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
-		size = -errno;
-	};
-
-	close(fd);
-	return size;
+ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
+				 unsigned char *value, size_t value_len)
+{
+	return __sysfs_attr_get_value(dev, attr_name, (char *)value,
+				      value_len, true);
 }
 
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

