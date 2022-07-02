Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C0ECCA479
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178892;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AkIO7jcx+CeUOIFMrtgf6OG/gS5TYPtM7styDCaABjI=;
	b=gMjbxAcFnikiKNdEQfX35/p6L5omQ5abnJNJPyQWpgB2s0W/hOH4uTkp60JdSRvKBhzTED
	ueyqhqajxJKVIrdAGenjjOpLXLgsmoP7RmM0E3pnU7ZHG7PRguKtwoc3nUR+Bmz/nYNZId
	KsfxCWEZQndOBBLb2rCxmoaTiWgWeTY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-CGtgcrA7OCOGed5qXFU4Aw-1; Thu, 07 Jul 2022 03:28:09 -0400
X-MC-Unique: CGtgcrA7OCOGed5qXFU4Aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC53A3C0E21B;
	Thu,  7 Jul 2022 07:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 973661121315;
	Thu,  7 Jul 2022 07:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 732C31947068;
	Thu,  7 Jul 2022 07:28:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 852581947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 20:57:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7656340E7F2A; Sat,  2 Jul 2022 20:57:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 71F1640E7F29
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 20:57:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58F22811E75
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 20:57:58 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-jJYDbCsJOg2OBO6dNkcesg-1; Sat, 02 Jul 2022 16:57:56 -0400
X-MC-Unique: jJYDbCsJOg2OBO6dNkcesg-1
Received: by mail-qt1-f182.google.com with SMTP id bs20so4585131qtb.11;
 Sat, 02 Jul 2022 13:57:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tmTe/j9IQg6kfh2nkxJHNkkQGZhhodot4AonVc2ypEg=;
 b=vgaYzcPktzN+ev51JsI+4UIZhTHeq39hJz42cdTaTkS+z83ahx/E4wzLArYQ24j3iH
 dM0Tk04aBQLsk1kba05YdlSYBoT1whlWI0yIGn3bwQ6KkGyNuChe0AymUGXIPbfN2mdA
 kxLZxXWzVT5U9zE97bjAp2vm4/PzFLAVn+jOgQwkUG4LorKgWI98qjfnBY6PW3d800VA
 65vALt0hekQsrVM9Z2NIJ0R4YEZjEGh62AAINNF6X74mzZ2lD0YuD/yzU8yiqZWcQfBl
 vm/xYk1xqD3E7mY+vxqpeiiQFtRIpYTJprirrD6O9owozvKU0fm4KX3KC2q0mBwruxsR
 chyw==
X-Gm-Message-State: AJIora/j111CYFZWw7J+2K/wW44PcLG94HMaK4ORCxdM5SuKAdqg2ptC
 6y40QpsGVQA/kJHWiIyxmrA=
X-Google-Smtp-Source: AGRyM1vMHV2C70cJUaiTyxu/YwSJ8XyP2OTkuYOtM18QdLzUztKGlOFKlbFY1e8fLJy/XDzQVTFpKw==
X-Received: by 2002:ac8:57d1:0:b0:31d:3e00:dfdc with SMTP id
 w17-20020ac857d1000000b0031d3e00dfdcmr4112648qta.333.1656795475669; 
 Sat, 02 Jul 2022 13:57:55 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:e838:b1c2:b125:986a])
 by smtp.gmail.com with ESMTPSA id
 n20-20020a05620a223400b006a6b564e9b8sm19311052qkh.4.2022.07.02.13.57.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Jul 2022 13:57:55 -0700 (PDT)
