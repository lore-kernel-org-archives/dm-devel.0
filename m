Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E01C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 31 May 2022 10:25:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-wbyxyGk_PbO3ywfUXjbafw-1; Tue, 31 May 2022 06:25:19 -0400
X-MC-Unique: wbyxyGk_PbO3ywfUXjbafw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02181294EDC4;
	Tue, 31 May 2022 10:25:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A9F77492C3B;
	Tue, 31 May 2022 10:25:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59B191947061;
	Tue, 31 May 2022 10:25:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A2BDA194705C
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 May 2022 10:25:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8628D2026D07; Tue, 31 May 2022 10:25:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80DFE2026D64
 for <dm-devel@redhat.com>; Tue, 31 May 2022 10:25:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65D6618A6503
 for <dm-devel@redhat.com>; Tue, 31 May 2022 10:25:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-Z3WnrD7xPEG2zk6a4Nwchg-1; Tue, 31 May 2022 06:25:12 -0400
X-MC-Unique: Z3WnrD7xPEG2zk6a4Nwchg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 7D07A1F8E9;
 Tue, 31 May 2022 10:25:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3E97E13AA2;
 Tue, 31 May 2022 10:25:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Qut5DQftlWJPLwAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 31 May 2022 10:25:11 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 31 May 2022 12:24:45 +0200
Message-Id: <20220531102445.18518-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH] libmultipath,
 kpartx: fix callers of dm_get_next_target()
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
Cc: lixiaokeng@huawei.com, Wu Guanghao <wuguanghao3@huawei.com>,
 dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

dm_get_next_target() may return NULL for target_type and params
in some situations. Follows the same idea as the previous patch
"dm_get_map: fix segfault when can't found target" by Wu Guanghao.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c       |  6 ++++--
 libmultipath/devmapper.c | 10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 49ffd31..bf14c78 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -412,8 +412,10 @@ dm_get_map(const char *mapname, char * outparams)
 		goto out;
 
 	/* Fetch 1st target */
-	dm_get_next_target(dmt, NULL, &start, &length,
-			   &target_type, &params);
+	if (dm_get_next_target(dmt, NULL, &start, &length,
+			       &target_type, &params) != NULL || !params)
+		/* more than one target or not found target */
+		goto out;
 
 	if (snprintf(outparams, PARAMS_SIZE, "%s", params) <= PARAMS_SIZE)
 		r = 0;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 9819e29..1ada3fb 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1715,6 +1715,16 @@ int dm_reassign_table(const char *name, char *old, char *new)
 	do {
 		next = dm_get_next_target(dmt, next, &start, &length,
 					  &target, &params);
+		if (!target || !params) {
+			/*
+			 * We can't call dm_task_add_target() with
+			 * invalid parameters. But simply dropping this
+			 * target feels wrong, too. Abort and warn.
+			 */
+			condlog(1, "%s: invalid target found in map %s",
+				__func__, name);
+			goto out_reload;
+		}
 		buff = strdup(params);
 		if (!buff) {
 			condlog(3, "%s: failed to replace target %s, "
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

