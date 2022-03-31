Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77C2C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 06:49:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-HBqCh6tUOyC7xaz13YCQSQ-1; Mon, 04 Apr 2022 02:48:39 -0400
X-MC-Unique: HBqCh6tUOyC7xaz13YCQSQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0E0E899EC5;
	Mon,  4 Apr 2022 06:48:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C05561468702;
	Mon,  4 Apr 2022 06:48:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA468194036B;
	Mon,  4 Apr 2022 06:48:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE58A19451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 22:03:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C1F3B40C1438; Thu, 31 Mar 2022 22:03:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BDE15400F8FD
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 22:03:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 735C8800B28
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 22:03:28 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-bOPzKmYvMm2kiiizqR-ghQ-1; Thu, 31 Mar 2022 18:03:20 -0400
X-MC-Unique: bOPzKmYvMm2kiiizqR-ghQ-1
Received: by mail-ed1-f41.google.com with SMTP id b15so874753edn.4;
 Thu, 31 Mar 2022 15:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=TIkpZXU6eDpzo3cMVd1sBQyW2EHQ/n+w+rqxQP5ETUw=;
 b=dWVOjCJzyPamC9Xg1Fl7KONwocsNrRfHPGk0Cdp41S+nc55swsuPspS4VkuvNKmlla
 HOspOCJ0ihq/b/7XEZc0YcV6++VMNAmeRVO0D7a97CmPPyoHpPEssgMFbz9uBbhH6K4b
 iVywLuRFYzt4i9w9bpt8txCsUa1Za2R3HErwDeOSpRwDxzwVQmygiCqz/J2SPB+qbBgF
 GKdRDeXlnhyJH/eAm/qD9HR+5TGZ27kK3KxzDmQKFkKEkoU+WXAxp/zVQoL3XbajFMdz
 SOWPnsn8IPEjAVhUPedWWOGzIMWyYcJIJJsuyLRB7NZCkTkIH7u9zUQEBh1+QQMPVPek
 VQTA==
X-Gm-Message-State: AOAM530IWnucvaGiHdi35eiN52nCZaphhHpfCY7ABgHwoWpmZkYawpX8
 AORYzh3ZL1GMnb0WhXrERU9tuq1LxDwVmg==
X-Google-Smtp-Source: ABdhPJwrocf5wfA3uY8P68HIYW1QfY4wsiYuxLMBN3abwaj3bbyno9YqIO5Vdj98GczqduyWM46BQw==
X-Received: by 2002:aa7:c64c:0:b0:418:ecf7:afaa with SMTP id
 z12-20020aa7c64c000000b00418ecf7afaamr18660269edr.38.1648764199045; 
 Thu, 31 Mar 2022 15:03:19 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl.
 [62.195.130.160]) by smtp.googlemail.com with ESMTPSA id
 sb15-20020a1709076d8f00b006dfe4cda58fsm247312ejc.95.2022.03.31.15.03.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 31 Mar 2022 15:03:18 -0700 (PDT)
From: Jakob Koschel <jakobkoschel@gmail.com>
To: Alasdair Kergon <agk@redhat.com>
Date: Fri,  1 Apr 2022 00:02:35 +0200
Message-Id: <20220331220236.884887-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 04 Apr 2022 06:48:34 +0000
Subject: [dm-devel] [PATCH 1/2] dm snapshot: remove usage of list iterator
 for list_add() after the loop body
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
Cc: Mike Snitzer <snitzer@redhat.com>, Cristiano Giuffrida <c.giuffrida@vu.nl>,
 "Bos, H.J." <h.j.bos@vu.nl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Jakob Koschel <jakobkoschel@gmail.com>,
 Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Mike Rapoport <rppt@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer to point to the found element
[1].

Before, the code implicitly used the head when no element was found
when using &pos->list. Since the new variable is only set if an
element was found, the list_add() is performed within the loop
and only done after the loop if it is done on the list head directly.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/md/dm-snap.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 0d336b5ec571..23386a6e67e7 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -528,13 +528,17 @@ static int __validate_exception_handover(struct dm_snapshot *snap)
 
 static void __insert_snapshot(struct origin *o, struct dm_snapshot *s)
 {
-	struct dm_snapshot *l;
+	struct dm_snapshot *l = NULL, *iter;
 
 	/* Sort the list according to chunk size, largest-first smallest-last */
-	list_for_each_entry(l, &o->snapshots, list)
-		if (l->store->chunk_size < s->store->chunk_size)
+	list_for_each_entry(iter, &o->snapshots, list)
+		if (iter->store->chunk_size < s->store->chunk_size) {
+			l = iter;
+			list_add_tail(&s->list, &iter->list);
 			break;
-	list_add_tail(&s->list, &l->list);
+		}
+	if (!l)
+		list_add_tail(&s->list, &o->snapshots);
 }
 
 /*

base-commit: f82da161ea75dc4db21b2499e4b1facd36dab275
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

