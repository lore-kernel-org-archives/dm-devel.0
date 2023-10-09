Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B6CCD68F6
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696921404;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4xGldyT1eg//Pg/jossEXb4WEXB6br1BaZLMjSwecXQ=;
	b=SaQgXc40HmP3r7XD0h5VXJ6LTgOdx3Kvy/MHKGLi1u5xBOa3NCNrktoov4yxqSzIBGRHHE
	OQ4+4gkdNUxXmcZ8UrwfkBhq8tfrwVrZBdoRXke4WE3U9h5c7qUYYQ0J9T/86TKxPBycDa
	nW8AKXEQpz5nqZAziZBXWj87zNQ7M6M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-rL-ixmGEM42Pj3mI3Q14xg-1; Tue, 10 Oct 2023 03:03:12 -0400
X-MC-Unique: rL-ixmGEM42Pj3mI3Q14xg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C746D1875055;
	Tue, 10 Oct 2023 07:03:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC94B47AD4A;
	Tue, 10 Oct 2023 07:03:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3675B19452E5;
	Tue, 10 Oct 2023 07:02:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5562819465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 16:18:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 41620215670B; Mon,  9 Oct 2023 16:18:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AB562156711
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 16:18:45 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A21F29ABA03
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 16:18:45 +0000 (UTC)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com
 [209.85.128.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-aYN2NLbiN2CDiyt3mpvzQg-1; Mon, 09 Oct 2023 12:18:43 -0400
X-MC-Unique: aYN2NLbiN2CDiyt3mpvzQg-1
Received: by mail-yw1-f175.google.com with SMTP id
 00721157ae682-5a7a7e9357eso6060947b3.0
 for <dm-devel@redhat.com>; Mon, 09 Oct 2023 09:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696868323; x=1697473123;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+v0P6uduPxkDwct3qYcLQFv77ucBxF1TcIWjbvekveU=;
 b=l6MKZNaHESf9DZw3sOFBbkylVN5yKt3oQj2ixjEOYzg55d3eUTFpFaPE8V4JghcZDW
 q8dagmKFTFpLBjcl9PxOBFc4s2M/OmYIfHm1ehC6kKN40ykS/rXaFvZImUy7dYShJbXz
 fOAVeWHlazsN5UuzoV03uOTJVpWIwQNZbYpm2oWWpr5UYYlSBp8Kv+7B3DN6N6Vbewoe
 l80HhgShkZ/2+6xQTo1wIums8elAf88IJ6em5zntAQ2IEAKxHAHTJUVjTl9KcirmMmf0
 Yi00gUdWpeHlXRv/LVHnC/tP5GVEmhi75j0IRkdMrxGwx9rVnPH0P1RjGftz/mgwbW2R
 OH+w==
X-Gm-Message-State: AOJu0YwFKblainJokX8C3UCPJtGNHWGPhMJYvJoSzFIqYF7ISTqjXTt0
 DecqBGCTZAPH11+UQPgMyrk=
X-Google-Smtp-Source: AGHT+IHB8jMCMIkYIOrWoj2aAnwZpAx6vHscHjQQzqKGazLmHofK5EelcUbictbWaOs9tL3UCKSfcQ==
X-Received: by 2002:a81:6e41:0:b0:598:bad6:8e67 with SMTP id
 j62-20020a816e41000000b00598bad68e67mr16343283ywc.30.1696868322609; 
 Mon, 09 Oct 2023 09:18:42 -0700 (PDT)
Received: from localhost ([2607:fb90:be22:da0:a050:8c3a:c782:514b])
 by smtp.gmail.com with ESMTPSA id
 u206-20020a8147d7000000b0059b4e981fe6sm3728032ywa.102.2023.10.09.09.18.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 Oct 2023 09:18:42 -0700 (PDT)
Date: Mon, 9 Oct 2023 09:18:40 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Message-ID: <ZSQn4Mppz9aJgFib@yury-ThinkPad>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
 <20231009151026.66145-4-aleksander.lobakin@intel.com>
MIME-Version: 1.0
In-Reply-To: <20231009151026.66145-4-aleksander.lobakin@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 10 Oct 2023 07:02:51 +0000
Subject: Re: [dm-devel] [PATCH 03/14] bitops: let the compiler optimize
 __assign_bit()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 09, 2023 at 05:10:15PM +0200, Alexander Lobakin wrote:
> Since commit b03fc1173c0c ("bitops: let optimize out non-atomic bitops
> on compile-time constants"), the compilers are able to expand inline
> bitmap operations to compile-time initializers when possible.
> However, during the round of replacement if-__set-else-__clear with
> __assign_bit() as per Andy's advice, bloat-o-meter showed +1024 bytes
> difference in object code size for one module (even one function),
> where the pattern:
> 
> 	DECLARE_BITMAP(foo) = { }; // on the stack, zeroed
> 
> 	if (a)
> 		__set_bit(const_bit_num, foo);
> 	if (b)
> 		__set_bit(another_const_bit_num, foo);
> 	...
> 
> is heavily used, although there should be no difference: the bitmap is
> zeroed, so the second half of __assign_bit() should be compiled-out as
> a no-op.
> I either missed the fact that __assign_bit() has bitmap pointer marked
> as `volatile` (as we usually do for bitmaps) or was hoping that the

No, we usually don't. Atomic ops on individual bits is a notable exception
for bitmaps, as the comment for generic_test_bit() says, for example:
         /*
          * Unlike the bitops with the '__' prefix above, this one *is* atomic,
          * so `volatile` must always stay here with no cast-aways. See
          * `Documentation/atomic_bitops.txt` for the details.
          */

For non-atomic single-bit operations and all multi-bit ops, volatile is
useless, and generic___test_and_set_bit() in the same file casts the 
*addr to a plain 'unsigned long *'.

> compilers would at least try to look past the `volatile` for
> __always_inline functions. Anyhow, due to that attribute, the compilers
> were always compiling the whole expression and no mentioned compile-time
> optimizations were working.
> 
> Convert __assign_bit() to a macro since it's a very simple if-else and
> all of the checks are performed inside __set_bit() and __clear_bit(),
> thus that wrapper has to be as transparent as possible. After that
> change, despite it showing only -20 bytes change for vmlinux (due to
> that it's still relatively unpopular), no drastic code size changes
> happen when replacing if-set-else-clear for onstack bitmaps with
> __assign_bit(), meaning the compiler now expands them to the actual
> operations will all the expected optimizations.
> 
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  include/linux/bitops.h | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index e0cd09eb91cd..f98f4fd1047f 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -284,14 +284,8 @@ static __always_inline void assign_bit(long nr, volatile unsigned long *addr,
>  		clear_bit(nr, addr);
>  }
>  
> -static __always_inline void __assign_bit(long nr, volatile unsigned long *addr,
> -					 bool value)
> -{
> -	if (value)
> -		__set_bit(nr, addr);
> -	else
> -		__clear_bit(nr, addr);
> -}
> +#define __assign_bit(nr, addr, value)				\
> +	((value) ? __set_bit(nr, addr) : __clear_bit(nr, addr))

Can you protect nr and addr with braces just as well?
Can you convert the atomic version too, to keep them synchronized ?

>  
>  /**
>   * __ptr_set_bit - Set bit in a pointer's value
> -- 
> 2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

