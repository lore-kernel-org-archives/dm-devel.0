Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D6E269826
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 11:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745408021; cv=none; b=CLxwo/obLgXuPeORnk0I3SKHNveBTFpH9Pjcj4Nt5vePF2iaPuGoezzVI3ccy7j2RxAh/rBv7j3IriYDg9KH+38m4Mbny6LfZiazK0lIYHqQWH2Kc4rKzxbnrrWy9SOdSpRoqi3v6W1mPfmWhJi1wCt189dlZEMny1J53z3R1tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745408021; c=relaxed/simple;
	bh=aj3a66NNTBJC5cgvpVbBVoz+DOkimpnRo57tbk9/H+4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=q2tlwMADfXZ8jHiv3Axa4hOnTofY1hv8mH7kETVBAloLIcKW6oe78+FrhRZ2k8Ue+lltZwzQxtS5odElPTo33kXn//ba088BLL7k38lk/1GvGEqwlkFb8bfkrlFxEHy1F/r+5LeWYBpx45OZ1nnyN6UUlRb3aOxau4i8ICX1t8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bm4y0/Ix; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bm4y0/Ix"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745408018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EqVUKj9OoLxknISa4Asq5BunnytsYwdUx/G7HyMqEMY=;
	b=bm4y0/Ixm9RwVnOL8cISm4kGl3bqy6oM0ZumeFmfZdDvTgjuVJsU75U2d64QJuJNaJ1KNW
	3WOSaZaPhAX/LtRVQl4IZgt/WbNyQq9BtBc54NDxN7CnmYNmrvzV0D2Xclk/W5IQSIXm52
	u9cR5urYTH6oMBL8OakCLQYUNWxThZE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-EGuyOxMIM4iuuebAFUH9_A-1; Wed,
 23 Apr 2025 07:33:31 -0400
X-MC-Unique: EGuyOxMIM4iuuebAFUH9_A-1
X-Mimecast-MFC-AGG-ID: EGuyOxMIM4iuuebAFUH9_A_1745408010
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2C311956094;
	Wed, 23 Apr 2025 11:33:30 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 842D719560A3;
	Wed, 23 Apr 2025 11:33:28 +0000 (UTC)
Date: Wed, 23 Apr 2025 13:33:24 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, LongPing Wei <weilongping@oppo.com>, 
    Eran Messeri <eranm@google.com>, Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm-verity: use softirq context only when
 !need_resched()
In-Reply-To: <20250422202205.100444-1-ebiggers@kernel.org>
Message-ID: <8d31ebb2-9982-cf23-3c62-edb4334d1323@redhat.com>
References: <20250422202205.100444-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2gEth35SARHUB8Ii9yG1OE61WBQ_eE15yVSZ3Q5piT0_1745408010
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

OK, Accepted.

Mikulas



On Tue, 22 Apr 2025, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Further limit verification in softirq (a.k.a. BH) context to cases where
> rescheduling of the interrupted task is not pending.
> 
> This helps prevent the CPU from spending too long in softirq context.
> 
> Note that handle_softirqs() in kernel/softirq.c already stops running
> softirqs in this same case.  However, that check is too coarse-grained,
> since many I/O requests can be processed in a single BLOCK_SOFTIRQ.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/md/dm-verity-target.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 3c427f18a04b3..4de2c226ac9db 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -680,11 +680,12 @@ static void verity_bh_work(struct work_struct *w)
>  }
>  
>  static inline bool verity_use_bh(unsigned int bytes, unsigned short ioprio)
>  {
>  	return ioprio <= IOPRIO_CLASS_IDLE &&
> -		bytes <= READ_ONCE(dm_verity_use_bh_bytes[ioprio]);
> +		bytes <= READ_ONCE(dm_verity_use_bh_bytes[ioprio]) &&
> +		!need_resched();
>  }
>  
>  static void verity_end_io(struct bio *bio)
>  {
>  	struct dm_verity_io *io = bio->bi_private;
> 
> base-commit: a33b5a08cbbdd7aadff95f40cbb45ab86841679e
> -- 
> 2.49.0
> 

