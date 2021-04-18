Return-Path: <SRS0=AWIE=JP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69DAC433B4
	for <dm-devel@archiver.kernel.org>; Sun, 18 Apr 2021 11:01:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 37EBA61029
	for <dm-devel@archiver.kernel.org>; Sun, 18 Apr 2021 11:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37EBA61029
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-Cv1l43r9NaGXsAizfdcazg-1; Sun, 18 Apr 2021 07:01:10 -0400
X-MC-Unique: Cv1l43r9NaGXsAizfdcazg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9065107ACE6;
	Sun, 18 Apr 2021 11:01:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49E60100239A;
	Sun, 18 Apr 2021 11:01:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1BD031806D16;
	Sun, 18 Apr 2021 11:00:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13IB0oVn018648 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 18 Apr 2021 07:00:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F112B1111A41; Sun, 18 Apr 2021 11:00:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECD821111A40
	for <dm-devel@redhat.com>; Sun, 18 Apr 2021 11:00:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7983485A5AA
	for <dm-devel@redhat.com>; Sun, 18 Apr 2021 11:00:47 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
	[209.85.128.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-476-OdtwcJa4Mgmzftv5FmPKFw-1; Sun, 18 Apr 2021 07:00:45 -0400
X-MC-Unique: OdtwcJa4Mgmzftv5FmPKFw-1
Received: by mail-wm1-f53.google.com with SMTP id
	q123-20020a1c43810000b029012c7d852459so6871905wma.0; 
	Sun, 18 Apr 2021 04:00:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Nh9WJCxwR1DpCbcRT0OIzlvOZU7PRUVa+7r5RlG2MsQ=;
	b=QmDxlg/lFnIIaNZtJzFyqeEsbcRj4NKsbnuqjo6o26rCNWCQ4gvIXKpDi8YBSkv92+
	aC0w+nR+JzY51D+DAngu5kzr0NU13wfrAXTzwVCpS2h/neTsDXqehqwphQjPf3nn8HY6
	oB4RbGjTJKcFOueqR3QF4hhsY+mc53TMVu/AnSOp4gWjjClviCXLNxMZDOJVsNVYXz9E
	d1ZmsV5oE6CiN+A+wBbheIVWxAuJ7lv0nuEeljWT6+m6lh1RcTIJAjDe29ofa2JD/umQ
	i8lQK3iY2/HLCjk25RVy96jQepVZpGxpsYU4c4m6H/dc+aS80koxpG8CCgYXF/hjdvkJ
	0BqQ==
X-Gm-Message-State: AOAM532U7GZBdfvfQpG+9jTRpPxB8gR2ZJM0RC8DlK7+eGY9V+nNoDqJ
	ipL3TEjCXwb+4+NzwjJDNVV3jBMnfCU=
X-Google-Smtp-Source: ABdhPJwDb1mK9GvRUOVsC90xq1/W8QWaLyEOjFeDNS8s3ouCdV7pSaNtrQ4tWRJ6Lon+YvpSdJwNPg==
X-Received: by 2002:a05:600c:243:: with SMTP id
	3mr16444798wmj.58.1618743643841; 
	Sun, 18 Apr 2021 04:00:43 -0700 (PDT)
Received: from [192.168.8.100] (37-48-40-152.nat.epc.tmcz.cz. [37.48.40.152])
	by smtp.gmail.com with ESMTPSA id
	k11sm15374037wrx.88.2021.04.18.04.00.41
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 18 Apr 2021 04:00:43 -0700 (PDT)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
	<20210417023323.852530-3-damien.lemoal@wdc.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <a073953a-703e-937b-6000-73ad67fffc39@gmail.com>
Date: Sun, 18 Apr 2021 13:00:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210417023323.852530-3-damien.lemoal@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Ondrej Kozina <okozina@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/3] dm crypt: Fix zoned block device
 support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 17/04/2021 04:33, Damien Le Moal wrote:
> Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector of
> the zone to be written instead of the actual location sector to write.
> The write location is determined by the device and returned to the host
> upon completion of the operation. This interface, while simple and
> efficient for writing into sequential zones of a zoned block device, is
> incompatible with the use of sector values to calculate a cypher block
> IV. All data written in a zone end up using the same IV values
> corresponding to the first sectors of the zone, but read operation will
> specify any sector within the zone, resulting in an IV mismatch between
> encryption and decryption.
> 
> Using a single sector value (e.g. the zone start sector) for all read
> and writes into a zone can solve this problem, but at the cost of
> weakening the cypher chosen by the user.

Reusing IV breaks the basic principle in disk encryption that block (sector)
must not be decrypted to correct plaintext if it is relocated.
(IOW, you must not use the same IV with the same key for another sector location.)

Please note that dm-crypt allows being configured to use such insecure
ciphers/IV to provide compatibility with older/foreign encryption systems only.

That said, IV is not the only place in dm-crypt that depends
on position (sector offset).

Dm-crypt allows using AEAD (authenticated encryption).
For now, it requires stacking over dm-integrity, but the idea was to use devices
that can store per-sector metadata natively.

In AEAD, offset (sector) is part of authenticated data (so decryption of relocated
sector fails). For AEAD, we use random IV. So your patch is not complete.

I think the proper solution would be to disable zone append for the dm-crypt
target completely, just set a flag for the whole target.
(Or somehow emulate that global sector offset).

Please do not introduce such complexity as you tried in this patchset.
I am sure this will backfire on us later.

