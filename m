Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697683;
	b=Yfg0hLaPFyP+ObF+pqdWDpGJMXL/kXxQLwvdjE7CTsK5nlk2AwabH+AbJlRnda0mza9D
	 Y6g1wo+woYxlAH4rijzLz83u4P7nA9xTnC/7usV8Ng2PDU3DR9YEEN6B8H3t7TPn/ASIf
	 nq+mtweVomqe3/uqXkkasgDECeTBPA9f9nNJokzWdqSiSsYAutASHaI5UD2SKiEL2a7SA
	 R1+MY6BMTIGP56xDRcLBJzcNWKmth8uPKV5AslNQ1deJLzPzlR2DYeIQizEBbOGULZI2S
	 Q4X/Joh9gW50PdxhCVtVYu9CPgmch9J1U8rk12y2La1y2yXncb6f6/ZYIh9PA3p98HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697683;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WRjg9wnrGZ7nUPdbceOheZj9U6OT129Wwye9oH/fuQ0=;
	b=gJwjhSzcwdPVuCGN4M/pXsSpKNCEE/xnIii0cCvguJFw3qSoHaMYh5YMF4WqQc2S9Ol1
	 XdH4R6aSpWPzma7lWMzOzDH/xGNuPx7RDaEwlLEP3yJI6GQ0w5FpDplrkdpoCr65uq7qV
	 WO3ILXsVMMhoaH3QsnQLTI/oFT0aYJD5aW5TBkZ2N0y56fVoK52inf28Ad2NgdbaavYim
	 MEx30LdUfPivhza/7Lh6KVGEHlHWeWh88mUR8+bmSQPnfexbKXUkpojP9XftV1x1EvvAI
	 xmf9+zz0pmYNucCNbXnhEfbCCUebwxWL+7VGYNw1+LNXLA7LvTUEVN9K+MhofOT3t4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hURM2oJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F94606A324;
	Tue,  3 Nov 2026 09:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hURM2oJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF761F00919;
	Tue,  3 Nov 2026 09:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793697683;
	bh=WRjg9wnrGZ7nUPdbceOheZj9U6OT129Wwye9oH/fuQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hURM2oJBC2OYLD2mT6ekT3v0VDVTkk2baBzSacBZn4V6h52JiQtM2UefBI9v2xgEy
	 Iy/8nCudEs2Da3L/03mL6YjYKKNz2I1NN7amoiyVX6LEnmHyOoraPHYKCtuWdyC53b
	 9ZuCZaL1ctb49F6o0CoMISbeYRYY9PElOGzMEgxi32vJfB9T5tFGdQ7EnYdoQzB+f8
	 STiRqwuR9gRSzxkWWy9/kBgQygOz/cji0FsOmpkviZbIgSwnydy1PGw9FyCFOvMLPx
	 aUxcyRQ1VhAsktmZSIhEdyA/qMAM9UcOOYT0wnIpv0/3mn5yg2f8xEsPaqPy12hfBW
	 1cp3hO9oac6Rw==
Date: Tue, 3 Nov 2026 10:21:19 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: agk@redhat.com, mpatocka@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, snitzer@kernel.org, bmarzins@redhat.com
Subject: Re: [PATCH] dm: release the sysfs kobject when its initialization
 fails
Message-ID: <20261103-amphibian-pig-of-fragrance-4afaba@quoll>
References: <20261103082329.1159472-1-vulab@iscas.ac.cn>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103082329.1159472-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 08:23:29 +0000, Wentao Liang wrote:
> dm_sysfs_init() uses kobject_init_and_add(), which requires a matching
> put even when adding the object fails. dm_setup_md_queue() currently
> unwinds the disk and holder links without releasing this object. Since
> md->type is still DM_TYPE_NONE, cleanup_mapped_device() also skips the
> sysfs cleanup, leaving the initialized kobject behind.
> 
> Call dm_sysfs_exit() before unwinding a failed sysfs initialization. This
> both puts the kobject and waits for its release callback, including when
> CONFIG_DEBUG_KOBJECT_RELEASE delays that callback, before the mapped
> device can be freed or its queue setup retried.
> 
> Fixes: 784aae735d9b ("dm: add name and uuid to sysfs")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/md/dm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 



Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