Date: Sat, 2 Jul 2022 13:57:54 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <YsCxUrTKd1N4aVoJ@yury-laptop>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <56a3cb896ec446ca24e4756042d9f0829afc671a.1656785856.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <56a3cb896ec446ca24e4756042d9f0829afc671a.1656785856.git.christophe.jaillet@wanadoo.fr>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: Re: [dm-devel] [PATCH 2/4] fs/ntfs3: Rename bitmap_size() as
 ntfs3_bitmap_size()
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 02, 2022 at 08:29:27PM +0200, Christophe JAILLET wrote:
> In order to introduce a bitmap_size() function in the bitmap API, we have
> to rename functions with a similar name.
> 
> Add a "ntfs3_" prefix and change bitmap_size() into ntfs3_bitmap_size().
> 
> No functional change.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  fs/ntfs3/bitmap.c  | 4 ++--
>  fs/ntfs3/fsntfs.c  | 2 +-
>  fs/ntfs3/index.c   | 6 +++---
>  fs/ntfs3/ntfs_fs.h | 2 +-
>  fs/ntfs3/super.c   | 2 +-
>  5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
> index e3b5680fd516..f98327453d83 100644
> --- a/fs/ntfs3/bitmap.c
> +++ b/fs/ntfs3/bitmap.c
> @@ -661,7 +661,7 @@ int wnd_init(struct wnd_bitmap *wnd, struct super_block *sb, size_t nbits)
>  	wnd->total_zeroes = nbits;
>  	wnd->extent_max = MINUS_ONE_T;
>  	wnd->zone_bit = wnd->zone_end = 0;
> -	wnd->nwnd = bytes_to_block(sb, bitmap_size(nbits));
> +	wnd->nwnd = bytes_to_block(sb, ntfs3_bitmap_size(nbits));
>  	wnd->bits_last = nbits & (wbits - 1);
>  	if (!wnd->bits_last)
>  		wnd->bits_last = wbits;
> @@ -1323,7 +1323,7 @@ int wnd_extend(struct wnd_bitmap *wnd, size_t new_bits)
>  		return -EINVAL;
>  
>  	/* Align to 8 byte boundary. */
> -	new_wnd = bytes_to_block(sb, bitmap_size(new_bits));
> +	new_wnd = bytes_to_block(sb, ntfs3_bitmap_size(new_bits));
>  	new_last = new_bits & (wbits - 1);
>  	if (!new_last)
>  		new_last = wbits;
> diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
> index 3de5700a9b83..9c74d88ce0f0 100644
> --- a/fs/ntfs3/fsntfs.c
> +++ b/fs/ntfs3/fsntfs.c
> @@ -493,7 +493,7 @@ static int ntfs_extend_mft(struct ntfs_sb_info *sbi)
>  	ni->mi.dirty = true;
>  
>  	/* Step 2: Resize $MFT::BITMAP. */
> -	new_bitmap_bytes = bitmap_size(new_mft_total);
> +	new_bitmap_bytes = ntfs3_bitmap_size(new_mft_total);
>  
>  	err = attr_set_size(ni, ATTR_BITMAP, NULL, 0, &sbi->mft.bitmap.run,
>  			    new_bitmap_bytes, &new_bitmap_bytes, true, NULL);
> diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
> index 84ccc1409874..5c5ea05a5ef1 100644
> --- a/fs/ntfs3/index.c
> +++ b/fs/ntfs3/index.c
> @@ -1353,7 +1353,7 @@ static int indx_create_allocate(struct ntfs_index *indx, struct ntfs_inode *ni,
>  
>  	alloc->nres.valid_size = alloc->nres.data_size = cpu_to_le64(data_size);
>  
> -	err = ni_insert_resident(ni, bitmap_size(1), ATTR_BITMAP, in->name,
> +	err = ni_insert_resident(ni, ntfs3_bitmap_size(1), ATTR_BITMAP, in->name,
>  				 in->name_len, &bitmap, NULL, NULL);
>  	if (err)
>  		goto out2;
> @@ -1415,7 +1415,7 @@ static int indx_add_allocate(struct ntfs_index *indx, struct ntfs_inode *ni,
>  	if (bmp) {
>  		/* Increase bitmap. */
>  		err = attr_set_size(ni, ATTR_BITMAP, in->name, in->name_len,
> -				    &indx->bitmap_run, bitmap_size(bit + 1),
> +				    &indx->bitmap_run, ntfs3_bitmap_size(bit + 1),
>  				    NULL, true, NULL);
>  		if (err)
>  			goto out1;
> @@ -1973,7 +1973,7 @@ static int indx_shrink(struct ntfs_index *indx, struct ntfs_inode *ni,
>  	if (err)
>  		return err;
>  
> -	bpb = bitmap_size(bit);
> +	bpb = ntfs3_bitmap_size(bit);
>  	if (bpb * 8 == nbits)
>  		return 0;
>  
> diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
> index 55d686e3c4ec..85210e610a3a 100644
> --- a/fs/ntfs3/ntfs_fs.h
> +++ b/fs/ntfs3/ntfs_fs.h
> @@ -945,7 +945,7 @@ static inline bool run_is_empty(struct runs_tree *run)
>  }
>  
>  /* NTFS uses quad aligned bitmaps. */
> -static inline size_t bitmap_size(size_t bits)
> +static inline size_t ntfs3_bitmap_size(size_t bits)
>  {
>  	return ALIGN((bits + 7) >> 3, 8);
>  }

Here everything looks OK for me. NTFS3 has their own good reasons
to reserve 64-bit words for their bitmaps, and they need their own
functions for this. And the prefix looks OK because it underlines
that this is a local story.

Maybe we can turn it into BITS_TO_LLONGS() and put into 
include/linux/bitops.h... But unless we have another subsystem that
needs it, I'm OK with current approach.

Acked-by: Yury Norov <yury.norov@gmail.com>

> diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
> index b41d7c824a50..7d48f886ac82 100644
> --- a/fs/ntfs3/super.c
> +++ b/fs/ntfs3/super.c
> @@ -1101,7 +1101,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
>  
>  	/* Check bitmap boundary. */
>  	tt = sbi->used.bitmap.nbits;
> -	if (inode->i_size < bitmap_size(tt)) {
> +	if (inode->i_size < ntfs3_bitmap_size(tt)) {
>  		err = -EINVAL;
>  		goto put_inode_out;
>  	}
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

