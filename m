Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794627149;
	b=ikjof5ip8ODU3L2hGolAqjpOhn3JQ9MlG+HiIOHvRjf71Ddmv45F1PbaQVHcgrpmhE+C
	 fb0zNnNTt3XJv6LyG9KephGOV7ZYtaKAQILrm7embcfrl9iPRpoX7/0TPiWbiWW4EJhQS
	 WLnRTWX1TNa/dSRd8jdKY5WJeK/hCBoP0e8bFxmsUJs+bWfjMGFXYSluLlBXiYAxNcoYI
	 Vq8d/RwUY5DzRcWt8vkJOledQyoNX88qSfJDi2ZXTtIIIuCRgakwDo8QmU9Z8nkFld5Yb
	 PyauHJhbP2pUcVowZllcBNnl0VP1GK5BdDQBCuqOZimXykVChK1mH0JVjsfDbWY3clQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794627149;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=hZ/+DLpUIlcbirEPmqeVlKHp9sAsvUE1CUbfS01vK7I=;
	b=2FSf8QcY6erjWA9bYYaDd2UmRYsglAP4eouYhd+bxmSVYRp99H9zW5GQLShV4yWoqbh2
	 w+BM+OmU4EJFchMR6451Vf4+QxPNgF5ODWGLbF1o/gUgI09ztdYJQTpwMqBjLKxviqnNU
	 0HGfHP+ivsR2dSWSztRmK/LvyD5oPnQHsYQCzrt6sVCqC4Fv1JWfyaYXYoBe8aCeNr/l3
	 5kiEQGOGHphOfy9cOP1N5I2XDLfxMQ0ZfHnaQgbU7NUAW9ZLZSBBRKy2uNCavGHpqdeAC
	 IVUKrAdSQG6sgtujkM/bJQEneNEzq7AUNvOYLkft/5Jc4mxb6S7cAQDI1KzyPJPJe2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fSpHT/5Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D07606A898;
	Sat, 14 Nov 2026 03:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSpHT/5Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EC11F000C4;
	Sat, 14 Nov 2026 03:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794627149;
	bh=hZ/+DLpUIlcbirEPmqeVlKHp9sAsvUE1CUbfS01vK7I=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=fSpHT/5YlKnVLQuflwMsI4ithJsCcCowAQeNfKXQn68pyvBjpKOneHjq/7tzigdU/
	 fBYUSuvX8vs6XD0Sn0kOKRcLcTwIu0Vg+RMZHWWD3GcLzqxkS3cfmNIIqSZYc26qY+
	 e+zaW8YGi4y83EuS58EkSpi3pyOfNOq8dmKJmiH2jWdqIZtcpzuEOpufh+oDPw55vW
	 NlHXaKHb0KHbJFsWf1drlXvwoCAnfiwAPpnZUcdaNCSrw/PXdN5K49A1P6Ts/eABr4
	 bzbs8Ld8g0AH+bTkbgSH6KnYPbPzcnPA9mJWzrtCxdw0ooLNs+ziSbnxkD9zD2M0t9
	 jQAMzdYVhW1tg==
Content-Type: multipart/mixed; boundary="===============0128583470197541293=="
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Message-Id: <2bd464dd12d81f4d712f7d89f65e0e572c66c9e84acce225d144eef3badc0251@mail.kernel.org>
In-Reply-To: <20261113161836.3587552-3-jarkko@kernel.org>
References: <20261113161836.3587552-3-jarkko@kernel.org>
Subject: Re: [PATCH v10 2/3] KEYS: Replace assoc_array with rhashtable
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,dhowells@redhat.com
Cc: jarkko@kernel.org,bpf@vger.kernel.org,dm-devel@lists.linux.dev,fsverity@lists.linux.dev,keyrings@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-security-module@vger.kernel.org,agk@redhat.com,ast@kernel.org,alexs@kernel.org,akpm@linux-foundation.org,andrii@kernel.org,bmarzins@redhat.com,daniel@iogearbox.net,dzm91@hust.edu.cn,eddyz87@gmail.com,emil@etsalapatis.com,ebiggers@kernel.org,ignat@linux.win,ihor.solodrai@linux.dev,jmorris@namei.org,jolsa@kernel.org,corbet@lwn.net,memxor@gmail.com,torvalds@linux-foundation.org,martin.lau@linux.dev,snitzer@kernel.org,mpatocka@redhat.com,paul@paul-moore.com,rdunlap@infradead.org,serge@hallyn.com,skhan@linuxfoundation.org,song@kernel.org,tytso@mit.edu,si.yanteng@linux.dev,yonghong.song@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 03:32:25 +0000 (UTC)

--===============0128583470197541293==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> KEYS: Replace assoc_array with rhashtable

TL;DR: keyring_read() now needs keyring->sem, but s390 cert_store calls it
unlocked; this may trigger a lockdep splat and possibly a use-after-free if a
link or index is freed during the walk.

> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c

[ ... ]

>  static long keyring_read(const struct key *keyring,
>  			 char *buffer, size_t buflen)
>  {
> -	struct keyring_read_iterator_context ctx;
> +	struct keyring_index *links = keyring_index_locked(keyring);
> +	key_serial_t *serials = (key_serial_t *)buffer;
> +	struct keyring_link *link;
> +	size_t count = 0;
>  	long ret;
>  
>  	kenter("{%d},,%zu", key_serial(keyring), buflen);

[ ... ]

> +	if (buffer && buflen && links) {
> +		list_for_each_entry(link, &links->list, list) {
> +			if (count == buflen / sizeof(*serials))
> +				break;
> +
> +			serials[count++] = keyring_link_key(link)->serial;
> +			cond_resched();
> +		}
>  	}

keyring_index_locked() is rcu_dereference_protected() on
lockdep_is_held(&keyring->sem), and the list is then walked with plain
list_for_each_entry() and a cond_resched() per entry.  That is fine when
the caller holds keyring->sem, as __keyctl_read_key() does.

Is that also true for all callers of the read method?  The s390 certificate
store calls it with no lock held:

arch/s390/kernel/cert_store.c:invalidate_keyring_keys() {
    keyring_payload_len = key_type_keyring.read(keyring, NULL, 0);
    ...
    rc = key_type_keyring.read(keyring, (char *)key_array,
                               keyring_payload_len);
}

The path is refresh_store() -> fill_cs_keyring() -> create_cs_keyring() ->
cleanup_cs_keys() -> find_cs_keyring() -> invalidate_keyring_keys(), and it
holds only cs_refresh_lock.

Before this patch the (keyring, NULL, 0) size query only read
nr_leaves_on_tree, and the real read used assoc_array_iterate(), which has
no lockdep check and never scheduled.  Now keyring_index_locked() runs at
function entry, so with CONFIG_PROVE_RCU=y a second cert_store refresh
looks like it would report a suspicious rcu_dereference_protected() usage.

The walk also runs with neither keyring->sem nor rcu_read_lock(), and
cond_resched() lets a grace period complete while the walker is sitting on
a link.  Can a concurrent key_unlink() or keyring_gc() (list_del_rcu() plus
call_rcu(keyring_link_free_rcu)), or keyring_clear() or keyring_revoke()
(keyring_index_free() -> queue_rcu_work()), free the link or the whole
index under the walker?

Should invalidate_keyring_keys() take down_read(&keyring->sem) around its
two read calls as part of this conversion?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43549115625
--===============0128583470197541293==--
