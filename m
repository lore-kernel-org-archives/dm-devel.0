Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E852DC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 17:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639590278;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g3ajkRhHSVgcjfS2qCcE2cXPRyrxWthb8skn8mktDL4=;
	b=bmJA8ZLWy1gzGFIDAEt2yVhNT6maRn7Pdr/dZx1MHvngZtbA3m4m1THYMyzF7H9jYvGiwT
	xWshA1fLbRbN7CagRQV7xfW+0hWXkeShHIm0z900sZuW6Niwa4c41PZWi0JaVBwdv/ojPB
	y1wOBYzVcGaHQEzE/zJideml3PHcyHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-1mLSDYgPM-OxHQbixTmUCw-1; Wed, 15 Dec 2021 12:44:34 -0500
X-MC-Unique: 1mLSDYgPM-OxHQbixTmUCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28A091937FC1;
	Wed, 15 Dec 2021 17:44:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E96C4D73A;
	Wed, 15 Dec 2021 17:44:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DD2851806D03;
	Wed, 15 Dec 2021 17:44:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BFHiOOO018413 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 12:44:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CD9461037F3A; Wed, 15 Dec 2021 17:44:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B28511037F36;
	Wed, 15 Dec 2021 17:44:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BFHiEMv011339; 
	Wed, 15 Dec 2021 11:44:15 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BFHiEXq011338;
	Wed, 15 Dec 2021 11:44:14 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 15 Dec 2021 11:44:09 -0600
Message-Id: <1639590250-11293-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
References: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 2/3] multipathd: update dm_info on multipath
	change events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When multipathd gets a change event for a multipath device, the dm info
may have changed, so update it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index fe40f6e3..2e99a266 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -818,6 +818,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 		conf = get_multipath_config();
 		reassign_maps = conf->reassign_maps;
 		put_multipath_config(conf);
+		dm_get_info(mpp->alias, &mpp->dmi);
 		if (mpp->wait_for_udev) {
 			mpp->wait_for_udev = 0;
 			if (get_delayed_reconfig() &&
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

