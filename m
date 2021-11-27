Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC090C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:23:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-YOr8V8wQPi-e3wPJShc7bQ-1; Sat, 27 Nov 2021 10:23:05 -0500
X-MC-Unique: YOr8V8wQPi-e3wPJShc7bQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 577B71006AA0;
	Sat, 27 Nov 2021 15:23:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DD6C19D9F;
	Sat, 27 Nov 2021 15:23:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1CDF21826D01;
	Sat, 27 Nov 2021 15:23:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFKfP8000683 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:20:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CE7902026D7F; Sat, 27 Nov 2021 15:20:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9B7C2026D65
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B188D805B0A
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:41 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-72-bJD37J3bM0u43qVVqJhG0Q-1; Sat, 27 Nov 2021 10:20:37 -0500
X-MC-Unique: bJD37J3bM0u43qVVqJhG0Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E230212CC;
	Sat, 27 Nov 2021 15:20:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52F2A13AAD;
	Sat, 27 Nov 2021 15:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id +OIcEsRMomFrFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:20:36 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:20:02 +0100
Message-Id: <20211127152006.8035-8-mwilck@suse.com>
In-Reply-To: <20211127152006.8035-1-mwilck@suse.com>
References: <20211127152006.8035-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFKfP8000683
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 07/11] multipathd: drop unnecessary path layout
	calls
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

In cli_list_map_fmt(), we only need field widths for map properties,
not for path properties. In json ouput, we need no field width padding
at all. Likewise in the prstatus related functions.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 1b563e7..db7646b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -277,8 +277,7 @@ cli_list_map_json (void *v, struct strbuf *reply, void *data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 
-	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
+        param = convert_dev(param, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
@@ -400,7 +399,6 @@ cli_list_map_fmt (void *v, struct strbuf *reply, void *data)
 	char * fmt = get_keyparam(v, FMT);
 
 	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
 	get_multipath_layout(vecs->mpvec, 1);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 	if (!mpp)
@@ -1266,8 +1264,7 @@ cli_getprstatus (void * v, struct strbuf *reply, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 
-	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
+        param = convert_dev(param, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
@@ -1291,7 +1288,6 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 	char * param = get_keyparam(v, MAP);
 
 	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
@@ -1314,7 +1310,6 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 	char * param = get_keyparam(v, MAP);
 
 	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

