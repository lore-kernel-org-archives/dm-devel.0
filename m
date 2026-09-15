Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033634B1467;
	Tue, 15 Sep 2026 12:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475980; cv=none; b=KXWqPNjyn6UGUDP/Ywin8T/fDZ7whbdIsedeO7BYQSPqhQsoIaGnwFPxVYQBXJsnorp+bzVAd65FnI3tdyDTGBHsIak/4YsOArcWeg7Zkb5l8JowG5wXAFWXrPJyMLBEnqvVgkwUMIB7csoidT63Jahudydcr339v12xdTAk2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475980; c=relaxed/simple;
	bh=7ramMcXV5gDjdkj7xeW5JZkLkgely5R+wAaq1aPyU54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hyzg4XmFpxJEq5Eudo5qVIa1FAampLcIc96KHan6BcXRGgX4NUh1AA7SxvHBlAHsuZYpfnhYrpnllJW9MAv6YIq8u4XmYwK9T7AjViBNPjVqTAf9h6Fjt87i0YgmcS9HD/F947ZSpnl1MWNaeaSoGazVZGBoYIuv/p9lNyvXxsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+lsjJCd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+lsjJCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29941F0089F;
	Tue, 15 Sep 2026 12:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789475978;
	bh=6bcWUaLRLetE24Lg9U+faOn8Kxcdt3OXRdtwLbu0uYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W+lsjJCdXnZizp9ZRFqmdZt8bC1InSnKanDlBqVfy7Y20dV2jcBqylcJiBs1EQuZV
	 C7A9LRtZVPDT/o/gLpjHUxSGrmG360qXGRUIYYX3tDOTSvtlS0rOKQZBL4nr9eWPLo
	 yFm0SD9eyXthtf7v38vd3JNfz+LNamHJri/64DyOp5ewi3OPJTE2QM04AA740pC593
	 QCDtwwTVe/FnShSYrrNM7Sk2G6UYdHfHrdIBvZhTYEysDFKSuCtT9kp4bQLF/sMqy1
	 2ImxHDcBTehQclsmCCKUoWF45ubkvvZrbgOi6qjAAYAym5Vq32Q0mKae0fMBEZg9Ur
	 pNYN1M9OelIRA==
Date: Tue, 15 Sep 2026 14:39:31 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andrew Halaney <andrew@amutable.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
	bpf@vger.kernel.org, fsverity@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/3] keys: Add well known IDs for fs-verity/dm-verity keys
Message-ID: <20260915-endverbraucher-gerahmt-amten-cfe971232d4c@brauner>
References: <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>

On Mon, Sep 14, 2026 at 11:41:41AM -0500, Andrew Halaney wrote:
> This more or less follows the bpf keyring approach, allowing userspace
> to easily find the keys instead of having to parse /proc/keys.
> 
> Signed-off-by: Andrew Halaney <andrew@amutable.com>
> ---

Thanks for doing this! Looks good to me,
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
