Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D38E2951A9
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 13:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056276; cv=none; b=QgpORB924oLbQ4NEboLi2BxDLeeE8/djSLvQgX3r7Lam3n2R2hUOPv2Q/KO/Kz8FmMPCnEAwypUIdLgAscHMUx+pkfLaNBQ6fMGl0me6NxsIHSB3Mfj3Xkyq40fGL7NAqSEor2945cWxI6E9rB8pEFiL1TmwUsrwAwDdhgNoH4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056276; c=relaxed/simple;
	bh=GzKqU69yTramT7VvzJPNz4DcRqpJyrpx5nLLb6sUiVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ymb0uWUO5shBXCEM3VQ2xBQ9uFpcD3k+s3feQbkZ7nIxI5iEnm38hOnQrta/pz+FUJ+l+5xFNf9NaIb8XtvjHHpQ/aKeGyNLl5u95Ly05LIjByEzEvadZ8v8izGQkKcht1OWiqpw5hKJFcFywKgZ8/E0mxz5h42HaqJgZICp7rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6B42668BEB; Mon, 12 May 2025 15:24:28 +0200 (CEST)
Date: Mon, 12 May 2025 15:24:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC md-6.16 v3 10/19] md/md-llbitmap: add data
 structure definition and comments
Message-ID: <20250512132427.GA31781@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-11-yukuai1@huaweicloud.com> <20250512050950.GJ868@lst.de> <89e306d4-bb30-96bd-0fe0-a5ff4e8012ef@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89e306d4-bb30-96bd-0fe0-a5ff4e8012ef@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 04:05:58PM +0800, Yu Kuai wrote:
> I'm not sure, this way is simpiler, however do you prefer add structure
> and comments by following patches gradually?

In general it's easier if code that belongs together is added in
one go.  Separate modules in the sense of they don't really
depend on the surroundings separately

>>> + */
>>> +struct llbitmap_barrier {
>>> +	char *data;
>>
>> This is really a states array as far as I can tell.  Maybe name it
>> more descriptively and throw in a comment.
>
> How about llbitmap_page_ctl ?

I mean the data pointer which really is states.  No real comment
on the structure name.

