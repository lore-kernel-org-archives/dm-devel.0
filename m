Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF86C61DB3
	for <dm-devel@archiver.kernel.org>; Thu, 12 Jan 2023 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673555345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5R8H1eJK/v6HeALvJM5y2Mcc1DnpH/1sL4jgJHJe2a0=;
	b=D6eNhVUxOm456X2pl8P77/yClF7JGoaWTO9+B0yb2BrzvEBLX0DcdJXu+AYj7rYftJFoNK
	DkBKSH1ZBdwlo7Qt6fCHIZuZqR6qV5UAzUqi3PD7lD0k1/n0luZLffPGSD0Bm+sj21aIoN
	d9tRfb2pDjJn9/OpFj5M+HWOasvnGmk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-R8A_q1aqNi6jhGihqebaUw-1; Thu, 12 Jan 2023 15:29:03 -0500
X-MC-Unique: R8A_q1aqNi6jhGihqebaUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B293858F09;
	Thu, 12 Jan 2023 20:29:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B66F32166B26;
	Thu, 12 Jan 2023 20:28:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 820421947050;
	Thu, 12 Jan 2023 20:28:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4E7311946A78
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 Jan 2023 20:28:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3328814171C8; Thu, 12 Jan 2023 20:28:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 191A814171C5;
 Thu, 12 Jan 2023 20:28:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 30CKSqR4009898;
 Thu, 12 Jan 2023 14:28:52 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 30CKSqbe009897;
 Thu, 12 Jan 2023 14:28:52 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 12 Jan 2023 14:28:49 -0600
Message-Id: <1673555329-9850-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1673555329-9850-1-git-send-email-bmarzins@redhat.com>
References: <1673555329-9850-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 2/2] libmultipath: remove pathgroup wildcard
 options
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
 Nitin Yewale <nyewale@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitin Yewale <nyewale@redhat.com>

The multipathd command "multipathd show wildcards" shows the pathgroup
format wildcards, but there is no way to use them in a multipathd
command.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 3193dbe0..9df77247 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -865,13 +865,6 @@ int snprint_wildcards(struct strbuf *buff)
 				       pd[i].wildcard, pd[i].header)) < 0)
 			return rc;
 
-	if ((rc = append_strbuf_str(buff, "\npathgroup format wildcards:\n")) < 0)
-		return rc;
-	for (i = 0; i < ARRAY_SIZE(pgd); i++)
-		if ((rc = print_strbuf(buff, "%%%c  %s\n",
-				       pgd[i].wildcard, pgd[i].header)) < 0)
-			return rc;
-
 	return get_strbuf_len(buff) - initial_len;
 }
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

