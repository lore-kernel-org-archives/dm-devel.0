Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76E133F8BE
	for <dm-devel@lists.linux.dev>; Sat,  8 Aug 2026 09:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786179606; cv=none; b=nG2I6XceLK9EfQFvfp9yBeBQwDIv9nPSDJOvUTm8+QfSSgxTfEoscyFxariF7bpj/Rr1W5zHFHw8UrdbL5WsK3DNc9C+Y0AoIfoGkTcMofKg9r8073csnYy1ItyRw/k56VD00BRENe+ZKyfSzMvQ3GGFqnDo6lUPUFXaO/8JKYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786179606; c=relaxed/simple;
	bh=Ig+cCBz8/Ks42G9yEbCjEfWRxrs2NwA4FALqld0p0Ac=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RyhZbDjzgH4zRknNHOAEJv+XXXo2mkXWEPvKPPOmSFMA02D9/YH/w2fFuPMCBi0VXieBqjKVamV8r/n32//PPGkfb15Wr65sJraRWzT3EuR5K1JwpjcwTarAmgZqtgqbj4OP6yJbn72/ADjf2g20Z+zcju1A9d0yoNzjVkPTe6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=aBSZQP8d; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="aBSZQP8d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1786179592; x=1786438792;
	bh=Ig+cCBz8/Ks42G9yEbCjEfWRxrs2NwA4FALqld0p0Ac=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=aBSZQP8dYXjAHfUY70ELQEnM0H+URKN1KNNoZ8veg81ZdVbtpSUaGxbBbaR2azMJN
	 XxuQgxsNlFSNai1TOpR/WLpNvyRxaTCgaNA1BIMyHmWH0YqK/JTyuL2w1XxQmvq889
	 nKWtHwrxPNADrZDZwa1TV3/5F5MZWFaekJ7f9sNI8xCg7ThBYHDexjx9PXPwRinVlC
	 pbxr2TmHQ6t9iIqNl+An2rCtcWLsvunNLqZEXI3y3PLnr3TkbQ0fbLYJbxinKkr6LP
	 pICdUcM3nbZORdPxJcfea/B8YMoTck7EFBBRKerMeADLVBRxXqKwsrIu2XMHjY7Ych
	 z6igduzPOxxmA==
Date: Sat, 08 Aug 2026 08:59:49 +0000
To: Ming-Hung Tsai <mtsai@redhat.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dm array: validate array block headers on read
Message-ID: <20260808085943.422108-1-hexlabsecurity@proton.me>
In-Reply-To: <CALjSBEvVOTpd+j3zgspvdbX2fhQwc1HoNQHFup0uEfkRM=2kVQ@mail.gmail.com>
References: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me> <20260731-b4-disp-4fd3bed9-v2-1-7b1835e4e7f6@proton.me> <CALjSBEvVOTpd+j3zgspvdbX2fhQwc1HoNQHFup0uEfkRM=2kVQ@mail.gmail.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 8125b29a189071a47d717c4f48bdcf22a8db24e3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2026 at 09:41:36PM +0800, Ming-Hung Tsai wrote:
> One minor nit, which needn't hold up the patch: I'd drop "wanted %u"
> from the error message. The wanted value is derivable from value_size,
> so printing "%s failed: max_entries %u invalid for value_size %u"
> carries the same information.

I'd keep it. The two DMERR_LIMITs above it in array_block_check() are
"blocknr %llu !=3D wanted %llu" and "csum %u !=3D wanted %u", so "%u !=3D w=
anted
%u" is the shape a reader of this function already expects. You're right
that the wanted value follows from value_size here and doesn't there --
what I was matching is the form, not the information content. Mikulas,
drop it when applying if you'd rather.

> Reproducer to validate the BUG_ON prevention using crafted metadata:
> create a cache device, and reduce the max_entries of the final array
> block of the mapping array. Next, expand the fast device to make the
> last array block exceeds its capacity, which triggers the BUG_ON in
> fill_ablock().

That is the path the equality test is there for -- an upper bound lets a
short max_entries through to fill_ablock() untouched. My A/B covered the
overread only, so that half was by inspection.

Thanks for the review.

Bryam

