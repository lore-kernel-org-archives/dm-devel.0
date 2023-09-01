Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BFCCA0FF7
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591418;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z/cs1gcOYLai8ievTzsgbQcSzuam0RmGFv5SxocU+FI=;
	b=CbrGFiZntSx6jQGnDA+oKsk95EJrR+QjUY+b0JxLLJuDwNdu9VMhjFmFWoVaMUF1qvadBq
	gcPB+fGUxKdSMEJ3Hk0TXJbV3VV+pbMkvqiIEnWXfxF69bJfWK3OO5vGLMmKEAQJ1SuH43
	qbJbNP45ubXbCRnyKqSiuvqCK1jGlWA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-dpfKINGzOkea2zoRwASMrg-1; Fri, 01 Sep 2023 14:03:35 -0400
X-MC-Unique: dpfKINGzOkea2zoRwASMrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E14C429AB44F;
	Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CA8681208F6F;
	Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A40A819472B2;
	Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6FF6319472B6
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5D4EDD4781B; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56BFED4781A
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B74092ACE1
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-WRQecNqvMxi7UWK_pgfFyw-1; Fri,
 01 Sep 2023 14:03:23 -0400
X-MC-Unique: WRQecNqvMxi7UWK_pgfFyw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 918812186C;
 Fri,  1 Sep 2023 18:03:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63DEA13582;
 Fri,  1 Sep 2023 18:03:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 4DmJFmon8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:22 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:33 +0200
Message-ID: <20230901180235.23980-21-mwilck@suse.com>
In-Reply-To: <20230901180235.23980-1-mwilck@suse.com>
References: <20230901180235.23980-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 20/21] libmultipath: dm_get_uuid(): return emtpy
 UUID for non-existing maps
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

libdevmapper will most probably not return a UUID for non-existing
maps anyway. But it's cheap to double-check here.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 248c373..9be82f4 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -706,12 +706,16 @@ dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
 {
 	struct dm_task *dmt;
 	const char *uuidtmp;
+	struct dm_info info;
 	int r = 1;
 
 	dmt = libmp_dm_task_create(DM_DEVICE_INFO);
 	if (!dmt)
 		return 1;
 
+	if (uuid_len > 0)
+		uuid[0] = '\0';
+
 	if (!dm_task_set_name (dmt, name))
 		goto uuidout;
 
@@ -720,11 +724,13 @@ dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
 		goto uuidout;
 	}
 
+	if (!dm_task_get_info(dmt, &info) ||
+	    !info.exists)
+		goto uuidout;
+
 	uuidtmp = dm_task_get_uuid(dmt);
 	if (uuidtmp)
 		strlcpy(uuid, uuidtmp, uuid_len);
-	else
-		uuid[0] = '\0';
 
 	r = 0;
 uuidout:
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

