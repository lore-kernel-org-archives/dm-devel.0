Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990887;
	b=LySAOGpVP5qmalaUM2fLHaxCe6bbbmB/+RkUG3x7iRszA8L2JubN22O+OBA8r/F6GEp2
	 cA59G4KoHXAnhV5dLNzdx8Tk67eEHcdPhQ0fjjxbeYgXhk8kzI+HavUE7HlIF/mWPs+cE
	 MlxnXiI07T/D4o3vg1PNkLklAwNMMkZbnEf37zY6hLYYQRhH5zs2RtZBn3jhktnypqkRt
	 JjM7/IHua+oBxh52HwDYKO0jOLh3WGk+W4t+Pl1jiPb3NEBw3j/5Yz7u84UEpUDwyZ3QE
	 BLZKdhdTUieARdZqBPbxK2xWJfnPrlk/uYjFSYjQeM3lTtfRaob8prsjyEqO2MqgQ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990887;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2lixgofUUnT1JCJwLjvCxZ/iIRI+aexy9yxHMFt3z/4=;
	b=T85IkyEwutNc8nlc5JuJXJ7ergAkFZY96j9/44XRN5FVQY9AaGeVe44Fn1/f2WSS/Pd9
	 Qrf1DdoUVDWLyg/wUiKwXHhsEz6gUjeNl3dPczaaJWxfmlBEOWJ6Af3I6AmsTsl81mSs3
	 q7fD0ZnM+kdQsJ5JYKxN4O0duzy3rdaeeAGGiAPZRXaYlVpQDMu6HDim1GzO5vl0qYEhd
	 EBxp/AGN8ntxzeMwPNqHrULy6ryYuv61SDqbRRbLktT1gzFw7WeD3Sv+H636qp6438H+T
	 UBM+GGDRKLjZHM3jDFkrnEYo4AsNCug9znaPsry+tphQFZUehXle+QCOfAvqVdi1Liw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8GzObb0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3190E606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8GzObb0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21831F0089F;
	Fri,  6 Nov 2026 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990887;
	bh=2lixgofUUnT1JCJwLjvCxZ/iIRI+aexy9yxHMFt3z/4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m8GzObb0nPyvXq/Z3bDwqJCrzNTnsTfY9g3ZcR8Q64rbVZtekrJN3Jkeu+le9g2KD
	 54kHB8zYQ903fDd3YYpECWFMqHypCtgLnSBye0/6L92GeWFxvr3bS+kBc9X9Q1T+ja
	 tcHneh18qKyBWRqR/tcRBT/proLyhGaaDutKa4B5hz3Lr3L0+3VswLxIFDvO9cior3
	 uPR+9mRkU/kCiE9dlQRwAF2LW8ycDyVtLIxEpxOMt7/+j3+GxvQOHU+QjC88rVjzoq
	 8f+8N8rtxiHKsVk33Dh0Z5AhlPPfTzDs9jgsoRY1ZRoCjdAyiV9mrPArY5gJmYuPmx
	 5M7WB9kpaN0lw==
Message-ID: <sashiko-outbox-202101@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm-cache: fix NULL pointer dereference on open failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
In-Reply-To: <05b79ec2-42f7-ffe3-20e6-1dc499e60cf5@redhat.com>
References: <05b79ec2-42f7-ffe3-20e6-1dc499e60cf5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:48:06 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] dm-cache: Fixes trailer cites c6b4fcbad044 instead of
  9b1cc9f251af
--

commit 9e9ca29bfbdfdcf14064f5312fa72be5b8ba53a8
Author: Mikulas Patocka <mpatocka@redhat.com>

> dm-cache: fix NULL pointer dereference on open failure
>
> When __begin_transaction_flags in metadata_open fails,
> dm_cache_metadata_close is called. dm_cache_metadata_close attempts to
> execute list_del(&cmd->list);, but the "cmd" object is not on any list
> yet, thus it crashes with NULL pointer dereference.
>
> Fix this by initializing cmd->list after cmd is allocated.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5
> Cc: stable@vger.kernel.org
> Fixes: c6b4fcbad044 ("dm: add cache target")

[Severity: Low]
Should the Fixes: tag reference 9b1cc9f251af ("dm cache: share
cache-metadata object across inactive and active DM tables") instead?

In c6b4fcbad044 ("dm: add cache target"), struct dm_cache_metadata did not
have a list member and dm_cache_metadata_close() did not call list_del().
Commit 9b1cc9f251af ("dm cache: share cache-metadata object across
inactive and active DM tables") added cmd->list, deferred list_add() to
lookup_or_open() after metadata_open() succeeds, and added
list_del(&cmd->list) to dm_cache_metadata_close().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/05b79ec2-42f7-ffe3-=
20e6-1dc499e60cf5@redhat.com?part=3D1
