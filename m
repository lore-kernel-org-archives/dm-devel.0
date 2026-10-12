Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496D12FE042;
	Mon, 12 Oct 2026 10:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801539; cv=none; b=Dg8bMhEqIMunnHY9+cC6S+PNlV+h2bSq16qfhpKKFEzm5Z0UBs7a+N0CdO9XALDaf1Sc/DCef7bRTagJ8KFted7z7yj8p/4MJ0BlejslRQxX7JS+KhHJ6wKBn0av3Yy8vKbxwrZ8/Ss9ZY3nSzCxMOwnSHJmRe+5edr5D++eXi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801539; c=relaxed/simple;
	bh=EQd+3dczeUe3H+Ot+Ypu0mX1arO0FEiWvLmZLukZDdQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=O7m6w+cvkxBlx5RuJbSxZuHDVETGT3yujQ7Ld6nbGAmyBZQOmENrWHZO/601btseoK3cstwY1fiTRS3+nwV6wDElKSB/1sDJAk9G7IE4FiD4oTLgho0GHedMZfGP7ml7JBemiZVEDoQnlm0VVGawpMddaKfOcEEFD9/O5m8W9gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HfrXc6gR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HfrXc6gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A314A1F0089B;
	Mon, 12 Oct 2026 10:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801538;
	bh=w4CH1veM7IQFs/FktA7SpJrlFII10QujZ+yrLExaIqI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=HfrXc6gRUF+pkWejsUoWAgc/NWJk5AZvEQJ3R5fb/piRDvekD7j4fXnaEBKrUFWiu
	 yo2nKHd3T0KJm2jOpUXdv/mEFxQKq7QZHYDDPRj4khSGJH+0hVtdWPut1fw1TAFVgz
	 wVIKZqXZzVPxnCWEETgvxSo/EP4BCrKUrOFJTic0ULf8/23H+Uv9f/UEDADD+X9oID
	 b/4lvtH8jYhY6OHPcwf8VPsjitNOU/o2S0JUTNJBs2shuS23Q9Z22REZE26gmo5FEg
	 tOGXrhH1g00dRg2oPXsxNL9+3YSlMhrqQM2y5PtAR4TjTHkn11tf70BaORRQEzBzTn
	 w8W5+ezo31/ow==
From: Christian Brauner <brauner@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Andrew Halaney <andrew@amutable.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 bpf@vger.kernel.org, fsverity@lists.linux.dev, linux-doc@vger.kernel.org
In-Reply-To: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
Subject: Re: [PATCH bpf-next v2 0/3] keys: Add well known IDs for
 fs-verity/dm-verity keys
Message-Id: <20261012-broschen-inanspruchnahme-gebilde-d72cf2b99cda@brauner>
Date: Mon, 12 Oct 2026 12:38:50 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8

On Thu, 08 Oct 2026 15:57:34 -0500, Andrew Halaney wrote:
> This more or less follows the bpf keyring approach, allowing userspace
> to easily find the keys instead of having to parse /proc/keys.

Applied to the vfs-7.4.keyring branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.keyring branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.keyring

[1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
      https://git.kernel.org/vfs/vfs/c/d3b8a0988385
[2/3] keys: add KEY_SPEC_FS_VERITY_KEYRING
      https://git.kernel.org/vfs/vfs/c/8439e5c46c33
[3/3] Documentation: keys: document IDs added since KEY_SPEC_REQKEY_AUTH_KEY
      https://git.kernel.org/vfs/vfs/c/b553f7d131ed

