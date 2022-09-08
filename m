Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117D9ECAAD3
	for <dm-devel@archiver.kernel.org>; Thu,  8 Sep 2022 00:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662597121;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7TC4YTJHh7GIEp01/6+aA9ExGj7A81UDC8Xf01q8u+E=;
	b=Fn84WLD4AgQNlHnyz2lJhsdanZlolEJssEodTHFcnuOIu0sFPPomoud6ZFqOCCU3c301H/
	2mCwB7ce/QpDqllpMfqKd/Hd65J8x4JsTLokp8MpxII1W9GoU5LtEzz1GJdHm2+wQsbbn0
	8qL6NerV0MxGrNjfprX4w8sw/dL/guc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-4LA3XydsPXC66iz6uOos-g-1; Wed, 07 Sep 2022 20:31:58 -0400
X-MC-Unique: 4LA3XydsPXC66iz6uOos-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE55F803520;
	Thu,  8 Sep 2022 00:31:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 55FA890A04;
	Thu,  8 Sep 2022 00:31:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1D3F61946A48;
	Thu,  8 Sep 2022 00:31:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A3DC1946A44
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Sep 2022 00:31:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12D761415117; Thu,  8 Sep 2022 00:31:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F39C31415102;
 Thu,  8 Sep 2022 00:31:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2880VpKO022359;
 Wed, 7 Sep 2022 19:31:51 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2880Vpno022358;
 Wed, 7 Sep 2022 19:31:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  7 Sep 2022 19:31:50 -0500
Message-Id: <1662597110-22321-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH] multipathd: fix read past end of of buffer in
 sending reply
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reduce the send() length for the uxlsnr reply, by the number of bytes
already sent

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/uxlsnr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 23cb123d..238744b7 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -541,7 +541,7 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 		if (c->len < c->cmd_len) {
 			const char *buf = get_strbuf_str(&c->reply);
 
-			n = send(c->fd, buf + c->len, c->cmd_len, MSG_NOSIGNAL);
+			n = send(c->fd, buf + c->len, c->cmd_len - c->len, MSG_NOSIGNAL);
 			if (n == -1) {
 				if (!(errno == EAGAIN || errno == EINTR))
 					c->error = -ECONNRESET;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

