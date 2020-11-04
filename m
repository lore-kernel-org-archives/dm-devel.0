Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE3CC2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 06:57:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A13822225B
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 06:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V28XXDWZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A13822225B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604473058;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P1SHjA50yV6zutbjRR7hFYwIRUSpPVf7gSQ+qD5X79g=;
	b=V28XXDWZZ5WzDggGaxrqX0uV38Nf08d4xh9KhxxatF1Hce0zxFsCBl2D2zZuAu5fGLo7UQ
	8ufm1yjxGONAaZ1+I+UcFCgmiRW7e7ppDvGgRFWe10A4kX2oBe5uD/DjQDLGmGs15w6PvN
	s4yeWbBQe62gKO6jqU2jlme6be66GA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-CcTlrAL_MQe_IQO5LyhDcA-1; Wed, 04 Nov 2020 01:57:36 -0500
X-MC-Unique: CcTlrAL_MQe_IQO5LyhDcA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AFCE5F9D0;
	Wed,  4 Nov 2020 06:57:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E973413C;
	Wed,  4 Nov 2020 06:57:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 171735811B;
	Wed,  4 Nov 2020 06:57:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A46sMst017358 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 01:54:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD62F413C; Wed,  4 Nov 2020 06:54:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0041C6CE4E;
	Wed,  4 Nov 2020 06:54:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A46sHmU022480; 
	Wed, 4 Nov 2020 00:54:17 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A46sGLQ022479;
	Wed, 4 Nov 2020 00:54:16 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  4 Nov 2020 00:54:08 -0600
Message-Id: <1604472849-22422-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	device-mapper development <dm-devel@redhat.com>,
	Steve Schremmer <sschremm@netapp.com>, Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 5/6] libmultipath: limit reading 0xc9 vpd page
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Only rdac arrays support 0xC9 vpd page inquiries. All other arrays will
return a failure. Only do the rdac inquiry when detecting array
capabilities if the array's path checker is explicitly set to rdac, or
the path checker is not set, and the array reports that it supports vpd
page 0xC9 in the Supported VPD Pages (0x00) vpd page.

Multipath was doing the check if either the path checker was set to
rdac, or no path checker was set.  This means that for almost all
non-rdac arrays, multipath was issuing a bad inquiry. This was annoying
users.

Cc: Steve Schremmer <sschremm@netapp.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 25 +++++++++++++++++++++++++
 libmultipath/discovery.h |  1 +
 libmultipath/propsel.c   | 10 ++++++----
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 95ddbbbd..5669690d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1346,6 +1346,31 @@ fetch_vpd_page(int fd, int pg, unsigned char *buff)
 	return buff_len;
 }
 
+/* heavily based on sg_inq.c from sg3_utils */
+bool
+is_vpd_page_supported(int fd, int pg)
+{
+	int i, len, buff_len;
+	unsigned char buff[4096];
+
+	buff_len = fetch_vpd_page(fd, 0x00, buff);
+	if (buff_len < 0)
+		return false;
+	if (buff_len < 4) {
+		condlog(3, "VPD page 00h too short");
+		return false;
+	}
+
+	len = buff[3] + 4;
+	if (len > buff_len)
+		condlog(3, "vpd page 00h trucated, expected %d, have %d",
+			len, buff_len);
+	for (i = 4; i < len; ++i)
+		if (buff[i] == pg)
+			return true;
+	return false;
+}
+
 int
 get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
 {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 6444887d..d3193daf 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -56,6 +56,7 @@ int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev,
 	    int allow_fallback);
+bool is_vpd_page_supported(int fd, int pg);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index fa4ac5d9..f771a830 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -496,13 +496,15 @@ check_rdac(struct path * pp)
 {
 	int len;
 	char buff[44];
-	const char *checker_name;
+	const char *checker_name = NULL;
 
 	if (pp->bus != SYSFS_BUS_SCSI)
 		return 0;
-	/* Avoid ioctl if this is likely not an RDAC array */
-	if (__do_set_from_hwe(checker_name, pp, checker_name) &&
-	    strcmp(checker_name, RDAC))
+	/* Avoid checking 0xc9 if this is likely not an RDAC array */
+	if (!__do_set_from_hwe(checker_name, pp, checker_name) &&
+	    !is_vpd_page_supported(pp->fd, 0xC9))
+		return 0;
+	if (checker_name && strcmp(checker_name, RDAC))
 		return 0;
 	len = get_vpd_sgio(pp->fd, 0xC9, 0, buff, 44);
 	if (len <= 0)
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

