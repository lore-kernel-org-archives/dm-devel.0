Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D0AC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 23 Dec 2021 01:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640223200;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uVeO0q2zlJAh69fjsJR3oTU358wcGEqllW0R+138KPo=;
	b=af3NRC/2LbKlbrkdtKBUqrIu7QBcAdSF6Pfx+m4R6YetVJmYJCx31hqjnu8RkGRXpRRO8f
	kG3pQTI4wq4sIBTolilzPLYuv4QA9sF9re3/J5uCnWcRqHRtR17LXEOGtNUqJXIDju2PUi
	i+DrisCCH7dyc5xX8z4AShkZngKDd2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-6LYUX7SGPb-K7pBaf759Xg-1; Wed, 22 Dec 2021 20:33:17 -0500
X-MC-Unique: 6LYUX7SGPb-K7pBaf759Xg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 260AB100E325;
	Thu, 23 Dec 2021 01:33:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71E5B104253B;
	Thu, 23 Dec 2021 01:33:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3FCB61809CB8;
	Thu, 23 Dec 2021 01:33:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BN1Wi7P009270 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 22 Dec 2021 20:32:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 408DF7EE89; Thu, 23 Dec 2021 01:32:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 959D77EE6B;
	Thu, 23 Dec 2021 01:32:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BN1WcRS001722; 
	Wed, 22 Dec 2021 19:32:38 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BN1WbZc001721;
	Wed, 22 Dec 2021 19:32:37 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 22 Dec 2021 19:32:33 -0600
Message-Id: <1640223155-1678-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1640223155-1678-1-git-send-email-bmarzins@redhat.com>
References: <1640223155-1678-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 1/3] libmultipath: fix DI_NOIO pathinfo
	PATH_PENDING handling
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

pp->state should only be set to PATH_PENDING if it is currently in
the PATH_UNCHECKED or PATH_WILD states. Otherwise, it should retain
its current state.  Fix this in pathinfo() calls with DI_NOIO, to
match with the rest of the code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7d939ae0..6e5d1005 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2345,7 +2345,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			 * Avoid any IO on the device itself.
 			 * simply use the path_offline() return as its state
 			 */
-			pp->chkrstate = pp->state = path_state;
+			if (path_state != PATH_PENDING ||
+			    pp->state == PATH_UNCHECKED ||
+			    pp->state == PATH_WILD)
+				pp->chkrstate = pp->state = path_state;
 		return PATHINFO_OK;
 	}
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

