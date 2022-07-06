Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AD0C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118342;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wxj7to9l26BJrXfUbO+P+duo7X0It38B9ELRxX+Rvj4=;
	b=SaHOzTCJwvKac18tzldmIeal3pIMprmXoLRTzJbnN8++442WRfSXa+ym1h+Q0TgZcBqIa7
	SRgTgKFsLwMaxMx5K06QJlVzT8ZHFaUdlknimKSCl9rSjm5/g69eCNbqsrs9IGs9P9CcX0
	qOvC0JjY+K8Kw9SVZzqqw0J8YxLLfH0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-yopKJTNYPSGrVp0uCD-_yQ-1; Wed, 06 Jul 2022 10:38:58 -0400
X-MC-Unique: yopKJTNYPSGrVp0uCD-_yQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D25D518E004B;
	Wed,  6 Jul 2022 14:38:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BFA072166B29;
	Wed,  6 Jul 2022 14:38:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ADAFD1947063;
	Wed,  6 Jul 2022 14:38:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5C3E31947063
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FB7DC28130; Wed,  6 Jul 2022 14:38:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B763C2812B
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 255D68339CB
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-1gWqLGsLMpCHQkbDJilx6A-1; Wed, 06 Jul 2022 10:38:45 -0400
X-MC-Unique: 1gWqLGsLMpCHQkbDJilx6A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 456561FF33;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 18F04134CF;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 6D2FBG6exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:38 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:11 +0200
Message-Id: <20220706143822.30182-4-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH 03/14] libmultipath: sysfs_bin_attr_get_value():
 no error if buffer is filled
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

sysfs_bin_attr_get_value() sets the length of bytes read to 0
when the provided buffer was too small, truncating potentially
useful data. This is harmful e.g. in do_inquiry(), if the "inquiry"
sysfs attribute contains more than 96 bytes (which is possible).

Actually, binary attributes don't need to be 0-terminated. Thus,
unlike for string attributes, it's not an error if the requested number of
bytes is exactly equal to the number of bytes read. We expect that
the caller knows how many bytes it needs to read.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 10 ++++++----
 libmultipath/sysfs.c     |  5 +----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7e09e4e..f5b8401 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1341,13 +1341,15 @@ static int
 get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
 {
 	int len;
-	size_t buff_len;
+	ssize_t buff_len;
 	unsigned char buff[VPD_BUFLEN];
 
 	memset(buff, 0x0, VPD_BUFLEN);
-	if (!parent || sysfs_get_vpd(parent, pg, buff, VPD_BUFLEN) <= 0) {
-		condlog(3, "failed to read sysfs vpd pg%02x", pg);
-		return -EINVAL;
+	buff_len = sysfs_get_vpd(parent, pg, buff, VPD_BUFLEN);
+	if (buff_len < 0) {
+		condlog(3, "failed to read sysfs vpd pg%02x: %s",
+			pg, strerror(-buff_len));
+		return buff_len;
 	}
 
 	if (buff[1] != pg) {
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index f45dbee..3ec9251 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -146,10 +146,7 @@ ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 	if (size < 0) {
 		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
 		size = -errno;
-	} else if (size == (ssize_t)value_len) {
-		condlog(4, "overflow while reading from %s", devpath);
-		size = 0;
-	}
+	};
 
 	close(fd);
 	return size;
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

