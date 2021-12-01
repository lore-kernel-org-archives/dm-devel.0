Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36831C4332F
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-lzwNvCeGM1SRNL5DylOBKA-1; Wed, 01 Dec 2021 07:37:35 -0500
X-MC-Unique: lzwNvCeGM1SRNL5DylOBKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A60293930;
	Wed,  1 Dec 2021 12:37:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C8E745D64;
	Wed,  1 Dec 2021 12:37:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 33E3B1809CB8;
	Wed,  1 Dec 2021 12:37:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbDb2008770 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 848BBC15E73; Wed,  1 Dec 2021 12:37:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80819C15E72
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46D9F8032EB
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:13 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-1-A4juPbVtPnmSL7iB0qpxQQ-1; Wed, 01 Dec 2021 07:37:11 -0500
X-MC-Unique: A4juPbVtPnmSL7iB0qpxQQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 44DDE21155;
	Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0D1FB13FF5;
	Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id yApUAXZsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:10 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:49 +0100
Message-Id: <20211201123650.16240-21-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbDb2008770
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 20/21] libmultipath (coverity): check return
	values in dm_get_multipath()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Coverity CID 374151.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 1dc83df..c0eb335 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1294,8 +1294,10 @@ struct multipath *dm_get_multipath(const char *name)
 	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
 		goto out;
 
-	dm_get_uuid(name, mpp->wwid, WWID_SIZE);
-	dm_get_info(name, &mpp->dmi);
+	if (dm_get_uuid(name, mpp->wwid, WWID_SIZE) != 0)
+		condlog(2, "%s: failed to get uuid for %s", __func__, name);
+	if (dm_get_info(name, &mpp->dmi) != 0)
+		condlog(2, "%s: failed to get info for %s", __func__, name);
 
 	return mpp;
 out:
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

