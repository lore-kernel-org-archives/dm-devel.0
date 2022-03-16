Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B87DC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 17 Mar 2022 08:03:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-i8CM3vplPXK3SiI9fUQr4A-1; Thu, 17 Mar 2022 04:03:54 -0400
X-MC-Unique: i8CM3vplPXK3SiI9fUQr4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E54F299E75C;
	Thu, 17 Mar 2022 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29D9A40D296B;
	Thu, 17 Mar 2022 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ADC3D193F511;
	Thu, 17 Mar 2022 08:03:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5FB2A1949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 19:46:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B4EA215688A; Wed, 16 Mar 2022 19:46:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3632B2156A5A
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 19:46:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C750802A6A
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 19:46:19 +0000 (UTC)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com
 [209.85.160.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-Nl75c-BROAqp1duB73m-rg-1; Wed, 16 Mar 2022 15:46:17 -0400
X-MC-Unique: Nl75c-BROAqp1duB73m-rg-1
Received: by mail-qt1-f172.google.com with SMTP id n11so2726336qtk.4
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 12:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=E10/RHxqxdnO02yRvPfaNr/v1jdUvJvGTwpcCM2UuCE=;
 b=IzkwL6qXeaEiQK7zKcifQuCk3aPbTPsNTjdQulFmSkknkn3V89wLua6HJ8TFZbNxG2
 9Xiya1JJ3+fMfxHw5aoa4m4TcdtDKo00JXrspI1PC73I0FhT7JWgxKvbQwvhkDEkFu1B
 UBax2R8MEtJrUqIse/pSAbscnj1GxUsb9QzpQmXk1a+/nkNnDFaPX5eBOh9JOSpDy5AG
 KRzr8JXUP0TceAHXmZa3dsLZuaN/xyRq6RLyFht1HdEkws955SsuWgLRX7DvxU9MkiAc
 jCJWZs1yQX0aNbjpd0gk3LicoXpik2FEdORAzJNXjsOSvekBP3VcMamoi9iXq1ndfPAF
 HEcA==
X-Gm-Message-State: AOAM532X9z/iH/MlRy0OPn+6nLYGn3wo1+/RSTc+6kwardyH3DsbYdHP
 I2SkQsk7ES05Psn3gBwY+KTNrcqAXjw2HA==
X-Google-Smtp-Source: ABdhPJzdid00/41lxSbckANfhz3hmgkLiL0sjFGBBL7VjSFouD738FwEvMgn4bxoZSVrvIQ/cKsiQg==
X-Received: by 2002:a05:622a:490:b0:2e1:cd32:f3da with SMTP id
 p16-20020a05622a049000b002e1cd32f3damr1206863qtx.339.1647459976253; 
 Wed, 16 Mar 2022 12:46:16 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
 by smtp.gmail.com with ESMTPSA id
 a14-20020a05620a066e00b0067d36cc5b12sm1253247qkh.87.2022.03.16.12.46.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 12:46:15 -0700 (PDT)
Date: Wed, 16 Mar 2022 15:46:14 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Qu Wenruo <wqu@suse.com>
Message-ID: <YjI+hkhhTTWMmPkz@localhost.localdomain>
References: <20211201051756.53742-1-wqu@suse.com>
 <20211201051756.53742-12-wqu@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211201051756.53742-12-wqu@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Thu, 17 Mar 2022 08:03:49 +0000
Subject: Re: [dm-devel] [PATCH 11/17] btrfs: make
 dec_and_test_compressed_bio() to be split bio compatible
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 01, 2021 at 01:17:50PM +0800, Qu Wenruo wrote:
> For compression read write endio functions, they all rely on
> dec_and_test_compressed_bio() to determine if they are the last bio.
> 
> So here we only need to convert the bio_for_each_segment_all() call into
> __bio_for_each_segment() so that compression read/write endio functions
> will handle both split and unsplit bios well.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/compression.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 8668c5190805..8b4b84b59b0c 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -205,18 +205,14 @@ static int check_compressed_csum(struct btrfs_inode *inode, struct bio *bio,
>  static bool dec_and_test_compressed_bio(struct compressed_bio *cb, struct bio *bio)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(cb->inode->i_sb);
> +	struct bio_vec bvec;
> +	struct bvec_iter iter;
>  	unsigned int bi_size = 0;
>  	bool last_io = false;
> -	struct bio_vec *bvec;
> -	struct bvec_iter_all iter_all;
>  
> -	/*
> -	 * At endio time, bi_iter.bi_size doesn't represent the real bio size.
> -	 * Thus here we have to iterate through all segments to grab correct
> -	 * bio size.
> -	 */
> -	bio_for_each_segment_all(bvec, bio, iter_all)
> -		bi_size += bvec->bv_len;
> +	ASSERT(btrfs_bio(bio)->iter.bi_size);

We're tripping this assert with generic/476 with -o compress, so I assume
there's some error condition that isn't being handled properly.  Thanks,

Josef

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

