Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 202B7C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACF7661A86
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ACF7661A86
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269--ZNnbbJiO5Sc5b35mb_V8g-1; Thu, 18 Nov 2021 18:20:39 -0500
X-MC-Unique: -ZNnbbJiO5Sc5b35mb_V8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8A8F87D542;
	Thu, 18 Nov 2021 23:20:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B06261000324;
	Thu, 18 Nov 2021 23:20:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8BDE14EA39;
	Thu, 18 Nov 2021 23:20:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AINEAA3005151 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 18:14:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3464540CFD12; Thu, 18 Nov 2021 23:14:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E52F40CFD11
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1654080B719
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:10 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-420-WrPheqZOOk-GiYuIEYJd_w-1; Thu, 18 Nov 2021 18:14:06 -0500
X-MC-Unique: WrPheqZOOk-GiYuIEYJd_w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0FC1B217BA;
	Thu, 18 Nov 2021 23:14:05 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C6ED513DC0;
	Thu, 18 Nov 2021 23:14:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id wPlJLjzelmGAQAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 23:14:04 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 19 Nov 2021 00:13:35 +0100
Message-Id: <20211118231338.22358-19-mwilck@suse.com>
In-Reply-To: <20211118231338.22358-1-mwilck@suse.com>
References: <20211118231338.22358-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AINEAA3005151
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 18/21] libmultipath (coverity): avoid sleeping in
	dm_mapname()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

dm_mapname is called while holding the vecs lock, and shouldn't
sleep. All callers handle a NULL return value.

This code dates back to the initial commit creating multipathd,
66b457b ("[multipathd]") from 2005. I am pretty certain that the comment
"device map might not be ready when we get here from uevent trigger"
doesn't hold any more (if it has ever been true). Perhaps the early
code acted on "add" events for maps, which would indeed not necessarily
have been set up. On the actually relevant "change" events, the map
name has to be set.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3e1a726..6c3ca1f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1390,7 +1390,6 @@ dm_mapname(int major, int minor)
 	const char *map;
 	struct dm_task *dmt;
 	int r;
-	int loop = MAX_WAIT * LOOPS_PER_SEC;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_STATUS)))
 		return NULL;
@@ -1400,23 +1399,9 @@ dm_mapname(int major, int minor)
 		goto bad;
 
 	dm_task_no_open_count(dmt);
-
-	/*
-	 * device map might not be ready when we get here from
-	 * daemon uev_trigger -> uev_add_map
-	 */
-	while (--loop) {
-		r = libmp_dm_task_run(dmt);
-
-		if (r)
-			break;
-
-		usleep(1000 * 1000 / LOOPS_PER_SEC);
-	}
-
+	r = libmp_dm_task_run(dmt);
 	if (!r) {
 		dm_log_error(2, DM_DEVICE_STATUS, dmt);
-		condlog(0, "%i:%i: timeout fetching map name", major, minor);
 		goto bad;
 	}
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

