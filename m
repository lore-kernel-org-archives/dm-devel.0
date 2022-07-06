Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15048C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Yl8mhblj2zeKDhm7RAieK09fa7eF6ySRZI6Q0Er0Hi0=;
	b=ShmZ4hSm3QPhQagwKpmkrImzWdG2meu6PrPmRx3cKfGwXeshggIWzfX3nvAy0RlqwBh8gY
	lX0qrw0H3ycllLkQAngI0PHACjbsWyVTGGrTOFWYbO9hvFPFBbKSrHJBCJP5WeYSkbKvqk
	Bui/FAI6rXLwBYpstN7sc8S6IWd4nZ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-KfQIsJm6MjWsJ21xhok3vA-1; Wed, 06 Jul 2022 10:38:55 -0400
X-MC-Unique: KfQIsJm6MjWsJ21xhok3vA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F63E1C006B8;
	Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 59A412026D64;
	Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 243601947063;
	Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA20F194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9A4DE40CFD0D; Wed,  6 Jul 2022 14:38:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9698A40CFD0A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EEAA1019C9A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:50 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-0Ph2WaOzOoq9kuslwHD-mQ-1; Wed, 06 Jul 2022 10:38:48 -0400
X-MC-Unique: 0Ph2WaOzOoq9kuslwHD-mQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 279351FF3B;
 Wed,  6 Jul 2022 14:38:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F03BE134CF;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id QDYyOW6exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:38 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:15 +0200
Message-Id: <20220706143822.30182-8-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH 07/14] libmultipath: sysfs_attr_get_value():
 don't return 0 if buffer too small
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

If the passed read buffer is too small to hold the value read plus
terminating 0 byte, return the given size value rather than 0.

This way we get similar semantics as for sysfs_bin_attr_get_get_value(),
except that sysfs_attr_get_value() must always 0-terminate the value;
thus a return value equal to the length parameter is an error for
the non-binary case.

Provide a helper macro to test this "overflow" condition.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c |  2 +-
 libmultipath/discovery.c | 14 +++++++-------
 libmultipath/propsel.c   |  6 +++++-
 libmultipath/sysfs.c     |  3 +--
 libmultipath/sysfs.h     | 13 +++++++++++++
 multipathd/main.c        |  2 +-
 6 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 09ae708..467bbaa 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -589,7 +589,7 @@ sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
 		ret = sysfs_attr_get_value(udd, "queue/max_sectors_kb", buff,
 					   sizeof(buff));
 		udev_device_unref(udd);
-		if (ret <= 0) {
+		if (!sysfs_attr_value_ok(ret, sizeof(buff))) {
 			condlog(1, "failed to get current max_sectors_kb from %s", mpp->alias);
 			return 1;
 		}
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f5b8401..54b1caf 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -560,10 +560,10 @@ sysfs_get_asymmetric_access_state(struct path *pp, char *buff, int buflen)
 	if (!parent)
 		return -1;
 
-	if (sysfs_attr_get_value(parent, "access_state", buff, buflen) <= 0)
+	if (!sysfs_attr_get_value_ok(parent, "access_state", buff, buflen))
 		return -1;
 
-	if (sysfs_attr_get_value(parent, "preferred_path", value, 16) <= 0)
+	if (!sysfs_attr_get_value_ok(parent, "preferred_path", value, sizeof(value)))
 		return 0;
 
 	preferred = strtoul(value, &eptr, 0);
@@ -638,8 +638,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	/*
 	 * read the current dev_loss_tmo value from sysfs
 	 */
-	ret = sysfs_attr_get_value(rport_dev, "dev_loss_tmo", value, 16);
-	if (ret <= 0) {
+	ret = sysfs_attr_get_value(rport_dev, "dev_loss_tmo", value, sizeof(value));
+	if (!sysfs_attr_value_ok(ret, sizeof(value))) {
 		condlog(0, "%s: failed to read dev_loss_tmo value, "
 			"error %d", rport_id, -ret);
 		goto out;
@@ -1737,8 +1737,8 @@ path_offline (struct path * pp)
 	}
 
 	memset(buff, 0x0, SCSI_STATE_SIZE);
-	err = sysfs_attr_get_value(parent, "state", buff, SCSI_STATE_SIZE);
-	if (err <= 0) {
+	err = sysfs_attr_get_value(parent, "state", buff, sizeof(buff));
+	if (!sysfs_attr_value_ok(err, sizeof(buff))) {
 		if (err == -ENXIO)
 			return PATH_REMOVED;
 		else
@@ -2142,7 +2142,7 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 			return -1;
 		len = sysfs_attr_get_value(pp->udev, "wwid", value,
 					   sizeof(value));
-		if (len <= 0)
+		if (!sysfs_attr_value_ok(len, sizeof(value)))
 			return -1;
 		len = strlcpy(pp->wwid, value, WWID_SIZE);
 		if (len >= WWID_SIZE) {
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 50d0b5c..18f2277 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -435,6 +435,7 @@ out:
 static int get_dh_state(struct path *pp, char *value, size_t value_len)
 {
 	struct udev_device *ud;
+	ssize_t rc;
 
 	if (pp->udev == NULL)
 		return -1;
@@ -444,7 +445,10 @@ static int get_dh_state(struct path *pp, char *value, size_t value_len)
 	if (ud == NULL)
 		return -1;
 
-	return sysfs_attr_get_value(ud, "dh_state", value, value_len);
+	rc = sysfs_attr_get_value(ud, "dh_state", value, value_len);
+	if (!sysfs_attr_value_ok(rc, value_len))
+		return -1;
+	return rc;
 }
 
 int select_hwhandler(struct config *conf, struct multipath *mp)
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index e48b05e..125f1c2 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -85,7 +85,6 @@ static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_
 		condlog(3, "%s: overflow reading from %s (required len: %zu)",
 			__func__, devpath, size);
 		value[size - 1] = '\0';
-		size = 0;
 	} else if (!binary) {
 		value[size] = '\0';
 		size = strchop(value);
@@ -165,7 +164,7 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 		return 1;
 
 	attr[0] = '\0';
-	if (sysfs_attr_get_value(pp->udev, "size", attr, 255) <= 0) {
+	if (!sysfs_attr_get_value_ok(pp->udev, "size", attr, sizeof(attr))) {
 		condlog(3, "%s: No size attribute in sysfs", pp->dev);
 		return 1;
 	}
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 72b39ab..cdc84e4 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -12,6 +12,19 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 			     char * value, size_t value_len);
 ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 				 unsigned char * value, size_t value_len);
+#define sysfs_attr_value_ok(rc, value_len)			\
+	({							\
+		ssize_t __r = rc;				\
+		__r >= 0 && (size_t)__r < (size_t)value_len;	\
+	})
+
+#define sysfs_attr_get_value_ok(dev, attr, val, len) \
+	({ \
+		size_t __l = (len);					\
+		ssize_t __rc = sysfs_attr_get_value(dev, attr, val, __l); \
+		sysfs_attr_value_ok(__rc, __l); \
+	})
+
 int sysfs_get_size (struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
 bool sysfs_is_multipathed(struct path *pp, bool set_wwid);
diff --git a/multipathd/main.c b/multipathd/main.c
index 2f2b9d4..68eca92 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1126,7 +1126,7 @@ sysfs_get_ro (struct path *pp)
 	if (!pp->udev)
 		return -1;
 
-	if (sysfs_attr_get_value(pp->udev, "ro", buff, sizeof(buff)) <= 0) {
+	if (!sysfs_attr_get_value_ok(pp->udev, "ro", buff, sizeof(buff))) {
 		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
 		return -1;
 	}
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

