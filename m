Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC13AECAAD2
	for <dm-devel@archiver.kernel.org>; Mon, 29 Aug 2022 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661793434;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2O8K0UF8S9o2+iUf0n4tXGpTw34NiWBr1eUaivjO8Jk=;
	b=NfMceCf+sADMwYBITP0e+pb3zq3iDLqfLgdKsoZ6RpWCqVT9TtPisCMxFG0G9A58+eQx7Z
	WHwI72ESCEzakJ7hdv/tOGmvW+Oh5CWU6TR+G8tpwXPOGwZ6q69bekVbavnxNdj8e/thn5
	695UjTb+QmDwpuPMI4HKI0MyQn59BS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-tGaqlHpwPqSiONDzmaxOBw-1; Mon, 29 Aug 2022 13:17:11 -0400
X-MC-Unique: tGaqlHpwPqSiONDzmaxOBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78B3D185A7B2;
	Mon, 29 Aug 2022 17:17:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19D4C2026D4C;
	Mon, 29 Aug 2022 17:17:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC0FB1946A45;
	Mon, 29 Aug 2022 17:17:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB72A1946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 Aug 2022 17:17:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C036A492C3B; Mon, 29 Aug 2022 17:17:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF534403351;
 Mon, 29 Aug 2022 17:17:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 27THH6Ob025157;
 Mon, 29 Aug 2022 12:17:06 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 27THH5nG025154;
 Mon, 29 Aug 2022 12:17:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 29 Aug 2022 12:17:05 -0500
Message-Id: <1661793425-25103-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH] multipathd: check for command overflow
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The code to build the command string calls snprintf() in a loop, adding
the return value to the start pointer, c. Since snprintf() can return
more characters than it actually printed if it runs out of space, c can
end up pointing past the end of the command string buffer on sebsequent
loops.  Since the size argument to snprintf() is unsigned, after an
overflow it will be a huge number, instead of a negative one, meaning
that it will continue printing past the end of the buffer. Check for
overflow after each snprintf() to avoid this.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 5a408945..1032fb2a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3707,6 +3707,10 @@ main (int argc, char *argv[])
 					c += snprintf(c, s + CMDSIZE - c,
 						      "%s ", argv[optind]);
 				optind++;
+				if (c >= s + CMDSIZE) {
+					fprintf(stderr, "multipathd command too large\n");
+					exit(1);
+				}
 			}
 			c += snprintf(c, s + CMDSIZE - c, "\n");
 		}
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

