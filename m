Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D674FC77B78
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 06:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682059685;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IbNQziB1o+jkDyXafSWKNECLYyLbmzHrlvTA73oncOE=;
	b=YCBkaeZSIdaJ+FRr76m3mC5s2VjRUIkZ/LU41vIV+8op/Hjh40mo+jAmKT03hwPd0+f6T+
	/uOLBKpMqQjIm5OG7E72j4Q0sdw9aWoo0Mj9cgKMLStrY4kA9aWvXHXL/ZUsv0vgdzvNsK
	bX+0VW8FR3w1tKOK0asId7heQKBt+9s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-6lD-QGO3NWaIcz_SRrb14w-1; Fri, 21 Apr 2023 02:48:00 -0400
X-MC-Unique: 6lD-QGO3NWaIcz_SRrb14w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2FA038173EA;
	Fri, 21 Apr 2023 06:47:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8EDB0407D45A;
	Fri, 21 Apr 2023 06:47:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E087619451F8;
	Fri, 21 Apr 2023 06:47:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E770C1946A4F
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 10:06:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9569763A51; Thu, 20 Apr 2023 10:06:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E98263A5F
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73FEA101A553
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:18 +0000 (UTC)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-JG-0oTksPOWAUs-0q5HjNA-1; Thu, 20 Apr 2023 06:06:14 -0400
X-MC-Unique: JG-0oTksPOWAUs-0q5HjNA-1
Received: by mail-wm1-f42.google.com with SMTP id bg5so99134wmb.1;
 Thu, 20 Apr 2023 03:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681985173; x=1684577173;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=ExnlLXqiP3hLS8bpFiqaYIxJLAKQF5DCX5VPxtSPsPo=;
 b=iUYXSa8mZRThwGArxI0HYvHA9HFUt6GSputDI0kkA191dSH4t1do+M4EOTY5i7hUfL
 +uzPQSZ0rIXbGNSEKZkD1Z/xGrn60c0Q426zD/vCG1yq4pZpQK3cwwLPez3UY679xJ4b
 p9FOrV0hxC+5BiFxcAXPwiHR55psQ55S//o9DzMogsRSc/YkmQwrdNIJWPWAj0c/L5eV
 gt9PSHTKwHSQ7w4SPLElzczubzaDa2p05Erg1/LFCYyP7LQWkHBGTNfzrKqSCsx7pUp8
 fRoxw7Wo98YernMNoLds1bHo6RH0x1BaDoY5dTo8pFBBzHfd2S0JXHNHTaNKZMRFqZ/1
 dDQQ==
X-Gm-Message-State: AAQBX9cL6f7lbQrzPwbwk4L+GDzBXwKc3pVIcovYiuwg6K3N1J3vBjY6
 2sL2W5/J/F75rkYCvrafKgk=
X-Google-Smtp-Source: AKy350Y9Lh9XIY3qybGhOCpyPMv4/qCxT9O5teS3GZxkrMtKC5XpeBENII5mka0Be7VFkgyszAIoCQ==
X-Received: by 2002:a7b:c4c6:0:b0:3f1:7006:e782 with SMTP id
 g6-20020a7bc4c6000000b003f17006e782mr804698wmk.25.1681985173032; 
 Thu, 20 Apr 2023 03:06:13 -0700 (PDT)
Received: from localhost.localdomain
 (aftr-62-216-205-208.dynamic.mnet-online.de. [62.216.205.208])
 by smtp.googlemail.com with ESMTPSA id
 l11-20020a5d674b000000b0030276f42f08sm201410wrw.88.2023.04.20.03.06.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 03:06:12 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: axboe@kernel.dk
Date: Thu, 20 Apr 2023 12:04:58 +0200
Message-Id: <20230420100501.32981-20-jth@kernel.org>
In-Reply-To: <20230420100501.32981-1-jth@kernel.org>
References: <20230420100501.32981-1-jth@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 21 Apr 2023 06:47:49 +0000
Subject: [dm-devel] [PATCH v4 19/22] block: mark bio_add_page as __must_check
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de, agruenba@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, willy@infradead.org,
 cluster-devel@redhat.com, kch@nvidia.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, rpeterso@redhat.com,
 dsterba@suse.com, linux-raid@vger.kernel.org, damien.lemoal@wdc.com,
 song@kernel.org, johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Now that all users of bio_add_page check for the return value, mark
bio_add_page as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index d766be7152e1..0f8a8d7a6384 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -465,7 +465,7 @@ extern void bio_uninit(struct bio *);
 void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
 void bio_chain(struct bio *, struct bio *);
 
-int bio_add_page(struct bio *, struct page *, unsigned len, unsigned off);
+int __must_check bio_add_page(struct bio *, struct page *, unsigned len, unsigned off);
 bool bio_add_folio(struct bio *, struct folio *, size_t len, size_t off);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

