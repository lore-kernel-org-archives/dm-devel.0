Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE53FC43334
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178894;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CQc5Gu3jyFyjsZsL1wJinjlf4O+oNxwlz5BHXkkX+5Y=;
	b=UanyivAcbUKLBOvK+v8ZKCem+fR0VZqcHZ+dmJu4i8DvTT2K8c7351GHAwDCOPC0p8ZQgX
	kqC77lRD/UTTkEgALMJXOTm4Yk0E1S+/KOh2fOBwNHlSdqDA/vQJ/wu+u5AZIBOLtTpDpm
	U7FGlL2n5EETXKXe7N2qsNWqb/w23Ng=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-Z57T8St1Nf6_B6e7iexNXw-1; Thu, 07 Jul 2022 03:28:12 -0400
X-MC-Unique: Z57T8St1Nf6_B6e7iexNXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D170180D08D;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF4112166B29;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B4398194706D;
	Thu,  7 Jul 2022 07:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F8921947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 20:44:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C69B18EB7; Sat,  2 Jul 2022 20:44:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2856618EA8
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 20:44:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C0373C025C3
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 20:44:16 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-Fb354nQEMFmDP5UsE824TQ-1; Sat, 02 Jul 2022 16:44:14 -0400
X-MC-Unique: Fb354nQEMFmDP5UsE824TQ-1
Received: by mail-qt1-f178.google.com with SMTP id x1so4550620qtv.8;
 Sat, 02 Jul 2022 13:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DlqK/gCHCDGy5OSRXAYFxnfYX+I9GxfO75TGVC+FALo=;
 b=gAXvpnlS7qG/ay0lLJVFBbpY/JUYApvOI28MVTVrDzUACxobffsFqCPrXeRX7e5bdi
 J6vexvsH33nzoQTVrRZd8w5CSy13kfiJadvXoqqQKT9hDRggE9j91nqLUh2wAzw3m4Xo
 e3ZE17zR6sS57nWC9MnQBiSluX+zNME9aLYO8xp6sAQDU/jXcVnse+irSIeu8KUDtWnP
 URGqXHSswnVo+X76qxTW/+bOE/1mSZWOBka408BqODHoqvpx8YIerNu82CUllN3UViqe
 B5BctKHIeXhWG7zgdoIpryevFW6iXCwhwqErxHPlF3by8KM+eVRt82AEDkkc33nnQQqz
 rAxw==
X-Gm-Message-State: AJIora8w+FfhAxS0YcAi/KoZUJmA4eK+xeC28ibh5WdK9GYCpyONhxRx
 FTwDr8aCSthmymePBE4u/Z8=
X-Google-Smtp-Source: AGRyM1v9Om7l6fke9TMJ9NBQOtPQriWNRvL7GNoiNXCdxK+C+aPoOgahYt70QVZO5kMXfNiYT220JQ==
X-Received: by 2002:a05:6214:e83:b0:470:54c3:e18e with SMTP id
 hf3-20020a0562140e8300b0047054c3e18emr22253839qvb.3.1656794653736; 
 Sat, 02 Jul 2022 13:44:13 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:e838:b1c2:b125:986a])
 by smtp.gmail.com with ESMTPSA id
 c19-20020a05622a059300b00304edcfa109sm18513614qtb.33.2022.07.02.13.44.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Jul 2022 13:44:13 -0700 (PDT)
Date: Sat, 2 Jul 2022 13:44:12 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <YsCuHLTsKGCO/jsL@yury-laptop>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: Re: [dm-devel] [PATCH 0/4] Introduce bitmap_size()
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

On Sat, Jul 02, 2022 at 08:28:53PM +0200, Christophe JAILLET wrote:
> This serie introduces bitmap_size() which returns the size, in bytes, of a
> bitmap. Such a function is useful to simplify some drivers that use vmalloc() or
> other functions to allocate some butmaps.

This generally looks like a step in a wrong direction. Bitmap is by
definition an array of bits. If someone has a reason to handle bitmap
on a per-byte basis, the guy is probably doing something wrong.

We already have quite comprehensive list of functions that help to
allocate, fill, clear, copy etc bitmap without considering it as an
array of bytes or words.

> ... some drivers that use vmalloc() ...

If a driver needs vmalloc() for a bitmap, we should introduce
bitmap_vmalloc(), not bitmap_size().

> It also hides some implementation details about how bitmaps are stored (array of
> longs)

Sorry, I don't understand that. How bitmap_size() helps to hide a fact that
bitmap is an array of unsigned longs? (Except that it makes an impression
that it's an array of bytes.)

> Before introducing this function in patch 3, patch 1 and 2 rename some functions
> with the same name but with different meaning.
> 
> Finaly, patch 4 makes use of the new function in bitmap.h.

You mentioned, you need bitmap_size() to use with vmalloc(), but in
patch 4, there's no such code. 
 
> Other follow-up patches to simplify some drivers will be proposed later if/when
> this serie is merged.

This series doesn't show an example of how you're going to use new
API, and therefore it's hard to judge, do we really need bitmap_size(),
or we just need more helpers around.

As I already said, bitmaps are evolving in 2nd direction, which is the
right approach, I think.

Thanks,
Yury

> Christophe JAILLET (4):
>   s390/cio: Rename bitmap_size() as idset_bitmap_size()
>   fs/ntfs3: Rename bitmap_size() as ntfs3_bitmap_size()
>   bitmap: Introduce bitmap_size()
>   bitmap: Use bitmap_size()
> 
>  drivers/md/dm-clone-metadata.c |  5 -----
>  drivers/s390/cio/idset.c       |  8 ++++----
>  fs/ntfs3/bitmap.c              |  4 ++--
>  fs/ntfs3/fsntfs.c              |  2 +-
>  fs/ntfs3/index.c               |  6 +++---
>  fs/ntfs3/ntfs_fs.h             |  2 +-
>  fs/ntfs3/super.c               |  2 +-
>  include/linux/bitmap.h         | 15 +++++++++------
>  lib/math/prime_numbers.c       |  2 --
>  9 files changed, 21 insertions(+), 25 deletions(-)
> 
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

