Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7573BCCA473
	for <dm-devel@archiver.kernel.org>; Tue, 21 Jun 2022 07:21:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-c1uMBbniMCG5voy_7RWeMA-1; Tue, 21 Jun 2022 03:21:19 -0400
X-MC-Unique: c1uMBbniMCG5voy_7RWeMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71713185A7A4;
	Tue, 21 Jun 2022 07:21:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7474A40E80E0;
	Tue, 21 Jun 2022 07:21:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C0C81947041;
	Tue, 21 Jun 2022 07:21:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AA82A1947042
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Jun 2022 07:13:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8959440CFD0B; Tue, 21 Jun 2022 07:13:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8588B40CFD0A
 for <dm-devel@redhat.com>; Tue, 21 Jun 2022 07:13:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D7273C02185
 for <dm-devel@redhat.com>; Tue, 21 Jun 2022 07:13:15 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-tzkvUnTyOIuzUZUrmv_ldQ-1; Tue, 21 Jun 2022 03:13:13 -0400
X-MC-Unique: tzkvUnTyOIuzUZUrmv_ldQ-1
Received: by mail-pl1-f169.google.com with SMTP id d5so11721600plo.12;
 Tue, 21 Jun 2022 00:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=+hte8AP5nf1klbLq0oX8P2OsV4GT1ocQRuako+1trRU=;
 b=RwfbKp1EyQkdzkeyYnT1/bjVGtphDiqYXVRW8vuNcqUiPuZIxsqCwYlLbr5zMOPFaQ
 cKRuLFzJ0aE8V5RmmEnCOysffin3qwmST+kw6OXyaL1TuCOxyjNyv2e1aIK0HcF0cYT8
 CJKF/rHGtnsc4CeahqzYf6iCR3E5xLxn3lXLmh3vvpo1Kd4gb6R8mxLRmbwwMxcI3F9w
 X4hFap2XAU/7Nvgsq1nLU0F5k/G5VVBhv9LPeINs8zCa0VWuIRr3ItbKTVcNWKaC2JEk
 WF8IGzOMrb1/NrOFWd5n1yECDmybjROv0PlOc5vvXBYNw4nSy+77tWyRXXw9suTbvWei
 2tPQ==
X-Gm-Message-State: AJIora/Jv4+U/ET8HNMnVwcyyxpprPg9iBHuu7drIUUY7nNMt8bxzUse
 b0cyTiqqGQVLVQaoQfI/18c+fuzG1YMqAkZ+
X-Google-Smtp-Source: AGRyM1sowog3TGzznepPSpPDlmdgPlk3Xw00kqu9HSCjnpSysKBPoHHNxtLp9WxjGqu195sNzA4u+A==
X-Received: by 2002:a17:902:7248:b0:167:95e2:f83c with SMTP id
 c8-20020a170902724800b0016795e2f83cmr27826774pll.74.1655795591658; 
 Tue, 21 Jun 2022 00:13:11 -0700 (PDT)
Received: from longfanaikebuke.Dlink (36-236-237-46.dynamic-ip.hinet.net.
 [36.236.237.46]) by smtp.gmail.com with ESMTPSA id
 d21-20020a056a0010d500b005251c3e7ac5sm4375310pfu.166.2022.06.21.00.13.10
 (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
 Tue, 21 Jun 2022 00:13:11 -0700 (PDT)
From: Steven Lung <1030steven@gmail.com>
To: agk@redhat.com
Date: Tue, 21 Jun 2022 15:12:59 +0800
Message-Id: <20220621071259.4008-1-1030steven@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Tue, 21 Jun 2022 07:21:11 +0000
Subject: [dm-devel] [PATCH] dm cache: fix typo
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
Cc: Steven Lung <1030steven@gmail.com>, dm-devel@redhat.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace neccessarily with necessarily.

Signed-off-by: Steven Lung <1030steven@gmail.com>
---
 drivers/md/dm-cache-metadata.h | 2 +-
 drivers/md/dm-cache-target.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index 179ed5bf8..0905f2c16 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -131,7 +131,7 @@ void dm_cache_dump(struct dm_cache_metadata *cmd);
  * hints will be lost.
  *
  * The hints are indexed by the cblock, but many policies will not
- * neccessarily have a fast way of accessing efficiently via cblock.  So
+ * necessarily have a fast way of accessing efficiently via cblock.  So
  * rather than querying the policy for each cblock, we let it walk its data
  * structures and fill in the hints in whatever order it wishes.
  */
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 28c5de8ec..54a8d5c9a 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2775,7 +2775,7 @@ static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
 
 /*
  * The discard block size in the on disk metadata is not
- * neccessarily the same as we're currently using.  So we have to
+ * necessarily the same as we're currently using.  So we have to
  * be careful to only set the discarded attribute if we know it
  * covers a complete block of the new size.
  */
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

