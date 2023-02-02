Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2710C61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 08:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675327374;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ps7ekv6q3exCTS7+JfQi/20gB1M+m6EjAHq+VyIPTvk=;
	b=RWTrqHCw6Cc3cggR1BFOzzmHHBYhplT+WN4eaJfOqJpjDZbJ6KvCGAbmIMiooe5l//NCmO
	HyB3MG2J+1qut7cgoDpVw2gdYQGTuBIcVUSdVt4lnche1qN58nT58dSgqMQhK6XQzySkJk
	G409Hx4ruy9NIe73M5kEFjn+8D1bMMA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-wV0LpxmMNfe9Xce7g563uA-1; Thu, 02 Feb 2023 03:42:50 -0500
X-MC-Unique: wV0LpxmMNfe9Xce7g563uA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3547B886C62;
	Thu,  2 Feb 2023 08:42:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B36AA404BEC0;
	Thu,  2 Feb 2023 08:42:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CD5D194658C;
	Thu,  2 Feb 2023 08:42:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 91E341946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 08:42:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3CD4340C1073; Thu,  2 Feb 2023 08:42:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 33E8240C1423
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 08:42:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07A7729A9D43
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 08:42:28 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-479-zCw9HeQKPc6wJJPi4MOPNQ-1; Thu,
 02 Feb 2023 03:42:24 -0500
X-MC-Unique: zCw9HeQKPc6wJJPi4MOPNQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 42ED6341E0;
 Thu,  2 Feb 2023 08:42:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 16C24138E8;
 Thu,  2 Feb 2023 08:42:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id B/HiA29322OhJwAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 02 Feb 2023 08:42:23 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  2 Feb 2023 09:42:20 +0100
Message-Id: <20230202084220.17447-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH] libmpathpersist: fix resource leak in
 update_map_pr()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The "no available paths" case would leak the memory resp points to.
Found by coverity.

Fixes: 50e2c16 ("multipathd: handle no active paths in update_map_pr")

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 8b52b74..178c2f5 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -733,7 +733,7 @@ int update_map_pr(struct multipath *mpp)
 	int noisy=0;
 	struct prin_resp *resp;
 	unsigned int i;
-	int ret, isFound;
+	int ret = MPATH_PR_OTHER, isFound;
 
 	if (!get_be64(mpp->reservation_key))
 	{
@@ -754,7 +754,7 @@ int update_map_pr(struct multipath *mpp)
 	{
 		condlog(0,"%s: No available paths to check pr status",
 			mpp->alias);
-		return MPATH_PR_OTHER;
+		goto out;
 	}
 	mpp->prflag = PRFLAG_UNSET;
 	ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp, noisy);
@@ -762,15 +762,15 @@ int update_map_pr(struct multipath *mpp)
 	if (ret != MPATH_PR_SUCCESS )
 	{
 		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
-		free(resp);
-		return  ret;
+		goto out;
 	}
 
+	ret = MPATH_PR_SUCCESS;
+
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
 		condlog(3,"%s: No key found. Device may not be registered. ", mpp->alias);
-		free(resp);
-		return MPATH_PR_SUCCESS;
+		goto out;
 	}
 
 	condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias,
@@ -795,6 +795,7 @@ int update_map_pr(struct multipath *mpp)
 		condlog(2, "%s: prflag flag set.", mpp->alias );
 	}
 
+out:
 	free(resp);
-	return MPATH_PR_SUCCESS;
+	return ret;
 }
-- 
2.39.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

