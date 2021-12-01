Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFF3C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-579-oxTzD2cNOhmHo2AKNVmr6A-1; Wed, 01 Dec 2021 07:37:51 -0500
X-MC-Unique: oxTzD2cNOhmHo2AKNVmr6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D503874986;
	Wed,  1 Dec 2021 12:37:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA46510023AA;
	Wed,  1 Dec 2021 12:37:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C665718077BC;
	Wed,  1 Dec 2021 12:37:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbCfF008729 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AC39A401E2F; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7B5F401E44
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F3CA8022F4
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-406-Bkq54IWmPnWr3lh3XTJ4Cw-1; Wed, 01 Dec 2021 07:37:10 -0500
X-MC-Unique: Bkq54IWmPnWr3lh3XTJ4Cw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B3C621FD60;
	Wed,  1 Dec 2021 12:37:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7FDDF13FF5;
	Wed,  1 Dec 2021 12:37:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id mJ9QHXVsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:47 +0100
Message-Id: <20211201123650.16240-19-mwilck@suse.com>
In-Reply-To: <20211201123650.16240-1-mwilck@suse.com>
References: <20211201123650.16240-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbCfF008729
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 18/21] libmultipath (coverity): avoid sleeping
	in dm_mapname()
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

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index dd293aa..1dc83df 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1389,7 +1389,6 @@ dm_mapname(int major, int minor)
 	const char *map;
 	struct dm_task *dmt;
 	int r;
-	int loop = MAX_WAIT * LOOPS_PER_SEC;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_STATUS)))
 		return NULL;
@@ -1399,23 +1398,9 @@ dm_mapname(int major, int minor)
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

