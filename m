Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795472844;
	b=hqWSNFciHGEV05snFZiGiIQ1/zGn531psSnmGNe8t64MlHmnKUw9nRTttnNOow14P4HF
	 AOyGHK70ZvVAD1/2nIjoOxyIIy68TGjL0vECwue2Gez8CcWprN3INPAt7MQT6MAwYNGqT
	 8rNh3I7caGZ7y2Z1EitxRrSP9W6aM2oY69RQpEMhIikZjrgWKP7Li+G6A66g9c/Q+maOF
	 QDNq5EG6PvxToYeEoN80nKP9593cYxOUe0wvY8wGPLVxYWXufzpvlqikmZGztOQIxKJ2s
	 XJ4hg9uhXkmGBhjm015EHoeZXAab6AB5KqIjxIuCyT81RH12NqFkrVSva1I3nADPzVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795472844;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1SXtsndVDFo01qaS3zcu/AOAPMuR2YTIaz0A9T5A49k=;
	b=Ir3NGJNRt5GMeRSJfgvzLBBR7sNrAJ3DeTD71Y21GRamp0EepnGIx58Tjw49lIzqtib7
	 ggbWTi2Vfdou/Ojzby/mvO+pJePpvciXLbYDqtADogZEX5R3O3veKTo1Ev1oKXLveePsc
	 aR56sHy6W7ncFb4Jwb3M1U2wL7aGhR+CIzfhPSgqOpTeiB3sp0Rf/AqMigG1cI7cQ8S7A
	 CX73Oa84nL0dXr2fOdrHnYosjCuOfBOjfsOPVhu1t2ozu12ZwNWi99OQTXuVA07hNLreN
	 Cjz3Rn8afZbtFchdoYJa1JxT15zT1spgtSgmpkry0LRD9/5Xqck0GnXRF/F6b/kr+aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUVLYUy8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69887606A322
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 22:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUVLYUy8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801A31F000D4;
	Mon, 23 Nov 2026 22:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795472843;
	bh=1SXtsndVDFo01qaS3zcu/AOAPMuR2YTIaz0A9T5A49k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FUVLYUy8+wLjjz2GmsHCRDZ53XWbwiKrRLQFflzBuNgSxawcoVmRP92maUmjYpDG1
	 mT+t36nQa9cif6++DofWkU5qyL0r6CAtxchH5EF3o5rqjwqa+zs94XohytYI7lBobR
	 yecDgpX7XsyvL+FFOQiJsCxEPomlIseE0opOe//ilKn1GHinIl2YtL0SYUUOJuvLs/
	 m40gvQlm42qoB+m719Ka4zValjWsD6JWWMYgL1FvK1884l2PYVKp0SytEiRmRCdxBE
	 l4L8KySyhifpd1rHsGoOiV39cOpmmKhJ2EzlfqIw9KfxqjON5TIzTZ4yosvJ1jZTVd
	 m5Rwbt0IqeUKQ==
Date: Mon, 23 Nov 2026 22:27:22 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>, Filip Suba <fsuba@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-compress: introduce the dm-compress target
Message-ID: <20261123222722.GB18468@google.com>
References: <d3fbdf3d-c7d8-0e4f-31f4-b187eb52ec30@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3fbdf3d-c7d8-0e4f-31f4-b187eb52ec30@redhat.com>

On Mon, Nov 23, 2026 at 10:07:01PM +0100, Mikulas Patocka wrote:
> +static int __init dm_compress_init(void)
> +{
> +	int r;
> +	unsigned i;
> +
> +	for (i = 0; i < dm_compress_n_algorithms; i++) {
> +		unsigned request_size;
> +		dm_compress_algorithms[i].cc = crypto_alloc_acomp(dm_compress_algorithms[i].name, 0, 0);
> +		if (IS_ERR(dm_compress_algorithms[i].cc)) {
> +			r = PTR_ERR(dm_compress_algorithms[i].cc);
> +			dm_compress_algorithms[i].cc = NULL;
> +			DMERR("Could not initialize algorithm %s", dm_compress_algorithms[i].name);
> +			goto bad;
> +		}
> +		request_size = ALIGN(sizeof(struct acomp_req) + crypto_acomp_reqsize(dm_compress_algorithms[i].cc), CRYPTO_MINALIGN);
> +		dm_compress_max_request_size = max(dm_compress_max_request_size, request_size);
> +	}

I would strongly suggest avoiding crypto_acomp for now.  Instead, it
would be better to simplify the set of supported algorithms to ZSTD and
LZ4 (the ones that are well known to do the best on the space/time
tradeoff curve) and call those library APIs directly.

That avoids all the scatterlist nonsense and other crypto_acomp issues,
especially when it seems the caller in this module has linear buffers
already and waits synchronously for each one to complete.  (acomp does
now support virtual addresses too, but it's still an extra layer that
provides no benefit for a synchronous software-only user like this.)

As-is, it looks like it also doesn't work correctly with the scomp-based
algorithms (lz4, lz4hc, lzo, 842) when chunk_size > PAGE_SIZE.  In that
case scomp either returns -ENOSYS (making dm-compress silently store
everything uncompressed) or overflows its internal scratch buffer.

There's plenty of precedent for just using the compression libraries
directly: zram, dm-vdo, btrfs, f2fs, etc.  If hardware offload is ever
wanted, it can be added later as an optional path, like erofs does.

- Eric
