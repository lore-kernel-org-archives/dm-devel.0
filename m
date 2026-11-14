Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794688695;
	b=glOQbvdIhuhTQQXnQEAYobfEe8CDYHNUX1WcB9xWtRcXHG6uvLrvmyLFRFuH+wM9ka3/
	 bFIPZD9FJhsLLFiC7JcYFy1pztcHThmosSPtghzW9ytRzSiaW0tE4s9XgN7bGqpsgFUiY
	 7mgQZ+02UMVdiu37GbI/DxCvPnLNxhah5rVECkCRo79QLUbZRq07dAveMCn9voc49ODoF
	 cByrkL989SuBquyYjuAzwF7YIgSzhQJ4cn7QRMKv2gDk/PK43lon6G82jnTjORwzrmc2N
	 +hp+KWUp7T6rEVBEecDfnIFdgReJhmASHVPweDNe3Lo6WZjycSwH4Jn7j0EfziFZNEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794688695;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VCGyHVFKkAZjSSjza2g0FyrSSaFZoL8CQjsvctCPwdU=;
	b=SYOZFO3vNHo7uEAbKhS5YDb7FCvoon2c56Et+NwQD10XFV7JtW+QOBQAqv1XVJhAbo3O
	 vimXvCIT8R8bApUf54DoycYYqwT3acKIfRZwSygszbVbLgpolhKGWmuHUvBwcJ6YrmUIz
	 iaXo6GNwAFSN54clWq9KrTyduX0F5vE/GFYrshGKjdWM7sVvlYe2O6SaurlPAkRXnEqFb
	 uq3gGs39ZKG4EwQxFYE+dZtiocRleb0h5yu1L7poPlSqaRfB65m2fVZKEhBHAbXEk/YUF
	 uAkhqCt823xZRmnbV+X3CtSwhovZAuZnIvId2J2+atzBGBNTSkQe0yxiuqyJuScKm0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mo50OBvQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 04204606A323;
	Sat, 14 Nov 2026 20:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mo50OBvQ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D2D821F000C5;
	Sat, 14 Nov 2026 20:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794688694;
	bh=VCGyHVFKkAZjSSjza2g0FyrSSaFZoL8CQjsvctCPwdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mo50OBvQRqhFlR02xy+G+EOJimTN8jRGcoFd35TrMXjwhG2YWmx7/04mr9cysS4c9
	 dd1oahQ4khkbcy91Z5MDWDTIHic/aHrMVJzY16vZOHoGwLin0WnJ22o4E9zUhDp+iY
	 V4Lu+61LQuq98/FwJI+fhkDlB9z4DeYktS//vEq3oQ3RLm069RKChfUjXhl6F7AigE
	 kOTUCLfPbx10pR2Ye2TLkdBCYMp6Z4NiPnVc0LuPQKot6BWT6NlVbMjmbGQri/gaUE
	 ds5cAQudUsMWsnFk7eODuleFrw9fdh2CEMCX8nxbLl1f/t+kf2Zbm7lWQyLZcuvIlB
	 u+O6rxj9sHSeg==
Date: Sat, 14 Nov 2026 22:38:10 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: bot+bpf-ci@kernel.org
Cc: dhowells@redhat.com, bpf@vger.kernel.org, dm-devel@lists.linux.dev,
	fsverity@lists.linux.dev, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, agk@redhat.com,
	agordeev@linux.ibm.com, ast@kernel.org, alexs@kernel.org,
	anastasia.eskova@ibm.com, akpm@linux-foundation.org,
	andrii@kernel.org, bmarzins@redhat.com, borntraeger@linux.ibm.com,
	daniel@iogearbox.net, dzm91@hust.edu.cn, eddyz87@gmail.com,
	emil@etsalapatis.com, ebiggers@kernel.org, ignat@linux.win,
	hca@linux.ibm.com, ihor.solodrai@linux.dev,
	James.Bottomley@hansenpartnership.com, jmorris@namei.org,
	jolsa@kernel.org, corbet@lwn.net, memxor@gmail.com,
	torvalds@linux-foundation.org, martin.lau@linux.dev,
	snitzer@kernel.org, mpatocka@redhat.com, zohar@linux.ibm.com,
	paul@paul-moore.com, oberpar@linux.ibm.com, rdunlap@infradead.org,
	roberto.sassu@huawei.com, serge@hallyn.com,
	skhan@linuxfoundation.org, song@kernel.org, svens@linux.ibm.com,
	tytso@mit.edu, gor@linux.ibm.com, si.yanteng@linux.dev,
	yonghong.song@linux.dev, martin.lau@kernel.org, mason@kernel.org
Subject: Re: [PATCH v13 6/7] KEYS: Replace assoc_array with rhashtable
Message-ID: <avjGskpYTWp_JGHd@kernel.org>
References: <20261114193631.731615-7-jarkko@kernel.org>
 <717a43d830b7a6544a51f3c227592eaadcd0afcf61ec9bf922ad517a280b8bfe@mail.kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <717a43d830b7a6544a51f3c227592eaadcd0afcf61ec9bf922ad517a280b8bfe@mail.kernel.org>

On Sat, Nov 14, 2026 at 08:24:27PM +0000, bot+bpf-ci@kernel.org wrote:
> > + * The walk is RCU-protected, so the keyring's semaphore is not required.  A
> > + * keyring modified concurrently may list a key twice or miss one, but it can
> > + * never have a link freed under the walk.
> 
> Could the comment instead say that the caller holds the keyring's semaphore,
> which keeps the list and the link count stable across the walk and the
> length calculation, with RCU only keeping the walk itself memory-safe?

If I did not miss anything, this is the only remark.

Hmm...

I think this is enough prose to capture the preconditions:

	/*
	 * The list and link count are stable across the walk as the caller
	 * holds keyring->sem.
	 */

Br, Jarkko
