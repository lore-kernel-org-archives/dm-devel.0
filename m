Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 126AAC3F6B0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 21:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660081599;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=reyJI8wp2je1+vkKw78HE6dhkBv+07BXaldfs7TtQdY=;
	b=CdAZDd5Rr4MhFXreqWf95jcj+ZL+SQZsJm/5BXI3DAvx4Cbv4xVhUOo+H6bXwCBmjq+rs9
	9LbaFcCNbFZZjkf48Y5h/bJm9IKnS5+Ddvdfj6vzkGCOsWDSnk7rrH0JToKxiP0C5VImDJ
	z6MkiXT57jXudT669T71mAB3vxXSAqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-860ZRzSmPbWnWwz9axcCoA-1; Tue, 09 Aug 2022 17:46:37 -0400
X-MC-Unique: 860ZRzSmPbWnWwz9axcCoA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAAD0185A7B2;
	Tue,  9 Aug 2022 21:46:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C90A61121314;
	Tue,  9 Aug 2022 21:46:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6501B1946A4C;
	Tue,  9 Aug 2022 21:46:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D0A0B1946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 21:46:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD21014152E0; Tue,  9 Aug 2022 21:46:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE95E140EBE3;
 Tue,  9 Aug 2022 21:46:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 279LkWYE023328;
 Tue, 9 Aug 2022 16:46:32 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 279LkWtF023327;
 Tue, 9 Aug 2022 16:46:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue,  9 Aug 2022 16:46:28 -0500
Message-Id: <1660081588-23278-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1660081588-23278-1-git-send-email-bmarzins@redhat.com>
References: <1660081588-23278-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 3/3] multipathd: Handle losing all path in
 update_map
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Its possible that when a multipath device is being updated, it will end
up that all the paths for it are gone. This can happen if paths are
added and then removed again before multipathd processes the uevent for
the newly created multipath device. In this case multipathd wasn't
taking the proper action for the case where all the paths had been
removed. If flush_on_last_del was set, multipathd wasn't disabling
flushing and if deferred_remove was set, it wasn't doing a deferred
remove. Multipathd should call flush_map_nopaths(), just like
ev_remove_path() does when the last path is removed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1380dd8b..f2890842 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -602,6 +602,10 @@ retry:
 		goto fail;
 	}
 	verify_paths(mpp);
+	if (VECTOR_SIZE(mpp->paths) == 0 &&
+	    flush_map_nopaths(mpp, vecs))
+		return 1;
+
 	mpp->action = ACT_RELOAD;
 
 	if (mpp->prflag) {
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

