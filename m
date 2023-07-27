Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D4DC04FE2
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690480519;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HWjpnrBWXwUZod04hP3csiwnl3dNr3sK55xWzGvKKUc=;
	b=BJy0/dWuwPrzVIZbhYK3OzV12JbGTkQfADzLLf73edqUhglN/TkSnAc2fRqBYzqbQ5rDTv
	pwTEFYU8AfxveFPUZO67shvknGqcDslwZVSm9NNe/QhQRsviFal7PPojjj9AlnKKglG7u2
	fmf9RaQ5MYx4sMN+4qGYSRt14j/pw/I=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-GYP4V1l5PiSSQZjtIk4DNA-1; Thu, 27 Jul 2023 13:55:15 -0400
X-MC-Unique: GYP4V1l5PiSSQZjtIk4DNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83FD71C0897B;
	Thu, 27 Jul 2023 17:55:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E276200B409;
	Thu, 27 Jul 2023 17:55:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 710C519452C6;
	Thu, 27 Jul 2023 17:55:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6299A1946A6C
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 08:07:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3429F4094DC1; Thu, 27 Jul 2023 08:07:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C7634094DC0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:07:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CF5338149B4
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:07:55 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-Ux164mrUMZylWOQwAMCcMA-1; Thu, 27 Jul 2023 04:07:53 -0400
X-MC-Unique: Ux164mrUMZylWOQwAMCcMA-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-6862d4a1376so188557b3a.0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 01:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690445272; x=1691050072;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=ubpyp4SIhGXjO6/VTKiZvWjlRzyN8ANvKHVN5xSGnIw=;
 b=PR0/EZkHB4uwhE+dlGezOg5+xt1Jg02NU7WVVOXyvMXbrKSeW83EknYA6mpQ8nbdmt
 jt2zsIoA2h5uff87+DVJ1zdyFE7s/or/bAiG5xQYQBRCkWb4BH9fsRwjkXIIfbzkUt/F
 pxvoX1IrQptxDhbRBnZL4qWbzwBvf371J6AhyQsmL5UhKwdrpepj5Co9GpcMLeQAQZkl
 H9Hg4EUq6x1kFpuvYPBwmeZyhUWApQ4NHEBm5abDTNuDHFS8x2KyLS5N3ok/l3fbiObl
 41ayQOpGPXd5NfR3oJFkSG2qCQ62QqA8bnNlGhJgZMtyEjtzOwXSkmqi+sGVvaXqiMKD
 8kbw==
X-Gm-Message-State: ABy/qLahzNGNe1pcOUYepyBe1//e5Huq7OsIb/BoVsw51IpMdnIXWebs
 lZ+Vq/DyTllc9H1FWKPq1vNSgw==
X-Google-Smtp-Source: APBJJlH8Hm//FCUnZvKJ1Fsda02AnYQWQqq2rUtStc8LnYU5/NdJ+w8F5lFLyohrr/NHLskzxbNOmQ==
X-Received: by 2002:a05:6a00:2d09:b0:682:59aa:178d with SMTP id
 fa9-20020a056a002d0900b0068259aa178dmr4647270pfb.1.1690445272018; 
 Thu, 27 Jul 2023 01:07:52 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.07.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 27 Jul 2023 01:07:51 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev
Date: Thu, 27 Jul 2023 16:04:23 +0800
Message-Id: <20230727080502.77895-11-zhengqi.arch@bytedance.com>
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 27 Jul 2023 17:54:53 +0000
Subject: [dm-devel] [PATCH v3 10/49] erofs: dynamically allocate the
 erofs-shrinker
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
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 Muchun Song <songmuchun@bytedance.com>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use new APIs to dynamically allocate the erofs-shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/erofs/utils.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index cc6fb9e98899..6e1a828e6ca3 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -270,19 +270,25 @@ static unsigned long erofs_shrink_scan(struct shrinker *shrink,
 	return freed;
 }
 
-static struct shrinker erofs_shrinker_info = {
-	.scan_objects = erofs_shrink_scan,
-	.count_objects = erofs_shrink_count,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *erofs_shrinker_info;
 
 int __init erofs_init_shrinker(void)
 {
-	return register_shrinker(&erofs_shrinker_info, "erofs-shrinker");
+	erofs_shrinker_info = shrinker_alloc(0, "erofs-shrinker");
+	if (!erofs_shrinker_info)
+		return -ENOMEM;
+
+	erofs_shrinker_info->count_objects = erofs_shrink_count;
+	erofs_shrinker_info->scan_objects = erofs_shrink_scan;
+	erofs_shrinker_info->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(erofs_shrinker_info);
+
+	return 0;
 }
 
 void erofs_exit_shrinker(void)
 {
-	unregister_shrinker(&erofs_shrinker_info);
+	shrinker_free(erofs_shrinker_info);
 }
 #endif	/* !CONFIG_EROFS_FS_ZIP */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

