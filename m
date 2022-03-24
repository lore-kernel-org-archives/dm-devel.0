Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA7B8C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 25 Mar 2022 07:27:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-twyiekgEO5mRdoKEahqTLQ-1; Fri, 25 Mar 2022 03:27:26 -0400
X-MC-Unique: twyiekgEO5mRdoKEahqTLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5797838041C3;
	Fri, 25 Mar 2022 07:27:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46246C27D92;
	Fri, 25 Mar 2022 07:27:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D9329194035D;
	Fri, 25 Mar 2022 07:27:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 357981940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 20:35:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA66040CFD0D; Thu, 24 Mar 2022 20:35:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5EE3400E550
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:35:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB56A85A5BE
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:35:29 +0000 (UTC)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-GUnhGoyJN8SrDIPPKll3NQ-1; Thu, 24 Mar 2022 16:35:28 -0400
X-MC-Unique: GUnhGoyJN8SrDIPPKll3NQ-1
Received: by mail-qv1-f41.google.com with SMTP id kc20so4685990qvb.3
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 13:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=/DA2QpPVPr3enZ27mGPd7ho97R+A7tobG2oweYbaoNA=;
 b=4FiV/cIFP0cGR7Qlws03pPPxjne4T1yi7IXfxn7518A3gJ1DyL/HylKX8Jy4p/goe2
 ZvB7as/NuVEgnITnQ+0jhiZ2WA2LoKxTlCvgkUMSLB59hXa4cq3UsHxC93zjdBtLOfw6
 KVXD8a4FVBkd8R7GW/JQtFWFQO27SFAuzD47ET8+iQ8qN6F+rk/0/zv4mkPk5Xc0YiFh
 t06ix8oAeiyyhBm6e4cebHlkwJisyOxJkJJZsuIf9vihQxwQyzT6AmnJQbqv8UQ9dNA3
 EhGAHoYk/zgU1N4nDNe8H8o6USm+WjqK6IoRilCx3j735hZ+Nq1G2yYNhuExkhUD+5VG
 Ex+g==
X-Gm-Message-State: AOAM531U9b/aDj3c6XHLOXeEmuoDSrN176hMaK5yF8Xqc8KrjfObJq4h
 d8X+h/r4AYieN9RbujkIOV1tzes=
X-Google-Smtp-Source: ABdhPJyGBdmnolpgAFuBdwe78chN1I2/ElrtcKyGcbdJw04vnJanHfFxqWQMoGpNfYfYLSKcO7xQdw==
X-Received: by 2002:ad4:5f4b:0:b0:441:4d40:f8d2 with SMTP id
 p11-20020ad45f4b000000b004414d40f8d2mr6070094qvg.33.1648154127897; 
 Thu, 24 Mar 2022 13:35:27 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 o21-20020ac85a55000000b002e16389b501sm3174633qta.96.2022.03.24.13.35.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 13:35:26 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Thu, 24 Mar 2022 16:35:23 -0400
Message-Id: <20220324203526.62306-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Fri, 25 Mar 2022 07:27:18 +0000
Subject: [dm-devel] [PATCH v3 0/3] block/dm: use BIOSET_PERCPU_CACHE from
 bio_alloc_bioset
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

This v3 is a rebase of the previous v2 series ontop of the revised v2
patch that Christoph provided.

Linus hasn't pulled the for-5.18/dm-changes branch yet, so the 3rd DM
patch cannot be applied yet.  But feel free to pickup the first 2
block patches for 5.19 and I'll rebase dm-5.19 on block accordingly.

Thanks,
Mike

v3: tweaked some code comments, refined patch headers and folded DM
    patches so only one DM patch now.
v2: add REQ_ALLOC_CACHE and move use of bio_alloc_percpu_cache to
    bio_alloc_bioset

Mike Snitzer (3):
  block: allow using the per-cpu bio cache from bio_alloc_bioset
  block: allow use of per-cpu bio alloc cache by block drivers
  dm: conditionally enable BIOSET_PERCPU_CACHE for dm_io bioset

 block/bio.c               | 88 +++++++++++++++++++++++------------------------
 block/blk.h               |  7 ----
 block/fops.c              | 11 ++++--
 drivers/md/dm-table.c     | 11 ++++--
 drivers/md/dm.c           |  8 ++---
 drivers/md/dm.h           |  4 +--
 include/linux/bio.h       |  8 +++--
 include/linux/blk_types.h |  3 +-
 8 files changed, 73 insertions(+), 67 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

