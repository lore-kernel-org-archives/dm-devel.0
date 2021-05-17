Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E939DC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 16:30:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9353B60FD9
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 16:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9353B60FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621269050;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qsaTeCJxarrX7TZh9EhCzk78CTW/7WS5oR8w6thrfW4=;
	b=id9Wvcx/W9b+ROjMuYsyMdHajBu0XOMP8tHD1zbdyluVWg6mm/8UZU10mC3gbDytw3ex5K
	yNHBKjyNmSgnm13wze0R56WrJBetu/Dyphxv8kMNNyOu/9f/SFz17L5eulN/0Erm7TBp/+
	swS4dDxzRhY4JmeYHrESBWGq8J1TBf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-b0q66crUOpmWiJ6_3u-YJw-1; Mon, 17 May 2021 12:30:48 -0400
X-MC-Unique: b0q66crUOpmWiJ6_3u-YJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02B5B192205F;
	Mon, 17 May 2021 16:30:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE87160C9B;
	Mon, 17 May 2021 16:30:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B060055353;
	Mon, 17 May 2021 16:30:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HGUeIH005300 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 12:30:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BD9C450400; Mon, 17 May 2021 16:30:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE81EBA63;
	Mon, 17 May 2021 16:30:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14HGU8SW006342; 
	Mon, 17 May 2021 11:30:08 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14HGU8hX006341;
	Mon, 17 May 2021 11:30:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 17 May 2021 11:29:59 -0500
Message-Id: <1621268999-6280-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1621268999-6280-1-git-send-email-bmarzins@redhat.com>
References: <1621268999-6280-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v4 6/6] multipathd: don't rescan_path on wwid
	change in uev_update_path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If get_uid() is returning a different wwid in uev_update_path(), then
the uid_attribute must have already gotten updated, which was the
purpose behind calling rescan_path() in the first place.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8e2beddd..2750f5e9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1359,7 +1359,6 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			condlog(0, "%s: path wwid changed from '%s' to '%s'",
 				uev->kernel, wwid, pp->wwid);
 			ev_remove_path(pp, vecs, 1);
-			rescan_path(uev->udev);
 			needs_reinit = 1;
 			goto out;
 		} else {
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

