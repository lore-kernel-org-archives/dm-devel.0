Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1DF63CB
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 05:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742966311; cv=none; b=CwuSl6b3Qf0xQ+vIR3d/wjfEgKhYki/f0T5ktnPxazk352VmDi0JX8+D+RQk1nLpOeJIBZIinxti+ZZF0fZH1fC8SDcnuvAFqqYufeKt0f8fkr8U6V4bbor3mvcxZa6LbuSzyAx9KjtJ/Act7lTY8nMvT4cH6Pl8RrDvrsTEsfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742966311; c=relaxed/simple;
	bh=aJPCKPi/va+hlSe2rogTv46iqlxZbEMrnVYs6qeN/nA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Id4J7qBPvFqylofvWRmQknkvxvCDSgW9f0lP/Ju13+mtSSQwejlHXIZ7gZF0mJzWINYdlNEhI6/QlRKcyyr2DrfTKXmpCJvJaCmb1JGYNVh9wWssH7nj6eJgzNBcEwU+S/JEsh62/c1a3hCiZbY3md05OmeatozHHThGgOWdqL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeN59fIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeN59fIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7FEC4CEE2;
	Wed, 26 Mar 2025 05:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742966310;
	bh=aJPCKPi/va+hlSe2rogTv46iqlxZbEMrnVYs6qeN/nA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XeN59fIYI1qRD9dnOWLF/Gm8Y/Rlq1vkxlhFyV90GN9w/Yts671wD1WpY8XGXihII
	 QgdbwtPr3zys0ua7gtqMu/AzUQFVz1NgO+kZZON2QVgLHnHRUZLC43L+lLeiKpZsFx
	 XKEVWYK6UYw2Eo4RsIqj8dWUPxBdoHiWL75ERlYH7aGlflsoNo2Hj+5pMH8Or3NvN8
	 67H0agtoQ6/AkBfSeqbI5tTUHNTzkERlsiHRN4hqx/XUE5yUQM8GdcIkfWBE0Z4IIG
	 JOh3FCGG+SEaH0MaPUxaV154+9743GePtKIoWTx3u7/auQ1KczJgBiVlGtkNwzIs5/
	 i6whEv/TsB7sw==
Date: Tue, 25 Mar 2025 22:18:29 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: mpatocka@redhat.com, agk@redhat.com, dm-devel@lists.linux.dev,
	guoweichao@oppo.com, snitzer@kernel.org
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
Message-ID: <20250326051829.GE1661@sol.localdomain>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326013049.1292617-1-weilongping@oppo.com>

On Wed, Mar 26, 2025 at 09:30:51AM +0800, LongPing Wei wrote:
>  try_verify_in_tasklet
>      If verity hashes are in cache, verify data blocks in kernel tasklet instead
> -    of workqueue. This option can reduce IO latency.
> +    of workqueue. This option can reduce IO latency. The size limits could be
> +    configured via /sys/module/dm_verity/parameters/use_bh_bytes. The four
> +    parameters correspond to limits for IOPRIO_CLASS_NONE,IOPRIO_CLASS_RT,
> +    IOPRIO_CLASS_BE and IOPRIO_CLASS_IDLE in turn.
> +    For example:
> +    <none>,<rt>,<be>,<idle>
> +    4096,4096,4096,4096

I'm concerned about adding yet another performance tuning UAPI, which will then
have to be maintained going forwards, even if the implementation changes.  See
e.g. how try_verify_in_tasklet has ended up not actually using tasklets anymore.
Is there any strong reason for userspace needing to configure use_bh_bytes
differently on different systems, vs. just having the kernel choose the best
value automatically without any new UAPI surface?

Keep in mind that the tunables could also be added separately later.

- Eric
