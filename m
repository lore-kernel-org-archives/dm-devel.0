Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D19C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:55:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-5Hk-K2faMFS69NdrO__ufA-1; Mon, 21 Mar 2022 02:54:58 -0400
X-MC-Unique: 5Hk-K2faMFS69NdrO__ufA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E79A2A5957A;
	Mon, 21 Mar 2022 06:54:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AEBB400E554;
	Mon, 21 Mar 2022 06:54:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C42C019451F3;
	Mon, 21 Mar 2022 06:54:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 414421953552
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 20:18:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 008D253D8; Sat, 19 Mar 2022 20:18:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EFD7153D3
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 20:18:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F16029AB3E7
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 20:18:41 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
 [209.85.218.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-Mc5nfef7PLu7iodQnrujIQ-1; Sat, 19 Mar 2022 16:18:39 -0400
X-MC-Unique: Mc5nfef7PLu7iodQnrujIQ-1
Received: by mail-ej1-f51.google.com with SMTP id dr20so22633499ejc.6;
 Sat, 19 Mar 2022 13:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=IZVebcAv1gMSkhke8vkvP7hwXg0ZkCIulZG5b/+xBiY=;
 b=Hft8yGAN1n2dXAiCgBRPvydObTru1NujpBHEXlm62RALTLEDp2Wla7yKSDZ9ajHtHI
 Uyri6xBlIihBZe1o5DJVX21sH7VS82wSFX7suTec3pxHE9080sBFUhEuJ4IUk6blgvir
 o4O48nSfeJbiiUKfR0fc2A5fa+zSwta53+2yA+n5YD7s9CFraxmOC/ncxSyZyXrnWu+d
 +lruE09yA/W8KNdE++N6eOz9zWNpfR7V2sh1lxutZRnCD9qjZoyCeunzrSuI9ZQVyYVU
 w+7daaO2QoLyY+Z313jLsUEw0N3DRgRDH1vqC6t9XIPx9X5UdFxTPy7AHRD9ooRYf0l5
 OeeA==
X-Gm-Message-State: AOAM532k6SaYEyaP43Aw4P25Dux4ZAKXeZXmTwRi5KC0PfNfW5aS5PdK
 dqSJw5TNLUCSiSJByeo3vEpnUWnaJu/DPg==
X-Google-Smtp-Source: ABdhPJz6YGncQ1L+tSJJzun8sdHJ/sWVfbSokhsMTus82Zc5zyyzMDqRv50uxI7CXKWWJhMQ5kxCHw==
X-Received: by 2002:a17:907:7e97:b0:6db:c1ef:6a68 with SMTP id
 qb23-20020a1709077e9700b006dbc1ef6a68mr13726402ejc.475.1647721118149; 
 Sat, 19 Mar 2022 13:18:38 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl.
 [62.195.130.160]) by smtp.googlemail.com with ESMTPSA id
 w19-20020a05640234d300b00416baf4cdcasm6133932edc.48.2022.03.19.13.18.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 19 Mar 2022 13:18:37 -0700 (PDT)
From: Jakob Koschel <jakobkoschel@gmail.com>
To: Alasdair Kergon <agk@redhat.com>
Date: Sat, 19 Mar 2022 21:18:11 +0100
Message-Id: <20220319201811.2515178-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:50 +0000
Subject: [dm-devel] [PATCH] dm thin: fix using the correct variable for
 sizeof()
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
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>, Mike Snitzer <snitzer@redhat.com>,
 linux-kernel@vger.kernel.org, "Bos, H.J." <h.j.bos@vu.nl>,
 Brian Johannesmeyer <bjohannesmeyer@gmail.com>, dm-devel@redhat.com,
 Jakob Koschel <jakobkoschel@gmail.com>, Mike Rapoport <rppt@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

While the original code is valid, it is not the obvious choice for the
sizeof() call and in preparation to limit the scope of the list iterator
variable the sizeof should be changed to the size of the array
elements that are beings sorted.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ec119d2422d5..2e41e50d6903 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2251,7 +2251,7 @@ static unsigned sort_cells(struct pool *pool, struct list_head *cells)
 		list_del(&cell->user_list);
 	}

-	sort(pool->cell_sort_array, count, sizeof(cell), cmp_cells, NULL);
+	sort(pool->cell_sort_array, count, sizeof(*pool->cell_sort_array), cmp_cells, NULL);

 	return count;
 }

base-commit: 34e047aa16c0123bbae8e2f6df33e5ecc1f56601
--
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

