Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA603876A1;
	Wed, 29 Jul 2026 19:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785352519; cv=none; b=YAdhGROW69JuojkVnMoexDe6yITjndBiiQovwu2583U2Q/McmjEvh4/9jd5TNjdbzhKjZnJdKkfD68m7fVOu6bqzCu1bgdIJuoxkJXG7Mw3H+vu2YkfFCss74mF7bXwhX/hEM1mdHnX+yqA7QPloTAkEj7qsB0WR2x1f0yGCQUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785352519; c=relaxed/simple;
	bh=ACVxb6dKkcrnNtisqYGm4UpUzPvdKbtvYtkIUyr69VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALbndq+2T097NgfS2fKKl/rwDLUOpevqrg7gBEKUpf7n74vatLo6sZFtsrs4AXFYogL626ty4MSZatluBvteI5cZkU9rYeNC8cKW4hsXPrvK4Xiz7fhXpUG6/73LH3iOWGlXoAb7aeMNlAF1pCxogLu2Q3zo5RL/SU4N4jB6aBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKfRLPuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKfRLPuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7438D1F000E9;
	Wed, 29 Jul 2026 19:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785352517;
	bh=ACVxb6dKkcrnNtisqYGm4UpUzPvdKbtvYtkIUyr69VE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BKfRLPucJOJ2w89ZiYJ6ouvZWgJPH7Unitufzwk6H0yhK18yLOR1LnTsQsWQkEvys
	 h6Y7H4pIwpb7l5KHOZU193Fk3Z62tw5GsSUnXq9lBLSTbARzjDQugFcJkjb4HVWsJO
	 MG3J4IDGRYlcg7LFfx2KUZtSz81K8nh3NZrqSz5pLu+1m2m/Oc0K22pOUmuRR9soaY
	 9BoZKjHJKXUodca21h9wPW5Q/cmMF24IeFsUiBZ6wSIBHkiA1sg3mkAM3OXtGnpQfC
	 S2zA96KfO0ZX1fkFPBbWcps+YX8qXnJX0hkP2KqeTlsaHMSiK/PYerrvOXgPLk3+jA
	 6tqf+WJq6v+Fw==
Date: Wed, 29 Jul 2026 13:15:15 -0600
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
Message-ID: <ampRQyXDbGgeg49V@kbusch-mbp>
References: <20260720201057.1862857-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720201057.1862857-1-kbusch@meta.com>

On Mon, Jul 20, 2026 at 01:10:52PM -0700, Keith Busch wrote:
> This addresses the misaligned direct-io problem behind various threads:

Hi Jens, have you had a chance to look at this one yet? This addresses
previous issues with certain device mappers under direct io.
