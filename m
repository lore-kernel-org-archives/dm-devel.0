Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD73C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118468;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=szb8Heb1G+MIsrUJywuiP3FjrWaH6TSp4lW/G5SJchk=;
	b=Bpmc3MsRJZKfELD0aAvUJeLLIyfrgTM8cWfYnEVxBpV4SzzwPNltWtO5RCdMDiikIM0+Rr
	ZWor/euMPb5hQy7bEqc+Zaocax47eWdAPBzIF+Jfn3iq36nxj8rw6gjum+YEFRDe65jBq8
	epR59qqOSjM3AQY04qkhbxoPqNtFl/g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-sVlL7Oe7NVqHdLJlgKvs9Q-1; Wed, 06 Jul 2022 10:40:36 -0400
X-MC-Unique: sVlL7Oe7NVqHdLJlgKvs9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D3318339C1;
	Wed,  6 Jul 2022 14:38:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D84032166B26;
	Wed,  6 Jul 2022 14:38:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 29186194706E;
	Wed,  6 Jul 2022 14:38:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0EBCD1947063
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E467E18ECB; Wed,  6 Jul 2022 14:38:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD90618EC9
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDFDC3C0F37A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:42 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-aOg0O8q6NhyoYWLN6mx8XQ-1; Wed, 06 Jul 2022 10:38:39 -0400
X-MC-Unique: aOg0O8q6NhyoYWLN6mx8XQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id CD4D91FE3E;
 Wed,  6 Jul 2022 14:38:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A0D3113ADA;
 Wed,  6 Jul 2022 14:38:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id yIWgJW2exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:37 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:09 +0200
Message-Id: <20220706143822.30182-2-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 01/14] libmultipath: alua: remove get_sysfs_pg83()
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

Since b72e753 ("libmultipath: alua: try to retrieve inquiry data from sysfs"),
we fetch inquiry and VPD data from sysfs anyway. No need to do this twice.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/alua_rtpg.c | 57 ++++++++-------------------
 1 file changed, 16 insertions(+), 41 deletions(-)

diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 3f9c0e7..4db13c2 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -228,25 +228,6 @@ get_target_port_group_support(const struct path *pp, unsigned int timeout)
 	return rc;
 }
 
-static int
-get_sysfs_pg83(const struct path *pp, unsigned char *buff, int buflen)
-{
-	struct udev_device *parent = pp->udev;
-
-	while (parent) {
-		const char *subsys = udev_device_get_subsystem(parent);
-		if (subsys && !strncmp(subsys, "scsi", 4))
-			break;
-		parent = udev_device_get_parent(parent);
-	}
-
-	if (!parent || sysfs_get_vpd(parent, 0x83, buff, buflen) <= 0) {
-		PRINT_DEBUG("failed to read sysfs vpd pg83");
-		return -1;
-	}
-	return 0;
-}
-
 int
 get_target_port_group(const struct path * pp, unsigned int timeout)
 {
@@ -265,32 +246,26 @@ get_target_port_group(const struct path * pp, unsigned int timeout)
 	}
 
 	memset(buf, 0, buflen);
+	rc = do_inquiry(pp, 1, 0x83, buf, buflen, timeout);
+	if (rc < 0)
+		goto out;
 
-	rc = get_sysfs_pg83(pp, buf, buflen);
-
-	if (rc < 0) {
+	scsi_buflen = get_unaligned_be16(&buf[2]) + 4;
+	if (scsi_buflen >= USHRT_MAX)
+		scsi_buflen = USHRT_MAX;
+	if (buflen < scsi_buflen) {
+		free(buf);
+		buf = (unsigned char *)malloc(scsi_buflen);
+		if (!buf) {
+			PRINT_DEBUG("malloc failed: could not allocate"
+				    "%u bytes", scsi_buflen);
+			return -RTPG_RTPG_FAILED;
+		}
+		buflen = scsi_buflen;
+		memset(buf, 0, buflen);
 		rc = do_inquiry(pp, 1, 0x83, buf, buflen, timeout);
 		if (rc < 0)
 			goto out;
-
-		scsi_buflen = get_unaligned_be16(&buf[2]) + 4;
-		/* Paranoia */
-		if (scsi_buflen >= USHRT_MAX)
-			scsi_buflen = USHRT_MAX;
-		if (buflen < scsi_buflen) {
-			free(buf);
-			buf = (unsigned char *)malloc(scsi_buflen);
-			if (!buf) {
-				PRINT_DEBUG("malloc failed: could not allocate"
-					    "%u bytes", scsi_buflen);
-				return -RTPG_RTPG_FAILED;
-			}
-			buflen = scsi_buflen;
-			memset(buf, 0, buflen);
-			rc = do_inquiry(pp, 1, 0x83, buf, buflen, timeout);
-			if (rc < 0)
-				goto out;
-		}
 	}
 
 	vpd83 = (struct vpd83_data *) buf;
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

