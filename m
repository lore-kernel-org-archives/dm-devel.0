Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173766;
	b=2xr8v+p0HB+2h+oVH2bgu6ScsuiMB55PKuW/e/dAzSyfYP8GscBz1kadBcnGILPKhPNm
	 +f6oml1Bq/pENR4MSYPkW5bcvaaFnxlWv0cosBqCTq4dsJG9lIdcp0owMW8GYHbZKWRiV
	 v+531jZlUVinR/EBkwySGnzNSBRK324xrhGe64QGKSftBLeTcchXTcr5LnN62u+mDKgX1
	 68XQxIwip1mVtESaCi8pvIziSToIXI4ePbNYo7TxdOHUykjQ7du2UxpR44NOLtQYQoTTT
	 U6/9AWEMtZmvV366cltKTQevBONpxy1+741eqnwiP9Th7E5JCn65dmk6dWtHOCUBg3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173766;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yqGSoQt+/+IGm/vcLxjFC5jDnaosioJJ/z/ky1SpraQ=;
	b=LtJ2Tmr4YeBAvT9zXjSlfa1B1v4JlirE4Ce0+CAsRqcwEun0NYVu4sYCjiAJmztm24j4
	 oR1IZoUHjRU48k6RoazdJbqQePO/qfuPj0AcjWbXVAPwFZNbT9+GBL8J9XijBH50yfuS5
	 SPPpOdVonIQfoDTn20e4rm61qJtW5wKMpAekeHDwxmIMK3NNfQ6195R5/TMyPVPrJ+LWv
	 Bnyysm1ryv8AvYD616aLn4LlbW9cXmrt7AcTXaFdBG2psI0skKif7nDhRYBnqqdevJ5gd
	 xfoBo40KLShnQRJStzCpSP/DkvEdEpZKzcaTcroWmofBlh3gtHk0OiedADceLL4q3hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QV+wt+Sa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFB9606A320;
	Fri, 20 Nov 2026 11:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QV+wt+Sa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFA01F000C6;
	Fri, 20 Nov 2026 11:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173765;
	bh=yqGSoQt+/+IGm/vcLxjFC5jDnaosioJJ/z/ky1SpraQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QV+wt+Sa1ee4kwhWEGsfKEb68qRmtkPgAagCV40Rgk7qR1IBW6TV2m/sCq27xEWek
	 r9TZZJlAM9h0LS9+vcU/u86DXsnWb6I3z0P1LHSFa2aksQ3P7my5PAYDbrxehxiGJZ
	 SBbOQJW+vG+iwptl4LRNnKLDygLT8S4WaVacb8T+Moh29KekbqXpnN0/bNZ1voDSuw
	 8OgONKGyfvnipZTes0ga4S1YjA109mTKfDNmilHiWwwt5IwFe8Nt83uweUBTisfKwl
	 pS0kGfIU8stbQvgRrJWeHY/vr/66qGOJj65ZHZrp3eLPOzn56izu3C05nCBXY5XC0X
	 ryOxQaZQa+TWw==
Message-ID: <sashiko-outbox-225029@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] dm raid: Clear MD_RECOVERY_WAIT on reshape setup
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: nenkov2004@gmail.com, linux-raid@vger.kernel.org, yukuai@fygo.io, song@kernel.org
Cc: dm-devel@lists.linux.dev, magiclinan@didiglobal.com, xiao@kernel.org, neil@brown.name, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com, syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com
In-Reply-To: <20261120111757.4705-2-nenkov2004@gmail.com>
References: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
 <20261120111757.4705-1-nenkov2004@gmail.com>
 <20261120111757.4705-2-nenkov2004@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 11:22:44 +0000
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
- [Low] dm raid: missing Fixes trailer for rs_start_reshape() error
  cleanup
--

commit 6a83155083baad91c84f61814a141b78b22b8537
Author: Hristos Nenkov <nenkov2004@gmail.com>

> dm raid: Clear MD_RECOVERY_WAIT on reshape setup failure
>
> rs_start_reshape() sets MD_RECOVERY_WAIT to keep the sync thread
> from running before the table reload. If setup, check_reshape() or
> start_reshape() fails, raid_preresume() logs the error and continues
> without a reshape. There is no reshape-related table reload to wait for.
>
> Clear MD_RECOVERY_WAIT on those error paths. Keep the bit set when
> reshape setup succeeds.
>
> Suggested-by: Yu Kuai <yukuai@fygo.io>
> Link: https://lore.kernel.org/r/4d13edef-f454-437b-8910-3a905697303e@fygo=
.io
> Signed-off-by: Hristos Nenkov <nenkov2004@gmail.com>

[Severity: Low]
Commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock") added
set_bit(MD_RECOVERY_WAIT, &mddev->recovery) at the start of
rs_start_reshape() without clearing it on the error return paths.  Should
this include:

  Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120111757.4705=
-1-nenkov2004@gmail.com?part=3D1
