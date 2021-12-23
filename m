Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0611FC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 23 Dec 2021 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640223205;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gEofLU5fIeMuaZb0YwpN/66pB6tirEjE9yeZddkW9OE=;
	b=DoJHMBN4ieUGXfYyvCczKfHVUqTQWN0IiKz/lUuE2l+LQQHdODVCNB6+BPK1W9ZnnAqlCq
	7zq5LI1OeBFiZitnsRiWekr77Dw7/uaW/54mTUXOkpSpDgqyphHTmqeyrBV9rBQLBe5GVF
	KWGI1Q6wCLa2AY+HxcnsKleXqud3FPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-2cda00a0NfWbTuCgQ3PLag-1; Wed, 22 Dec 2021 20:33:22 -0500
X-MC-Unique: 2cda00a0NfWbTuCgQ3PLag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26A22100E32B;
	Thu, 23 Dec 2021 01:33:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A78E104253B;
	Thu, 23 Dec 2021 01:33:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D85A71809CB8;
	Thu, 23 Dec 2021 01:33:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BN1WlHq009285 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 22 Dec 2021 20:32:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 14FA277478; Thu, 23 Dec 2021 01:32:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A86D577C8A;
	Thu, 23 Dec 2021 01:32:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BN1Weu6001726; 
	Wed, 22 Dec 2021 19:32:40 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BN1Wdku001725;
	Wed, 22 Dec 2021 19:32:39 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 22 Dec 2021 19:32:34 -0600
Message-Id: <1640223155-1678-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1640223155-1678-1-git-send-email-bmarzins@redhat.com>
References: <1640223155-1678-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 2/3] libmultipath: simplify out
	__set_no_path_retry()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The only caller of __set_no_path_retry() is set_no_path_retry(), so
remove the define and the unneeded arguments from the function.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version |  2 +-
 libmultipath/structs_vec.c        | 11 +++++------
 libmultipath/structs_vec.h        |  3 +--
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 7cdce9fc..2d0c9f26 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -176,7 +176,7 @@ global:
 	select_reservation_key;
 	send_packet;
 	set_max_fds;
-	__set_no_path_retry;
+	set_no_path_retry;
 	set_path_removed;
 	set_prkey;
 	setup_map;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index cb0ebae6..f1031f61 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -588,23 +588,22 @@ static void leave_recovery_mode(struct multipath *mpp)
 	}
 }
 
-void __set_no_path_retry(struct multipath *mpp, bool check_features)
+void set_no_path_retry(struct multipath *mpp)
 {
 	bool is_queueing = false; /* assign a value to make gcc happy */
 
-	check_features = check_features && mpp->features != NULL;
-	if (check_features)
+	if (mpp->features)
 		is_queueing = strstr(mpp->features, "queue_if_no_path");
 
 	switch (mpp->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
 		break;
 	case NO_PATH_RETRY_FAIL:
-		if (!check_features || is_queueing)
+		if (!mpp->features || is_queueing)
 			dm_queue_if_no_path(mpp->alias, 0);
 		break;
 	case NO_PATH_RETRY_QUEUE:
-		if (!check_features || !is_queueing)
+		if (!mpp->features || !is_queueing)
 			dm_queue_if_no_path(mpp->alias, 1);
 		break;
 	default:
@@ -613,7 +612,7 @@ void __set_no_path_retry(struct multipath *mpp, bool check_features)
 			 * If in_recovery is set, leave_recovery_mode() takes
 			 * care of dm_queue_if_no_path. Otherwise, do it here.
 			 */
-			if ((!check_features || !is_queueing) &&
+			if ((!mpp->features || !is_queueing) &&
 			    !mpp->in_recovery)
 				dm_queue_if_no_path(mpp->alias, 1);
 			leave_recovery_mode(mpp);
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index d33fe984..3253f1bb 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -11,8 +11,7 @@ struct vectors {
 	struct mutex_lock lock; /* defined in lock.h */
 };
 
-void __set_no_path_retry(struct multipath *mpp, bool check_features);
-#define set_no_path_retry(mpp) __set_no_path_retry(mpp, true)
+void set_no_path_retry(struct multipath *mpp);
 
 int adopt_paths (vector pathvec, struct multipath * mpp);
 void orphan_path (struct path * pp, const char *reason);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

