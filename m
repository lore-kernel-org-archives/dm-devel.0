Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D39C43334
	for <dm-devel@archiver.kernel.org>; Fri, 10 Jun 2022 16:26:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-2Hyw5DoMPoipLpPeiLD06w-1; Fri, 10 Jun 2022 12:26:28 -0400
X-MC-Unique: 2Hyw5DoMPoipLpPeiLD06w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1272185A7B2;
	Fri, 10 Jun 2022 16:26:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7399C2166B26;
	Fri, 10 Jun 2022 16:26:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 27C1B194704E;
	Fri, 10 Jun 2022 16:26:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0C70319466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Jun 2022 16:26:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F16921730C; Fri, 10 Jun 2022 16:26:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC6AD1131A
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 16:26:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1F983817A6A
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 16:26:22 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-atpADNSZPFGd46JOtwKuPw-1; Fri, 10 Jun 2022 12:26:18 -0400
X-MC-Unique: atpADNSZPFGd46JOtwKuPw-1
Received: by mail-qv1-f48.google.com with SMTP id a9so18954158qvt.6
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 09:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fhscStQQRtPcccNUsRr4YZQVo1ovuXtwrHw5X+UP0W8=;
 b=yj+L05OJGR0sJHMcDTIubGIXj9kfncUZZG5Ty8c2XxctFsZSRR1wxhNOEiD1TZRZKe
 cOzyt8/cJYK7iefEzDGmctH34uZsxuKRoKnqtIVKbPYfaooIvlZCxiUDfqOh5gruPYtr
 MlBp9Btpqak66ZK3VmnxxznBeXtp80+Sz+zDc2no8G+HmKNwNg1pUe9Jw/14cGlDAjo/
 ORyn6mZNHPmzjo2hjCVDzIqfe+t0h7do/RaFn1KXWf4cPrc25ouO+hA6ZohM3xZpKFgh
 upbKV1HjmF5QMw2POq4n9AlRyh0LApXFwbgk6padcvGpoT5zyNgsp57cknmM0CWC3rt/
 Z5Gw==
X-Gm-Message-State: AOAM531tzEZBunetG2BctWbQS8VwF6wuaBGo86Dot9VdhzisGyXiPBwT
 5BqOWZsbsd9Hc5lbnvSISUZJmBcl/WDAgpM=
X-Google-Smtp-Source: ABdhPJzSkKHBZir4uwZrmCMeDM0Z6eZgTtMuxFaw2GeQ5ABf0rbwtoyDyK/+aFKN3Q918GOUqOGQng==
X-Received: by 2002:a0c:fd42:0:b0:461:c75f:e530 with SMTP id
 j2-20020a0cfd42000000b00461c75fe530mr90750188qvs.27.1654878377722; 
 Fri, 10 Jun 2022 09:26:17 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w15-20020a05620a424f00b006a69d7f390csm18917593qko.103.2022.06.10.09.26.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Jun 2022 09:26:17 -0700 (PDT)
Date: Fri, 10 Jun 2022 12:26:16 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Message-ID: <YqNwqGeI/4sy9zn1@redhat.com>
References: <20220609114300.453650-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
In-Reply-To: <20220609114300.453650-1-shinichiro.kawasaki@wdc.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] dm crypt: set bdev to clone bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 09 2022 at  7:43P -0400,
Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com> wrote:

> After the commit ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone"),
> bdev is no longer set to clone bio for ->map function. Instead, each DM
> targets shall set bdev to the clone bio by calling bio_set_dev() before
> issuing IO. Also the commit ensured that dm_zone_endio() is called from
> clone_endio() only when DM targets set bdev to the clone bio.
> 
> However, crypt_map() of dm-crypt does not call bio_set_dev() for every
> clone bio. Then dm_zone_endio() is not called at completion of the bios
> and zone locks are not properly unlocked. This triggers a hang when
> blktests block/004 is run for dm-crypt on zoned block devices [1]. To
> avoid the hang, call bio_set_dev() for every bio in crypt_map().
> 
> [1]
> 
> [ 6596.702977][T55017] run blktests block/004 at 2022-06-07 20:18:01

<snip>

Please refrain from putting stack traces in patch headers whenever
possible.  Really no need for this, especially given how long this one
is!

I revised the header as follows:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=cae0053631cd4b02bb882b53c7da20652b038049
 
> Fixes: ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/md/dm-crypt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 159c6806c19b..c68523a89428 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3378,6 +3378,8 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	struct dm_crypt_io *io;
>  	struct crypt_config *cc = ti->private;
>  
> +	bio_set_dev(bio, cc->dev->bdev);
> +
>  	/*
>  	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
>  	 * - for REQ_PREFLUSH device-mapper core ensures that no IO is in-flight
> @@ -3385,7 +3387,6 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	 */
>  	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
>  	    bio_op(bio) == REQ_OP_DISCARD)) {
> -		bio_set_dev(bio, cc->dev->bdev);
>  		if (bio_sectors(bio))
>  			bio->bi_iter.bi_sector = cc->start +
>  				dm_target_offset(ti, bio->bi_iter.bi_sector);
> -- 
> 2.36.1
> 

BUT something isn't quite adding up with why you need this change
given commit ca522482e3ea has this compatibility code:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9650ba2075b8..d62f1354ecbf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -581,7 +581,9 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
        struct dm_target_io *tio;
        struct bio *clone;

-       clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO, &md->io_bs);
+       clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->io_bs);
+       /* Set default bdev, but target must bio_set_dev() before issuing IO */
+       clone->bi_bdev = md->disk->part0;

        tio = clone_to_tio(clone);
        tio->flags = 0;

The clone bio passed to crypt_map() _should_ be the same as was passed
before commit ca522482e3ea (It gets set to md->disk->part0 rather than
bio->bi_bdev but they really should point to the same top-level DM
bdev).

So why is your extra override to have dm-crypt point to its underlying
data device important now?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

