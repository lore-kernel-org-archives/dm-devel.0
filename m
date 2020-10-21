Return-Path: <SRS0=YCRG=D4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6A0C4363A
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:41:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ABA93223C7
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VGNQ6INu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABA93223C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603316516;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=J+kMJPn7mZ7B8dwe0hCwammhCgnLAZMnU+9zCmoKb0Y=;
	b=VGNQ6INuzoDGQrryl5xQfSW6m2a5tQNEvhYg70M8bwDPgNab2AqZeYi4KWFMohokz6RLhn
	gA4HT0WH1T4KE9Im0Gosxt4jEHUAixmfrGkWxKG70Ncs6zPc4v1bRnAWzAal0YYjeqJPcS
	GCr33z8qFksDgpKQoR+xkWGAhRrj4x0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-B0RskObANMKoWki3NXjEgA-1; Wed, 21 Oct 2020 17:41:54 -0400
X-MC-Unique: B0RskObANMKoWki3NXjEgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 295E25F9C1;
	Wed, 21 Oct 2020 21:41:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB63C5C5AF;
	Wed, 21 Oct 2020 21:41:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD102181A06D;
	Wed, 21 Oct 2020 21:41:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09LLdXSR008760 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Oct 2020 17:39:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 05A4B5B4C0; Wed, 21 Oct 2020 21:39:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E62E5B4BE;
	Wed, 21 Oct 2020 21:39:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09LLdU9p028791; 
	Wed, 21 Oct 2020 16:39:30 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09LLdUmR028790;
	Wed, 21 Oct 2020 16:39:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 21 Oct 2020 16:39:26 -0500
Message-Id: <1603316366-28735-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
References: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 4/4] libmultipath: change log level for null
	uid_attribute
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If uid_attribute is explicitly set to an empty string, multipath should
log the uid at the default log level, since using the fallback code is
the expected behavior.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d7e8577f..950b1586 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2084,8 +2084,11 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 			len = strlen(pp->wwid);
 		origin = "callout";
 	} else {
-		bool udev_available = udev && pp->uid_attribute
+		bool valid_uid_attr = pp->uid_attribute
 			&& *pp->uid_attribute;
+		bool empty_uid_attr = pp->uid_attribute
+			&& !*pp->uid_attribute;
+		bool udev_available = udev && valid_uid_attr;
 
 		if (udev_available) {
 			len = get_udev_uid(pp, pp->uid_attribute, udev);
@@ -2095,7 +2098,8 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 		}
 		if ((!udev_available || (len <= 0 && allow_fallback))
 		    && has_uid_fallback(pp)) {
-			used_fallback = 1;
+			if (!udev || !empty_uid_attr)
+				used_fallback = 1;
 			len = uid_fallback(pp, path_state, &origin);
 		}
 	}
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

