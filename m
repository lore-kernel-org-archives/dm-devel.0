Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C8BBA28;
	Wed, 13 Dec 2023 04:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mL2viXPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CC4C433C7;
	Wed, 13 Dec 2023 04:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702443428;
	bh=5BOi3Lwdro3EYfj4e0mqi80DNewhu0wK7EVeY8e20mA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mL2viXPFPMXylyv+jO64cyP5OgXhwVz7USicBblv5xRQIJlimFbas8/P6ZZxR3wyt
	 feiwg+g3PEARPbJgmIw4CtC+aJ0gjk9BLGjUM1T6BUcd5LLb6/c/6was5hiiyvNwgK
	 XVz50wfZyeVcTIVYEdye1UjW0aiKFIcLp29cF5dXZvsy+u/hUNFZu8j1qlNxSnTOQ9
	 sRswZ5TOqCtdN7xmcfbee7Lr7YuyThuNdUmlv8gofKkI/3uJeFotwn9oOpPi5lpfq5
	 tZckmc3cuBRgSZGenLPG4bEq/tKOgOGka3S76GuYULYE22kLCs2f71/aWsUbUYuWeu
	 5K6bG/6VnZLBQ==
Date: Tue, 12 Dec 2023 20:57:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Hongyu Jin <hongyu.jin.cn@gmail.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	axboe@kernel.dk, zhiguo.niu@unisoc.com, ke.wang@unisoc.com,
	yibin.ding@unisoc.com, hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v4 2/5] dm: Support I/O priority for dm_io()
Message-ID: <20231213045705.GC1127@sol.localdomain>
References: <ZXeJ9jAKEQ31OXLP@redhat.com>
 <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
 <20231212111150.18155-3-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212111150.18155-3-hongyu.jin.cn@gmail.com>

On Tue, Dec 12, 2023 at 07:11:47PM +0800, Hongyu Jin wrote:
> From: Hongyu Jin <hongyu.jin@unisoc.com>
> 
> Add ioprio field in struct dm_io_region, by this field
> specific I/O priority when call dm_io().
> 
> Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
> Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
> Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>

Is struct dm_io_region really the right place for this?  What about
struct dm_io_request?  Or a parameter to dm_io().

- Eric