If you want to use encryption with zoned devices properly,
it must be designed for it. FDE is not.

In this case, probably btrfs fs encryption layer is the proper place that allows
configuring different keys or tweak zones IV to allow block-based encryption.

Allowing to stack over dm-crypt in the meantime is OK, but disable these
incompatible zoning features completely, please.

We often use online reencryption - which can switch arbitrary encryption
parameters for active devices expecting sector offset is invariant.
I am not sure if this can even work with zone append and provide expected security.

Also, this brings the question if dm-integrity has the same issue...

Thanks,
Milan


 Instead, to solve this
> problem, explicitly disable support for zone append operations using
> the zone_append_not_supported field of struct dm_target if the IV mode
> used is sector-based, that is for all IVs modes except null and random.
> 
> The cypher flag CRYPT_IV_NO_SECTORS iis introduced to indicate that the
> cypher does not use sector values. This flag is set in
> crypt_ctr_ivmode() for the null and random IV modes and checked in
> crypt_ctr() to set to true zone_append_not_supported if
> CRYPT_IV_NO_SECTORS is not set for the chosen cypher.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Fixes: 8e225f04d2dd ("dm crypt: Enable zoned block device support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/md/dm-crypt.c | 49 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index b0ab080f2567..6ef35bb29ce5 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -137,6 +137,7 @@ enum cipher_flags {
>  	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cipher */
>  	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
>  	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (elephant) */
> +	CRYPT_IV_ZONE_APPEND,		/* IV mode supports zone append operations */
>  };
>  
>  /*
> @@ -2750,9 +2751,10 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
>  	}
>  
>  	/* Choose ivmode, see comments at iv code. */
> -	if (ivmode == NULL)
> +	if (ivmode == NULL) {
>  		cc->iv_gen_ops = NULL;
> -	else if (strcmp(ivmode, "plain") == 0)
> +		set_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags);
> +	} else if (strcmp(ivmode, "plain") == 0)
>  		cc->iv_gen_ops = &crypt_iv_plain_ops;
>  	else if (strcmp(ivmode, "plain64") == 0)
>  		cc->iv_gen_ops = &crypt_iv_plain64_ops;
> @@ -2762,9 +2764,10 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
>  		cc->iv_gen_ops = &crypt_iv_essiv_ops;
>  	else if (strcmp(ivmode, "benbi") == 0)
>  		cc->iv_gen_ops = &crypt_iv_benbi_ops;
> -	else if (strcmp(ivmode, "null") == 0)
> +	else if (strcmp(ivmode, "null") == 0) {
>  		cc->iv_gen_ops = &crypt_iv_null_ops;
> -	else if (strcmp(ivmode, "eboiv") == 0)
> +		set_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags);
> +	} else if (strcmp(ivmode, "eboiv") == 0)
>  		cc->iv_gen_ops = &crypt_iv_eboiv_ops;
>  	else if (strcmp(ivmode, "elephant") == 0) {
>  		cc->iv_gen_ops = &crypt_iv_elephant_ops;
> @@ -2791,6 +2794,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
>  		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
>  	} else if (strcmp(ivmode, "random") == 0) {
>  		cc->iv_gen_ops = &crypt_iv_random_ops;
> +		set_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags);
>  		/* Need storage space in integrity fields. */
>  		cc->integrity_iv_size = cc->iv_size;
>  	} else {
> @@ -3281,14 +3285,32 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  	cc->start = tmpll;
>  
> -	/*
> -	 * For zoned block devices, we need to preserve the issuer write
> -	 * ordering. To do so, disable write workqueues and force inline
> -	 * encryption completion.
> -	 */
>  	if (bdev_is_zoned(cc->dev->bdev)) {
> +		/*
> +		 * For zoned block devices, we need to preserve the issuer write
> +		 * ordering. To do so, disable write workqueues and force inline
> +		 * encryption completion.
> +		 */
>  		set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
>  		set_bit(DM_CRYPT_WRITE_INLINE, &cc->flags);
> +
> +		/*
> +		 * All zone append writes to a zone of a zoned block device will
> +		 * have the same BIO sector (the start of the zone). When the
> +		 * cypher IV mode uses sector values, all data targeting a
> +		 * zone will be encrypted using the first sector numbers of the
> +		 * zone. This will not result in write errors but will
> +		 * cause most reads to fail as reads will use the sector values
> +		 * for the actual data locations, resulting in IV mismatch.
> +		 * To avoid this problem, allow zone append operations only when
> +		 * the selected IV mode indicated that zone append operations
> +		 * are supported, that is, IV modes that do not use sector
> +		 * values (null and random IVs).
> +		 */
> +		if (!test_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags)) {
> +			DMWARN("Zone append is not supported with the selected IV mode");
> +			ti->zone_append_not_supported = true;
> +		}
>  	}
>  
>  	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
> @@ -3356,6 +3378,15 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	struct dm_crypt_io *io;
>  	struct crypt_config *cc = ti->private;
>  
> +	/*
> +	 * For zoned targets, we should not see any zone append operation if
> +	 * the cypher IV mode selected does not support them. In the unlikely
> +	 * case we do see one such operation, warn and fail the request.
> +	 */
> +	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND &&
> +			 !test_bit(CRYPT_IV_ZONE_APPEND, &cc->cipher_flags)))
> +		return DM_MAPIO_KILL;
> +
>  	/*
>  	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
>  	 * - for REQ_PREFLUSH device-mapper core ensures that no IO is in-flight
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

