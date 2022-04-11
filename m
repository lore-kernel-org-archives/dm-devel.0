Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A242C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 00:19:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-FlxRI2fTM1Gfv3zBXZMUjw-1; Sun, 10 Apr 2022 20:19:09 -0400
X-MC-Unique: FlxRI2fTM1Gfv3zBXZMUjw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 854E6101AA44;
	Mon, 11 Apr 2022 00:19:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E69453CE;
	Mon, 11 Apr 2022 00:19:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1839C19451F1;
	Mon, 11 Apr 2022 00:19:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02C4D19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 00:19:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E194A54ACA4; Mon, 11 Apr 2022 00:19:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD54748FB17
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 00:19:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B20543804505
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 00:19:02 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-nHSbCOS_M3aaPp3cxgJ59g-1; Sun, 10 Apr 2022 20:19:00 -0400
X-MC-Unique: nHSbCOS_M3aaPp3cxgJ59g-1
X-IronPort-AV: E=Sophos;i="5.90,250,1643644800"; d="scan'208";a="196445340"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2022 08:18:59 +0800
IronPort-SDR: bSGKL1fNu5igXqDiGy5mV/KMF1TJv+mMphYd4xIxzjPkc5nSnsp1Jmz3JHhb04uFU1ZHNt8598
 I0GqU7fFMHA3/is+T69hvi93m5/Nm7t6Is+fg6Jjo3hyV7YFeqMLEmo8VLxWXLqDeU4iY1nIQA
 0pQ+J6DUCUoPd+39b3bvKkkuCBTLcE3Au4+aIl3EgeINujwKdEJoeQPJnGvtUOQN0jYpbUFkHS
 yZV+HDCbga6TgrHS9VoUztTL81MP2oNvUfQHdlcOa+4A6UsqzJCBzVdKDHX2TZRLPBwPdJdyuK
 7k+rk30+5IxPJG9xKWl97RAs
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Apr 2022 16:49:29 -0700
IronPort-SDR: +y3+6igybrXfk2l4b2+2zV1Y43kEm9YDNz0AsUAdGeyfwkQkvjx66c9tI4qQ5fWPyiDJjzCWYy
 O2z9oWK/YL46Gc2ctXotjk86ebhOXmWZLD1lXVEgcUeLyy6B1FulyJJXyhYbBNbgxjhG9puxpF
 TLUcflUGHI3lgOEfpwoaZj6CNknRzHlwyE0KTj9VEKiVG2Ifdi1BSMkV4fLJcEKBKycsZ+dqsz
 ELKkBE8jE+NbmHp+yjjM+wY0WN0RAIaIvW2sHG1x/hWjZWUFubhveyrFQW4EtCqP5dGKZfCGGw
 kRU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Apr 2022 17:18:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kc8bl2MWbz1Rwrw
 for <dm-devel@redhat.com>; Sun, 10 Apr 2022 17:18:59 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id XFbyOtlvAM7c for <dm-devel@redhat.com>;
 Sun, 10 Apr 2022 17:18:58 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kc8bk290Wz1Rvlx;
 Sun, 10 Apr 2022 17:18:58 -0700 (PDT)
Message-ID: <8b9078c2-7884-a5b5-5aa9-ad284b4068ef@opensource.wdc.com>
Date: Mon, 11 Apr 2022 09:18:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Ming Lei <ming.lei@redhat.com>, Mike Snitzer <snitzer@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
 <20220408171254.935171-2-ming.lei@redhat.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220408171254.935171-2-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/9/22 02:12, Ming Lei wrote:
> dm_zone_map_bio() is only called from __map_bio in which the io's
> reference is grabbed already, and the reference won't be released
> until the bio is submitted, so no necessary to do it dm_zone_map_bio
> any more.

I do not think that this patch is correct. Removing the extra reference on
the io can lead to problems if the io is completed in the target
->map(ti, clone) call or before dm_zone_map_bio_end() is called for the
DM_MAPIO_SUBMITTED or DM_MAPIO_REMAPPED cases. dm_zone_map_bio_end() needs
to reference the original bio, so we must ensure that it is still around,
which means keeping an extra IO reference to avoid dm_io_dec_pending()
calling bio_endio() on the orgi bio before dm_zone_map_bio_end() has a
chance to run.

> 
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm-core.h |  7 -------
>  drivers/md/dm-zone.c | 10 ----------
>  drivers/md/dm.c      |  7 ++++++-
>  3 files changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 4277853c7535..13136bd47cb3 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -277,13 +277,6 @@ static inline void dm_io_set_flag(struct dm_io *io, unsigned int bit)
>  	io->flags |= (1U << bit);
>  }
>  
> -static inline void dm_io_inc_pending(struct dm_io *io)
> -{
> -	atomic_inc(&io->io_count);
> -}
> -
> -void dm_io_dec_pending(struct dm_io *io, blk_status_t error);
> -
>  static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
>  {
>  	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index c1ca9be4b79e..85d3c158719f 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -545,13 +545,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  		return DM_MAPIO_KILL;
>  	}
>  
> -	/*
> -	 * The target map function may issue and complete the IO quickly.
> -	 * Take an extra reference on the IO to make sure it does disappear
> -	 * until we run dm_zone_map_bio_end().
> -	 */
> -	dm_io_inc_pending(io);
> -
>  	/* Let the target do its work */
>  	r = ti->type->map(ti, clone);
>  	switch (r) {
> @@ -580,9 +573,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  		break;
>  	}
>  
> -	/* Drop the extra reference on the IO */
> -	dm_io_dec_pending(io, sts);
> -
>  	if (sts != BLK_STS_OK)
>  		return DM_MAPIO_KILL;
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3c5fad7c4ee6..b8424a4b4725 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -929,11 +929,16 @@ static inline bool dm_tio_is_normal(struct dm_target_io *tio)
>  		!dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
>  }
>  
> +static void dm_io_inc_pending(struct dm_io *io)
> +{
> +	atomic_inc(&io->io_count);
> +}
> +
>  /*
>   * Decrements the number of outstanding ios that a bio has been
>   * cloned into, completing the original io if necc.
>   */
> -void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
> +static void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
>  {
>  	/* Push-back supersedes any I/O errors */
>  	if (unlikely(error)) {


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

