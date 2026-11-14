Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675860;
	b=aKdHbWQoc4hmoFElUnRYnklauLS2pXm1+6WHO3KwGDySGxXRmZz/SafUBOL9NzJl8vf/
	 AFdNGSgbOioZHjo98TUkYHmSN07+gYE45CND/S6+6afPh+lJU+0EIY32KaVQnRjiLo3iQ
	 lG/81mqIxIc5ieD+HIhpFgXx5nE013FEhK246gCI+p9Vw9jLum5XfKuKjlLWHZmSghAos
	 cS/LDe9mxmDhXlGc2r2zkF8/DImuITndVsRzc590QduXd9P8CpAp5Xayd+dOsHyYIassZ
	 LUJI/JlCDtstwlbSxj73Iq4pwr2uipsOqKuoPOsrqwSmy96HL38ds0jPpb3oIbgLk8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675860;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=P3R1fxnK2fHEw6kEa18V4jQ4Zete2japEw/6tUn8fvc=;
	b=MVmz9s6+bcJewF9H/erwWGw7+LZBlO8MQCqMK+ToQLyY5Wc8H0xlCsNsqUGd0bbDKcUZ
	 TYI8ls78yu0H96fxGFEt8Oef95K++hr4a+Y8HAXrcsY0yYEOhba7igUKEJg+EkPhYddAc
	 0NMdsOyXkGnbZY4MHSyUyGBN4eZfAJ59EGtrm+atjw5Ih4Ax3/YbyChWhhNkYsV4v3kqp
	 fhaDw+Ze0HfcMbIbFyvY6k6Xb+A1J7Y+ygPgX3KUuZcT1CU4z7Dy4ZCmew5lMj3GbY+MD
	 ecFjqmvLVUL9npn4uufHnXUxGAqcLwtZ9hP7GCVvJezla2pkzL3EEPhh8QAlVEsCFAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RrIO2nnn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FCB606A330;
	Sat, 14 Nov 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RrIO2nnn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB051F000C4;
	Sat, 14 Nov 2026 17:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794675859;
	bh=P3R1fxnK2fHEw6kEa18V4jQ4Zete2japEw/6tUn8fvc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=RrIO2nnnCtVuyU/3tU5BytDg8ykluxl0TSYiZA5BT1lRK8o2OWF3fBeB1rSbWbl3f
	 oGMj5qdXl4Zp2XJuE0GBqah0MoZlbi2OsX01yaNb7uKlHlcY5HcFjvntxwxzB5hex1
	 Cpn/WU29mb0mmZKZCwijaMvEVfH9YFJ+c4G21hFpOj+tC70+6R+KOgFnq2WfJXVarj
	 2c+9TWR3EVBBCVH6l3zW2dr9RVyrv1sYjE2ZjziajRktF8WWiiO96gC8DBEiJy6DJn
	 akiQhO2HK7LBWcznqKceUuWopzvuCqgvBCrWt7w4fLnrVTq1SqD8nXjvkhXR9vBCSb
	 l6G1S4bCu59cA==
Content-Type: multipart/mixed; boundary="===============3120634351969932012=="
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Message-Id: <a75e29128bdce3037d830cd6f269f27e01a680e943df2db427a12c99971bc8be@mail.kernel.org>
In-Reply-To: <20261114161211.376859-6-jarkko@kernel.org>
References: <20261114161211.376859-6-jarkko@kernel.org>
Subject: Re: [PATCH v11 5/6] KEYS: Replace assoc_array with rhashtable
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,dhowells@redhat.com
Cc: jarkko@kernel.org,bpf@vger.kernel.org,dm-devel@lists.linux.dev,fsverity@lists.linux.dev,keyrings@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-security-module@vger.kernel.org,agk@redhat.com,agordeev@linux.ibm.com,ast@kernel.org,alexs@kernel.org,anastasia.eskova@ibm.com,akpm@linux-foundation.org,andrii@kernel.org,bmarzins@redhat.com,borntraeger@linux.ibm.com,daniel@iogearbox.net,dzm91@hust.edu.cn,eddyz87@gmail.com,emil@etsalapatis.com,ebiggers@kernel.org,ignat@linux.win,hca@linux.ibm.com,ihor.solodrai@linux.dev,James.Bottomley@HansenPartnership.com,jmorris@namei.org,jolsa@kernel.org,corbet@lwn.net,memxor@gmail.com,torvalds@linux-foundation.org,martin.lau@linux.dev,snitzer@kernel.org,mpatocka@redhat.com,zohar@linux.ibm.com,paul@paul-moore.com,oberpar@linux.ibm.com,rdunlap@infradead.org,roberto.sassu@huawei.com,serge@hallyn.com,skhan@linuxfoundation.org,song@kernel.org,svens@linux.ibm.com,tytso@mit.edu,gor@linux.ibm.com,
 si.yanteng@linux.dev,yonghong.song@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 17:04:15 +0000 (UTC)

--===============3120634351969932012==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> KEYS: Replace assoc_array with rhashtable

TL;DR: Not a bug today, but the new keyring_read() comment says the semaphore
isn't needed; without it, a missed key could possibly leak uninitialized
kvmalloc() bytes to user space. Comment should say the read lock matters.

> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c

[ ... ]

>  /*
>   * Read a list of key IDs from the keyring's contents in binary form
>   *
> - * The keyring's semaphore is read-locked by the caller.  This prevents someone
> - * from modifying it under us - which could cause us to read key IDs multiple
> - * times.
> + * The walk is RCU-protected, so the keyring's semaphore is not required.  A
> + * keyring modified concurrently may list a key twice or miss one, but it can
> + * never have a link freed under the walk.
>   */
>  static long keyring_read(const struct key *keyring,
>  			 char *buffer, size_t buflen)

This isn't a bug today, but is the new comment accurate about the
semaphore not being required?

keyring_read() writes serials while walking the list, and then computes the
returned length separately from the link count:

    ret = keyring_iterate(keyring, keyring_read_iterator, &ctx);
    ...
    ret = keyring_nr_links(keyring) * sizeof(key_serial_t);

keyctl_read_key() kvmalloc()s key_data without zeroing it and copies back
exactly ret bytes when ret <= buflen:

    key_data = kvmalloc(key_data_len, GFP_KERNEL);
    ret = __keyctl_read_key(key, key_data, key_data_len);
    ...
    if (copy_to_user(buffer, key_data, ret))

Both callers of ->read, __keyctl_read_key() and read_sed_opal_key(), hold
down_read(&key->sem), and every writer of index->list and index->nr
(__key_link(), __key_unlink(), keyring_gc(), keyring_clear(),
keyring_revoke()) holds down_write() on the same semaphore, so the walk
always writes exactly nr serials.

Without the semaphore, a walk that misses a key, as the comment allows
(for example a link prepended with list_add_rcu() after the walk has passed
the head), would leave keyring_nr_links() larger than the number of serials
written.  Could the uninitialized tail of the kvmalloc() buffer then be
copied to user space?

The old comment described the requirement correctly.  Could the new comment
say that the caller's read lock on the semaphore is what keeps the returned
length consistent with the serials written?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43615900108
--===============3120634351969932012==--
