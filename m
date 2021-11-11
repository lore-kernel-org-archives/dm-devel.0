Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABADC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 13:08:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A0428611AD
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 13:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A0428611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-e-bUay_vNleUhDJ2ox7Y4w-1; Thu, 11 Nov 2021 08:08:11 -0500
X-MC-Unique: e-bUay_vNleUhDJ2ox7Y4w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDC25875048;
	Thu, 11 Nov 2021 13:08:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB42C67843;
	Thu, 11 Nov 2021 13:08:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B31275FBDC;
	Thu, 11 Nov 2021 13:08:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABD7x6W019730 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 08:07:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2863D51E3; Thu, 11 Nov 2021 13:07:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2321051E2
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 13:07:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEA8D100B8EA
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 13:07:52 +0000 (UTC)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com
	[209.85.208.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-412-84Sd87rJO3mbC3tgyCrgLw-1; Thu, 11 Nov 2021 08:07:51 -0500
X-MC-Unique: 84Sd87rJO3mbC3tgyCrgLw-1
Received: by mail-ed1-f53.google.com with SMTP id z21so23907200edb.5;
	Thu, 11 Nov 2021 05:07:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=lCYPHFIR2zL2WRQMMRw0vit7el+xs1wKp/P2WsZEnvg=;
	b=Evck/L/CqrrgM9ZMu/ping5SlfuMYht9g7xRtgXuQZF9eYvwFnYHMeWQI1LZVBHO5V
	O0R8SPG15OVOSqF/ubSxllPN+ZqH4PP0rLHn0Iq1KeqmnETJ5ng22J9uJDHzYoj4t7l4
	Zdxu1WGl3eMN3Y8a7HI3Ay7QvMdbwngnO18tZXCo/+gT2cGkU46tdS6CILaeGDJEpAAN
	vHdwGzCxlapvu9ifFZvvRg8iSDXHVBEC1ZdWKSqU6vi/WOxhhfaAA7Dy17VZOkeCtG30
	/X8CzNc4+Vr+J+OnE3iWb/ZoxSLTb5u+GMGbQGcdg2Ph3Giaw31lBiQyRFNS2HkKalX5
	4gHw==
X-Gm-Message-State: AOAM531WSEDeZmj7v8NzkuNLOftyaWXD1U6OEuGUPGVcm+6aYMA66Dll
	UNKJKhQs/LHhnBJaS9iM8tY=
X-Google-Smtp-Source: ABdhPJw9LWGjTEFHq48+DHpYzPZ46EM70QzAP0+SXZL1/24AIxBSCIGcKU/qnG4QMjmBmZpUa5/w8A==
X-Received: by 2002:a05:6402:50ce:: with SMTP id
	h14mr9677570edb.228.1636636069450; 
	Thu, 11 Nov 2021 05:07:49 -0800 (PST)
Received: from [192.168.2.27] (113.151.broadband3.iol.cz. [85.70.151.113])
	by smtp.gmail.com with ESMTPSA id
	hq33sm1489439ejc.119.2021.11.11.05.07.48
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 11 Nov 2021 05:07:48 -0800 (PST)
Message-ID: <da6989dc-1fab-cbd0-4ea9-1b60ea9de964@gmail.com>
Date: Thu, 11 Nov 2021 14:07:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
To: Itai Handler <itai.handler@gmail.com>, dm-devel@redhat.com
References: <CAFpOueRBb9y_Fgb3-c6_eFTKZR9DoAXZmxqqx0UH1Yb2rbV0RQ@mail.gmail.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <CAFpOueRBb9y_Fgb3-c6_eFTKZR9DoAXZmxqqx0UH1Yb2rbV0RQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, snitzer@redhat.com
Subject: Re: [dm-devel] [RFC PATCH 1/1] dm crypt: change maximum sector size
 to PAGE_SIZE
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/11/2021 18:43, Itai Handler wrote:
> Maximum sector size of dm-crypt is currently limited to 4096 bytes.
> 
> On systems where PAGE_SIZE is larger than 4096 bytes, using larger
> sectors can be beneficial for performance reasons.

The limit to 4096 was set because this is the smallest possible
page size that all platform supports.

If you allow a higher size here, the device cannot be activated on a platform
with the smaller page size. (Encrypted sector size becomes
atomic sector size for all upper layers - as you mention below, not
all fs support bigger sectors.)

For LUKS, this is not acceptable - the format is portable by definition.

For specific dm-crypt device, I am not sure. I would better kept
the 4096 page size limit here.

It also depends on crypto API driver here (performance is usually optimized to 4k).
What cipher and encryption mode did you use for test?

How the number looks for random access? Linear test is usually misleading.
I expect there will be big performance problem if you write small data chunks,
writes and encryption will be amplified to full big sectors here...)

(Technical detail: such pat MUST increase dm-crypt minor version.)

Milan

> 
> This patch changes maximum sector size from 4096 bytes to PAGE_SIZE,
> and in addition it changes the type of sector_size in
> struct crypt_config from 'unsigned short int' to 'unsigned int', in
> order to be able to represent larger values.
> 
> On a prototype system which has PAGE_SIZE of 65536 bytes, I saw about
> x2 performance improvement in sequential read throughput benchmark
> while using only about half of the CPU usage, after simply increasing
> sector size from 4096 to 65536 bytes.
> I used ext4 filesystem for that benchmark, which supports 64KiB
> sectors.
> 
> Note: A small change should be made in cryptsetup in order to add
> support for sectors larger than 4096 bytes.
> 
> Signed-off-by: Itai Handler <itai.handler@gmail.com>
> ---
>   drivers/md/dm-crypt.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 916b7da16de2..78c239443bd5 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -168,7 +168,7 @@ struct crypt_config {
>          } iv_gen_private;
>          u64 iv_offset;
>          unsigned int iv_size;
> -       unsigned short int sector_size;
> +       unsigned int sector_size;
>          unsigned char sector_shift;
> 
>          union {
> @@ -3115,9 +3115,9 @@ static int crypt_ctr_optional(struct dm_target
> *ti, unsigned int argc, char **ar
>                          cc->cipher_auth = kstrdup(sval, GFP_KERNEL);
>                          if (!cc->cipher_auth)
>                                  return -ENOMEM;
> -               } else if (sscanf(opt_string, "sector_size:%hu%c",
> &cc->sector_size, &dummy) == 1) {
> +               } else if (sscanf(opt_string, "sector_size:%u%c",
> &cc->sector_size, &dummy) == 1) {
>                          if (cc->sector_size < (1 << SECTOR_SHIFT) ||
> -                           cc->sector_size > 4096 ||
> +                           cc->sector_size > PAGE_SIZE ||
>                              (cc->sector_size & (cc->sector_size - 1))) {
>                                  ti->error = "Invalid feature value for
> sector_size";
>                                  return -EINVAL;
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

