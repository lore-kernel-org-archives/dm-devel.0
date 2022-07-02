Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB5EC43334
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178892;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QqymCkN+NNGic7cVz5+9uiJO4fPxkicvKyia3gMiXwM=;
	b=GLerxqYEy3ScgrBoslVdqBWACkietfxGJsIGXQbX2TaCaBAucNznjDVM01kyBarAC0CbZX
	dUahS37Wp0wf3VsxpbSrfOVsqO3pifXjrXJMtYETUQi9wxneX/0ozxeNHpwZUuwl7d2C2K
	Ar4IMpa4pUt1h+RGZy82isEI/4Nk96I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-vgRiAPITMjCpQb-b0uFsfw-1; Thu, 07 Jul 2022 03:28:08 -0400
X-MC-Unique: vgRiAPITMjCpQb-b0uFsfw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2524438041D3;
	Thu,  7 Jul 2022 07:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 104E4400DFA6;
	Thu,  7 Jul 2022 07:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 22403194707F;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 61E0E1947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 21:09:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B53040E7F29; Sat,  2 Jul 2022 21:09:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 371C240E7F28
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 21:09:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F1D43C025D3
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 21:09:50 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-NDHd8T5ANQqbWVXqGPBPYQ-1; Sat, 02 Jul 2022 17:09:48 -0400
X-MC-Unique: NDHd8T5ANQqbWVXqGPBPYQ-1
Received: by mail-qt1-f177.google.com with SMTP id he28so4605473qtb.13;
 Sat, 02 Jul 2022 14:09:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sMAa2iLeQqiv/ZzIKaEzdmiyv2BKPN4LO2LUx74OXts=;
 b=f+OcmiZHw3TwB+JgkTWKYaS5TNr0tvSZ7Cxkx2EIUj+6i3mnZCZlHD5dYTHtBzOKfb
 yMvI/JMSX65NyOVafyrRXYIlUDSdIHwUXafyqRpSIyvQ4GIf2RJDOfbpJCa4FpFw6EmI
 +i2yje77FdMFl8Bjbry0Y3nyPkgGKx+GNNb6Io1o2Z9/Z/soC+mdkYEAk80rtfJ3/zak
 2KBD7fUWKoZuYCadnJUgBjcP1ozjB+b+tT1K0qv8EFk3m4MJ78xheZJjGJUGzJU9UHTU
 +yi3TwRTbjOv3PI63Z+kG2O0E1sQ1SyvIBIpk63A7U47ihAZIKyBhmiHbXnHug3Ku1vg
 G03Q==
X-Gm-Message-State: AJIora+Y7uhc70VDPSwpt3NQyPTxWGvpD0DweXf0C48UyM4eGnRYPRvq
 SDW6St5L5XyaHSREBNC4Esc=
X-Google-Smtp-Source: AGRyM1vI0vuCSLmgu6ot91FWxWNvpuMeLByWm6OnSRKXaOezOBQwCg2H7Y1rdlq+T8yiEhPqf1YmXg==
X-Received: by 2002:a05:622a:1104:b0:31d:2a1c:a4fb with SMTP id
 e4-20020a05622a110400b0031d2a1ca4fbmr14927580qty.327.1656796187972; 
 Sat, 02 Jul 2022 14:09:47 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:e838:b1c2:b125:986a])
 by smtp.gmail.com with ESMTPSA id
 c3-20020ac84e03000000b00304f55e56e4sm17032646qtw.40.2022.07.02.14.09.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Jul 2022 14:09:47 -0700 (PDT)
Date: Sat, 2 Jul 2022 14:09:46 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <YsC0GpltMVaCPhkJ@yury-laptop>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <98f5d3d855a9c687ccc035edf62016b02a6876b7.1656785856.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <98f5d3d855a9c687ccc035edf62016b02a6876b7.1656785856.git.christophe.jaillet@wanadoo.fr>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: Re: [dm-devel] [PATCH 3/4] bitmap: Introduce bitmap_size()
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 02, 2022 at 08:29:36PM +0200, Christophe JAILLET wrote:
> The new bitmap_size() function returns the size, in bytes, of a bitmap.
> 
> Remove the already existing bitmap_size() functions and macro in some
> files.
> These files already use the bitmap API and will use the new function
> in bitmap.h automatically.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/md/dm-clone-metadata.c | 5 -----
>  include/linux/bitmap.h         | 6 ++++++
>  lib/math/prime_numbers.c       | 2 --
>  3 files changed, 6 insertions(+), 7 deletions(-)
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
> index f091a1664bf1..f66fb98a4126 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -48,6 +48,7 @@ struct device;
>   *  bitmap_equal(src1, src2, nbits)             Are *src1 and *src2 equal?
>   *  bitmap_intersects(src1, src2, nbits)        Do *src1 and *src2 overlap?
>   *  bitmap_subset(src1, src2, nbits)            Is *src1 a subset of *src2?
> + *  bitmap_size(nbits)                          Size, in bytes, of a bitmap
>   *  bitmap_empty(src, nbits)                    Are all bits zero in *src?
>   *  bitmap_full(src, nbits)                     Are all bits set in *src?
>   *  bitmap_weight(src, nbits)                   Hamming Weight: number set bits
> @@ -124,6 +125,11 @@ unsigned long *bitmap_alloc_node(unsigned int nbits, gfp_t flags, int node);
>  unsigned long *bitmap_zalloc_node(unsigned int nbits, gfp_t flags, int node);
>  void bitmap_free(const unsigned long *bitmap);
>  
> +static __always_inline size_t bitmap_size(unsigned long nbits)
> +{
> +	return BITS_TO_LONGS(nbits) * sizeof(unsigned long);
> +}
> +
>  /* Managed variants of the above. */
>  unsigned long *devm_bitmap_alloc(struct device *dev,
>  				 unsigned int nbits, gfp_t flags);
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

This should be dropped, for sure, and kmalloc() at line 128 should be
replaced with bitmap_alloc().

For the driver, we need to introduce bitmap_kvmalloc/bitmap_kvfree etc. 

>  struct primes {
>  	struct rcu_head rcu;
>  	unsigned long last, sz;
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

