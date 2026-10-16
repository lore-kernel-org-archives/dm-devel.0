Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C688B41A923;
	Fri, 16 Oct 2026 08:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139251; cv=none; b=Jw43Bm5RWnrbgxgc5BU2/BfEJ/FH4YlEb4WcQ6n0eLkuyaIXXTWb32Ke8xSjCJ1P8lZXncD0t2lwQuG2HcocYRgB1DVxR+Rxd2L1scz6qOTeds9+Y0nI9yKC+NhWrmIKqjTi6TmV/1Q2T1w4qX3L4EQxB+BTjOCcgV14LDcJeBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139251; c=relaxed/simple;
	bh=+H+gcbO8/GdePEPNqNGwAbchsNQcK6/a1jIVjw7YQZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMon0gDfAPRJzG8O3WAr+5tHnoBtf5vJOaEKOnprv31vj0zNNpXm3eL8Uq+x92lthbJdi8hJnCE461ucDkD9GYrQpZaNz4qpf56YfvM1Irmyp/V3WNDSBxQt8Z9H+TmM2k9ozbLJS+bLsSlccU/85H6CJrds/I9GYAx4zBUYUzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lzs4bUl9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lzs4bUl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502F21F000C4;
	Fri, 16 Oct 2026 08:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792139249;
	bh=43WzBBDSBPDoqOTx2OTFsH6xhSXl8SSUb+vJUiJbtJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lzs4bUl9+WVWd8J3U435zH6GMfKNGMwrZcogSut62Tucr1JDLK9yzO0N9XgOJ9xj1
	 ueE97ndDBy3XFCpVxw6jT+SvlPDfhSSBt1KC3SAocfHqdRvdNnp5YsOzWk/d+V0BRN
	 ywOgjkYd3nw/tZdcF4GKJTw84Tvveaas8aKMipgv/DGkOQ5kpnHtGGKOHBShx9nYgT
	 iQMB5NABBDaYBIedyjVC2AxN2E4rvEUbswjYIuswGRvhQ0yJeStCP4VGCDpdULPRNl
	 rYrKJwmnC+gefsx9QSxulci43rgXc1r0RGZd0ljaNQ3tXUftExeDvNqosr62RdyXwc
	 Lj96KswkODT/Q==
Date: Fri, 16 Oct 2026 10:27:19 +0200
From: Christian Brauner <brauner@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, David Howells <dhowells@redhat.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Andrew Halaney <andrew@amutable.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
	bpf@vger.kernel.org, fsverity@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/3] keys: Add well known IDs for
 fs-verity/dm-verity keys
Message-ID: <20261016-ratlos-endkunde-eindimensional-1fe5eef08d13@brauner>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
 <20261012-broschen-inanspruchnahme-gebilde-d72cf2b99cda@brauner>
 <DM5UD20248FG.3BXPS76LK06F5@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DM5UD20248FG.3BXPS76LK06F5@gmail.com>

On Fri, Oct 16, 2026 at 12:38:11AM +0000, Alexei Starovoitov wrote:
> On Mon, Oct 12, 2026 at 12:38 PM Christian Brauner <brauner@kernel.org> wrote:
> > Applied to the vfs-7.4.keyring branch of the vfs/vfs.git tree.
> > Patches in the vfs-7.4.keyring branch should appear in linux-next soon.
> 
> What is this branch based on ?
> v2 was sent against bpf-next, because
> commit 264d8fd2794f ("bpf, keys: Add a bpf keyring for program signature validation")
> is only there.
> All hunks in keyctl.h, key.h and process_keys.c have its lines as
> context, so the patches don't apply to -rc as-is.
> And patch 3 documents KEY_SPEC_BPF_KEYRING.

It's based on the portion of bpf-next that has Daniel's keyring patches.
Which means I just wait until bpf-next is merged and then send it as a
follow-up pr.
