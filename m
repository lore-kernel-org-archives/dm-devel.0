Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E65C77B7A
	for <dm-devel@archiver.kernel.org>; Fri, 19 May 2023 15:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684509803;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oNlZ+XPmL4O/l5aIbTvvxgJVnV4Ng4qxjbHV8CIC4h4=;
	b=b3yi+fEMA8C77JmPBoua6bE5qpkbiPBa23yu+zC7MoIPZhiHkKPvlTsN7b1Tr3NapwPAof
	RqbtYuh0M53G7ddvf8GINwj5amiXAA/+3Mk7RgvhODHKwbENvSNq/64O5SIixX0XYGPJc2
	Yntjk7wNbzyfbRntMauVCh0z2uw4aL4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-qHOt__e1MgGaQ0j1a3WuAw-1; Fri, 19 May 2023 11:23:20 -0400
X-MC-Unique: qHOt__e1MgGaQ0j1a3WuAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB9F1101A52C;
	Fri, 19 May 2023 15:23:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AAFB140E954;
	Fri, 19 May 2023 15:23:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2563619465B2;
	Fri, 19 May 2023 15:23:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6294119465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 19 May 2023 15:23:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 517E340C6CCD; Fri, 19 May 2023 15:23:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48EB740C6CD1
 for <dm-devel@redhat.com>; Fri, 19 May 2023 15:23:16 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29FA5800141
 for <dm-devel@redhat.com>; Fri, 19 May 2023 15:23:16 +0000 (UTC)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com
 [209.85.160.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-yfZwcfonMve3TAsgFu8FFA-1; Fri, 19 May 2023 11:23:14 -0400
X-MC-Unique: yfZwcfonMve3TAsgFu8FFA-1
Received: by mail-qt1-f170.google.com with SMTP id
 d75a77b69052e-3f38e1142d0so16937061cf.2
 for <dm-devel@redhat.com>; Fri, 19 May 2023 08:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684509794; x=1687101794;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=KQivtLqNJRG8EpR/lUW7uy3izlo40t0jANCAkNQxEPE=;
 b=QJ9C/Bs8P3LmUCneuQzI6IZRcyFechUHVyapCSlZzFzAHZfmY5zS1x3kWW5cNvHh4x
 AWs1YfZoky/shFKSlyHiUlv1gDG8v2H9m+Yh41p0TNS5gcVWQlUIueUhZH1lcF80V+ZE
 qNZuTneqYo8j4CwabZrJtgVIOS3gpnydRmST++wDqPgAiopvkqYtpetwlWgMp/ryK2PS
 h8KB+aREjQ2K6KGAMyWDFAa1DIa6sMJJjLlSQRg8legoCyVt2aOvQK/8HG0FbDXZ3X8v
 41IoJzZrttl8Art1aCQecrIF77tEWPnTKsheZcik6yk3GMoehNiNHZhZVv+OAchHs6lQ
 fM9A==
X-Gm-Message-State: AC+VfDwZXQ5apXL3UR2o/rlCQhxx8PoXXNIxYuT9gfjsVj/uFfSCgb8Q
 sppojK9c8zgQbg1Okf6H3YPDE50=
X-Google-Smtp-Source: ACHHUZ5KZDF2WuE+iLnjFEJ4qmC2nD5mUZp17EvZzOJDdFPHVvmlXVoj6ey88vsNHzWaS5Y6xHhQeQ==
X-Received: by 2002:a05:622a:192:b0:3f5:92b:eff9 with SMTP id
 s18-20020a05622a019200b003f5092beff9mr3992630qtw.46.1684509793876; 
 Fri, 19 May 2023 08:23:13 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b28-20020a05620a127c00b0075941df3365sm1164925qkl.52.2023.05.19.08.23.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 May 2023 08:23:13 -0700 (PDT)
Date: Fri, 19 May 2023 11:23:12 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Joe Thornber <ejt@redhat.com>
Message-ID: <ZGeUYESOQsZkOQ1Q@redhat.com>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <20230518223326.18744-5-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230518223326.18744-5-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v7 4/5] dm-thin: Add REQ_OP_PROVISION support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, May 18 2023 at  6:33P -0400,
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
>  drivers/md/dm-thin.c | 74 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 70 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 2b13c949bd72..f1b68b558cf0 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1245,8 +1247,8 @@ static int io_overlaps_block(struct pool *pool, struct bio *bio)
>  
>  static int io_overwrites_block(struct pool *pool, struct bio *bio)
>  {
> -	return (bio_data_dir(bio) == WRITE) &&
> -		io_overlaps_block(pool, bio);
> +	return (bio_data_dir(bio) == WRITE) && io_overlaps_block(pool, bio) &&
> +	       bio_op(bio) != REQ_OP_PROVISION;
>  }
>  
>  static void save_and_set_endio(struct bio *bio, bio_end_io_t **save,
> @@ -1394,6 +1396,9 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
>  	m->data_block = data_block;
>  	m->cell = cell;
>  
> +	if (bio && bio_op(bio) == REQ_OP_PROVISION)
> +		m->bio = bio;
> +
>  	/*
>  	 * If the whole block of data is being overwritten or we are not
>  	 * zeroing pre-existing data, we can issue the bio immediately.

This doesn't seem like the best way to address avoiding passdown of
provision bios (relying on process_prepared_mapping's implementation
that happens to do the right thing if m->bio set).  Doing so cascades
into relying on complete_overwrite_bio() happening to _not_ actually
being specific to "overwrite" bios.

I don't have a better suggestion yet but will look closer.  Just think
this needs to be formalized a bit more rather than it happening to
"just work".

Cc'ing Joe to see what he thinks too.  This is something we can clean
up with a follow-on patch though, so not a show-stopper for this
series.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

