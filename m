Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795290992;
	b=IH3TnAdOlt2vOASaWgDXeezD8iNgPoy8Fbp7o9GqhTO3vICf+/CikWUlbj5Q/O07Q6KO
	 kdQy7Ip5Wa++dflN+lRo79CgSB9bbNTOBtW977VZREfEIOXETrfTlQ9SvtSgJ9h/bkQ+i
	 7/EvsOYDtACx265quaTtiDvnCXFN3aCMUeA2mqJ6mcFZKTuaJEom6WM9BRjStThQI8HGs
	 NG5BXFOfLJaIhBKSt4JU5mQ8QMe++BuSljTv07efPhcdUnnlDtaQjoh9ftgqc91C2qOkC
	 vFxIfzqeP4Qu1TYoJ5J9+IhxwB6JAUkIV0KvvVM61ep0V7HU8ZxrTTdY8BxPs1EEGPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290992;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=23IDwk3BEvcoO7nr7xSMYC3SYO+hpSQTPRRnKuF6fw4=;
	b=Db6Klo1596278IeR4/vaWuqXY5R4Ioh4NA28r1S7riqlfopQ6s876IdrzGkSJYPuw4ZA
	 xSoQoqApHIgbTmXV+GIMKPpcxy2FMzHF8Gb0mvxJ25lmBs9K3vYrwIFs9ggfzHVf/5+yR
	 Dz2ZjR4W8+jEWpUCH3I35Rom2XGYC3HI3tYxz1egqQkR0BGzCTczexV14rBwNuDyjmYBS
	 fgCXKTM4sy4ImS+2n9T+4ba8M2Qk35w31k8TPqS5XtNdZo/35Rn/teCmk6m9log+WjfmC
	 Vovzmbt39d8A9IQ5T880tqzWuefxgidlWQsW5xaTLANkEVcPaO7tkwyW9F7r7USEN2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UL4/VmZd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84DB606A320;
	Sat, 21 Nov 2026 19:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UL4/VmZd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073151F000C4;
	Sat, 21 Nov 2026 19:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290992;
	bh=23IDwk3BEvcoO7nr7xSMYC3SYO+hpSQTPRRnKuF6fw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UL4/VmZdsgsu0mqc1ftY0mgbzC0pMr+SQDEqY/IzjV+BF8HrSDLdAfK2UvftqnSoL
	 ELh6adk0PEF0QYmJb866BLaqKGGkWJfZWC69BYJsRUhuAExkAlmHMLirhCb1XtgmTQ
	 6HBQoMY3JZQcTr+30WLRXh1OFQmqo43GbI2KApvGgM2T9a0CwSHfkI48IM7dTTqT+D
	 07dRkbxEpgvww/e5/DqeFbzj+DlM34juyRO4CXzT3Hch9+yjgtyXWccXT6/oSIO3IS
	 7GSYplLquClJkdNYtH4PRK1HXZu2K+VE3PH0VzVdzvAkSy6hWSl5/hb9AwuJiXdJOH
	 ydXerEda6gccQ==
Date: Sat, 21 Nov 2026 11:56:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Anvik Loitongbam <permissiontogallop@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm-inlinecrypt: emit key type as an optional table
 argument
Message-ID: <20261121195630.GF1975@quark>
References: <20261121131539.7519-1-permissiontogallop@gmail.com>
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
In-Reply-To: <20261121131539.7519-1-permissiontogallop@gmail.com>

On Sat, Nov 21, 2026 at 06:45:39PM +0530, Anvik Loitongbam wrote:
> inlinecrypt_status() emits ctx->key_type as a positional argument between
> the key and iv_offset:
> 
>   <cipher> <key> <key_type> <iv_offset> <dev_path> <start>
> 
> but inlinecrypt_ctr() parses the base table as:
> 
>   <cipher> <key> <iv_offset> <dev_path> <start>
> 
> and keytype, is an optional feature argument parsed by
> inlinecrypt_ctr_optional(). Resulting in STATUSTYPE_TABLE output for every
> dm-inlinecrypt device to be not reloadable, the constructor reads
> key_type as iv_offset and shifts the remaining fields.
> 
> Keep the base table in constructor order and emit a non-default key type
> as keytype:hw-wrapped in the optional feature list. Raw keys remain the
> default and are not emitted, preserving the existing table text for
> raw-key devices.
> 
> The two dmsetup examples in the documentation acquired
> the same extra positional key-type field, so removed it there as well.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260525121348.1321282-2-linlin.zhang%40oss.qualcomm.com
> Fixes: f9f57971da38 ("dm-inlinecrypt: add support for hardware-wrapped keys")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anvik Loitongbam <permissiontogallop@gmail.com>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
