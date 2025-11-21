Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE291E5B60
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 01:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763689717; cv=none; b=FFSYf/K0wEr2nb6qdeUe2gXAFWHvMSqEmHFFWrQm9jfs0ru3QLDa3zqKNeCvt4JeNfPd8rbtJWIAOkQeXAK7EKZaMv08b8MM+q5TTt8UGeQpvgqS3EIaoYx2IgU7tLv4iykBvqNzE7cLDiY9R67ZnOZfmRuCtijxSTtLraZwN8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763689717; c=relaxed/simple;
	bh=3Op4G5SRhmiukGxvu9pviWsvw56Vo9fiKoGVh/c38/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuPTxZrwnRWCGxsAJRcUEE18km1BXUn/wLVUJAZSdEA7AF2bI9QvI6q4gsbFga1jXyX/M1LAIxp3ZfYtlCQg+g7Fd2I0Gi4yRY9JwZbiV2LLOR9EYVG1o3DhsRULuFoMYqAGDbvPwEBdkCKXoxkgCK7gTm6316XebA9tuPAhOEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sghop2wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sghop2wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E271C116D0;
	Fri, 21 Nov 2025 01:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763689716;
	bh=3Op4G5SRhmiukGxvu9pviWsvw56Vo9fiKoGVh/c38/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sghop2wrrwh75WA0uGIOrRmW2PwN92TuAaYpPhTttTJm5stipYKvwZms1onmQbCAx
	 Nav5upsGoAwIJjBcgCEAhlLLE7Neic4DkxDZCbVbnaQABvoYaJ3fbjM1wLyrdjhOtr
	 uG30+p1GcI9Gc4895R+2jb6AmHUa6MVYGiiGmtDuXIl/KTJN1FsDBHTkgCxR3oKHbj
	 CTFMFfQhq4vIIlrnYDqA6hQR/VsbT2jcMdd8iwci8scDeZYarokZ3euuL33nGb8+U3
	 cXYHySVQUGxg93a5YGRBHi4LTvf2gaFEsG9HibmAMxNF/FCO3HI1dCxzzn3tgs5cvb
	 brZekB2Eg+RUQ==
Date: Fri, 21 Nov 2025 01:48:34 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev, Ondrej Kozina <okozina@redhat.com>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-verity: remove useless mempool
Message-ID: <20251121014834.GB3078357@google.com>
References: <b8066f81-09eb-d3f5-59ab-1929c2bd7568@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8066f81-09eb-d3f5-59ab-1929c2bd7568@redhat.com>

On Mon, Nov 17, 2025 at 09:43:54PM +0100, Mikulas Patocka wrote:
> v->fec->extra_pool has zero reserved entries, so we can remove it and use
> the kernel cache directly.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-verity-fec.c |   12 +++---------
>  drivers/md/dm-verity-fec.h |    1 -
>  2 files changed, 3 insertions(+), 10 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
