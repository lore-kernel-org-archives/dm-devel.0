Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210003597B;
	Sat, 20 Jun 2026 21:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781990836; cv=none; b=UBDk8UFJPxuOB1KTW0hkWJzlZEfL51SIymtdodUQbRHkUIWZ6wy7Gb9LiTqmWDkJxGza+pDrCAHfW2vXZrDXCl8CDKzqt6AeDgESB+aJgJRfndZpAQkfqIc5Z7YxInvfQcvWFe9ujEuhS2yc46/r4UeoDFMA1pdJ7/ShS+5qJ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781990836; c=relaxed/simple;
	bh=k0tw37oTgoijHTzslreWs63br0mhdlz0v5QmW+TMebY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VchLMmtW7weY208tKwMzyG35FJMxX/XOwN89TV4aZpApTv6S2dp4E0pw5AHuD7MJ8vQg7/oo4BrNXqe5y02S8jrfTYdEYzGk8HfIoI7of0vg3rVSKGk6536cpKaKPpTwN0V3fj35NLUo+tZzhbSO+b6kRSla3HkHAsik1j5mkn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PckG8UW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PckG8UW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909F11F000E9;
	Sat, 20 Jun 2026 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781990834;
	bh=Bn7btM6aPISE6eCFFmm7GJe6EfxA8Y9AFDm1aRvc878=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PckG8UW1zOSLpkkKg4SX1eiVXGKOZ0i2waABbFmdLrljjWXIh0kK/C5OisoJ+JHSN
	 iFIXsTQPKT2FZ/nlNsNSISYdNuQS8Gh4bwL+Epo38UDB8yO83fBo6vBErqlwGfU/6i
	 Sq5vzuVLHr01mQ6PvthdY2aPaxfTFhqqxnJ9WvOvMvuGs5wTTKRWHg6kBi0YUIHRcA
	 TWGFmNs/TPgyiP88UUa/QnMOAOEmrYYzoqRFYK+iw1mPIfbRZGkYZj9ExuB5PDYzmK
	 hR26fLeXSlfvoPnbT3cZO2NawlE40uBbAnFKnfiOsYlIFIhxa95f12v9FS1Tti+epj
	 UxSkIfinaDfIg==
Date: Sat, 20 Jun 2026 14:27:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
Message-ID: <20260620212713.GB1702@quark>
References: <20260525121348.1321282-1-linlin.zhang@oss.qualcomm.com>
 <20260525121348.1321282-2-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525121348.1321282-2-linlin.zhang@oss.qualcomm.com>

On Mon, May 25, 2026 at 05:13:48AM -0700, Linlin Zhang wrote:
> @@ -502,8 +520,9 @@ static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
>  		 * the returned table.  Userspace is responsible for redacting
>  		 * the key when needed.
>  		 */
> -		DMEMIT("%s %*phN %llu %s %llu", ctx->cipher_string,
> -		       ctx->key.size, ctx->key.bytes, ctx->iv_offset,
> +		DMEMIT("%s %*phN %u %llu %s %llu", ctx->cipher_string,
> +		       ctx->key.size, ctx->key.bytes,
> +		       ctx->key_type, ctx->iv_offset,
>  		       ctx->dev->name, ctx->start);

I think you forgot to update this when adding support for keyring keys.
The point of the keyring keys (to the extent they have a point at all)
is that their contents can't be read back from userspace.  But this just
returns the contents.  Take a look at how dm-crypt.c handles this.

- Eric
