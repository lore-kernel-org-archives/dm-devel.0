Return-Path: <SRS0=DHxF=KG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76683C433ED
	for <dm-devel@archiver.kernel.org>; Tue, 11 May 2021 23:22:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1690661626
	for <dm-devel@archiver.kernel.org>; Tue, 11 May 2021 23:22:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1690661626
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620775366;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A51yAflqaT9HeABK59H6mtWb7JHvaeBthx13IT50MbU=;
	b=Huq487SxXraD8jW1y5cmhNJMH3LxwNMn9YSsvzqhmwkcJzn3DhWgM7OueMBdh6DyQ3W3Y9
	1FXUm5Sse6G2mvaNEU7sdwY+1AKFez65PSSrqe16J4Ka3HdA4HiNeVCPL1ndpJ/r/O938Z
	vT0kpwZyORGUTtzREMwifqZ2wuFk5FI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-9O8_EVDmNWeeneq212Pq6Q-1; Tue, 11 May 2021 19:22:44 -0400
X-MC-Unique: 9O8_EVDmNWeeneq212Pq6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 565C76D506;
	Tue, 11 May 2021 23:22:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3972560C04;
	Tue, 11 May 2021 23:22:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0CF945535F;
	Tue, 11 May 2021 23:22:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14BNMDX7013354 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 May 2021 19:22:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4728F2C6FD; Tue, 11 May 2021 23:22:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77B1F2CF2C;
	Tue, 11 May 2021 23:22:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14BNM8Zv024034; 
	Tue, 11 May 2021 18:22:09 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14BNM8vN024033;
	Tue, 11 May 2021 18:22:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 11 May 2021 18:22:02 -0500
Message-Id: <1620775324-23984-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 3/5] multipathd: make ev_remove_path return
	success on path removal
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When ev_remove_path() returns success, callers assume that the path (and
possibly the map) has been removed.  When ev_remove_path() returns
failure, callers assume that the path has not been removed. However, the
path could be removed on both success or failure. This could cause
callers to dereference the path after it was removed. Change
ev_remove_path() to return success whenever the path is removed, even if
the map was removed due to a failure when trying to reload it. Found by
coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6090434c..4bdf14bd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1284,7 +1284,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 
 			strlcpy(devt, pp->dev_t, sizeof(devt));
 			if (setup_multipath(vecs, mpp))
-				return 1;
+				return 0;
 			/*
 			 * Successful map reload without this path:
 			 * sync_map_state() will free it.
@@ -1304,8 +1304,10 @@ out:
 	return retval;
 
 fail:
+	condlog(0, "%s: error removing path. removing map %s", pp->dev,
+		mpp->alias);
 	remove_map_and_stop_waiter(mpp, vecs);
-	return 1;
+	return 0;
 }
 
 static int
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

