Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABD015ADD
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZmEwfGD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524294;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=6Gni6mzvaBaFKxuMxn9hZgE2UC6/dQHw9AadxVgtVNo=;
	b=EZmEwfGD067GWjOTLpI2TLvZWCdgQte5BaC4QiOHpJaTM6/5cbHHYXzyA+nBnXIImyJs/E
	YCX+QZwIP9XhGIu2Q8WLs0AsayNvogErYNJA0IXv2vZaupxPmYKOQ8USxseyINX3WiDjLr
	l5T05gXJdFsZx1BPUhOZDqkiUlx4HjA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-fAJ238moPDy3v1dpAJ1xkQ-1; Tue, 17 Oct 2023 02:31:33 -0400
X-MC-Unique: fAJ238moPDy3v1dpAJ1xkQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2D9E8F15C0
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC19A492BFC
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B25219466EE
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 26FBC1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 Oct 2023 17:48:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3924492BFC; Mon, 16 Oct 2023 17:48:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DBD57492BFA
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 17:48:27 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6EBD8E8C61
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 17:48:27 +0000 (UTC)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
 [209.85.219.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-_S4XuzCAOpOTGue17Iq3MQ-1; Mon, 16 Oct 2023 13:48:25 -0400
X-MC-Unique: _S4XuzCAOpOTGue17Iq3MQ-1
Received: by mail-yb1-f176.google.com with SMTP id
 3f1490d57ef6-d9a4c0d89f7so5595694276.1
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 10:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1697478505; x=1698083305;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6Gni6mzvaBaFKxuMxn9hZgE2UC6/dQHw9AadxVgtVNo=;
 b=YwV0Ld7tzN3dzFoSekOY8bEGyDSfV/AxzmTySdR95JImwvsG8pMHQr2P4oVeNWrOWf
 5RfVKKjMfVR3jeDuqg/7FZECFY8YR5ISR8CN5gf5EqUSafc9Bh93l34ibkgxXg5fXl+f
 6euSmWMXnkvxK9I5VyLT+/0Me0K9Gd7DH/dKcPUSryqpQOY4V4w3gHLOycJC4HjjFPzW
 DgSSbRAgCFH3xQxL1yZpt0rHbEZUwaMkwPfzt0/hzWJJe+FatY++IkEPbcw0m0OlIBQn
 /VPNwt6pRIGDaQ7/zUTlJTNUk5CcSzNL7pAnxERpAQ/svTkT7wYgK0knTYDFHjeb3nPX
 6sdQ==
X-Gm-Message-State: AOJu0Yx5sH1vOoDYHZgBM6IJHbfHxuXnI6p7Pj0g6ukIjTAgcs/3gRlP
 dD9hUvmoGZ6aKVImxdlyCpw=
X-Google-Smtp-Source: AGHT+IFxhp5Fg6dD0ShGrsQoX3lKB8P2VZfUuC29sX4UXOWErGVDVNAevi+hJU45YX1WEraFAAwehQ==
X-Received: by 2002:a25:3742:0:b0:d9a:4a5f:415d with SMTP id
 e63-20020a253742000000b00d9a4a5f415dmr18010718yba.0.1697478505154; 
 Mon, 16 Oct 2023 10:48:25 -0700 (PDT)
Received: from localhost ([2607:fb90:be80:2b9:64a5:5a0e:5435:bd4])
 by smtp.gmail.com with ESMTPSA id
 q17-20020a25f911000000b00d20d4ffbbdbsm2775571ybe.0.2023.10.16.10.48.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 Oct 2023 10:48:24 -0700 (PDT)
Date: Mon, 16 Oct 2023 10:48:23 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH v2 09/13] bitmap: make bitmap_{get,set}_value8() use
 bitmap_{read,write}()
Message-ID: <ZS13Z8Ls69lEBYib@yury-ThinkPad>
References: <20231016165247.14212-1-aleksander.lobakin@intel.com>
 <20231016165247.14212-10-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231016165247.14212-10-aleksander.lobakin@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 17 Oct 2023 06:31:30 +0000
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 16, 2023 at 06:52:43PM +0200, Alexander Lobakin wrote:
> Now that we have generic bitmap_read() and bitmap_write(), which are
> inline and try to take care of non-bound-crossing and aligned cases
> to keep them optimized, collapse bitmap_{get,set}_value8() into
> simple wrappers around the former ones.
> bloat-o-meter shows no difference in vmlinux and -2 bytes for
> gpio-pca953x.ko, which says the code doesn't get optimized worse.

That's just amazing!

bloat-o-meter itself doesn't say on optimization, but in this case
I think that BITS_PER_BYTE passed at compile time allows to generate
just as good code with the generic bitmap_write/read().

Acked-by: Yury Norov <yury.norov@gmail.com>

> Suggested-by: Yury Norov <yury.norov@gmail.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  include/linux/bitmap.h | 38 +++++---------------------------------
>  1 file changed, 5 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 2020cb534ed7..c2680f67bc4e 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -572,39 +572,6 @@ static inline void bitmap_from_u64(unsigned long *dst, u64 mask)
>  	bitmap_from_arr64(dst, &mask, 64);
>  }
>  
> -/**
> - * bitmap_get_value8 - get an 8-bit value within a memory region
> - * @map: address to the bitmap memory region
> - * @start: bit offset of the 8-bit value; must be a multiple of 8
> - *
> - * Returns the 8-bit value located at the @start bit offset within the @src
> - * memory region.
> - */
> -static inline unsigned long bitmap_get_value8(const unsigned long *map,
> -					      unsigned long start)
> -{
> -	const size_t index = BIT_WORD(start);
> -	const unsigned long offset = start % BITS_PER_LONG;
> -
> -	return (map[index] >> offset) & 0xFF;
> -}
> -
> -/**
> - * bitmap_set_value8 - set an 8-bit value within a memory region
> - * @map: address to the bitmap memory region
> - * @value: the 8-bit value; values wider than 8 bits may clobber bitmap
> - * @start: bit offset of the 8-bit value; must be a multiple of 8
> - */
> -static inline void bitmap_set_value8(unsigned long *map, unsigned long value,
> -				     unsigned long start)
> -{
> -	const size_t index = BIT_WORD(start);
> -	const unsigned long offset = start % BITS_PER_LONG;
> -
> -	map[index] &= ~(0xFFUL << offset);
> -	map[index] |= value << offset;
> -}
> -
>  /**
>   * bitmap_read - read a value of n-bits from the memory region
>   * @map: address to the bitmap memory region
> @@ -676,6 +643,11 @@ static inline void bitmap_write(unsigned long *map,
>  	map[index + 1] |= (value >> space);
>  }
>  
> +#define bitmap_get_value8(map, start)			\
> +	bitmap_read(map, start, BITS_PER_BYTE)
> +#define bitmap_set_value8(map, value, start)		\
> +	bitmap_write(map, value, start, BITS_PER_BYTE)
> +
>  #endif /* __ASSEMBLY__ */
>  
>  #endif /* __LINUX_BITMAP_H */
> -- 
> 2.41.0

