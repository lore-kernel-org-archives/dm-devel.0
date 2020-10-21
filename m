Return-Path: <SRS0=YCRG=D4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DF3C4363A
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:39:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A1419223C7
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dusP/Dsz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1419223C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603316386;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=THfIMiT5t6+9ciFii9BYp/Wjwu/q1Q0pXDIHVdjQskU=;
	b=dusP/Dsz3IjmJ4ZEO0fpGQEO6CpyBKv2IfXGaUEv4iKY3Po7OAqf0M8e76wK/OwIgBw3EV
	Mw8pNlcjAy36goNEPLTiCZzmuXmyaNjHAM6s34prCx9LrhJUASNTEcKz2BoDmGktc33Xlz
	9/MXUKqa8KlAbRhIGI0TXQDMAdCzD3E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-aCkOxN6ZPY-dq54tAJis2w-1; Wed, 21 Oct 2020 17:39:44 -0400
X-MC-Unique: aCkOxN6ZPY-dq54tAJis2w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAAC71019625;
	Wed, 21 Oct 2020 21:39:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72A9710013D7;
	Wed, 21 Oct 2020 21:39:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 80E048C7DE;
	Wed, 21 Oct 2020 21:39:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09LLdYJq008781 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Oct 2020 17:39:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BDF1019D7C; Wed, 21 Oct 2020 21:39:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3020A19C78;
	Wed, 21 Oct 2020 21:39:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09LLdTda028787; 
	Wed, 21 Oct 2020 16:39:30 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09LLdTtY028786;
	Wed, 21 Oct 2020 16:39:29 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 21 Oct 2020 16:39:25 -0500
Message-Id: <1603316366-28735-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
References: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 3/4] libmultipath: add uid failback for dasd
	devices
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add failback code to get the uid for dasd devices from sysfs. Copied
from dasdinfo

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h  |  1 +
 libmultipath/discovery.c | 37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 39a5e415..947ba467 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -8,6 +8,7 @@
  */
 #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
 #define DEFAULT_NVME_UID_ATTRIBUTE	"ID_WWN"
+#define DEFAULT_DASD_UID_ATTRIBUTE	"ID_UID"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
 #define DEFAULT_SELECTOR	"service-time 0"
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index cbde3585..d7e8577f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1957,12 +1957,44 @@ get_vpd_uid(struct path * pp)
 	return get_vpd_sysfs(parent, 0x83, pp->wwid, WWID_SIZE);
 }
 
+/* based on code from s390-tools/dasdinfo/dasdinfo.c */
+static ssize_t dasd_get_uid(struct path *pp)
+{
+	struct udev_device *parent;
+	char value[80];
+	char *p;
+	int i;
+
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "ccw",
+							       NULL);
+	if (!parent)
+		return -1;
+
+	if (sysfs_attr_get_value(parent, "uid", value, 80) < 0)
+		return -1;
+
+	p = value - 1;
+	/* look for the 4th '.' and cut there */
+	for (i = 0; i < 4; i++) {
+		p = index(p + 1, '.');
+		if (!p)
+			break;
+	}
+	if (p)
+		*p = '\0';
+
+	return strlcpy(pp->wwid, value, WWID_SIZE);
+}
+
 static ssize_t uid_fallback(struct path *pp, int path_state,
 			    const char **origin)
 {
 	ssize_t len = -1;
 
-	if (pp->bus == SYSFS_BUS_SCSI) {
+	if (pp->bus == SYSFS_BUS_CCW) {
+		len = dasd_get_uid(pp);
+		*origin = "sysfs";
+	} else if (pp->bus == SYSFS_BUS_SCSI) {
 		len = get_vpd_uid(pp);
 		*origin = "sysfs";
 		if (len < 0 && path_state == PATH_UP) {
@@ -2010,6 +2042,9 @@ static bool has_uid_fallback(struct path *pp)
 		  !strcmp(pp->uid_attribute, ""))) ||
 		(pp->bus == SYSFS_BUS_NVME &&
 		 (!strcmp(pp->uid_attribute, DEFAULT_NVME_UID_ATTRIBUTE) ||
+		  !strcmp(pp->uid_attribute, ""))) ||
+		(pp->bus == SYSFS_BUS_CCW &&
+		 (!strcmp(pp->uid_attribute, DEFAULT_DASD_UID_ATTRIBUTE) ||
 		  !strcmp(pp->uid_attribute, ""))));
 }
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

