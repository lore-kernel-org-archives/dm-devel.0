Return-Path: <SRS0=Tx5l=NY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A70C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:03:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4CBC60724
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:03:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E4CBC60724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630620193;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p19JDSE8AhzyMeoT5bWAvHyxNJaBlHns2VAvIip1GZo=;
	b=GPZ4Nnd6q2M6hb/BmcmvebAKeK15ZBvEY5ukl7KtF/rbvK3kIXWuWLHhL3zuOdoqi+tqq/
	gJX+xZHBMApWLcj+tiIg7EQuGEvtrs0sAt4Gwchz828SxeMVR5WFqpAv9x9oWadgmeZymy
	sjP63j/Pba44UODy0hL9aXD78QiKMY0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-n3flX8aqMceKcdT7j49gjA-1; Thu, 02 Sep 2021 18:03:11 -0400
X-MC-Unique: n3flX8aqMceKcdT7j49gjA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 418B418766DB;
	Thu,  2 Sep 2021 22:03:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13ECD5D9FC;
	Thu,  2 Sep 2021 22:03:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B174A1806D0F;
	Thu,  2 Sep 2021 22:03:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 182Lvwrc013347 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Sep 2021 17:57:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6C09F6A91F; Thu,  2 Sep 2021 21:57:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 843CC6A8F8;
	Thu,  2 Sep 2021 21:57:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 182LvrJZ012299; 
	Thu, 2 Sep 2021 16:57:54 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 182LvrTp012298;
	Thu, 2 Sep 2021 16:57:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  2 Sep 2021 16:57:45 -0500
Message-Id: <1630619869-12251-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
References: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 2/6] mpathpersist: fail commands when no
	usable paths exist
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

"mpathpersist -oCK <reservation_key> <device>" will return success if it
is run on devices with no usable paths, but nothing is actually done.
The -L command will fail, but it should give up sooner, and with a more
helpful error message.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 190e9707..26710e79 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -604,7 +604,8 @@ int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
 			return ret ;
 		}
 	}
-	return MPATH_PR_SUCCESS;
+	condlog (0, "%s: no path available", mpp->wwid);
+	return MPATH_PR_DMMP_ERROR;
 }
 
 int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
@@ -663,6 +664,11 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 
 	active_pathcount = count_active_paths(mpp);
 
+	if (active_pathcount == 0) {
+		condlog (0, "%s: no path available", mpp->wwid);
+		return MPATH_PR_DMMP_ERROR;
+	}
+
 	struct threadinfo thread[active_pathcount];
 	memset(thread, 0, sizeof(thread));
 	for (i = 0; i < active_pathcount; i++){
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

