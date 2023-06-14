Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A6EEB64DC
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 07:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686813748;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bm2VYBk1+jE4Vhqej+u/+S08XQ0Suq8IejiakfCXhaY=;
	b=cQ+s/gz+z8ZlrdfZtVx3cOdk4PO+p5WEQ3D3nMGb+t5/W/Ygmvw+qHTkqBLXpJr9RSadTg
	HklRf1gPJx0KtmhAxQD36bc7QBeRWvVCqJqpzyztT5Hf8gt8ApDHeyyYl4wbpQvKiuZAvP
	/29HorAQmDj8Stj9Otno32UFdhy+y6Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-_XRSH4BMNyq8rA5slewSEg-1; Thu, 15 Jun 2023 03:22:25 -0400
X-MC-Unique: _XRSH4BMNyq8rA5slewSEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4051185A791;
	Thu, 15 Jun 2023 07:22:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82CE2C1603B;
	Thu, 15 Jun 2023 07:22:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9C3D81946A43;
	Thu, 15 Jun 2023 07:22:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FD15194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 07:51:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D3D909E93; Wed, 14 Jun 2023 07:51:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CCD7A2956
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:51:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6CBB3C02574
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:51:56 +0000 (UTC)
Received: from mail.208.org (183.242.55.162 [183.242.55.162]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-b61HCAkwPGOdoCKWdrkr3w-1; Wed,
 14 Jun 2023 03:51:54 -0400
X-MC-Unique: b61HCAkwPGOdoCKWdrkr3w-1
Received: from mail.208.org (email.208.org [127.0.0.1])
 by mail.208.org (Postfix) with ESMTP id 4QgyLB29jMzBQJZ7
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 15:51:46 +0800 (CST)
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
 by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id R7n_klA_tSed for <dm-devel@redhat.com>;
 Wed, 14 Jun 2023 15:51:46 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
 by mail.208.org (Postfix) with ESMTPSA id 4QgyLB0MFCzBQJYq;
 Wed, 14 Jun 2023 15:51:46 +0800 (CST)
MIME-Version: 1.0
Date: Wed, 14 Jun 2023 15:51:45 +0800
From: baomingtong001@208suo.com
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com
In-Reply-To: <20230614074927.4072-1-luojianhong@cdjrlc.com>
References: <20230614074927.4072-1-luojianhong@cdjrlc.com>
User-Agent: Roundcube Webmail
Message-ID: <6b5a89f9478bae992bedf18dead1e60c@208suo.com>
X-Sender: baomingtong001@208suo.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 15 Jun 2023 07:22:20 +0000
Subject: [dm-devel] [PATCH] dm: remove unneeded variable from ql_status()
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
Cc: linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: 208suo.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

fix the following coccicheck warning:

drivers/md/dm-ps-queue-length.c:90:14-16: Unneeded variable: "sz". 
Return "0".

Signed-off-by: Mingtong Bao <baomingtong001@208suo.com>
---
  drivers/md/dm-ps-queue-length.c | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-ps-queue-length.c 
b/drivers/md/dm-ps-queue-length.c
index e305f05ad1e5..59411d0a2083 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -87,7 +87,6 @@ static void ql_destroy(struct path_selector *ps)
  static int ql_status(struct path_selector *ps, struct dm_path *path,
               status_type_t type, char *result, unsigned int maxlen)
  {
-    unsigned int sz = 0;
      struct path_info *pi;

      /* When called with NULL path, return selector status/args. */
@@ -109,7 +108,7 @@ static int ql_status(struct path_selector *ps, 
struct dm_path *path,
          }
      }

-    return sz;
+    return 0;
  }

  static int ql_add_path(struct path_selector *ps, struct dm_path *path,

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

