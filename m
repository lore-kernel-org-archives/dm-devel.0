Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BD9C77B7F
	for <dm-devel@archiver.kernel.org>; Fri, 12 May 2023 17:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683912772;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Jw6p+FlgPre1XG7hXWEQ0Ax6Uc9dyUS8FTNtqKjdDBc=;
	b=CD3qVAi0Ixf7kmh0c7lo6N/ULpHnQYh8Ctv7tdBEvVRiH6mMVC1m4ZANFCpHPBzIyCI7KQ
	gMnGvbkF3A8PUxCAgNpEwU3WGZLDXpfEAZe+WMOAiASNc2yEA+f97zJUanhI1qi55Hs5am
	/1OZCK6KKtQ7fC02KtRJjmth8mUt9MI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-mvopZDg8O8Wi-AWcavp_dg-1; Fri, 12 May 2023 13:32:50 -0400
X-MC-Unique: mvopZDg8O8Wi-AWcavp_dg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06E443810B09;
	Fri, 12 May 2023 17:32:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C42E92026D16;
	Fri, 12 May 2023 17:32:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9501719451E4;
	Fri, 12 May 2023 17:32:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C99E619451E3
 for <dm-devel@listman.corp.redhat.com>; Fri, 12 May 2023 17:32:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B65FE14152F6; Fri, 12 May 2023 17:32:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE939141511D
 for <dm-devel@redhat.com>; Fri, 12 May 2023 17:32:44 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 933EF1C02CA3
 for <dm-devel@redhat.com>; Fri, 12 May 2023 17:32:44 +0000 (UTC)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-9_oUu0hmP1qIQq1vXb_dcQ-1; Fri, 12 May 2023 13:32:42 -0400
X-MC-Unique: 9_oUu0hmP1qIQq1vXb_dcQ-1
Received: by mail-qv1-f41.google.com with SMTP id
 6a1803df08f44-61a62fc8b5bso80703266d6.2
 for <dm-devel@redhat.com>; Fri, 12 May 2023 10:32:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683912762; x=1686504762;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6V0M3WHsM/CbP7GPo2jgrowLKKxSm62sS3psQx8zXQg=;
 b=cPwfwDZVStvqChhGnB/OGywmHZhX9Jf1bgUrQCfmJ25xYAYb2c2SCpGlxVcBSxmdQY
 7PlgavDUZ/Fb7vJM5sRPetNvi2aGaQpAt3Fa7momSluMf/+8ZZrtUva0lxezkvFuQb8R
 5W1+U4C9KDQ1fUQ4hFCAKIpOolZklPAkf0oHouX5TyPGN+3a3qSk4pqC/SvhH80U98YY
 KVmALUHtSp6jBdzpqEkGv/0HZpq6pHdDytyW4YXxRa1U7TIeyvsntMg4oz4twSCmY5Rg
 lxh56DIaVFRh/YLRm4qv3H2B/GBmaPM8OIfAk9JgHYQw+a2a2OxpWSp0H3ajMOg0Xe3l
 ae4w==
X-Gm-Message-State: AC+VfDzMZ38X78b87WlTi/TbgiIphj4WeCOpGJXPLWmGjiQRACMLd+VW
 45cKkveA3sPunnuj3pei7qMF/DU=
X-Google-Smtp-Source: ACHHUZ5jRqBe5V3qEMe4Dw+z/UN5rDNtGltRsfG7pSdt3oaD03wHbynKxPl194sOY+kaYveH3Enm2A==
X-Received: by 2002:ad4:5ae5:0:b0:621:1b1d:7dde with SMTP id
 c5-20020ad45ae5000000b006211b1d7ddemr38554895qvh.8.1683912762375; 
 Fri, 12 May 2023 10:32:42 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 h10-20020a0cf20a000000b0061b5c45f970sm3137246qvk.74.2023.05.12.10.32.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 May 2023 10:32:41 -0700 (PDT)
Date: Fri, 12 May 2023 13:32:40 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZF54OH8hZTTko4c3@redhat.com>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-5-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230506062909.74601-5-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v6 4/5] dm-thin: Add REQ_OP_PROVISION support
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, May 06 2023 at  2:29P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> dm-thinpool uses the provision request to provision
> blocks for a dm-thin device. dm-thinpool currently does not
> pass through REQ_OP_PROVISION to underlying devices.
> 
> For shared blocks, provision requests will break sharing and copy the
> contents of the entire block. Additionally, if 'skip_block_zeroing'
> is not set, dm-thin will opt to zero out the entire range as a part
> of provisioning.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  drivers/md/dm-thin.c | 70 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 66 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 2b13c949bd72..3f94f53ac956 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
...
> @@ -4114,6 +4171,8 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	 * The pool uses the same discard limits as the underlying data
>  	 * device.  DM core has already set this up.
>  	 */
> +
> +	limits->max_provision_sectors = pool->sectors_per_block;

Just noticed that setting limits->max_provision_sectors needs to move
above pool_io_hints code that sets up discards -- otherwise the early
return from if (!pt->adjusted_pf.discard_enabled) will cause setting
max_provision_sectors to be skipped.

Here is a roll up of the fixes that need to be folded into this patch:

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 3f94f53ac956..90c8e36cb327 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4151,6 +4151,8 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
 	}
 
+	limits->max_provision_sectors = pool->sectors_per_block;
+
 	/*
 	 * pt->adjusted_pf is a staging area for the actual features to use.
 	 * They get transferred to the live pool in bind_control_target()
@@ -4171,8 +4173,6 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 * The pool uses the same discard limits as the underlying data
 	 * device.  DM core has already set this up.
 	 */
-
-	limits->max_provision_sectors = pool->sectors_per_block;
 }
 
 static struct target_type pool_target = {
@@ -4349,6 +4349,7 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_provision_bios = 1;
 	ti->provision_supported = true;
+	ti->max_provision_granularity = true;
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

