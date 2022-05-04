Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64135C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 14:41:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-ilODsvNUMjC2uU-rZNBt8g-1; Wed, 04 May 2022 10:41:16 -0400
X-MC-Unique: ilODsvNUMjC2uU-rZNBt8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A42D811E80;
	Wed,  4 May 2022 14:41:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF8552166B41;
	Wed,  4 May 2022 14:41:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7718B1947046;
	Wed,  4 May 2022 14:41:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B8C7E1947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 14:41:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 94FD11565292; Wed,  4 May 2022 14:41:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 911071565291
 for <dm-devel@redhat.com>; Wed,  4 May 2022 14:41:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 797671014A63
 for <dm-devel@redhat.com>; Wed,  4 May 2022 14:41:09 +0000 (UTC)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
 [209.85.218.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-rvHRjyHSN8e9a1FxiBhRNA-2; Wed, 04 May 2022 10:41:06 -0400
X-MC-Unique: rvHRjyHSN8e9a1FxiBhRNA-2
Received: by mail-ej1-f54.google.com with SMTP id g6so3338893ejw.1;
 Wed, 04 May 2022 07:41:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=BzRY9ZN2JX3MmgZfmHZC73VvnmwtVQcDJ3YTGcNusTg=;
 b=0J4/fu/KVMEWlIbI+j6guCUe5XMPM0pVAqKpWIzT5I3l+hIXqHXo+CHtWjs0a96Y/h
 roDadhW+KPVMIClSMFBm/5Wx5zCacW1ccedhhLyvbrJHB/ZliZIu9iVGN5cyPHkGKv4V
 6VF/AMSlViW/09CqKOF18kKV1ZC9EGIHhWUBrF95u6newAkiV7nAwgimFymzhV5nSJVy
 RCuT1KNq2aHJy0Xm6lv6+YeymB+rGeM9kD2rd0kN1IjckIBraz/jfFrg39p1bup2p4eY
 iUPmjaErWGaSX7nsPpDXlOuFrCro1PlEwoNTvpRgTTycAVz/y3TnpyxXh/tzJsgvFIbF
 pUAw==
X-Gm-Message-State: AOAM5313POoMVuHDfYQf9+zzT2AIcArCcEA/P5cNnzy1TasCSxQnOKSJ
 jTDV9KUANnWjHymfJiGVvlbq5+ASaFo=
X-Google-Smtp-Source: ABdhPJwIx6oed39vbFrSdMydmxW0opKFK//08RHWP7xl9lj7S+abHoBJfkLirDBniZuYdxubQFTurA==
X-Received: by 2002:a17:907:6095:b0:6e7:cc3f:c33d with SMTP id
 ht21-20020a170907609500b006e7cc3fc33dmr20957831ejc.570.1651675264874; 
 Wed, 04 May 2022 07:41:04 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 ml20-20020a170906cc1400b006f3ef214dc6sm5774861ejb.44.2022.05.04.07.41.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 07:41:04 -0700 (PDT)
Message-ID: <0418bcca-2e7c-f4a2-d261-788b534c3481@gmail.com>
Date: Wed, 4 May 2022 16:41:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
References: <alpine.LRH.2.02.2204241654220.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2204250851320.1699@file01.intranet.prod.int.rdu2.redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <alpine.LRH.2.02.2204250851320.1699@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2] dm-crypt: make printing of the key
 constant-time
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 25/04/2022 14:53, Mikulas Patocka wrote:
> This is the second version of this patch. It casts the value to unsigned
> before doing the shift, because right shift of a negative number is not
> defined.
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The device mapper dm-crypt target is using scnprintf("%02x", cc->key[i]) to
> report the current key to userspace. However, this is not constant-time
> operation and it may leak information about the key via timing, via cache
> access patterns or via the branch predictor.
> 
> This patch changes it to use "%c" instead. We introduce a function
> hex2asc. hex2asc converts a number in the range 0 ... 15 to an ascii
> character and it is coded in such a way that it contains no branches and
> no memory accesses.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc; stable@vger.kernel.org

I have run some tests with it, also cryptsetup testsuite is fine.
If it helps, you can add

Tested-by: Milan Broz <gmazyland@gmail.com>

Milan



> 
> ---
>   drivers/md/dm-crypt.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-crypt.c	2022-04-25 14:41:15.000000000 +0200
> +++ linux-2.6/drivers/md/dm-crypt.c	2022-04-25 14:42:06.000000000 +0200
> @@ -3439,6 +3439,11 @@ static int crypt_map(struct dm_target *t
>   	return DM_MAPIO_SUBMITTED;
>   }
>   
> +static char hex2asc(unsigned char c)
> +{
> +	return c + '0' + ((unsigned)(9 - c) >> 4 & 0x27);
> +}
> +
>   static void crypt_status(struct dm_target *ti, status_type_t type,
>   			 unsigned status_flags, char *result, unsigned maxlen)
>   {
> @@ -3459,7 +3464,7 @@ static void crypt_status(struct dm_targe
>   				DMEMIT(":%u:%s", cc->key_size, cc->key_string);
>   			else
>   				for (i = 0; i < cc->key_size; i++)
> -					DMEMIT("%02x", cc->key[i]);
> +					DMEMIT("%c%c", hex2asc(cc->key[i] >> 4), hex2asc(cc->key[i] & 0xf));
>   		} else
>   			DMEMIT("-");
>   
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

