Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1AF2D46B2
	for <dm-devel@lists.linux.dev>; Tue, 16 Dec 2025 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765874526; cv=none; b=TucQxou+dGhW7pY9u4lfjVZPqsyW8b6q+4SKr8+Dwe1BApAN9NE7RywhP/xYkisq+00LRqZx/cq38b4Wak4JFYCa9bZTTC6BnvkE+EnTv6MTAcUVJhj9bCtDsfBsF3izGT8FLRQGHit84wo6xN4yKAH1SLt5mb3hH0vT8x7d51M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765874526; c=relaxed/simple;
	bh=LeSPLdw8CyUvLD+Wsks/a84DYfWD8ihFZCgPW/k/oKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alwJ1m3FtlhMwMbaZ3DEfkTwAdT64YPqtneca26cuc1ugEVKbcOu8iFh46uSy/RgFZj3GgkXsX6wkPi2Pd8Z1wN08zBvI5uqMe2M9nkfbDQgd7Qo4jM2WDa6C6dzxvMZ1vSXNSBLI3nybRIiK/ei+4aqN+sybwx0Unt7cy+z3EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7TLAJ3C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7TLAJ3C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765874523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bedoI72M4dzcfCaw0bozxUr5koxef0u+N35NgEwFoMY=;
	b=H7TLAJ3CEpseqHx+NV8WMzYuHgvKJVbD//eZtyLLOZE9ZAT2vEvMgC799tmdZr03ghn+cD
	tcOQPTCKqLd2AG3scEurdrqWYMe6G2K9n/wgG8sqxVAbZx8kJagnoiBMrFWTAJiQkbBIXx
	cVZJm7i5iC4oq2HT2BeyhU6Z77GnmX8=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-CfRtN_FeN3W_t2sofvkILg-1; Tue, 16 Dec 2025 03:42:01 -0500
X-MC-Unique: CfRtN_FeN3W_t2sofvkILg-1
X-Mimecast-MFC-AGG-ID: CfRtN_FeN3W_t2sofvkILg_1765874521
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-6446ee26635so6926573d50.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Dec 2025 00:42:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765874521; x=1766479321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bedoI72M4dzcfCaw0bozxUr5koxef0u+N35NgEwFoMY=;
        b=gAG03bB2+zPu0W/3UzRSPBIrz5OggDfgjxG1EybKm634JNYEmKXC5ugfAv2zf1m6oG
         yMRenS2JtdSSmHPtcEzzENP245vmXRMqEyO+LMi8HJXJtWVBspPlYoRS+3VdJ4Ox6tDQ
         5TvQTJARjhUCpm9uTVwQu6KVnEwtZyz2ORbjtTWS1Om0jbgH6vWlATcwpOQrkaXnXexV
         SmQfR8UkbZqHwYYFGUGmXtYL5/opUyA1PuV5crm9ffvQ1OzAldlTsGbGVaEBNpHZjB5S
         OOf9HStGH1SHinDyrkqg+7k19Zt2aJ7LPy9Enhf7TlDyg0k5wBnUcoLJSyN5yjAVgfiN
         RHkA==
X-Forwarded-Encrypted: i=1; AJvYcCWvrM3/XfJWxRsiyhaqPFAMZuOl0d2TVMcFbwAxagfpZGb/fdEiBT7DHVWPRho09A5Hx7rtZoPU4A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3jhrFEZ0vP4PwaccEQl0jdtbHNOvEx6+yuu8ynaD9cS9fNPpa
	sdyCW2AGsKm5UcGBNXIJijjgRghbV797rZJE24q3aOxRLr1JiUKVCe5a9a0eL0Rr3O5m6VTaumx
	W4NhJBeLFFtU4YUTzfE+9d80NPkyrcUfJSGmFdUNdTvLAnHPhP8pkQP2Wo4/++HUXPfW/Cx3drz
	WMalsXdgq2C0vKEZTPxgsURd5bpmUWMiFcKHY=
X-Gm-Gg: AY/fxX4FlM2m/G9km1C/wa0SXNLNZgRdgrDohG2mmgDkKlPlg0mVL1JjbkvwY/x/wNS
	uBqtetEc3zk1RK/NaOR36vfctbUUYDbc6HZvMw3EjKyxTIsatQlnw3pNg9VO9PNoeO9YhrKEV0g
	l4pU6cmmgZW8qrRgE8eCNFmpCHarTC6RTfL4uHJp5rjoAIFyqKFZ4SJ+mOPmonzvhb
X-Received: by 2002:a05:690e:130c:b0:641:f5bc:699c with SMTP id 956f58d0204a3-64555664965mr11300520d50.74.1765874520964;
        Tue, 16 Dec 2025 00:42:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsdXWnoFL9I7pAq/MaIAVAy9awQVMPdeIdCZyZ8gA28f/XjQGXPGkhfCfGI1rJgvn170eyS00H/OkJzbKACvU=
X-Received: by 2002:a05:690e:130c:b0:641:f5bc:699c with SMTP id
 956f58d0204a3-64555664965mr11300511d50.74.1765874520647; Tue, 16 Dec 2025
 00:42:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251208121020.1780402-1-agruenba@redhat.com> <20251208121020.1780402-7-agruenba@redhat.com>
 <aUERRp7S1A5YXCm4@infradead.org>
In-Reply-To: <aUERRp7S1A5YXCm4@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 16 Dec 2025 09:41:49 +0100
X-Gm-Features: AQt7F2oWOgXF4BWLyQhRHkpji9S9Pl-ufTycpWlGBJkrm01TM2UaID084bN-gCY
Message-ID: <CAHc6FU6QCfqTM9zCREdp3o0UzFX99q2QqXgOiNkN8OtnhWYZVQ@mail.gmail.com>
Subject: Re: [RFC 06/12] bio: don't check target->bi_status on error
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ivg3g4LAEEPaX9-en3A5B-gHxjQiT0mU_yJkT887RIM_1765874521
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 8:59=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
> On Mon, Dec 08, 2025 at 12:10:13PM +0000, Andreas Gruenbacher wrote:
> > In a few places, target->bi_status is set to source->bi_status only if
> > source->bi_status is not 0 and target->bi_status is (still) 0.  Here,
> > checking the value of target->bi_status before setting it is an
> > unnecessary micro optimization because we are already on an error path.
>
> What is source and target here?  I have a hard time trying to follow
> what this is trying to do.

Not sure, what would you suggest instead?

Thanks,
Andreas

