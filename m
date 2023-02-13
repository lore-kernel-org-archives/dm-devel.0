Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3403C636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319297;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ps3QJJ9wSmCI4TFZiQcT6v2cF+fjFnXeC1RLOZibxa8=;
	b=OnXCOFUNZmgT7HfKR1mB6iIHOIJq19U2wEMtG69V1c+kId+fNXxIZWuo3NnhHLTXGeLfgm
	VMyzrtY2eFkKd5B497aJmQNulHc6c8/ndh/MMRaE1pKLKRqqBTRqumMsRTJ7nqIzuEJloW
	D35zOreVbkKuStBZ2pb6cUNvB0HAzD0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-anZruNssMF67JVDeIubcbg-1; Mon, 13 Feb 2023 15:14:55 -0500
X-MC-Unique: anZruNssMF67JVDeIubcbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6128A800B24;
	Mon, 13 Feb 2023 20:14:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F87A1121318;
	Mon, 13 Feb 2023 20:14:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D1EB194658C;
	Mon, 13 Feb 2023 20:14:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D6DD11946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C84FE40B40C9; Mon, 13 Feb 2023 20:14:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C049440CF8ED
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2EF13815F63
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:51 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-SnBGdJC8P56TTsI2VpucRw-4; Mon, 13 Feb 2023 15:14:50 -0500
X-MC-Unique: SnBGdJC8P56TTsI2VpucRw-4
Received: by mail-qt1-f175.google.com with SMTP id 5so15176290qtp.9
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=H/k1mVHeY5VIltVb9/d2/ws/LWCw0FbXzRxKq6m/iDg=;
 b=LJjekUA2i/pu+NCvg2JOAq71fsUzjAB5QtIlY9n1RUcAPkN2siqwQHPJ172IPhMD50
 0eOjLzM+EJjoGF7nOwyPTiHmE0Qyp3kZNS8NIjNEWcyot/p4H7MjmvTkJFLNcjmwIXy2
 f5HQlXD70EKLJegEM7takPpPpiG7c4FB06zmKbcTkE3JYPPb5qMQmlFv67o2kVqePh6B
 1WJYonq3Te/8V4dNpglZ8Mn01xn6juHRfCUUEDgfon0W4n/XJ+XKNhDp+K1OPq/QCuCf
 OOrg3yRjzGsV3iYNLOHQLN/IDRoJUF14swSl12W63jog+3AOsPhaPZ4aBluoe1tbNptg
 efAQ==
X-Gm-Message-State: AO0yUKXGv8TX+SC7e3PKPBPIcr6dksSrRhWOax6IGNDiubTuACCK38I7
 t6GpH7UgMBRTYb9wppAB+YhlcVuzoR1YgRizp4EwwXwfEs8jVcrf/GK8WqkfpXA5DBSOy2FBxk1
 Zs45RVz6lFwT9LgJCdt8F8qAgS67wAcPVG35QmNpOA2UtR5cOAaJa5EIIBjlLZxipM48xmA==
X-Google-Smtp-Source: AK7set8JSeuD+nqBvUSRWjcmOmwIAfnV1Iw6EUBBOKOM8sB/VWCoyuygie/P5Q+S4hgttEnbfczLJg==
X-Received: by 2002:a05:622a:3cf:b0:3bb:8de4:474e with SMTP id
 k15-20020a05622a03cf00b003bb8de4474emr22397892qtx.37.1676319289177; 
 Mon, 13 Feb 2023 12:14:49 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 d10-20020ac800ca000000b003b0b903720esm9964414qtg.13.2023.02.13.12.14.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:48 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:35 -0500
Message-Id: <20230213201401.45973-14-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 13/39] dm crypt: correct 'foo*' to 'foo *'
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-crypt.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2af24a6ad81a..168f49e20beb 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -988,20 +988,20 @@ static int crypt_iv_elephant(struct crypt_config *cc, struct dm_crypt_request *d
 	}
 
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
-		diffuser_disk_to_cpu((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_b_decrypt((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_a_decrypt((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_cpu_to_disk((__le32*)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_disk_to_cpu((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_b_decrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_a_decrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_cpu_to_disk((__le32 *)data_offset, cc->sector_size / sizeof(u32));
 	}
 
 	for (i = 0; i < (cc->sector_size / 32); i++)
 		crypto_xor(data_offset + i * 32, ks, 32);
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		diffuser_disk_to_cpu((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_a_encrypt((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_b_encrypt((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_cpu_to_disk((__le32*)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_disk_to_cpu((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_a_encrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_b_encrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_cpu_to_disk((__le32 *)data_offset, cc->sector_size / sizeof(u32));
 	}
 
 	kunmap_local(data);
@@ -1265,7 +1265,7 @@ static unsigned int *org_tag_of_dmreq(struct crypt_config *cc,
 {
 	u8 *ptr = iv_of_dmreq(cc, dmreq) + cc->iv_size +
 		  cc->iv_size + sizeof(uint64_t);
-	return (unsigned int*)ptr;
+	return (unsigned int *)ptr;
 }
 
 static void *tag_from_dmreq(struct crypt_config *cc,
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

