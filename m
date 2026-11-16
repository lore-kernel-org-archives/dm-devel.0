Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794859244;
	b=RukkrTVvthsUa0ZODb6Fo8AjNk5H++MHZQynfVHgUSFzQ6JZ5Hz6vbG0S3pPvqxjI/x6
	 G9V0tcyynP1jwZfWU5b1Nzo1S1K7KwLD32Vxri5xDHGpnBZsyRv8zp8y5s+EJCjT+Sxay
	 uzqVnB/U/vDAqg64nhC1xTN+gup0VFMOYr2n+2P7/eoG5RBwwl7Bj1FK+jyDWJXoUWSVp
	 tS8SoGYB0fmVMmRBfx8q8x/UkB1OmYaYrPlko7ASGHP1uXucnQ0nLgCth7179uwd9+Lmw
	 6j0HWJh+lG0+nDVYIXAPw2behQDj/CTalbUNhaW+Yjbpn1za4gTjBL6cZjL7ZxK1peg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859244;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=BWD/vpvxbsY8uBbAHZokY+AV+nKje0i3PXiJI8BfHII=;
	b=oFMrP8cJR5NnlPyMLjVzkIODsDSS7xV28nH+XfBuIsPm5H21EFYAir5QMDLgFjzKbdR1
	 RFvEYtotV+7ImCbuqI3x62Vs65yspBi6m3x/MPAAfVBFCd/Fj+Mchw6hgt9akbUSaxJdF
	 3tD+Nd30DnPndxCI8y+uKZ/WYChqMhfFNyGfZm1oi2fPLxsSgHSi8xtiYQ7EeZIiPCMWJ
	 yuhjIOdOwW8qoGCSlHxkAJ1npVlbhUJwI1I6uGgbK2ogWweDu0qTp9C9w6vBsFd5cOrnS
	 LBb3+5vaoTMgS29oEm3LflBveSoTQgoDJ/Y3eQKG5mi7WLsyl4c656iFH6Rh2wAv/zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NRbVOazG;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2B7606A322
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 20:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E2B7606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NRbVOazG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794859243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BWD/vpvxbsY8uBbAHZokY+AV+nKje0i3PXiJI8BfHII=;
	b=NRbVOazGNoCpDeuQ6xv342Xmbis67AmdXRfIEveoU0T/B7TnhuNxk2WKOZEamPe5NS7nNe
	KWG6OtxQFePD3UuZMCJfgCvpcrvsQHDSAMT67pJkGGQfClJwv7sMexeWjfWjUdC29JCn49
	+eu6ITu9fmETmKfp6dsI/G/5rh5UAp8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-MIFi9gTNNBK1DT0jUeqjyA-1; Mon,
 16 Nov 2026 15:00:40 -0500
X-MC-Unique: MIFi9gTNNBK1DT0jUeqjyA-1
X-Mimecast-MFC-AGG-ID: MIFi9gTNNBK1DT0jUeqjyA_1794859239
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 896DC1955F4A;
	Mon, 16 Nov 2026 20:00:39 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C2EF3001DA7;
	Mon, 16 Nov 2026 20:00:37 +0000 (UTC)
Date: Mon, 16 Nov 2026 21:00:34 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Donut Oreo Computer I <donut.oreo.computer@gmail.com>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm btree: Remove redundant index condition
In-Reply-To: <CALKjhPewyFB0=2tfyNVuDPosTAisDD2YcejTpX+0iiKRXdsGaw@mail.gmail.com>
Message-ID: <f9266fcb-d030-dd16-e16f-0569b93bf4b6@redhat.com>
References: <CALKjhPewyFB0=2tfyNVuDPosTAisDD2YcejTpX+0iiKRXdsGaw@mail.gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: NcScYc_O9rz2kyGB_58FY_BYpJHyykBOZJe_ZD56T2Y_1794859239
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 6 Nov 2026, Donut Oreo Computer I wrote:

> The index is unsigned, so checking whether i is non-negative is
> unnecessary.

Really?

In the caller, there is

"unsigned int level, index = -1, last_level = info->levels - 1;"

In btree_insert_raw, there is "int r, i = *index, top = 1;"

If you cast -1 to unsigned int and then cast it back to int, you get -1.

So, it doesn't seem like an obvious dead code to me.

Mikulas

> Signed-off-by: Donut Oreo Computer <donut.oreo.computer@gmail.com>
> ---
>  drivers/md/persistent-data/dm-btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/persistent-data/dm-btree.c
> b/drivers/md/persistent-data/dm-btree.c
> index dd02eee4a23c..b7ac2f6d1d71 100644
> --- a/drivers/md/persistent-data/dm-btree.c
> +++ b/drivers/md/persistent-data/dm-btree.c
> @@ -1108,7 +1108,7 @@ static int btree_insert_raw(struct shadow_spine
> *s, dm_block_t root,
>                  * see a way to do this automatically as part of the spine
>                  * op.
>                  */
> -               if (shadow_has_parent(s) && i >= 0) { /* FIXME: second
> clause unness. */
> +               if (shadow_has_parent(s)) {
>                         __le64 location =
> cpu_to_le64(dm_block_location(shadow_current(s)));
> 
>                         __dm_bless_for_disk(&location);
> --
> 2.56.0
> 

