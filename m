Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA992C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 06:48:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251--ka1ThtBOUCopl2ekvTcaQ-1; Mon, 04 Apr 2022 02:48:40 -0400
X-MC-Unique: -ka1ThtBOUCopl2ekvTcaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A757899EC1;
	Mon,  4 Apr 2022 06:48:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2780B1468707;
	Mon,  4 Apr 2022 06:48:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB5F9193F6E7;
	Mon,  4 Apr 2022 06:48:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A99C194035F
 for <dm-devel@listman.corp.redhat.com>; Sun,  3 Apr 2022 03:41:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2236140D3F86; Sun,  3 Apr 2022 03:41:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D4B540D3F6E
 for <dm-devel@redhat.com>; Sun,  3 Apr 2022 03:41:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 038811C05157
 for <dm-devel@redhat.com>; Sun,  3 Apr 2022 03:41:17 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-p35w2WkyOHCtqekcrxDriQ-1; Sat, 02 Apr 2022 23:41:14 -0400
X-MC-Unique: p35w2WkyOHCtqekcrxDriQ-1
Received: by mail-pj1-f54.google.com with SMTP id u14so1935200pjj.0;
 Sat, 02 Apr 2022 20:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=wKcnleMWX6fErDylcJrWaDMR8n2XsKTiHTFRkseuUTs=;
 b=PIzuEwuwsmydKNBtKmmDIOBZLT4glTRnCnf7zxmlQm+UcGxmsRk6Ayg+S8FUTQKXcN
 dTLP/YSLD/6E5Jw6Q0QH9slmV6Z8dyzOvGh5bRciNFgir9yuaBPOvYayGOWgnDDY6DGV
 zrh+wknfwUbpb2nuvAbj4V9Og0VCSm6L12mbBn/29xf9jkLOzKaHZLxRNPp3vI02gB78
 zg6HRrWQQLFkf55zLWqh3H+/N+SLMU060SCme6XHBMK3bL9PJw87PNOOksxvufbogr1L
 ZFRrgZe7fxl7qFDKlbuBxpeg4PZao9RfF6pTOZX3mYzw2yXvaxIuWjF9cQnr2U8Lsumu
 gI+g==
X-Gm-Message-State: AOAM530h+OIdPstbRfSZvaAEhDGpW9MhwuFFNahEH1CKbaJRQELe2woe
 uFTXKgq1Qh/HTsQyOq6yc2SvNfxA67s=
X-Google-Smtp-Source: ABdhPJyOFt+eICj3S8tPcD+56WBb2Tz2iwGW0YkRJ1H3Gfxu6b7msnMxRZJJaW6aZLzixAXzPEC6wA==
X-Received: by 2002:a17:902:7e0d:b0:156:47a4:a7c4 with SMTP id
 b13-20020a1709027e0d00b0015647a4a7c4mr17487903plm.141.1648957272910; 
 Sat, 02 Apr 2022 20:41:12 -0700 (PDT)
Received: from localhost.localdomain ([183.156.181.188])
 by smtp.googlemail.com with ESMTPSA id
 x14-20020aa784ce000000b004fa79973c94sm7215598pfn.165.2022.04.02.20.41.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Apr 2022 20:41:12 -0700 (PDT)
From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
To: agk@redhat.com,
	snitzer@redhat.com,
	dm-devel@redhat.com
Date: Sun,  3 Apr 2022 11:41:01 +0800
Message-Id: <20220403034101.14735-1-xiam0nd.tong@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 04 Apr 2022 06:48:34 +0000
Subject: [dm-devel] [PATCH v2] md: dm-mpath: use list iterator only inside
 the loop
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
Cc: Xiaomeng Tong <xiam0nd.tong@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

To move the declare of list iterator into the list_for_each_entry_*()
macro in the future, it should be avoided to use the list iterator
variable after the loop body [1].

Because the cases (the list is empty or no entry is found) have been
checked prior to iterating m->priority_groups, it is fine to move the
bypass_pg(m, pg, bypassed); inside the loop when entry is found.

[1]: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes since v1:
 - it is not a bug, have checked before (Mike Snitzer)
 - tweak code to avoid dead code "return -EINVAL;" (Xiaomeng Tong)

v1: https://lore.kernel.org/lkml/20220327053742.2942-1-xiam0nd.tong@gmail.com/

---
 drivers/md/dm-mpath.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f4719b65e5e3..13c65eab32a2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1496,11 +1496,12 @@ static int bypass_pg_num(struct multipath *m, const char *pgstr, bool bypassed)
 	}
 
 	list_for_each_entry(pg, &m->priority_groups, list) {
-		if (!--pgnum)
+		if (!--pgnum) {
+			bypass_pg(m, pg, bypassed);
 			break;
+		}
 	}
 
-	bypass_pg(m, pg, bypassed);
 	return 0;
 }
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

