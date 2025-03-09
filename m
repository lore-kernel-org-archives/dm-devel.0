Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A0717A312;
	Sun,  9 Mar 2025 23:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741562364; cv=none; b=UEHH4oyN9tQjH3Ug/3T9d9dWrcUc1Ylpb1XZgANt1itnZc7mSa85EFthuTvecJev5UVVPaWbppFblLMPDUPOM/xsHyHWh1dSwpN9/gisommRtCUKrzyMtu8Ray82L6pjJGH31hAVDI/Nv0DEFUIQDaCxDbqJcTNzbxgbqk78d30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741562364; c=relaxed/simple;
	bh=CikG01t+77+0PEMSEdSHdkXMOcsG/rMs0OefwBM/ljs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F606Qsf12AX5sBLrjaejrAFVyV+tKFHiwPVo4vm5ozHqNmIC7SWB17yshcEl+eM2sTU4isKPozlEUJr476XVJ94Rrdcv4EOigw11rCxNn4zey26C/w3By+W5Ke+ZKxrAznLqDD0tXKMHic2SNQpObg9pqpE7h6+Y64DIibRwQ20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfxnmrPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfxnmrPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2845DC4CEE3;
	Sun,  9 Mar 2025 23:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741562364;
	bh=CikG01t+77+0PEMSEdSHdkXMOcsG/rMs0OefwBM/ljs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RfxnmrPMLgt25v5GqHIQ4pme4xLcQf+iqs3mu2kPgpxA+A9llVWT/nJPELA//N3Tb
	 mrjiOYzUGBz57Mog9oGiJAia4SLAhyGOwWW+Cbrey2ax4gNrc0ZEeGWnRE/qWvJO7o
	 pzLrNyoy7BTHK5xhdiLKPrQRB061nLO5Exl/MUNSpvukeEnLRY1wW7PmpITolyY1jY
	 Ewc6WaJ6wjhoouFGOhSfnhssp5okoWLrP9uIq8J/WOjMuF5MF/mKT0NEkFQFfsbLTu
	 gXbW/U2KzdzsDqRcdCF7uTBjsHWC4Ppl4R3AuO8ZhUxF8LGP692GgYFeJgXdBwFu92
	 KbsxHQQP87QAQ==
Message-ID: <23c2e385-60ae-491c-b903-ea23f82881b3@kernel.org>
Date: Mon, 10 Mar 2025 08:19:22 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] dm: free table mempools if not used in __bind
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-3-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309222904.449803-3-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/10/25 07:28, Benjamin Marzinski wrote:
> With request-based dm, the mempools don't need reloading when switching
> tables, but the unused table mempools are not freed until the active
> table is finally freed. Free them immediately if they are not needed.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
