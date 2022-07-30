Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB01C04A68
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jul 2022 05:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659158020;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zgp71+ZUCJVuPmudQ07qsoiMfjfu3LM/THeo9ls4caI=;
	b=A8TXVo+B4sQWKpyyz1/+9UpOi0B6gpXADYSGfcWhoJ4pKV2Z6/VJ7wO1cjKYF1brwZ8PD2
	QcZ9U2Y9saP6+ADSAepR9yRr/DFQQ86kJlq3h7ABA6nDnivWoEmc5ibv+rfzd00C/IKdK6
	OFe1SRNxKio66gaAdQy66TD/7UcRNM4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-DnxFudDvNgG0Bck4dtjAPA-1; Sat, 30 Jul 2022 01:13:36 -0400
X-MC-Unique: DnxFudDvNgG0Bck4dtjAPA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE9FE281137E;
	Sat, 30 Jul 2022 05:13:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE116492CA2;
	Sat, 30 Jul 2022 05:13:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 249651923A94;
	Sat, 30 Jul 2022 05:13:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D890B19256F4
 for <dm-devel@listman.corp.redhat.com>; Sat, 30 Jul 2022 05:13:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CB2E5403D0E0; Sat, 30 Jul 2022 05:13:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BD0DD4047D22;
 Sat, 30 Jul 2022 05:13:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 26U5D9SQ024141;
 Sat, 30 Jul 2022 00:13:09 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 26U5D8ku024140;
 Sat, 30 Jul 2022 00:13:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Sat, 30 Jul 2022 00:12:59 -0500
Message-Id: <1659157980-24079-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
References: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 5/6] multipathd: fix uxlsnr timeout
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
Cc: Wu Guanghao <wuguanghao3@huawei.com>,
 device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

check_timeout() is called whenever it's time to handle a client, and if
it detects a timeout, it will switch to the CLT_SEND state.  However it
may already be in the CLT_SEND state, and may have already sent the
length, and possibly some data. Restarting the CLT_SEND state will cause
it to restart sending the length, messing up communication with the
client. If we are already sending a reply to the client, we should just
finish the send. Disable timeouts in the CLT_SEND state.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/uxlsnr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 04bcd020..23cb123d 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -405,10 +405,11 @@ static void set_client_state(struct client *c, int state)
 	case CLT_RECV:
 		reset_strbuf(&c->reply);
 		memset(c->cmd, '\0', sizeof(c->cmd));
-		c->expires = ts_zero;
 		c->error = 0;
 		/* fallthrough */
 	case CLT_SEND:
+		/* no timeout while waiting for the client or sending a reply */
+		c->expires = ts_zero;
 		/* reuse these fields for next data transfer */
 		c->len = c->cmd_len = 0;
 		break;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

