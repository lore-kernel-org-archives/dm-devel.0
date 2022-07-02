Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F00ECCA481
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MZrnnRERUm5iRgcda5mn92JJAOlw9wKMnqG+x0QT/Ns=;
	b=WyoAlu0rO1eQh+PoRBkvGSFpB7nEAE4b2tqOeXfoSI2AnT9jN5xZJbbFBq62Mx1hSBdAfv
	y7TcRHEpBV5ldFHU9YCO8JEIjVQAWQOM0B+Hk093TPV4e2I24eM8xC737wh0prKSoB+EH4
	ExeFINDMmlNkSEDFkgKzTXBS9v0LgeU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-SJ-rMG2VP2-bAySkQ-bJtg-1; Thu, 07 Jul 2022 03:28:12 -0400
X-MC-Unique: SJ-rMG2VP2-bAySkQ-bJtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B296B181E06C;
	Thu,  7 Jul 2022 07:28:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1A7E2166B29;
	Thu,  7 Jul 2022 07:28:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8FBB6194706B;
	Thu,  7 Jul 2022 07:28:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B586A1947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 20:46:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8D642166B29; Sat,  2 Jul 2022 20:46:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A48622166B26
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 20:46:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8995F185A7A4
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 20:46:34 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-LBV15yAGMeKFKaI8DH5WFQ-1; Sat, 02 Jul 2022 16:46:32 -0400
X-MC-Unique: LBV15yAGMeKFKaI8DH5WFQ-1
Received: by mail-qt1-f171.google.com with SMTP id x1so4555927qtv.8;
 Sat, 02 Jul 2022 13:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=N+mq0Y7evuA/KRdL0BLthRO/Vn35FRdsKAND75BcEFY=;
 b=dikFs6n12Sy5bWrmPiI/so4G3LZQhTp1ssAz+3UyXQDcNWZQ4R7HLoe9d4XGz3dFvF
 RrDW5vlhrR+RT6CZa8wRbSgYyyf+udaMbrLaLSyOwSCfnNX67+xZld4hy9DPE8uesQzi
 tChZJfvEikag13xiMT0K+/c8KT+WLt/a3mU4Yq3h8Z5vRpnzZOgZYYEsAl0Buhj+xF88
 weh46O3LXe2dyqHd9X6CXa0evM16DfvvpC9zvJVblqfs1BMUZiNt6iTsryia4x7Mm28c
 d/ThsQGhuDWOX1dWLElkIjYX0ULMunKaJZFvB4wwhMndrQeo+LxYIad0fns/k7+hlU1Y
 qQhw==
X-Gm-Message-State: AJIora8/9PM9UbWGuDgphbLOA6XHzIhPc7CeucYTaSjId717ODMS3FMC
 HNYu2Qa1tfGiUgnZa72ScAs=
X-Google-Smtp-Source: AGRyM1vjFgjitLBuQOeSuo/OKde0C2zCG2i7rCQmnsS9b/7NGq3EkHHEPjctpLsqsrGPdIjCur6S0A==
X-Received: by 2002:a05:6214:19cb:b0:470:8fae:eb90 with SMTP id
 j11-20020a05621419cb00b004708faeeb90mr21566832qvc.92.1656794792059; 
 Sat, 02 Jul 2022 13:46:32 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:e838:b1c2:b125:986a])
 by smtp.gmail.com with ESMTPSA id
 r132-20020a37a88a000000b006af373cec2csm12713874qke.70.2022.07.02.13.46.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Jul 2022 13:46:31 -0700 (PDT)
Date: Sat, 2 Jul 2022 13:46:31 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <YsCup7Kjzm9QWeZ5@yury-laptop>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: Re: [dm-devel] [PATCH 1/4] s390/cio: Rename bitmap_size() as
 idset_bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 andriy.shevchenko@linux.intel.com, gor@linux.ibm.com, linux@rasmusvillemoes.dk,
 hca@linux.ibm.com, ntfs3@lists.linux.dev, snitzer@kernel.org,
 oberpar@linux.ibm.com, linux-kernel@vger.kernel.org,
 almaz.alexandrovich@paragon-software.com, dm-devel@redhat.com,
 svens@linux.ibm.com, vneethv@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, agk@redhat.com
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

On Sat, Jul 02, 2022 at 08:29:09PM +0200, Christophe JAILLET wrote:
> In order to introduce a bitmap_size() function in the bitmap API, we have
> to rename functions with a similar name.
> 
> Add a "idset_" prefix and change bitmap_size() into idset_bitmap_size().
> 
> No functional change.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/s390/cio/idset.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/cio/idset.c b/drivers/s390/cio/idset.c
> index 45f9c0736be4..e1e77fe080bf 100644
> --- a/drivers/s390/cio/idset.c
> +++ b/drivers/s390/cio/idset.c
> @@ -16,7 +16,7 @@ struct idset {
>  	unsigned long bitmap[];
>  };
>  
> -static inline unsigned long bitmap_size(int num_ssid, int num_id)
> +static inline unsigned long idset_bitmap_size(int num_ssid, int num_id)
>  {
>  	return BITS_TO_LONGS(num_ssid * num_id) * sizeof(unsigned long);
>  }
> @@ -25,11 +25,11 @@ static struct idset *idset_new(int num_ssid, int num_id)
>  {
>  	struct idset *set;
>  
> -	set = vmalloc(sizeof(struct idset) + bitmap_size(num_ssid, num_id));
> +	set = vmalloc(sizeof(struct idset) + idset_bitmap_size(num_ssid, num_id));
>  	if (set) {
>  		set->num_ssid = num_ssid;
>  		set->num_id = num_id;
> -		memset(set->bitmap, 0, bitmap_size(num_ssid, num_id));
> +		memset(set->bitmap, 0, idset_bitmap_size(num_ssid, num_id));

We don't need bitmap_size() here, we need to replace memset() with
bitmap_zero().

>  	}
>  	return set;
>  }
> @@ -41,7 +41,7 @@ void idset_free(struct idset *set)
>  
>  void idset_fill(struct idset *set)
>  {
> -	memset(set->bitmap, 0xff, bitmap_size(set->num_ssid, set->num_id));
> +	memset(set->bitmap, 0xff, idset_bitmap_size(set->num_ssid, set->num_id));

Same, but bitmap_fill().

>  }
>  
>  static inline void idset_add(struct idset *set, int ssid, int id)
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

