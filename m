Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496ABC77B61
	for <dm-devel@archiver.kernel.org>; Thu, 13 Apr 2023 06:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681368922;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sOMzViP0zTwjO4nJuoowLpvVUxcr7VvGodN7hpvK1XA=;
	b=dzJBiSZEObiEpW7b7cAjV7/dwPXkHudhJZM6vLUIedxzVrqANg8Qy2v05/4NnxM78Qjhyb
	ymLBCp9CrUiwxAjb6rZ0xpnweXlxf1xYaGl7dNVkcOK3SAq7IXCAuaA2dxgHmSwFUMC7sv
	cIYyNqVWwxBqAUGsmE6U8JilNCcXafI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-Os-cdkCSMQWpGIYF0fT22w-1; Thu, 13 Apr 2023 02:55:19 -0400
X-MC-Unique: Os-cdkCSMQWpGIYF0fT22w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F335C88563B;
	Thu, 13 Apr 2023 06:55:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC1112166B34;
	Thu, 13 Apr 2023 06:55:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9D9A01946A7F;
	Thu, 13 Apr 2023 06:55:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0BEB31946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Apr 2023 10:26:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E11D7492C14; Wed, 12 Apr 2023 10:26:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9400492C13
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 10:26:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE76C2A59566
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 10:26:06 +0000 (UTC)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com
 [209.85.217.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-anriCTJrN1OxP5AUHzeUnA-1; Wed, 12 Apr 2023 06:26:05 -0400
X-MC-Unique: anriCTJrN1OxP5AUHzeUnA-1
Received: by mail-vs1-f53.google.com with SMTP id e20so9917339vsj.10
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 03:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1681295164; x=1683887164;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=s5vg+YiNoxs31Tbnrbv2vsVS/DbOkcWGxusmaV9cfKk=;
 b=RfYLQYaFeirZoTnjXp4LlHiQQMu2Gv3ujK6LrA3tpf0gccitmIm/H0YKSLW8rJUkBP
 5UGIZLod7LE7o/ivNB1SAL8nQrxkZKsw1eJ94MFcoGMDOCe7wyCB9Bpv3G9sWPMM4m2A
 AsYJfFFOf7PWDtYhWH5yFOq97XEVUlzsHSmM59uYiv+ETLlWcmPAEatgqKBajEy33XbN
 v6rAuSjafMkLosx4Ln+CUVlCvYhnAetjt9ZbgKlz8oqO8a7yMV88lKqzjcMpVnLpc5zC
 SOSWc89XU4RjrxHBRWaPqZ2J1WwAEjAWd3mUyyhQ0FgdCgHLpoFcY/TvNlnmuPN3uw9o
 aLBA==
X-Gm-Message-State: AAQBX9frQVfcrFAAcleVxShS1L5/P7rWKWTB7Xfq9wWA1GSuUJuljy+7
 Y5X2Gvwzj1CGGPsYwi8fQsqog7WLgvuZDnA4n+BmrA==
X-Google-Smtp-Source: AKy350Y0FPXWa3mLhpuSfB2wOlCNyI4G0X8q0GPeu0ZGyUt76BO9Zf7I0z0F2H0jq5JCqvcQzrzp/+A3FO8XMIP0FFg=
X-Received: by 2002:a67:cc0f:0:b0:42c:74a1:424f with SMTP id
 q15-20020a67cc0f000000b0042c74a1424fmr3659466vsl.1.1681295164459; Wed, 12 Apr
 2023 03:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230412093617.285177-1-naresh.kamboju@linaro.org>
In-Reply-To: <20230412093617.285177-1-naresh.kamboju@linaro.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 12 Apr 2023 15:55:53 +0530
Message-ID: <CA+G9fYv2nEBe=kJK4veunkvXD9GvqyaPFQ7rUbMD1S4+0nUS3Q@mail.gmail.com>
To: michael.christie@oracle.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 13 Apr 2023 06:55:08 +0000
Subject: Re: [dm-devel] [PATCH v6 00/18] Use block pr_ops in LIO
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
Cc: shy828301@gmail.com, roman.gushchin@linux.dev,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, hch@lst.de,
 bvanassche@acm.org, linux-scsi@vger.kernel.org, willy@infradead.org,
 chaitanyak@nvidia.com, ryan.roberts@arm.com, keescook@chromium.org,
 snitzer@kernel.org, linux-block@vger.kernel.org, kbusch@kernel.org,
 vbabka@suse.cz, yuzhao@google.com, axboe@kernel.dk, martin.petersen@oracle.com,
 halbuer@sra.uni-hannover.de, mkoutny@suse.com, akpm@linux-foundation.org,
 mgorman@techsingularity.net, zokeefe@google.com,
 kirill.shutemov@linux.intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linaro.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 12 Apr 2023 at 15:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> [sorry for the adding you in CC]
>
> While running LTP controllers test suite on this patch set applied on top of
> the next-20230406 and the following kernel panic noticed on qemu-i386.

Also noticed on qemu-x86_64.

Crash log link,
------------------
- https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/test/check-kernel-panic/log
- https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/tests/

lore link,
https://lore.kernel.org/linux-block/20230407200551.12660-1-michael.christie@oracle.com/


--
Linaro LKFT
https://lkft.linaro.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

