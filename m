Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215E11B944
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 20:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707252100; cv=none; b=IrrJsi+xIUgj5VWEA+FYsJDhshDyKejNWBfrp7ZT0a8nbGfVlRZcWDj4JD/4A6yiyXfmxX+qmjffTo1TpLbKEZb5RqwsKSm8jrgBGlsxWQi5HNEgaDFiOCmdZbi0e4HnqR7+vans0I6qiBI/i3vITS2ho++2649aKZCeGm8NjPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707252100; c=relaxed/simple;
	bh=zRebTIjsaUf0Ub4DudPfuaj5E5yA9aiK7hFyGAJ1y+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqZIxMJUGGgCVY1l3dLI4MvLXmCPchFlSyiznB6VEOKQJuL8PCpUk/NJISUJdmfPUo593e6HEwbEI+bnmPBEQ0ytK2gsWrMvVhyoCfqkKovdbCUBnpliKuNw0Ln/C00JTz+MXkcTEDcoavTjvd3lqPRrj1YUvC+1qDcIfOJKpoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3bbbc6bcc78so870749b6e.1
        for <dm-devel@lists.linux.dev>; Tue, 06 Feb 2024 12:41:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707252098; x=1707856898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BK3tYW6CKwmcWEiVIKa8enrUi4F8IUfBPb681tY1iZI=;
        b=hsEbSeMarqQfe29QYgPvoxXQ8gpisV8t4byZjHxY4TR7mA67j22alwlA9/eVhP7NiP
         dfpjZtfcxdDOfg6E6ZX42QvexNQu9x2JULIMv2o9Agw3XSWttoRspx36Y0aIsFwkLrQ1
         85tA+J+ec3IL1uWD6aRAjdv1MesCaRos/XKnSB1QKMYkbXJJMfyhMSc+oFc/h2flJLHm
         gxl/18aChI8tJY8IbciRX/Rhlq1cWzRNFm84q8OdsvFNBIY8xsaj8jD1frpgnEk6FGU5
         bdPsSnrbMYniKi9XLi4Cr2zK5TV0Gah3wQpa6h7MpKV2xT3Bi+FbK2lYVRKYdLQpCOSs
         099Q==
X-Forwarded-Encrypted: i=1; AJvYcCWErUPuLWSLofLWuNfSdFuXu8qxi9WYPUHd/PQjvC0/5mBuUJrchJ6klqz3QqtOoy+mBQFbAb9Vg7KruhgKAIkqk1ZM2xNxE2w=
X-Gm-Message-State: AOJu0Yxpp38jfNKM+GxLdAJiLwNLHMTriADAEeeM8guwJlRoJbxpI6dd
	2BVBOq9W/KYuXp8JXi95UCvNtKcuYD6x/D95RAduMCnzNrZA8RwuBgpDbNvk/Q==
X-Google-Smtp-Source: AGHT+IGqpcz7w8gXYKBU6CYEiwFCfJ+MsnXv3yBYJ560ReaFJUvziCmQspI4RUDkDIP0eDtLZ5OnjA==
X-Received: by 2002:a05:6808:3199:b0:3bf:e478:6f41 with SMTP id cd25-20020a056808319900b003bfe4786f41mr3251032oib.14.1707252098199;
        Tue, 06 Feb 2024 12:41:38 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW6elav5x43l40JoZ/qbnlSpl7WyDCyC8xP7h8/eU3zyk2T/cv8T2ZFK38QbX5hQyt5i1lV+/7NKt3vEl2DpDFyAPRWYDoqker0dELGNpdlLqguk+ArDfehQDo2DJ0P7n8AgRRPZFb6qxnbPZO+w5j3NbMSyMe6gnuw4ehqsaoUAEc8U2Gr6nmDT3c8GCG1S0bjDyyHWPkehbtc5jCK
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id j25-20020ac874d9000000b0042994b3c20dsm1215094qtr.29.2024.02.06.12.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 12:41:37 -0800 (PST)
Date: Tue, 6 Feb 2024 15:41:36 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/26] dm: Use the block layer zone append emulation
Message-ID: <ZcKZgKIRhQGRHrG5@redhat.com>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-11-dlemoal@kernel.org>
 <Zb5-2LsnQtJHV2mL@redhat.com>
 <4eb920d7-e2fc-49d0-9eec-5fc152fa21de@kernel.org>
 <ZcFGGdVc7mqCpU7a@redhat.com>
 <ce23dd28-50d3-4650-993d-351cbcb45a80@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce23dd28-50d3-4650-993d-351cbcb45a80@kernel.org>

On Mon, Feb 05 2024 at  6:40P -0500,
Damien Le Moal <dlemoal@kernel.org> wrote:

> On 2/6/24 05:33, Mike Snitzer wrote:
> > On Mon, Feb 05 2024 at 12:38P -0500,
> > Damien Le Moal <dlemoal@kernel.org> wrote:
> > 
> >> On 2/4/24 02:58, Mike Snitzer wrote:
> >>> Love the overall improvement to the DM core code and the broader block
> >>> layer by switching to this bio-based ZWP approach.
> >>>
> >>> Reviewed-by: Mike Snitzer <snitzer@kernel.org>
> >>
> >> Thanks Mike !
> >>
> >>> But one incremental suggestion inlined below.
> >>
> >> I made this change, but in a lightly different form as I noticed that I was
> >> getting compile errors when CONFIG_BLK_DEV_ZONED is disabled.
> >> The change look like this now:
> >>
> >> static void dm_split_and_process_bio(struct mapped_device *md,
> >> 				     struct dm_table *map, struct bio *bio)
> >> {
> >> 	...
> >> 	need_split = is_abnormal = is_abnormal_io(bio);
> >> 	if (static_branch_unlikely(&zoned_enabled))
> >> 		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
> >>
> >> 	...
> >>
> >> 	/*
> >> 	 * Use the block layer zone write plugging for mapped devices that
> >> 	 * need zone append emulation (e.g. dm-crypt).
> >> 	 */
> >> 	if (static_branch_unlikely(&zoned_enabled) &&
> >> 	    dm_zone_write_plug_bio(md, bio))
> >> 		return;
> >>
> >> 	...
> >>
> >> with these added to dm-core.h:
> >>
> >> static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
> >> 					   struct bio *bio)
> >> {
> >> 	return md->emulate_zone_append && bio_straddle_zones(bio);
> >> }
> >> static inline bool dm_zone_write_plug_bio(struct mapped_device *md,
> >> 					  struct bio *bio)
> >> {
> >> 	return md->emulate_zone_append && blk_zone_write_plug_bio(bio, 0);
> >> }
> >>
> >> These 2 helpers define to "return false" for !CONFIG_BLK_DEV_ZONED.
> >> I hope this works for you. Otherwise, I will drop your review tag when posting V2.
> > 
> > Why expose them in dm-core.h ?
> > 
> > Just have what you put in dm-core.h above dm_split_and_process_bio in dm.c ?
> 
> I wanted to avoid "#ifdef CONFIG_BLK_DEV_ZONED" in the .c files. But if you are
> OK with that, I can move these inline functions in dm.c.

I'm OK with it, dm.c already does something like this for
dm_queue_destroy_crypto_profile() by checking if
CONFIG_BLK_INLINE_ENCRYPTION defined.

Mike
