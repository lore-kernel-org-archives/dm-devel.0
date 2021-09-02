Return-Path: <SRS0=Tx5l=NY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A394CC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:02:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 36BF360F12
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 36BF360F12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630620176;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xK9F6ZQIDfByQ/D4qN1aeVobYT3GQl1Xzk/mpRJiEm8=;
	b=aGjnEvvOwm/6XNq7nSGut4+CAQxiQUQh5m+HqnJo+A9lGMWgepAKIU9NXKeeOAbkULsXH2
	7un4pnjY7+c3a90cvgFn3IJjpgDeFssdb9E4ZDgV3//JfTg50T+Ehh/dWvi8aWYu7rFBJ/
	6IWs4NlbfEN0Klc1XRb3SkXTIlcOzS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-1bMYa3vZPbShyvtEwyGEug-1; Thu, 02 Sep 2021 18:02:53 -0400
X-MC-Unique: 1bMYa3vZPbShyvtEwyGEug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A199107ACCD;
	Thu,  2 Sep 2021 22:02:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 883F35D9FC;
	Thu,  2 Sep 2021 22:02:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 62F1E18087F1;
	Thu,  2 Sep 2021 22:02:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 182LvwP7013338 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Sep 2021 17:57:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3160860C4A; Thu,  2 Sep 2021 21:57:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4911260BF1;
	Thu,  2 Sep 2021 21:57:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 182LvqUW012295; 
	Thu, 2 Sep 2021 16:57:52 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 182LvqCV012294;
	Thu, 2 Sep 2021 16:57:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  2 Sep 2021 16:57:44 -0500
Message-Id: <1630619869-12251-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
References: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/6] multipath.conf: fix typo in ghost_delay
	description
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

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 064e4826..d6b8c7f6 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1251,7 +1251,7 @@ The default is: in \fB/sys/block/<dev>/queue/max_sectors_kb\fR
 Sets the number of seconds that multipath will wait after creating a device
 with only ghost paths before marking it ready for use in systemd. This gives
 the active paths time to appear before the multipath runs the hardware handler
-to switch the ghost paths to active ones. Setting this to \fI0\fR or \fIon\fR
+to switch the ghost paths to active ones. Setting this to \fI0\fR or \fIno\fR
 makes multipath immediately mark a device with only ghost paths as ready.
 .RS
 .TP
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

