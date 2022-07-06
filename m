Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F4FCCA473
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118347;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XdIOr/swKv8nFmKRTwt1wjCeAxkOTB7RC9nS3TW48Eo=;
	b=R/AlAzXA/MBk5B1kpxZQAY9kJv8K0CP8QGxX4q5h26C7LbAyhvGhMF7DgVZSYPz40WWbb4
	q0gZ9ilkpzk+BgIlOY7t7XARW+SzQQ8MGp5o57uUv7CnRZYSQ4zhIvrCFzAPYrg2B/vQsg
	iuBwWdrOY4NzwcRdTlzhMlNBZk7W1x0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-sOL9X7AGOOqjKo845Zxapg-1; Wed, 06 Jul 2022 10:39:06 -0400
X-MC-Unique: sOL9X7AGOOqjKo845Zxapg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6E323C0F381;
	Wed,  6 Jul 2022 14:39:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 948982026D64;
	Wed,  6 Jul 2022 14:39:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 664CF1947067;
	Wed,  6 Jul 2022 14:39:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B9AC9194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:39:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A9974492C3B; Wed,  6 Jul 2022 14:39:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5884401E54
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:39:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C2F51C006B8
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:39:02 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-H9juscerNWSHUxPGa7nUfA-1; Wed, 06 Jul 2022 10:38:54 -0400
X-MC-Unique: H9juscerNWSHUxPGa7nUfA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 9492F1FF3D;
 Wed,  6 Jul 2022 14:38:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69A85134CF;
 Wed,  6 Jul 2022 14:38:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id kMBGGG+exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:39 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:17 +0200
Message-Id: <20220706143822.30182-10-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH 09/14] libmultipath: sysfs: cleanup file
 descriptors on pthread_cancel()
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/sysfs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 9c84af7..6494638 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -49,7 +49,7 @@ static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_
 {
 	const char *syspath;
 	char devpath[PATH_MAX];
-	int fd;
+	long fd;
 	ssize_t size = -1;
 
 	if (!dev || !attr_name || !value || !value_len) {
@@ -74,6 +74,8 @@ static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_
 			__func__, devpath, strerror(errno));
 		return -errno;
 	}
+	pthread_cleanup_push(close_fd, (void *)fd);
+
 	size = read(fd, value, value_len);
 	if (size < 0) {
 		size = -errno;
@@ -90,7 +92,7 @@ static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_
 		size = strchop(value);
 	}
 
-	close(fd);
+	pthread_cleanup_pop(1);
 	return size;
 }
 
@@ -112,7 +114,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 {
 	const char *syspath;
 	char devpath[PATH_MAX];
-	int fd;
+	long fd;
 	ssize_t size = -1;
 
 	if (!dev || !attr_name || !value || !value_len) {
@@ -138,6 +140,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			__func__, devpath, strerror(errno));
 		return -errno;
 	}
+	pthread_cleanup_push(close_fd, (void *)fd);
 
 	size = write(fd, value, value_len);
 	if (size < 0) {
@@ -148,7 +151,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 		condlog(3, "%s: underflow writing %zu bytes to %s. Wrote %zd bytes",
 			__func__, value_len, devpath, size);
 
-	close(fd);
+	pthread_cleanup_pop(1);
 	return size;
 }
 
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

