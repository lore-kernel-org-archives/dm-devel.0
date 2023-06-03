Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94948C7EE24
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 20:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685823401;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PxBcXT/OVAqNRC26O2smbnKoLDpb2DKxoXYcVJbg8g0=;
	b=CIFrNXhvCus3j5x8MSUBcXG03pigPsT/UkOzocOnMvwblQ6542eNuNcGX5fhQ5II2Fj6oE
	yQ14+bpNCwggxUP/HMUl5X9fnGvnAJzuhtB5NtalZnxeAiMxetVuDue85RHHZI7RbAtg0S
	FbWq/I3hdOS5AXdMeS6fWTKPAyfrn3k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-fzF0x-2CP7epjm5aZjnHCg-1; Sat, 03 Jun 2023 16:16:38 -0400
X-MC-Unique: fzF0x-2CP7epjm5aZjnHCg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCBE28032EF;
	Sat,  3 Jun 2023 20:16:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC3B71410F25;
	Sat,  3 Jun 2023 20:16:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AFDCC19465A0;
	Sat,  3 Jun 2023 20:16:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7519F1946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 20:16:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 49E3A1121315; Sat,  3 Jun 2023 20:16:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 42C141121314
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:35 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 273DC1C05122
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:35 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-JGzUoOdDNWGtmIF40TpYUQ-1; Sat, 03 Jun 2023 16:16:31 -0400
X-MC-Unique: JGzUoOdDNWGtmIF40TpYUQ-1
Received: by mail-pj1-f52.google.com with SMTP id
 98e67ed59e1d1-2566ed9328eso2827365a91.2; 
 Sat, 03 Jun 2023 13:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685823390; x=1688415390;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Wwm6y0uAqQL65eNndzr7gfbmRUptPUVk/b+gJobQ0ZE=;
 b=k85DczmnCwmin8FyJM1jB/vKgSHzXuxQgwys33NVEHtGjCx1wx8U/83q11Te7KO0wQ
 xv/q+VVEn24+VkUrJN+uWO0+pjx7HEPlLSWBC4SM+tg9V/Qu7lTxmcLsvQGgXeYu9j6k
 rXNsK3nurmuHw/hguqQKynHIU7q8ZHEMvqPTkhqshqTuoblTB2BrBc4dbByGgY0Kij/8
 8jFbucTQzO447ds/kd9VcxTx21osEhci/4wjooMNsI6eQf28h+kuPDYG70rJhJoMmeqO
 RNinzPjbWpjVmNhyduEPIhCO5UQsWyQIeJWNtN7aVnx98MIfDESmjjTEg/hbjJ23zb+x
 N8NA==
X-Gm-Message-State: AC+VfDxMEi4Qh4OU7L3L1OGTJQWODljpPnbmVhfm+hbpYFp69ZX3bYSe
 AuIqSozD6ihYJv1vbEwIskUnpjwB7CYW3Q==
X-Google-Smtp-Source: ACHHUZ6+DVIaDXY3V4bk2UJ3VMYDkDps43QEvbrdIPHt71i0o9LwdWP4g09RbzJWV7xwkfyS6nalSA==
X-Received: by 2002:a17:90a:7147:b0:253:74f8:1e31 with SMTP id
 g7-20020a17090a714700b0025374f81e31mr3089623pjs.39.1685823390075; 
 Sat, 03 Jun 2023 13:16:30 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 u7-20020a17090a1d4700b00250bf8495b3sm5001691pju.39.2023.06.03.13.16.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 03 Jun 2023 13:16:29 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sat,  3 Jun 2023 13:15:25 -0700
Message-Id: <20230603201525.9409-5-eatnumber1@gmail.com>
In-Reply-To: <20230603201525.9409-1-eatnumber1@gmail.com>
References: <ZHs2BHGBrJ-YGd-v@debian.me>
 <20230603201525.9409-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 4/4] Document an example of how the tunables
 relate in dm-integrity.
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
Cc: Russell Harmon <eatnumber1@gmail.com>, dm-devel@redhat.com,
 mpatocka@redhat.com, snitzer@redhat.com, linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Russell Harmon <eatnumber1@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 0241457c0027..d8a5f14d0e3c 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -213,6 +213,12 @@ table and swap the tables with suspend and resume). The other arguments
 should not be changed when reloading the target because the layout of disk
 data depend on them and the reloaded target would be non-functional.
 
+For example, on a device using the default interleave_sectors of 32768, a
+block_size of 512, and an internal_hash of crc32c with a tag size of 4
+bytes, it will take 128 KiB of tags to track a full data area, requiring
+256 sectors of metadata per data area. With the default buffer_sectors of
+128, that means there will be 2 buffers per metadata area, or 2 buffers
+per 16 MiB of data.
 
 Status line:
 
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

