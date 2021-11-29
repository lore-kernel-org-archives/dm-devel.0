Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB2DC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:10:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-mD_EjdTUPhmKBofCMTESXA-1; Mon, 29 Nov 2021 15:10:29 -0500
X-MC-Unique: mD_EjdTUPhmKBofCMTESXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC45D102C8D4;
	Mon, 29 Nov 2021 20:10:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF0BA76608;
	Mon, 29 Nov 2021 20:10:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 872164A7C9;
	Mon, 29 Nov 2021 20:10:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATK9hD7001899 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 15:09:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0D31340CFD11; Mon, 29 Nov 2021 20:09:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 07B9640CFD05
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4144185A7BA
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:42 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-5-UVKStD0YODmq-VtyfISm0g-1; Mon, 29 Nov 2021 15:09:41 -0500
X-MC-Unique: UVKStD0YODmq-VtyfISm0g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1CE42177B;
	Mon, 29 Nov 2021 20:09:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 88C2813EB0;
	Mon, 29 Nov 2021 20:09:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id CFg/H4MzpWFsHgAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 29 Nov 2021 20:09:39 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 29 Nov 2021 21:08:56 +0100
Message-Id: <20211129200902.21817-8-mwilck@suse.com>
In-Reply-To: <20211129200902.21817-1-mwilck@suse.com>
References: <20211129200902.21817-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ATK9hD7001899
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 07/13] multipathd: drop unnecessary path
	layout calls
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 multipathd/cli_handlers.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 1b563e7..1b7f258 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -278,7 +278,6 @@ cli_list_map_json (void *v, struct strbuf *reply, void *data)
 	char * param = get_keyparam(v, MAP);
 
 	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 
 	if (!mpp)
@@ -400,7 +399,6 @@ cli_list_map_fmt (void *v, struct strbuf *reply, void *data)
 	char * fmt = get_keyparam(v, FMT);
 
 	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
 	get_multipath_layout(vecs->mpvec, 1);
 	mpp = find_mp_by_str(vecs->mpvec, param);
 	if (!mpp)
@@ -1267,7 +1265,6 @@ cli_getprstatus (void * v, struct strbuf *reply, void * data)
 	char * param = get_keyparam(v, MAP);
 
 	param = convert_dev(param, 0);
-	get_path_layout(vecs->pathvec, 0);
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

