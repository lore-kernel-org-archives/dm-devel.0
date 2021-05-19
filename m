Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4891AC433B4
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 15:51:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C75D160FF2
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 15:51:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C75D160FF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-YQgVPyyVOeCSUBORii72Cw-1; Wed, 19 May 2021 11:51:54 -0400
X-MC-Unique: YQgVPyyVOeCSUBORii72Cw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E62D803635;
	Wed, 19 May 2021 15:51:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D061860C04;
	Wed, 19 May 2021 15:51:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCE931800BB8;
	Wed, 19 May 2021 15:51:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14JFjuto025200 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 11:45:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1097A210EA03; Wed, 19 May 2021 15:45:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C357210EA04
	for <dm-devel@redhat.com>; Wed, 19 May 2021 15:45:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8529C95F34E
	for <dm-devel@redhat.com>; Wed, 19 May 2021 15:45:53 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
	[209.85.221.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-438-5oCQfTvyNLmNlPdKMvadYQ-1; Wed, 19 May 2021 11:45:49 -0400
X-MC-Unique: 5oCQfTvyNLmNlPdKMvadYQ-1
Received: by mail-wr1-f51.google.com with SMTP id y14so12442346wrm.13;
	Wed, 19 May 2021 08:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=HoKYm+RjM06T+m3egtchaR58vmg5foFNNoFnXFUB4KY=;
	b=oGZyc3/vX4N76L91jzWUbWoKt5Smj3jX09GBMFNU7X/vdeCgzSgMtPzOqM2jEXI7fH
	kEUSFFzfNV6YsrZ8D1WHJjedgyfkfLunwuZv593dTmIrYRgi1nscnoPcMxWhGrvYG9XL
	0Gk6rwF+Au6W7mqL9fHgt7VT2HWIr3kJz7/zP0I1Vd/U5SfEcRVNhwrUGY2DkWZo+O/o
	fVu1yNCLL3G7uQU3DPWCLtfsbXh9UwQcMbtsnMMWYD1iCaNelE1wSGdX8wYJmXR0sw/f
	FVDemghw7ZCBYcYhyAwWXRC8LCxOcxuJRMeAM4UoC6z63xFSu456R+AiTP2haB7bgRmq
	yvQQ==
X-Gm-Message-State: AOAM533aEx7HHDyLJUXeyM8czwIAoI1E6hToSl3R4AaxwqBuex522dee
	9GLIz5UdLmf5iciSKPys0jk=
X-Google-Smtp-Source: ABdhPJw1u1uMzrO7DRYw/EmjZmzNxiFE44IwvHFTvvcnJYVrkdDG8gz/h5qX98I3BBLxrENzbKmEbQ==
X-Received: by 2002:a5d:64e5:: with SMTP id g5mr15623125wri.30.1621439148157; 
	Wed, 19 May 2021 08:45:48 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	j14sm6534412wmj.19.2021.05.19.08.45.46
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 19 May 2021 08:45:47 -0700 (PDT)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-12-damien.lemoal@wdc.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <cbbf8310-cc46-7925-c8e9-1edb23d245ca@gmail.com>
Date: Wed, 19 May 2021 17:45:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210519025529.707897-12-damien.lemoal@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 11/11] dm crypt: Fix zoned block device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 19/05/2021 04:55, Damien Le Moal wrote:
> Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector
> of the zone to be written instead of the actual sector location to
> write. The write location is determined by the device and returned to
> the host upon completion of the operation. This interface, while simple
> and efficient for writing into sequential zones of a zoned block
> device, is incompatible with the use of sector values to calculate a
> cypher block IV. All data written in a zone end up using the same IV
> values corresponding to the first sectors of the zone, but read
> operation will specify any sector within the zone resulting in an IV
> mismatch between encryption and decryption.
> 
> To solve this problem, report to DM core that zone append operations are
> not supported. This result in the zone append operations being emulated
> using regular write operations.

Yes, I think this is definitive better approach and it does not need
to fiddle with dm-crypt crypto, thanks.

Just one comment below:

> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/md/dm-crypt.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index f410ceee51d7..44339823371c 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3280,14 +3280,28 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
> +		 * have the same BIO sector, the start of the zone. When the
> +		 * cypher IV mode uses sector values, all data targeting a
> +		 * zone will be encrypted using the first sector numbers of the
> +		 * zone. This will not result in write errors but will
> +		 * cause most reads to fail as reads will use the sector values
> +		 * for the actual data locations, resulting in IV mismatch.
> +		 * To avoid this problem, ask DM core to emulate zone append
> +		 * operations with regular writes.
> +		 */
> +		DMWARN("Zone append operations will be emulated");

Do we really want to fill log with these?

(I know it is not a good example in this context - but during online reencryption,
dm-crypt table segments are continuously reloaded and because the message is in in table constructor,
it will flood the syslog with repeated message.)

Maybe move it to debug or remove it completely?
What would be nice to have some zoned info extension to lsblk so we can investigate
storage stack over zoned device (if there is some sysfs knob to detect it, it should be trivial)... 

Thanks,
Milan

> +		ti->emulate_zone_append = true;
>  	}
>  
>  	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

