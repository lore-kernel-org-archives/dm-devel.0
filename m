Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F16CD68FC
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696921395;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xOz2sk8fHHEwmgeTRdBY4xU+RS5otamsdkmC05DWz9Y=;
	b=BHFFlubinEgul5FnrNNWtirRcF2zqQ+/MXSazCXaNY5s/5qCLPgDbzFxv/MRcDxS6wpcMc
	MDOtwrkgpnX1J/+BZnHSrpjmuJ9kHXVvBchq9tJICpj13dzxbuZzNh5ZbbyF6Z1oha68JS
	r40XUSrpdVLkR6Dqbnmhd7Jui0lnpkg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-677-ghSnwAO4MbuGZ-1goFeyXA-1; Tue, 10 Oct 2023 03:03:12 -0400
X-MC-Unique: ghSnwAO4MbuGZ-1goFeyXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5457281D7BB;
	Tue, 10 Oct 2023 07:03:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C91040C6EC0;
	Tue, 10 Oct 2023 07:03:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DADC719452CF;
	Tue, 10 Oct 2023 07:02:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE0BC19465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 17:04:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79EFE36E5; Mon,  9 Oct 2023 17:04:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 731FA36E1
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 17:04:31 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 506F585A5BD
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 17:04:31 +0000 (UTC)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com
 [209.85.128.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-6vorhGhGM1SclFHgoXQMWw-1; Mon, 09 Oct 2023 13:04:19 -0400
X-MC-Unique: 6vorhGhGM1SclFHgoXQMWw-1
Received: by mail-yw1-f182.google.com with SMTP id
 00721157ae682-5a7ba0828efso996797b3.3
 for <dm-devel@redhat.com>; Mon, 09 Oct 2023 10:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696871059; x=1697475859;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=GrtA6lKuYWUe++j58BXstURMH0ObpUyX8a0STO/sotc=;
 b=kfRKMwrkennofnzLmYFH7N/qOagkNi8v3cCj/rwylT1EA8KokxfTKt6A+HPGuzzEu9
 qqp9Y8K+g+Jcp54cDpbtRLhb0U93rnUx3asgZTbdZeHjEmyKGstkZBtA3XiMhv4radzu
 Cr4LNy/NPWBFxq0FveASdiobzxZhyXvtQDiZ25a8s/WvYns/WSkVPuyWH8duXQd6bk2j
 9MEjTTDzVSKsVLijJ1jFI1NLQFG5IRwuJNEWXvUzvgMerb86Rb8erH++9gzzly26dVma
 k7FYxijdHi4aIEHYx9L4J9LbwZlXLE/Aoio7VzhBIQhlztHA6t5ng/SmJfMYrF2MNBuJ
 S6vg==
X-Gm-Message-State: AOJu0YyEhMBuMDz1nupqi26iD+vyWlxZQte8KdXuAb1BnTMZ2hW5qjNb
 U4emqQMEH45o8aG9ssuVbzs=
X-Google-Smtp-Source: AGHT+IFCaKLUIQtaVFO6RZQ7mzNkB38jHP0WXbG7WaO+K53JI2BYGR30cn9swjnv1mxH93LfVRqHVw==
X-Received: by 2002:a0d:f542:0:b0:59f:5361:d18c with SMTP id
 e63-20020a0df542000000b0059f5361d18cmr15848023ywf.41.1696871058634; 
 Mon, 09 Oct 2023 10:04:18 -0700 (PDT)
Received: from localhost ([2607:fb90:be22:da0:a050:8c3a:c782:514b])
 by smtp.gmail.com with ESMTPSA id
 g192-20020a0dddc9000000b0054bfc94a10dsm3799789ywe.47.2023.10.09.10.04.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 Oct 2023 10:04:18 -0700 (PDT)
Date: Mon, 9 Oct 2023 10:04:16 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Message-ID: <ZSQykJtkemZTiYHP@yury-ThinkPad>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
 <20231009151026.66145-9-aleksander.lobakin@intel.com>
MIME-Version: 1.0
In-Reply-To: <20231009151026.66145-9-aleksander.lobakin@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 10 Oct 2023 07:02:51 +0000
Subject: Re: [dm-devel] [PATCH 08/14] bitmap: introduce generic optimized
 bitmap_size()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 09, 2023 at 05:10:20PM +0200, Alexander Lobakin wrote:
> The number of times yet another open coded
> `BITS_TO_LONGS(nbits) * sizeof(long)` can be spotted is huge.
> Some generic helper is long overdue.

OK, I see your point. Indeed, opencoding this again and again may be
annoying. 

Acked-by: Yury Norov <yury.norov@gmail.com>
 
> Add one, bitmap_size(), but with one detail.
> BITS_TO_LONGS() uses DIV_ROUND_UP(). The latter works well when both
> divident and divisor are compile-time constants or when the divisor
> is not a pow-of-2. When it is however, the compilers sometimes tend
> to generate suboptimal code (GCC 13):
> 
> 48 83 c0 3f          	add    $0x3f,%rax
> 48 c1 e8 06          	shr    $0x6,%rax
> 48 8d 14 c5 00 00 00 00	lea    0x0(,%rax,8),%rdx
> 
> %BITS_PER_LONG is always a pow-2 (either 32 or 64), but GCC still does
> full division of `nbits + 63` by it and then multiplication by 8.
> Instead of BITS_TO_LONGS(), use ALIGN() and then divide by 8. GCC:
> 
> 8d 50 3f             	lea    0x3f(%rax),%edx
> c1 ea 03             	shr    $0x3,%edx
> 81 e2 f8 ff ff 1f    	and    $0x1ffffff8,%edx
> 
> Now it divides `nbits + 63` by 8 and then masks bits[2:0].
> bloat-o-meter:
> 
> add/remove: 0/0 grow/shrink: 20/133 up/down: 156/-773 (-617)
> 
> Clang does it better and generates the same code before/after starting
> from -O1, except that with the ALIGN() approach it uses %edx and thus
> still saves some bytes:
> 
> add/remove: 0/0 grow/shrink: 9/133 up/down: 18/-538 (-520)
> 
> Note that we can't expand DIV_ROUND_UP() by adding a check and using
> this approach there, as it's used in array declarations where
> expressions are not allowed.
> Add this helper to tools/ as well.
> 
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  drivers/md/dm-clone-metadata.c | 5 -----
>  include/linux/bitmap.h         | 8 +++++---
>  include/linux/cpumask.h        | 2 +-
>  lib/math/prime_numbers.c       | 2 --
>  tools/include/linux/bitmap.h   | 8 +++++---
>  5 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/dm-clone-metadata.c b/drivers/md/dm-clone-metadata.c
> index c43d55672bce..47c1fa7aad8b 100644
> --- a/drivers/md/dm-clone-metadata.c
> +++ b/drivers/md/dm-clone-metadata.c
> @@ -465,11 +465,6 @@ static void __destroy_persistent_data_structures(struct dm_clone_metadata *cmd)
>  
>  /*---------------------------------------------------------------------------*/
>  
> -static size_t bitmap_size(unsigned long nr_bits)
> -{
> -	return BITS_TO_LONGS(nr_bits) * sizeof(long);
> -}
> -
>  static int __dirty_map_init(struct dirty_map *dmap, unsigned long nr_words,
>  			    unsigned long nr_regions)
>  {
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 03644237e1ef..63e422f8ba3d 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -237,9 +237,11 @@ extern int bitmap_print_list_to_buf(char *buf, const unsigned long *maskp,
>  #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
>  #define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
>  
> +#define bitmap_size(nbits)	(ALIGN(nbits, BITS_PER_LONG) / BITS_PER_BYTE)
> +
>  static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
>  {
> -	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
> +	unsigned int len = bitmap_size(nbits);
>  
>  	if (small_const_nbits(nbits))
>  		*dst = 0;
> @@ -249,7 +251,7 @@ static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
>  
>  static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
>  {
> -	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
> +	unsigned int len = bitmap_size(nbits);
>  
>  	if (small_const_nbits(nbits))
>  		*dst = ~0UL;
> @@ -260,7 +262,7 @@ static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
>  static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
>  			unsigned int nbits)
>  {
> -	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
> +	unsigned int len = bitmap_size(nbits);
>  
>  	if (small_const_nbits(nbits))
>  		*dst = *src;
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index f10fb87d49db..dbdbf1451cad 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -821,7 +821,7 @@ static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
>   */
>  static inline unsigned int cpumask_size(void)
>  {
> -	return BITS_TO_LONGS(large_cpumask_bits) * sizeof(long);
> +	return bitmap_size(large_cpumask_bits);
>  }
>  
>  /*
> diff --git a/lib/math/prime_numbers.c b/lib/math/prime_numbers.c
> index d42cebf7407f..d3b64b10da1c 100644
> --- a/lib/math/prime_numbers.c
> +++ b/lib/math/prime_numbers.c
> @@ -6,8 +6,6 @@
>  #include <linux/prime_numbers.h>
>  #include <linux/slab.h>
>  
> -#define bitmap_size(nbits) (BITS_TO_LONGS(nbits) * sizeof(unsigned long))
> -
>  struct primes {
>  	struct rcu_head rcu;
>  	unsigned long last, sz;
> diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
> index f3566ea0f932..81a2299ace15 100644
> --- a/tools/include/linux/bitmap.h
> +++ b/tools/include/linux/bitmap.h
> @@ -2,6 +2,7 @@
>  #ifndef _TOOLS_LINUX_BITMAP_H
>  #define _TOOLS_LINUX_BITMAP_H
>  
> +#include <linux/align.h>
>  #include <string.h>
>  #include <linux/bitops.h>
>  #include <linux/find.h>
> @@ -25,13 +26,14 @@ bool __bitmap_intersects(const unsigned long *bitmap1,
>  #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
>  #define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
>  
> +#define bitmap_size(nbits)	(ALIGN(nbits, BITS_PER_LONG) / BITS_PER_BYTE)
> +
>  static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
>  {
>  	if (small_const_nbits(nbits))
>  		*dst = 0UL;
>  	else {
> -		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
> -		memset(dst, 0, len);
> +		memset(dst, 0, bitmap_size(nbits));
>  	}
>  }
>  
> @@ -83,7 +85,7 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
>   */
>  static inline unsigned long *bitmap_zalloc(int nbits)
>  {
> -	return calloc(1, BITS_TO_LONGS(nbits) * sizeof(unsigned long));
> +	return calloc(1, bitmap_size(nbits));
>  }
>  
>  /*
> -- 
> 2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

