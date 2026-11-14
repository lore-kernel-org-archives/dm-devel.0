Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675108;
	b=GQW3Qq1t645i2d0PF+PM48L38lism66C/8VOU8J8lJ/i6JrhuCUWxRLb3NMoM3/3CX8j
	 q/nAnTKEPWJ2TI65Rx46iqCbe1NXkPPQSQ8dtcL6OdWTQ5vHqxUly47Z3Ft/hKHl9hIuN
	 OFjcMA1xuxGlPTe2ZrXjS+yn1hM4nVZpP/mjK4SdWH2BvyBsBPiNy+72HE0ov54HwbFUv
	 BSDeVGApt8m7GntWMyysLWZZ9KxmAqgTkuy+vqcw0GGDYIL+KfXIf7ZqMW1ekVzDi8dSg
	 3ym6aGG+fH7FqSIXkEKRVi7gRbvNXVqkN4qCzXDBEEVPA+mw0Kn1iM3S+wXDnDBMNdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675108;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=LXQuHtzRZ4Jdx8f4vSdPwcHY0jVqbzYOQJ255Mn11LY=;
	b=qrhb32mupyZ+OE7z6gurR1pTxtOdq8nRu+36Mo8IKvU5rzexggv23ZKzDcyXzaergIyS
	 c5P5FwCNjVwRBb4Uyj6pvjKjAhaVoabezBpKHTJwL7ws/zcPRFuakCNO69h6N08ae7Eif
	 IXaTA4w7ZsVvvmOmnd+JhsrfY3hv6k6bdcPOD0DZtuwpugpTb3IwgQUObXWkZhelLi0Th
	 D0d9PQOV5wGV2uFqxR96tOW6uZDJ6QDX4H9YG85eBQqLJ30TQewQfpjjf1ee6ZCenQiC1
	 v8uanqMcp6bOK8NXrpldNYBRHpdV6yslIPyKidg41L6W8ywwNCgKNcF13QYBT4mvTZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l9kHxO0K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D844F606A889;
	Sat, 14 Nov 2026 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l9kHxO0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005511F000C6;
	Sat, 14 Nov 2026 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794675108;
	bh=LXQuHtzRZ4Jdx8f4vSdPwcHY0jVqbzYOQJ255Mn11LY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=l9kHxO0KQXwnDz0rsqo34SJK0Pu9fp7Iy/4eAJQ5hzVXkZtfvH2tJm6eRobqW57xX
	 sSNGlLftlsMpsd+FSsMtTrRbh8aI2bIKTlDzncuTjoy4HL1zf6a/tN/6796NWDAeIf
	 Q8ZKFOKVbZEmS8vUGtQwSHdtR1JSSJ5FtYCU8dzvFMqCwfdvI/gkzhhrPlYwpuCAlx
	 qKXPxWJooWuy/tnPnMDUsRAcUoyC3BaWGJfDZ9sJWtsh/4izREc/0gxOYE0eqvhypq
	 1bzu4lUoeNAYJgN6cTTp4a1r31G3kk4E89FNPY4tAlXOTRTuY3BvLycbNcmKeR/1JH
	 3DiPAbhKpX/WA==
Content-Type: multipart/mixed; boundary="===============5830880315187501306=="
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Message-Id: <caabf5117f03756c1c1b478d2a802c2a188996dde73545bbc552b6093484d557@mail.kernel.org>
In-Reply-To: <20261114161211.376859-2-jarkko@kernel.org>
References: <20261114161211.376859-2-jarkko@kernel.org>
Subject: Re: [PATCH v11 1/6] s390/cert_store: Pin the user session keyring
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,dhowells@redhat.com
Cc: jarkko@kernel.org,bpf@vger.kernel.org,dm-devel@lists.linux.dev,fsverity@lists.linux.dev,keyrings@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-security-module@vger.kernel.org,agk@redhat.com,agordeev@linux.ibm.com,ast@kernel.org,alexs@kernel.org,anastasia.eskova@ibm.com,akpm@linux-foundation.org,andrii@kernel.org,bmarzins@redhat.com,borntraeger@linux.ibm.com,daniel@iogearbox.net,dzm91@hust.edu.cn,eddyz87@gmail.com,emil@etsalapatis.com,ebiggers@kernel.org,ignat@linux.win,hca@linux.ibm.com,ihor.solodrai@linux.dev,James.Bottomley@HansenPartnership.com,jmorris@namei.org,jolsa@kernel.org,corbet@lwn.net,memxor@gmail.com,torvalds@linux-foundation.org,martin.lau@linux.dev,snitzer@kernel.org,mpatocka@redhat.com,zohar@linux.ibm.com,paul@paul-moore.com,oberpar@linux.ibm.com,rdunlap@infradead.org,roberto.sassu@huawei.com,serge@hallyn.com,skhan@linuxfoundation.org,song@kernel.org,svens@linux.ibm.com,tytso@mit.edu,gor@linux.ibm.com,
 si.yanteng@linux.dev,yonghong.song@linux.dev,stable@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 16:51:43 +0000 (UTC)

--===============5830880315187501306==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> s390/cert_store: Pin the user session keyring

TL;DR: Commit message only: the stable tag should be v6.6+, not v6.1+, and the
changelog's keyring-lifetime reason looks inaccurate. It also omits the new
ERR_PTR handling. The code change looks worthwhile.

>     s390/cert_store: Pin the user session keyring
>
>     The user session keyring stays alive only because the session keyring is
>     pinned by current_cred().
>
>     Pin the reference at:
>
>     1. find_cs_keyring()
>     2. cleanup_cs_keys()
>     3. create_cs_keyring()
>
>     Cc: David Howells <dhowells@redhat.com>
>     Cc: stable@vger.kernel.org # v6.1+
>     Fixes: 8cf57d7217c3 ("s390: add support for user-defined certificates")
>     Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

The stable tag says "# v6.1+", but the commit named in Fixes: is not in
v6.1.  8cf57d7217c3 is contained in v6.6 and not in v6.5, and
arch/s390/kernel/cert_store.c does not exist in v6.1 through v6.5, so there
is nothing to backport there.

The other patches in this series that fix the same commit use "# v6.6+".
Should this be:

  Cc: stable@vger.kernel.org # v6.6+

The changelog says the user session keyring stays alive only because the
session keyring is pinned by current_cred().  Is that accurate?

look_up_user_keyrings() links the user session keyring into the per-user_ns
register:

    ret = key_link(reg_keyring, session_keyring);

and get_user_register() notes that "the keyring is pinned by the user_ns".
That link is what normally keeps it alive.

cred->session_keyring is usually a different keyring, either a "_ses"
keyring from join_session_keyring() or pam_keyinit, or NULL.  It is the user
session keyring only when install_session_keyring(user_session) happened to
run for that process.

The change itself looks worthwhile, since the owner has KEY_USR_ALL on that
keyring and can revoke or invalidate it, after which keyring_gc() can drop
the register link while cert_store still uses the pointer.  Could the
changelog give that reason instead?

The changelog also does not mention that the three callers now handle an
ERR_PTR return from get_user_session_keyring().  Before this patch that
ERR_PTR was passed straight into keyring_search(), key_unlink() and
keyring_alloc(), which dereference keyring->type.  Could that be described
as well?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43615900108
--===============5830880315187501306==--
