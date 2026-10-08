Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A510435FF6C;
	Thu,  8 Oct 2026 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791495890; cv=none; b=fcbFMeqlt678+BHM11LrjCF/IwdoxczAMM2VT9A+d+FO4WDkTJcoVqGV9qqlfmV+QWT2Q08n8ULGHxkg2HLS7rkQaWB1mzwL9+lH7xt1UB1NQeFVB1jp19oho1LHBiSaRrj2G3xiDFDN6InP+zuaq+sLb0QMbBrA/zi0TqWlYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791495890; c=relaxed/simple;
	bh=V5hyUjce0dyiGY9B38zdGs+bp16nnUtkw0t3Xbr0hrI=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=Zc1jSI+JvlBTzMJWpZLHb9ndSk6Tiq36RIdz8A/6Hwm1Qx0Xl2f1kOeld0/MB03kPgUyGbOWfYE/lp8KdfZ++Ra38FvLFERxNASUifTwC2LD+Fuj1tXI88xg9bo39nj2lV5HDaAjWEm+IGShbLBWCXpSDtNmtFp9MB4HLAsV3O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWzmUdqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWzmUdqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1BC1F000FF;
	Thu,  8 Oct 2026 21:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791495889;
	bh=AQbyI5xskQ8NVKHXl0zWyTvdWxuuhblMJj4vmGkU8hE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=jWzmUdqjRh7znL9SYL0fjYFqVaiT7ifzU/aR2GHWmToi4lUxGzOk3WYRxhFPAONnE
	 9ZAnf08DAHjPniwJKjinTZiD6wVWOcac3VtD8JBj4/vncHe55h6bFFETLQCz+Qo5Fq
	 ZeD/XucbA3D2AV1jpDWHd3lXijHNwJgFUGkRbN5PJf+axnGLzvrparOgo5PJI2i5uu
	 nstUWvg20aN1BdU9xcUPwCX402bWFKS2as1U9XPvHUAiz7EdIW6gz5WHqb0+NET1bK
	 JkRMbPGHfdAytedhghy5zoio6YW1UGA6Kk1lFAHjasiGk+IkYLxkz9iYZ2v1uB7Gyw
	 WiyeVIwUFZwrA==
Content-Type: multipart/mixed; boundary="===============6446318386397627273=="
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <910460850fd4163dadb804fbdf6c17f6a9dfec060f4d865a17df87336ea3e165@mail.kernel.org>
In-Reply-To: <20261008-ajhalaney-dmverity-key-identifier-v2-1-008456d189cb@amutable.com>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-1-008456d189cb@amutable.com>
Subject: Re: [PATCH bpf-next v2 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
From: bot+bpf-ci@kernel.org
To: andrew@amutable.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,agk@redhat.com,snitzer@kernel.org,mpatocka@redhat.com,bmarzins@redhat.com,dhowells@redhat.com,jarkko@kernel.org,paul@paul-moore.com,jmorris@namei.org,serge@hallyn.com,ebiggers@kernel.org,tytso@mit.edu,corbet@lwn.net,skhan@linuxfoundation.org,rdunlap@infradead.org
Cc: dm-devel@lists.linux.dev,linux-kernel@vger.kernel.org,keyrings@vger.kernel.org,linux-security-module@vger.kernel.org,bpf@vger.kernel.org,fsverity@lists.linux.dev,linux-doc@vger.kernel.org,andrew@amutable.com,brauner@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu,  8 Oct 2026 21:44:46 +0000 (UTC)

--===============6446318386397627273==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> keys: add KEY_SPEC_DM_VERITY_KEYRING

TL;DR: Design/uapi question: was David Howells' v1 suggestion (reserved
negative key ID block, common register functions) intentionally dropped? The
new uapi value -10 should be settled before release.

> diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
> --- a/include/uapi/linux/keyctl.h
> +++ b/include/uapi/linux/keyctl.h
> @@ -25,6 +25,7 @@
>  #define KEY_SPEC_REQKEY_AUTH_KEY	-7	/* - key ID for assumed request_key auth key */
>  #define KEY_SPEC_REQUESTOR_KEYRING	-8	/* - key ID for request_key() dest keyring */
>  #define KEY_SPEC_BPF_KEYRING		-9	/* - key ID for the BPF-specific keyring */
> +#define KEY_SPEC_DM_VERITY_KEYRING	-10	/* - key ID for the .dm-verity keyring */

On v1, David Howells wrote:

  I have no particular objection to setting aside a block of negative key
  IDs for special keyrings that need to be accessed a lot - though I would
  make common reg/unreg functions that take the ID to be registered and,
  say, set the block at -257..-512.  Moving the BFP keyring to -257 and
  DM to -258.

  (<715249.1789718726@warthog.procyon.org.uk>)

The question of whether this was being asked for v2 was raised in reply, but
there was no answer, and this version still continues the one-off -9/-10
sequence with a dm-verity specific key_register_dm_verity_keyring() and
dm_verity_keyring_lock.

Was the suggestion to use a reserved ID block with common register and
unregister functions intentionally dropped, or should it still be addressed?

Since KEY_SPEC_DM_VERITY_KEYRING is a UAPI value, would it be possible to
settle this before the -10 value is released?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37844805282
--===============6446318386397627273==--
