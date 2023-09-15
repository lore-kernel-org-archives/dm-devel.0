Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F1FCD37B0
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 20:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694808262;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D9E3iy4dBQUtQ3a+L2CBpK43Q4FSCrbydd7zge8k1rA=;
	b=ILe2arpmg/hmnpfXaoqZAk3yj8WtsUsS3MLgl4WvC+OMGfGNTvrre2QrCUatDtDPmqewLI
	EXVI0mPHWnKZY29MpZjbZU6r/Vb8St3+UeDKcKRf1E3k1df6F2kh586zxOohvDHh0vdKEy
	hewiIS97nRUmO1KavKpF107B65kff6s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-8Kxhlg-8OYGPuqJ7K9bw1g-1; Fri, 15 Sep 2023 16:04:18 -0400
X-MC-Unique: 8Kxhlg-8OYGPuqJ7K9bw1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6A3A81705D;
	Fri, 15 Sep 2023 20:04:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3D621054F81;
	Fri, 15 Sep 2023 20:04:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B03119466E6;
	Fri, 15 Sep 2023 20:04:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17E6A194658C
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 20:04:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3D2B21B2419; Fri, 15 Sep 2023 20:04:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D865D200BC7F
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:04:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7C18101B04C
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:04:07 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-3J4a6nJPPESBjahoIWnq8g-1; Fri, 15 Sep 2023 16:04:03 -0400
X-MC-Unique: 3J4a6nJPPESBjahoIWnq8g-1
Received: by mail-pf1-f173.google.com with SMTP id
 d2e1a72fcca58-68fac346f6aso2308406b3a.3
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 13:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694808243; x=1695413043;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=WBuZz+BdckpJHOm1ZISAhTef4sCi4HSxGN+vf0MxAr8=;
 b=X2tJtwzf4XUvQs+w9uNhqsZ5a/3aWmPHuLv7S8f9t8lHH5TlPhVFugdo8fg4kLIhHQ
 3XP0edj7UAuKsGXgT0TFSnhQ5QBsTSOrWgquRipzZTLitUzJDkY/1AP+6fRYgCCsqC/m
 Yu2G6YZ9NO1lBM81E49CLtz9mQEl9kuKXq7GiD+lKXwAne6CsQTS5a01N8b4vy78j9A8
 t4CRcfwFF6nlaVS3L94vffUCFDc0AhTvFTfrPdyLLxPHX3irBZ9T145kf0jbAvTBgfu+
 5dln2PdkZQiFQ5BtTnZH+eE4TbQZA5zDdOEnYwZIr5bwXB0o72FPzMZ0bPY8K7KhPXRW
 NXsg==
X-Gm-Message-State: AOJu0YxPusb4wRT1GuYHq3fVvmkBY0Mp1Uu5NqKXvMug/kwukR9D5mmS
 ARmD9iuuTeVHuEBFp/nevxplAg==
X-Google-Smtp-Source: AGHT+IHRUYTJjIKllYHBewMbpKQsYsoD6C28ob0Nn4eDxpBQYKIGmGp4tJnxthVcYLQpU9tsohhP2w==
X-Received: by 2002:aa7:88c8:0:b0:690:15c7:60d8 with SMTP id
 k8-20020aa788c8000000b0069015c760d8mr3508557pff.22.1694808242750; 
 Fri, 15 Sep 2023 13:04:02 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 k15-20020aa792cf000000b0068a3f861b24sm3312716pfa.195.2023.09.15.13.04.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Sep 2023 13:04:02 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>
Date: Fri, 15 Sep 2023 13:04:01 -0700
Message-Id: <20230915200400.never.585-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1178; i=keescook@chromium.org; 
 h=from:subject:message-id;
 bh=hh6/l0ERrceykgj05rTGEqoGv9O3N3l11v+m7r5kK6w=; 
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlBLiwjAee1aCYWRgESmBPvaP+ZPywLMQavQYy6
 K1opOJdk7yJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZQS4sAAKCRCJcvTf3G3A
 JmEyD/9Nw4qdkEPs0CMpZYH9PJm4rFd+PH9nRC+v78Gfq/aOca9MZMGgAsVTNZVVLy3P6KBjD2m
 mtmN77g1YZHJHCVzbdUI0UvlIfsuR086YpqaUWYp7+Q7hZfHkyCcKKrUFceRRDruDxkNaUOsNN2
 IzNy4s/CR4vogKkDt+GZ1M4KjWCNednV7pIbc7OTZ7oDfmLZSemK//MribH6UwbwstZZ/IbuMuy
 aeNZcS/1An4v4h1P+RuIKViYXbrMbIVTWpvGjOIbLasIYjcKoW9pSlewMy33Z139w9b2WMNcLGN
 01cMC9t6y0j1p4xe4bkCrA0JEvmLH5zv+rMOGyLuvyeaG6u2Y41oqm+FNy5fEZOI3Neo6HIqjrW
 8dQ4XaWrwKCWR6rc2vzr2N6EFCxh7FMrjtAvMQo4HoYMuzYpp+4owygZiP1XptuqamDfXDnhjTf
 d79h5FKJzmmzKtPa7y41OC7rFq2Hk7JciHa8JTHI3cw1D4J5VvcDE1ZlMq+Cxpi9QK4ImW7tWhS
 DrKAuYb0nA6Npm4thazac1wWwsCnAmJf6MLJqBrJfE1yYX4s3Tr2XuB22ABIm6T4hfpag6YFrbQ
 NiOsSHMZ6+N3PeHEo1lrusu22nve1JOWkpcUnxD7lJ3kW3pdEnfUXewlmUjhQFSa9tdp54xnhT6
 5iS4QDJ ir8mttuw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp;
 fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH] dm: Annotate struct dm_stat with __counted_by
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
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@kernel.org>,
 llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
 linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
 dm-devel@redhat.com, linux-hardening@vger.kernel.org,
 Tom Rix <trix@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct dm_stat.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/dm-stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index db2d997a6c18..bdc14ec99814 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -56,7 +56,7 @@ struct dm_stat {
 	size_t percpu_alloc_size;
 	size_t histogram_alloc_size;
 	struct dm_stat_percpu *stat_percpu[NR_CPUS];
-	struct dm_stat_shared stat_shared[];
+	struct dm_stat_shared stat_shared[] __counted_by(n_entries);
 };
 
 #define STAT_PRECISE_TIMESTAMPS		1
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

