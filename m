Return-Path: <SRS0=xkgx=EQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB5FC388F7
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:44:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08B3220781
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HXPc9yBr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08B3220781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605012263;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rKLfVpVlIZNlgBXgfzKLDhy8ajv+MWv4W+WdrAQbNXA=;
	b=HXPc9yBrb+bHG+Qo7F0lXyZdiQqnNync1W55z/edG8ibM/oVVqIrhWmFNx/XnA1V+HxUL/
	bNgnv1E2Cozq3Y23GCMULTmiuBinbjfuH/VMTdJufBFVph3hBgjI/4UJAHvSv7o+G7YTbp
	V2AB2UNFjHCRVkwzmIqk1tnxzWMun1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-eCnM5R5oOvmgm1dQ2xyPzQ-1; Tue, 10 Nov 2020 07:44:21 -0500
X-MC-Unique: eCnM5R5oOvmgm1dQ2xyPzQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44C2F809DDC;
	Tue, 10 Nov 2020 12:44:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A9C46EF4A;
	Tue, 10 Nov 2020 12:44:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C70B1800B72;
	Tue, 10 Nov 2020 12:44:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AACiAf3026756 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 10 Nov 2020 07:44:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7E35C9F6B; Tue, 10 Nov 2020 12:44:10 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB4B8610F3;
	Tue, 10 Nov 2020 12:44:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 0AACi14j002382; Tue, 10 Nov 2020 07:44:01 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 0AACi1VH002376; Tue, 10 Nov 2020 07:44:01 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Tue, 10 Nov 2020 07:44:01 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Message-ID: <alpine.LRH.2.02.2011100743130.19628@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm writecache: advance the number of arguments
 when reporting max_age
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When we report the "max_age" value, we must advance the number of
arguments by two.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 3923d4854e18 ("dm writecache: implement gradual cleanup")
Cc: stable@vger.kernel.org	# v5.7+

---
 drivers/md/dm-writecache.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-11-10 11:09:53.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-11-10 13:29:52.000000000 +0100
@@ -2479,6 +2479,8 @@ static void writecache_status(struct dm_
 			extra_args += 2;
 		if (wc->autocommit_time_set)
 			extra_args += 2;
+		if (wc->max_age != MAX_AGE_UNSPECIFIED)
+			extra_args += 2;
 		if (wc->cleaner)
 			extra_args++;
 		if (wc->writeback_fua_set)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

