Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B0A199FBB;
	Tue, 29 Oct 2024 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730220284; cv=none; b=o3kJw3nC8lNmDMy0VjYZ9jog699mKmW+8ywpwf8bsGkQb4TstY1Nd9XqREL5s2+FK/R37/BLeNlbnSP9U5F3IU8Yjtwxv9SzIKagr9YoOgGR/zvrsQ3L7pQREDoJqMYmJhTowQSJRY8oKZQxJmRWgdeoSlFMwc3jtHz9mHee9g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730220284; c=relaxed/simple;
	bh=eh4zIpr9hXJbjU+gPJNU8c1R5EohPpknuK6IFTBhWR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajbhQACu1RQUX4MYpiaybXmDdQ/xWb9HqCd77m6muQyUbnDoo0pZ8eeHiHiOxTwxuZsMjLmBmrewBb7I3UnzZ4DkOsz8l3PlXhwmMIH7Le7YQDxiZ6+x0P0bPf7+DKiu8n1b5psNXXPLaeAAWR4mkJOgMHbVy9plB0BKnD6jk94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDGJaPw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDGJaPw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53367C4CECD;
	Tue, 29 Oct 2024 16:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730220283;
	bh=eh4zIpr9hXJbjU+gPJNU8c1R5EohPpknuK6IFTBhWR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PDGJaPw3A+Y/OHdeRC4Ynmz69V/IaGtviPGM9N+xNxPGo+4af3POoFVTIvmHABwxP
	 I+aG92/HJ12//WLeJXVFk8PCesH02oC9JameuLiYazty5/u1TZL7TnSerM/vUt71rA
	 ecg5MJ7Vg3C60bpk0cJQF21ABb+rYT1SJAPbo6xMs6F3q87IJ00EL2rNEwQdJW8YI4
	 pXyM+bEGz0J+46RpAV0xYgNQL/SqY+S5HfWfy+7cwdqdDX6uoXp62JXhszcYvbs7Wu
	 HoTbi+bRyNPeOKh7GvdPtGpeyxIzZ6EtTt0OjShOyO3LO9u+oypLK++DdUEbajcoUi
	 9KuuhSoN4Zx0g==
Date: Tue, 29 Oct 2024 12:44:42 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] dm ioctl: rate limit a couple of ioctl based error
 messages
Message-ID: <ZyEQ-mT-ojb6R0a7@kernel.org>
References: <20241024110431.1906858-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024110431.1906858-1-colin.i.king@gmail.com>

On Thu, Oct 24, 2024 at 12:04:31PM +0100, Colin Ian King wrote:
> It is possible to spam the kernel log with a misbehaving user process that
> is passing incorrect dm ioctls to /dev/mapper/control. Use a rate limit
> on these error messages to reduce the noise.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Mikulas, please update the header to include the context that
stress-ng is what Colin was using when he experienced excessive
warnings.

Thanks.

Acked-by: Mike Snitzer <snitzer@kernel.org>
