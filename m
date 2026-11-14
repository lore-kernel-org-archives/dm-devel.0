Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675102;
	b=yF5mMDpTSRReOugHlRawXAKBo2LhArUBlkQiyIr+YOuK8uPi2WZezi0/kLMeYhVSgz8g
	 bU0pSvtZIeX5Yg7VBrjiR3k8vELQwWMjPcAzDKyHkImphBIs7AXpEn6xA23gPcDOqFhUQ
	 20njt8/c1/pILeFTa1AHBm9lGt3aBcUrHuHB0awTg1m5UiOumV6ZXYZCqA6hwr4EBU2oo
	 68qDbwt0gktOJlf1baiKfcu0dMl64U4/93Pd9/d67P74uBRywpsWTBpNBEAuJ3JNu6+BE
	 jKrlZK2u7glosuwEBFUsDR0KdWA8I6cwrFhmK1uI0F7QIKDHvYvteXrOJ3vPzE4BbmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675102;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=lf5yOV6E0bLpUFnmFnTJTpA7kRKYCm0BXhQfaG0ikWw=;
	b=hshudTYvRNgAiVY7C0U5c6gwifZrr2nWkCAP/oozKJp3y7OCnXY5OBpeoRn/01r8UEpw
	 h8bG2GBgKRIGIcVxCl19WEPwGFI7TB7+igbvCjsOICYJvoaKjp49REBQcOcShIoV1KpCz
	 4xz4c48ebbSkfr20sRE8PgUYxWDh1R1/v6Q2OlUI3V9wkJt8r1ba2hgE+ably3dms7hxF
	 Tm33hzFFRl3hqKKUkdA0yxRGcWDfwZgYz3j1FHiq71OUpT8p++vtS/iNDRsygy+52clEy
	 dWWPcoD0ca1h9megvFLVjQHD/B9V7ZhEw47pbGMqvnNPvyQ8P+4yV59yg3fpTd4SpDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Waht3f+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7475F606A330;
	Sat, 14 Nov 2026 16:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Waht3f+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2091F000C4;
	Sat, 14 Nov 2026 16:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794675102;
	bh=lf5yOV6E0bLpUFnmFnTJTpA7kRKYCm0BXhQfaG0ikWw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Waht3f+9QErXyuWfPwOjhY5uGJLjoc01blT9MmSCGydUq19NoiOJ7BQLH+nutXIKd
	 2ytWlBWBCCBBE9rms5rWddDyUhralaT7C4KvnG8l+2bMdxHU7BLlBRP4eae948vLvl
	 GhKJA8x9t0MQW9W8+jCf5y7yd0YWL2TLIDfGV+qqlBwUMNYshu/91wPy+NB5t/sldS
	 v88+wQlg1w/lzAVK4lwUSKJ2zYGO6U7QZkkY356CuLN9Gq8YTDUMefjobzGFdtCRvR
	 JgcEAu1Lruw90w79a2KedGcd9tYcDt2M0dcEZqYPD4yJ9LOZYUUkqx0FtIPqDEMpxx
	 Wmy2+3a3HuWpw==
Content-Type: multipart/mixed; boundary="===============4363717070346101437=="
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Message-Id: <2981fac1594ba65bbe05828f369be80a0903ae4a524d961a0ab671797d7c2d0d@mail.kernel.org>
In-Reply-To: <20261114161211.376859-3-jarkko@kernel.org>
References: <20261114161211.376859-3-jarkko@kernel.org>
Subject: Re: [PATCH v11 2/6] s390/cert_store: Return an owned reference from find_cs_keyring()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,dhowells@redhat.com
Cc: jarkko@kernel.org,bpf@vger.kernel.org,dm-devel@lists.linux.dev,fsverity@lists.linux.dev,keyrings@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-security-module@vger.kernel.org,agk@redhat.com,agordeev@linux.ibm.com,ast@kernel.org,alexs@kernel.org,anastasia.eskova@ibm.com,akpm@linux-foundation.org,andrii@kernel.org,bmarzins@redhat.com,borntraeger@linux.ibm.com,daniel@iogearbox.net,dzm91@hust.edu.cn,eddyz87@gmail.com,emil@etsalapatis.com,ebiggers@kernel.org,ignat@linux.win,hca@linux.ibm.com,ihor.solodrai@linux.dev,James.Bottomley@HansenPartnership.com,jmorris@namei.org,jolsa@kernel.org,corbet@lwn.net,memxor@gmail.com,torvalds@linux-foundation.org,martin.lau@linux.dev,snitzer@kernel.org,mpatocka@redhat.com,zohar@linux.ibm.com,paul@paul-moore.com,oberpar@linux.ibm.com,rdunlap@infradead.org,roberto.sassu@huawei.com,serge@hallyn.com,skhan@linuxfoundation.org,song@kernel.org,svens@linux.ibm.com,tytso@mit.edu,gor@linux.ibm.com,
 si.yanteng@linux.dev,yonghong.song@linux.dev,stable@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 16:51:37 +0000 (UTC)

--===============4363717070346101437==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> s390/cert_store: Return an owned reference from find_cs_keyring()

TL;DR: Commit message only: it should say which reference was over-dropped and
that fill_cs_keyring() now also puts the keyring_alloc() reference on success;
the review finds no bug.

> s390/cert_store: Return an owned reference from find_cs_keyring()
>
> Return an owned reference from find_cs_keyring() so that it will not get
> dropped.
> Cc: David Howells <dhowells@redhat.com>
> Cc: stable@vger.kernel.org # v6.6+
> Fixes: 8cf57d7217c3 ("s390: add support for user-defined certificates")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

This isn't a bug, but could the changelog describe which reference was
being over-dropped?

Previously find_cs_keyring() dropped the reference from keyring_search()
or request_key() and returned a borrowed pointer, and cleanup_cs_keys()
then called key_put() on it.  On the fill_cs_keyring() error path the
keyring_alloc() reference had already been put, so that key_put() dropped
the link reference.  On the request_key() path it dropped a reference
that was never owned.

The patch also makes fill_cs_keyring() put the keyring_alloc() reference
on the success path, so the keyring is pinned only by its link in the
user session keyring after a refresh.

Could the message mention this, since it is what makes the
cleanup_cs_keys() and fill_cs_keyring() hunks balance?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43615900108
--===============4363717070346101437==--
