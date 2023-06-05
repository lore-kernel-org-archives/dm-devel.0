Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25CC3C77B73
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 05:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685941780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PxBcXT/OVAqNRC26O2smbnKoLDpb2DKxoXYcVJbg8g0=;
	b=b167bNW4r7l0RJ6MaW5kToIo1yHzIA/2yEknH8bM9Hhm8zbKOGtresDKeuo6gW/GtFlaIZ
	2JDvk4lMZu3WMvQ0CymED2a/NbXAAfPfYH+aHeLhB6GpLpFAmXSwbm+eB5QmUK0G2VSAD6
	D6Mv/r7Sxffs/Q71sX3Jhz5eMAMl+m8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-q9HPuZytO7aTA7sTQifpoA-1; Mon, 05 Jun 2023 01:09:36 -0400
X-MC-Unique: q9HPuZytO7aTA7sTQifpoA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D34E28032F1;
	Mon,  5 Jun 2023 05:09:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD41E2166B25;
	Mon,  5 Jun 2023 05:09:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 98BFD19465A0;
	Mon,  5 Jun 2023 05:09:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36EB41946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 05:09:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 247012166B27; Mon,  5 Jun 2023 05:09:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BDCF2166B25
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:09:33 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE6598027F5
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:09:32 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-JuuCb0SfNCG7FJFbmSS2tw-1; Mon, 05 Jun 2023 01:09:27 -0400
X-MC-Unique: JuuCb0SfNCG7FJFbmSS2tw-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-652426346bbso1945059b3a.3; 
 Sun, 04 Jun 2023 22:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685941766; x=1688533766;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Wwm6y0uAqQL65eNndzr7gfbmRUptPUVk/b+gJobQ0ZE=;
 b=d5q347LfLO+pBna5OF2MCgai9nMtPfmTgzX0RWFi1xDe07yUI2W8zohjSecB+Zo0IK
 UNafXaX5MYKJHdmhMuZ/dsDErqOmKAn3zoxW8xjbL9iGA5d/DbtnZnfyehq4xXkWzaHL
 wcXA1Xz+3XQ+/e8QLKlUbOHQKuE9pKLMcO3S26dF994ex2D1J7oL/DY+cYJJL0y+OZ6h
 t5CudnlQRMFP7YbDMlEFCQ1WMZH4NaMeydMnYdsU9NNdo0NwniTPfNEATPQkerQJO9V3
 RpkDcE7OoFvNcyxptcTm+wmXlOTAxbu75XmzgxKTixa/wIEylFgwKfd/C5YejlR08cjr
 q7fA==
X-Gm-Message-State: AC+VfDwTYLST17PLuWhpoMIoqhhLVfL/oml0mMwmb7PimQ0zUsMPeNVL
 R9iqt8ab1qHsofvXqOVukgM=
X-Google-Smtp-Source: ACHHUZ7A+41eKnG/u3IdkDoLdozgfNSgaF3ptgh5m/NSIvlHyFo5a3hmQ9mo1hD4H0gJj50ugAtc6Q==
X-Received: by 2002:a05:6a00:150a:b0:652:9f37:8d27 with SMTP id
 q10-20020a056a00150a00b006529f378d27mr5492787pfu.8.1685941765803; 
 Sun, 04 Jun 2023 22:09:25 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 fe16-20020a056a002f1000b0064d48d98260sm4329175pfb.156.2023.06.04.22.09.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 22:09:25 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sun,  4 Jun 2023 22:08:53 -0700
Message-Id: <20230605050853.6240-5-eatnumber1@gmail.com>
In-Reply-To: <20230605050853.6240-1-eatnumber1@gmail.com>
References: <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230605050853.6240-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v4 4/4] Documentation: dm-integrity: Document an
 example of how the tunables relate.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

