Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B248CD68F9
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696921395;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8BDAJs72VvQ7wrEypUdN+XbHtAFAnU2lVb/fDw879y8=;
	b=CkAoH5Jg66ZuQK6ZpDtvywQNDpxyNsjKQlxzan4epMY1IfTblNZiB8ZyMWH2njB9teiKJy
	rlKeszWVNsUgFpse6ELohRsXrjl7DWa+nzmju1Xw9jQUi7esHLJTOemJodYNThVNofPhZb
	CGG7/XwitZVFmoxisNGGKH+6NZmSHX0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-l5bZXwlyPc6eejTRK8nlig-1; Tue, 10 Oct 2023 03:03:11 -0400
X-MC-Unique: l5bZXwlyPc6eejTRK8nlig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9533880E8D0;
	Tue, 10 Oct 2023 07:03:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82F25C0FE2D;
	Tue, 10 Oct 2023 07:03:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 214A919465B6;
	Tue, 10 Oct 2023 07:02:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A27319465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 16:50:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E8C9B2027046; Mon,  9 Oct 2023 16:50:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0DBC2027045
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 16:50:19 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C315E29AA3BB
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 16:50:19 +0000 (UTC)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com
 [209.85.128.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-3NAiNHlINIyyGlSSKztIFg-1; Mon, 09 Oct 2023 12:50:17 -0400
X-MC-Unique: 3NAiNHlINIyyGlSSKztIFg-1
Received: by mail-yw1-f181.google.com with SMTP id
 00721157ae682-5a7ad24b3aaso5227227b3.2
 for <dm-devel@redhat.com>; Mon, 09 Oct 2023 09:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696870217; x=1697475017;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=yhm7YrqXofK0AegCXETsHz1KMPta2LD8FhGIuFko2pY=;
 b=kQptC7XyuakPAGVmkZUwtnb4ROaLihK+tqSuYbJpIEyBQUiGlC95o11xRRlEoOIXi1
 kLiaNHOF/oYhWG7wloJjC+boXvhbPz8Pz+Qj13wz6RXdLpsmKbGElAi1/FzbJmHFfNTg
 Sdx1iWjNGuU97eKIijb72Dmaoi2g0lAP7sjkN4GXgp3xVyANIlug2v5BHKxGcd5XIzZg
 f/7gycYx6rHb5ZC84HSYVgnj1cB3C3vIDqXwRJ24fLfeSbVuWrTdbbJJG+nQFQvZjNnK
 fwys7V3vecuPSPKSgrGKvFIIibv8RIu88Z1wHw0VOnnIf+1/tn+qacjK90ma8fRvEV3A
 +YIA==
X-Gm-Message-State: AOJu0Yxbusw5bwY2DhAd+U8igbSEh1e/4Eyod/av7cyyLir2HUSmBIxG
 SxMFvno+2k4fNJ611ZWDvck=
X-Google-Smtp-Source: AGHT+IGDGieAvy8YgNDMEl5ERI+L5dnLHTLO6C63fhmPXvU26M+Gw4A6t2G+i0jttc7QnLS2senhew==
X-Received: by 2002:a0d:c207:0:b0:59a:f131:50fa with SMTP id
 e7-20020a0dc207000000b0059af13150famr16404483ywd.47.1696870217228; 
 Mon, 09 Oct 2023 09:50:17 -0700 (PDT)
Received: from localhost ([2607:fb90:be22:da0:a050:8c3a:c782:514b])
 by smtp.gmail.com with ESMTPSA id
 p6-20020a0dff06000000b0059c8387f673sm3823742ywf.51.2023.10.09.09.50.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 Oct 2023 09:50:16 -0700 (PDT)
Date: Mon, 9 Oct 2023 09:50:15 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Message-ID: <ZSQvR+bQ8PS9/CEa@yury-ThinkPad>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
 <20231009151026.66145-7-aleksander.lobakin@intel.com>
MIME-Version: 1.0
In-Reply-To: <20231009151026.66145-7-aleksander.lobakin@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 10 Oct 2023 07:02:51 +0000
Subject: Re: [dm-devel] [PATCH 06/14] fs/ntfs3: rename bitmap_size() ->
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 09, 2023 at 05:10:18PM +0200, Alexander Lobakin wrote:
> bitmap_size() is a pretty generic name and one may want to use it for
> a generic bitmap API function. At the same time, its logic is
> NTFS-specific, as it aligns to the sizeof(u64), not the sizeof(long)
> (although it uses ideologically right ALIGN() instead of division).
> Add the prefix 'ntfs3_' used for that FS (not just 'ntfs_' to not mix
> it with the legacy module).
> 
> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  fs/ntfs3/bitmap.c  |  4 ++--
>  fs/ntfs3/fsntfs.c  |  2 +-
>  fs/ntfs3/index.c   | 11 ++++++-----
>  fs/ntfs3/ntfs_fs.h |  2 +-
>  fs/ntfs3/super.c   |  2 +-
>  5 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
> index 107e808e06ea..a2e18f13e93a 100644
> --- a/fs/ntfs3/bitmap.c
> +++ b/fs/ntfs3/bitmap.c
> @@ -653,7 +653,7 @@ int wnd_init(struct wnd_bitmap *wnd, struct super_block *sb, size_t nbits)
>  	wnd->total_zeroes = nbits;
>  	wnd->extent_max = MINUS_ONE_T;
>  	wnd->zone_bit = wnd->zone_end = 0;
> -	wnd->nwnd = bytes_to_block(sb, bitmap_size(nbits));
> +	wnd->nwnd = bytes_to_block(sb, ntfs3_bitmap_size(nbits));
>  	wnd->bits_last = nbits & (wbits - 1);
>  	if (!wnd->bits_last)
>  		wnd->bits_last = wbits;
> @@ -1345,7 +1345,7 @@ int wnd_extend(struct wnd_bitmap *wnd, size_t new_bits)
>  		return -EINVAL;
>  
>  	/* Align to 8 byte boundary. */
> -	new_wnd = bytes_to_block(sb, bitmap_size(new_bits));
> +	new_wnd = bytes_to_block(sb, ntfs3_bitmap_size(new_bits));
>  	new_last = new_bits & (wbits - 1);
>  	if (!new_last)
>  		new_last = wbits;
> diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
> index 33afee0f5559..7a14d2347f27 100644
> --- a/fs/ntfs3/fsntfs.c
> +++ b/fs/ntfs3/fsntfs.c
> @@ -522,7 +522,7 @@ static int ntfs_extend_mft(struct ntfs_sb_info *sbi)
>  	ni->mi.dirty = true;
>  
>  	/* Step 2: Resize $MFT::BITMAP. */
> -	new_bitmap_bytes = bitmap_size(new_mft_total);
> +	new_bitmap_bytes = ntfs3_bitmap_size(new_mft_total);
>  
>  	err = attr_set_size(ni, ATTR_BITMAP, NULL, 0, &sbi->mft.bitmap.run,
>  			    new_bitmap_bytes, &new_bitmap_bytes, true, NULL);
> diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
> index 124c6e822623..ab53a4b6ddf8 100644
> --- a/fs/ntfs3/index.c
> +++ b/fs/ntfs3/index.c
> @@ -1453,8 +1453,8 @@ static int indx_create_allocate(struct ntfs_index *indx, struct ntfs_inode *ni,
>  
>  	alloc->nres.valid_size = alloc->nres.data_size = cpu_to_le64(data_size);
>  
> -	err = ni_insert_resident(ni, bitmap_size(1), ATTR_BITMAP, in->name,
> -				 in->name_len, &bitmap, NULL, NULL);
> +	err = ni_insert_resident(ni, ntfs3_bitmap_size(1), ATTR_BITMAP,
> +				 in->name, in->name_len, &bitmap, NULL, NULL);
>  	if (err)
>  		goto out2;
>  
> @@ -1515,8 +1515,9 @@ static int indx_add_allocate(struct ntfs_index *indx, struct ntfs_inode *ni,
>  	if (bmp) {
>  		/* Increase bitmap. */
>  		err = attr_set_size(ni, ATTR_BITMAP, in->name, in->name_len,
> -				    &indx->bitmap_run, bitmap_size(bit + 1),
> -				    NULL, true, NULL);
> +				    &indx->bitmap_run,
> +				    ntfs3_bitmap_size(bit + 1), NULL, true,
> +				    NULL);
>  		if (err)
>  			goto out1;
>  	}
> @@ -2089,7 +2090,7 @@ static int indx_shrink(struct ntfs_index *indx, struct ntfs_inode *ni,
>  	if (in->name == I30_NAME)
>  		ni->vfs_inode.i_size = new_data;
>  
> -	bpb = bitmap_size(bit);
> +	bpb = ntfs3_bitmap_size(bit);
>  	if (bpb * 8 == nbits)
>  		return 0;
>  
> diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
> index 629403ede6e5..93333156aac6 100644
> --- a/fs/ntfs3/ntfs_fs.h
> +++ b/fs/ntfs3/ntfs_fs.h
> @@ -961,7 +961,7 @@ static inline bool run_is_empty(struct runs_tree *run)
>  }
>  
>  /* NTFS uses quad aligned bitmaps. */
> -static inline size_t bitmap_size(size_t bits)
> +static inline size_t ntfs3_bitmap_size(size_t bits)
>  {
>  	return ALIGN((bits + 7) >> 3, 8);
>  }

This looks like duplicating BITS_TO_U64(). If so, why not just switch
to using the macro while you're here?

> diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
> index cfec5e0c7f66..b1fb6efe7084 100644
> --- a/fs/ntfs3/super.c
> +++ b/fs/ntfs3/super.c
> @@ -1285,7 +1285,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
>  
>  	/* Check bitmap boundary. */
>  	tt = sbi->used.bitmap.nbits;
> -	if (inode->i_size < bitmap_size(tt)) {
> +	if (inode->i_size < ntfs3_bitmap_size(tt)) {
>  		ntfs_err(sb, "$Bitmap is corrupted.");
>  		err = -EINVAL;
>  		goto put_inode_out;
> -- 
> 2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

