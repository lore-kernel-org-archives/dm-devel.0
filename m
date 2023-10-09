Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E5ECD68F5
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696921395;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QIGOiQPchDzlceSblMKE8m9c74luFnUem1aCtFeRzq4=;
	b=FO0oLUVDRhai56iXTKsHYGWeCLAFNoijPysCjV9/rQHa46r0lPv9apDWkBdlFCPNsUOBqd
	IcXMDVDvTghUvyOV/j9IoEpCiDWAqtkSK1XCI4mMoEpIjI1606o0ZwsJLnCAGJRg0GOs0S
	oDAAa//deQs8EdDcs5WzizOveuGZjy8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-wRvoqJSrNqq8rjrazvTGLQ-1; Tue, 10 Oct 2023 03:03:11 -0400
X-MC-Unique: wRvoqJSrNqq8rjrazvTGLQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 097E81C03D95;
	Tue, 10 Oct 2023 07:03:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E618F15C5E;
	Tue, 10 Oct 2023 07:03:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6025319452ED;
	Tue, 10 Oct 2023 07:02:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 102DA19465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 16:35:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 872F4492B16; Mon,  9 Oct 2023 16:35:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FDF047AD4A
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 16:35:24 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 639A5101AA70
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 16:35:24 +0000 (UTC)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com
 [209.85.128.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-YsiTGm_-OkWDQgng36ZHPg-1; Mon, 09 Oct 2023 12:35:22 -0400
X-MC-Unique: YsiTGm_-OkWDQgng36ZHPg-1
Received: by mail-yw1-f169.google.com with SMTP id
 00721157ae682-59f6492b415so40738937b3.0
 for <dm-devel@redhat.com>; Mon, 09 Oct 2023 09:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696869322; x=1697474122;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RsC4B5mELowhLCBdNvaIf+LwPDrz+keu3BL55c6ZynM=;
 b=G5BjZC5+wOp4nD7nztLcZUi8GqFxO8yvn/PdLyGU5wGL+5dzF0TbbsB3xiwGpI18gm
 Khv/m2zwZLdhRy5S6cLJ5LlItOWHw/KB/AK50j0SJpr2xyUMn9phSN9mzaRcadVcz0s8
 46dDWAQYRvVEBpQS6XWf4rOks02/Oq+wB6w2zU/L4CznEyvh2Wh8gx4Ax5VwOgP01p8/
 l+NiBessC/LCu8w9vubaxm/gXrNbZdLSyOKVBs0MNwfFxELYmE1RoKk+GZZ83s5deckt
 8LzCv0ukcOY5WE2fK0gHOlaS6X6gksOaGsjZ9E+Dgr/GzOgRDDqlcHMzEeQC6xvYEWib
 xk+w==
X-Gm-Message-State: AOJu0YwIhRo/4we9gXiytxlIK/bW0tQVdkSBCHtDrYwvDwu6mo+Qeq75
 7eq7v2YhKs27fg+VCFDXD1cLHRiI5tIYGw==
X-Google-Smtp-Source: AGHT+IFsvzJ6MeZI8r2v1L+4g/jHEVPfPdzddzGB/p3atEyZSUf9/4/r7GGX68WKl3pdJXGPfRRxWA==
X-Received: by 2002:a81:a1c2:0:b0:5a4:dde3:6db5 with SMTP id
 y185-20020a81a1c2000000b005a4dde36db5mr8226753ywg.10.1696869321805; 
 Mon, 09 Oct 2023 09:35:21 -0700 (PDT)
Received: from localhost ([2607:fb90:be22:da0:a050:8c3a:c782:514b])
 by smtp.gmail.com with ESMTPSA id
 s7-20020a817707000000b005707fb5110bsm3798669ywc.58.2023.10.09.09.35.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 Oct 2023 09:35:21 -0700 (PDT)
Date: Mon, 9 Oct 2023 09:35:20 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Message-ID: <ZSQryML6+uySSQ55@yury-ThinkPad>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
 <20231009151026.66145-6-aleksander.lobakin@intel.com>
MIME-Version: 1.0
In-Reply-To: <20231009151026.66145-6-aleksander.lobakin@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 10 Oct 2023 07:02:51 +0000
Subject: Re: [dm-devel] [PATCH 05/14] s390/cio: rename bitmap_size() ->
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
Cc: linux-s390@vger.kernel.org, ntfs3@lists.linux.dev,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 David Ahern <dsahern@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 09, 2023 at 05:10:17PM +0200, Alexander Lobakin wrote:
> bitmap_size() is a pretty generic name and one may want to use it for
> a generic bitmap API function. At the same time, its logic is not
> "generic", i.e. it's not just `nbits -> size of bitmap in bytes`
> converter as it would be expected from its name.
> Add the prefix 'idset_' used throughout the file where the function
> resides.

At the first glance, this custom implementation just duplicates the
generic one that you introduce in the following patch. If so, why
don't you switch idset to just use generic bitmap_size()?

> 
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
> idset_new() really wants its vmalloc() + memset() pair to be replaced
> with vzalloc().
> ---
>  drivers/s390/cio/idset.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/cio/idset.c b/drivers/s390/cio/idset.c
> index 45f9c0736be4..0a1105a483bf 100644
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
> @@ -25,11 +25,12 @@ static struct idset *idset_new(int num_ssid, int num_id)
>  {
>  	struct idset *set;
>  
> -	set = vmalloc(sizeof(struct idset) + bitmap_size(num_ssid, num_id));
> +	set = vmalloc(sizeof(struct idset) +
> +		      idset_bitmap_size(num_ssid, num_id));
>  	if (set) {
>  		set->num_ssid = num_ssid;
>  		set->num_id = num_id;
> -		memset(set->bitmap, 0, bitmap_size(num_ssid, num_id));
> +		memset(set->bitmap, 0, idset_bitmap_size(num_ssid, num_id));
>  	}
>  	return set;
>  }
> @@ -41,7 +42,8 @@ void idset_free(struct idset *set)
>  
>  void idset_fill(struct idset *set)
>  {
> -	memset(set->bitmap, 0xff, bitmap_size(set->num_ssid, set->num_id));
> +	memset(set->bitmap, 0xff,
> +	       idset_bitmap_size(set->num_ssid, set->num_id));
>  }
>  
>  static inline void idset_add(struct idset *set, int ssid, int id)
> -- 
> 2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

