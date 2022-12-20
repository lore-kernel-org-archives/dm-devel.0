Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57ABDC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 20 Dec 2022 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671579726;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YMYRWeuOEk73siD+EVzs2CZva+XXz2KJ2ic8NlnfqS0=;
	b=EJFQz1jsTywTuIyu/T9SNOT6SEOODu/W3ZNu0Eh085uePfUPvIaDtl7tOlSj1ggpKFL/h1
	K6hTx3VWq4QE9uF4/VEpMnmPxPQTw0VoiN5AzmYLYTHwf3UqMjSVaYmVWXTOf0sV2C89uI
	EXj2VNtUALWw1x0cfxTLZXm1XT6Ey0M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-3e0YBd_hPM2lG2IpqcPKuA-1; Tue, 20 Dec 2022 18:41:34 -0500
X-MC-Unique: 3e0YBd_hPM2lG2IpqcPKuA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ADBE85C6E4;
	Tue, 20 Dec 2022 23:41:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B77B9492C14;
	Tue, 20 Dec 2022 23:41:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90B5D1947054;
	Tue, 20 Dec 2022 23:41:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BB5A1947053
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Dec 2022 23:41:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5FB5E492B02; Tue, 20 Dec 2022 23:41:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B920492B00;
 Tue, 20 Dec 2022 23:41:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BKNfOJT023720;
 Tue, 20 Dec 2022 17:41:24 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BKNfNsJ023719;
 Tue, 20 Dec 2022 17:41:23 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 20 Dec 2022 17:41:15 -0600
Message-Id: <1671579675-23658-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
References: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 6/6] libmultipath: orphan paths if coalesce_paths
 frees newmp
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If coalesce_paths() is called without a mpvec, it will free all the
multipath devices on newmp at the end. This will clear pp->mpp from the
path, but it doesn't completely unitialize them. cli_add_map() can call
coalsce_paths() this way, when adding a device that doesn't currently
exist. cli_add_map() first creates the device in the kernel, and then
calls ev_add_map() to add it to multipathd. If something goes wrong in
ev_add_map(), the paths will still be initialized, even though they're
orphans.

Fix this by calling remove_map() to orphan the paths that belong to
the multipath devices being deleted by coalesce_paths().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index e551047a..e689f8a7 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1273,8 +1273,11 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 	ret = CP_OK;
 out:
 	free(size_mismatch_seen);
-	if (!mpvec)
-		free_multipathvec(newmp, KEEP_PATHS);
+	if (!mpvec) {
+		vector_foreach_slot (newmp, mpp, i)
+			remove_map(mpp, vecs->pathvec, NULL);
+		vector_free(newmp);
+	}
 	return ret;
 }
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

