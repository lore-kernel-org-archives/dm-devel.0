Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057863B777F;
	Wed, 17 Jun 2026 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781715283; cv=none; b=pwJYDdaBZ1NwnUK5kv2IVa3GhHEMvQfKa+OYTj18Yc9465Gb5NQO+nnraxfsfUK4d5xUCwv4EEwGcTcBqFbPQC3bTEopuQVOFKKd7BWRWt76K1N/Ypw3W/bId8CwAxezxJfS0XqUqcz0D4TpkraGaWXl8RBlYQWOid2gamGY/DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781715283; c=relaxed/simple;
	bh=o3WUJ/eNJk6R+/NNqNLMdwE5ozkdzguccRMv92lhDxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cb078vK+gX0nGu3v9bmk1liTT2mwMvL61G1sruMPO4eU21czA2DxrkYm1oKU/Q3Yj3n1iykelDg3Iq8pT5HIfoMgQy25EBNLJ4PjwFnKJBRmCdGGoJVg/So8/EBKfJl4AU4As/uFhno3wr+M1JuNxxlwmZ93tkpHCNvkzaCEWmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WY+S5E0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WY+S5E0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126081F000E9;
	Wed, 17 Jun 2026 16:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781715280;
	bh=o3WUJ/eNJk6R+/NNqNLMdwE5ozkdzguccRMv92lhDxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WY+S5E0jtX6KCqBOdBzQ2G67O39yAzVKNZKDLneoY7hQ36OTl5bBgrAi/a0LtRXxz
	 JqD3EfSB0s4slreCmFO3ipNWOjPDAlZWly+BIu3UXqY6vigdvU+qLCRNQCcZQ9gTr2
	 CldBjLyo/808wk6cvcBBQXmelwWaZLtwa/ZfzZOX84eEu42sj8ENr1NxNpp1A1+5Jr
	 xTYzv8iX3Zlov7VDSwOMdliIyEyEHYwWAhQSi+u5E+66JNtAWBvpPZoZgxxVAw48f3
	 h2Xxt+mM8QNFqsmVe6BlPqDJ1NhyBGnovqP1r/M+h+vjJdMCRy+OxX1cZFV5Wjc9bV
	 22tE2Ff336g9w==
Date: Wed, 17 Jun 2026 10:54:38 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajLRTkSZJ0WCYNk4@kbusch-mbp>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey>
 <ajK4YacvP7eQ-S2o@kbusch-mbp>
 <ajK-Y7uoK0QT5PVl@gallifrey>
 <ajLJiOwim7qBp_0P@kbusch-mbp>
 <ajLO80kZmFnyR2mH@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajLO80kZmFnyR2mH@gallifrey>

On Wed, Jun 17, 2026 at 04:44:35PM +0000, Dr. David Alan Gilbert wrote:
> (It's a bit scary you're having to go around quite
> a few places and make similar fixes; I assume there
> are others that do similar things).

Yes, I understand that. I'm looking into a common way to validate this.
The md raid doesn't have this problem because they always call
bio_split_to_limits() first, but that's not an optimal thing to do for
dm raid in the normal read/write path, so perhaps a common checker needs
to happen generically in the block layer. Yeah, I know I removed the
previous higher level validation ... I'll try find something less costly
than what we had before.
