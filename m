Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664BBC43334
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 12:39:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-fNnTlZlZPTWYW2NOq9ncdA-1; Fri, 17 Jun 2022 08:39:44 -0400
X-MC-Unique: fNnTlZlZPTWYW2NOq9ncdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CF9A85A580;
	Fri, 17 Jun 2022 12:39:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D0C012026985;
	Fri, 17 Jun 2022 12:39:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D94B1947079;
	Fri, 17 Jun 2022 12:39:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36F09194705F
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 12:39:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 108312026985; Fri, 17 Jun 2022 12:39:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C62F2026D64
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 12:39:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5606811E7A
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 12:39:30 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-UGfpHRboMTWrFNErRsnOhQ-1; Fri, 17 Jun 2022 08:39:29 -0400
X-MC-Unique: UGfpHRboMTWrFNErRsnOhQ-1
Received: by mail-pj1-f47.google.com with SMTP id
 t3-20020a17090a510300b001ea87ef9a3dso4038791pjh.4
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 05:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=prc6vo9UtEUb0+NEUXY+sEuVoqXzXH159hY5xoOO6Yg=;
 b=uSqgcyQ94t9GloLpzU4Rm4MqJX/Zf/lDSR3kpdu8WqF/8Scj8crGtaodd9ZPKyHlll
 GCtQbfpsoe53ms/Y29Bc48M3AIIvlwmybDDnApsyS72BWh/FGpLtQdxXpGRSdMjoaRhE
 zpGPK19YHbU3bqNh/B2zf6M/xyFr59uGpaiZL9Y7eOuNYVy1XRDX0jf84y8qgRADH0Pg
 2XCLue1lhQMzVoGs3Xet/axD/nlQ0tXhRweAn+ulJfB/jBVSvXljyhlseP88lagZsPhw
 2ifKJNysJpw2VQSDt2KmvB15KJ+dj0oa5QarI3xRjU9cyy2jC6WzQ2EzolZxB+0A32eI
 Z8mQ==
X-Gm-Message-State: AJIora9HBzYg9O0HIwrxqX0GnKPsTGTcGiX7zsW1t7i6Llv8QP35mI4Z
 /IsOtxsLuWz/KgF50230FLw+cpRzwsQHNw==
X-Google-Smtp-Source: AGRyM1sCJQxpCz0Cb2KjTNHJhkP1bkBVMukKykWQ+XRJIPXAB31d8VQjRg8AZp0cECmhhASSlWm4/Q==
X-Received: by 2002:a17:902:64c2:b0:168:c298:bdee with SMTP id
 y2-20020a17090264c200b00168c298bdeemr9497058pli.82.1655469567752; 
 Fri, 17 Jun 2022 05:39:27 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157]) by smtp.gmail.com with ESMTPSA id
 nk10-20020a17090b194a00b001e2f53e1042sm5529503pjb.7.2022.06.17.05.39.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 05:39:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20220614090934.570632-1-hch@lst.de>
References: <20220614090934.570632-1-hch@lst.de>
Message-Id: <165546956681.341943.17711027449182235917.b4-ty@kernel.dk>
Date: Fri, 17 Jun 2022 06:39:26 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] clean up the chunk_sizehandling helpers a little
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 14 Jun 2022 11:09:28 +0200, Christoph Hellwig wrote:
> this series cleans up a bunch of block layer helpers related to the chunk
> size.
> 
> Diffstat:
>  block/blk-merge.c      |   28 ++++++++++++++++------------
>  block/blk.h            |   13 +++++++++++++
>  drivers/md/dm.c        |   17 ++++++-----------
>  include/linux/blkdev.h |   39 +++++++--------------------------------
>  4 files changed, 42 insertions(+), 55 deletions(-)
> 
> [...]

Applied, thanks!

[1/6] block: factor out a chunk_size_left helper
      commit: d0e3310bb972f65c4b614c29f8022f57a52123c8
[2/6] dm: open code blk_max_size_offset in max_io_len
      commit: 6d5661a5d0e513dde5d49820315c5d6249a5c732
[3/6] block: open code blk_max_size_offset in blk_rq_get_max_sectors
      commit: 92ac28684e7eccf968b556893ca09c57d1fb3cdd
[4/6] block: cleanup variable naming in get_max_io_size
      commit: 08fdba80df1fd78a22b00e96ffd062a5bbaf8d8e
[5/6] block: fold blk_max_size_offset into get_max_io_size
      commit: d8f1d38c87b87ea3a0a0c58b6386333731e29470
[6/6] block: move blk_queue_get_max_sectors to blk.h
      commit: d8fca63495fb21e9b2dfcf722346aa844459139a

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

