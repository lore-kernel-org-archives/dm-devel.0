Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794687872;
	b=DaBsTS9NoolLlaq/Czkf8DGbFP3nk095ZADBUInrCPKMHZ82RdTXP1U9t8dZVCRzI37Y
	 iF6EYIJKK0TQNaCd19GzVio3A+90jXZKk2k5U8bvpGJdtzcTk3Ezd7uLH0ARqpVrPRrw4
	 musBWWFr0H13zKSueLY88WSOMUNe6Brk3Ahkazt8o5HphHDXpboVSI+SaZQuSubzA+olW
	 JrfrlmSGx8fUutXuN3BKs9krVnuz0S3ibutNgKzd4NiGFpCocnWfilxzqH8YSZ65t3WZQ
	 6h8rVgf/DX9xXg5svM9GpUMDPCervSF+mbEZfIsdq/nXUUQ+lMJ3WxdVTOrOqeu+ktA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794687872;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=V9Oz70E155O9jInt6hTC5pYZasQgcnWNCVJSKndXa7k=;
	b=XM+gSjmVvc1o6nNXIcrZ0D195COcDYLAZiWYV8XuZntC73DL+Mmu/4W5h8TfQYrxzJBL
	 Ank682qqcLTPsA8Xq9PMcZ83ReHD2za2D0AdpuDm+L+CGcAh0lQGglXgYve9YwIjYSAge
	 nWoTq1yPAStIveO+fmvrGDg5ifjd2TTPXwJSnEB+2qygm9zzWKqkyJXCsOdiSnB2PTpjs
	 nK+rPmqx70zK4GcaEShgO7MrjKu2Y9jRJGbhELz+N+UByNP51iVkST0XpSFijC4/XNu/t
	 npVcAUsGoK92jigSrnS8BRR69YftJJ9Q4kVkPxkUvf25T4IDDtWTuQRqPmfzdC/uM2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jjyAKqBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2325E606A329;
	Sat, 14 Nov 2026 20:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jjyAKqBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360D21F000C4;
	Sat, 14 Nov 2026 20:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794687871;
	bh=V9Oz70E155O9jInt6hTC5pYZasQgcnWNCVJSKndXa7k=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=jjyAKqBDcfwj3adWi8yNdPH+HlRifwnvumzIU4W0VCkulv16TycwN4NG2NMOzVuBa
	 F8kZfYeoNSO1X73ZEEtPzIvcCcVg0fXWpqxl/ECrCSxl3abjRb4E1MaEdts1VS5JDf
	 X3gcenvuxtT8Grm0f5iy95PvQIPr/MmvcWMTAa0Lrj2YLQ0EeFkpyrReIqDfLMCqPq
	 sXPlSdQhkATWRwgtUR6FL7PR169AzBS6PV/QZV2LpdKJhusIIYNmoqItbOAgBizTcm
	 /YMzVQf/1uAMwwQZo3IqIWPrR/hIxBWuJXk3oe1fDt+TFmZnQQyeYck8z+dDPX89s3
	 AvRmJ3rlFmRQg==
Content-Type: multipart/mixed; boundary="===============2241572966179256876=="
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Message-Id: <717a43d830b7a6544a51f3c227592eaadcd0afcf61ec9bf922ad517a280b8bfe@mail.kernel.org>
In-Reply-To: <20261114193631.731615-7-jarkko@kernel.org>
References: <20261114193631.731615-7-jarkko@kernel.org>
Subject: Re: [PATCH v13 6/7] KEYS: Replace assoc_array with rhashtable
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,dhowells@redhat.com
Cc: jarkko@kernel.org,bpf@vger.kernel.org,dm-devel@lists.linux.dev,fsverity@lists.linux.dev,keyrings@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-security-module@vger.kernel.org,agk@redhat.com,agordeev@linux.ibm.com,ast@kernel.org,alexs@kernel.org,anastasia.eskova@ibm.com,akpm@linux-foundation.org,andrii@kernel.org,bmarzins@redhat.com,borntraeger@linux.ibm.com,daniel@iogearbox.net,dzm91@hust.edu.cn,eddyz87@gmail.com,emil@etsalapatis.com,ebiggers@kernel.org,ignat@linux.win,hca@linux.ibm.com,ihor.solodrai@linux.dev,James.Bottomley@HansenPartnership.com,jmorris@namei.org,jolsa@kernel.org,corbet@lwn.net,memxor@gmail.com,torvalds@linux-foundation.org,martin.lau@linux.dev,snitzer@kernel.org,mpatocka@redhat.com,zohar@linux.ibm.com,paul@paul-moore.com,oberpar@linux.ibm.com,rdunlap@infradead.org,roberto.sassu@huawei.com,serge@hallyn.com,skhan@linuxfoundation.org,song@kernel.org,svens@linux.ibm.com,tytso@mit.edu,gor@linux.ibm.com,
 si.yanteng@linux.dev,yonghong.song@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 20:24:27 +0000 (UTC)

--===============2241572966179256876==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> KEYS: Replace assoc_array with rhashtable

TL;DR: Comment only, not a bug today: the new keyring_read() comment says no
semaphore is needed and concurrent changes are possible, but the caller's
semaphore prevents that. Suggests rewording it.

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

[ ... ]

> +		ret = keyring_iterate(keyring, keyring_read_iterator, &ctx);
> +		if (ret < 0)
>  			return ret;

[ ... ]

This isn't a bug today, but the new comment looks inaccurate.  It says the
keyring's semaphore is not required and that a concurrent modification may
list a key twice or miss one.

keyring_read() walks the list under RCU, but the length it returns is
computed separately afterwards:

    ret = keyring_iterate(keyring, keyring_read_iterator, &ctx);
    ...
    ret = keyring_nr_links(keyring) * sizeof(key_serial_t);

keyctl_read_key() allocates key_data with kvmalloc(), which is not zeroed,
and when the returned length is <= buflen it does:

    ret = __keyctl_read_key(key, key_data, key_data_len);
    if (ret <= 0 || ret > buflen)
        break;
    ...
    if (copy_to_user(buffer, key_data, ret))

If a link were added between the walk and keyring_nr_links(), ret would
cover more entries than were written, and the extra uninitialised bytes
would be copied to userspace.

Today this can't happen, because __keyctl_read_key() does
down_read(&key->sem) (as does the s390 invalidate_keyring_keys()), and every
writer of index->list and index->nr (__key_link_lock(), __key_move_lock(),
__key_unlink_lock(), keyring_clear(), keyring_gc(), and key_revoke() via
keyring_revoke()) holds the semaphore for write.  So the concurrent
modification described by the comment does not occur.

Could the comment instead say that the caller holds the keyring's semaphore,
which keeps the list and the link count stable across the walk and the
length calculation, with RCU only keeping the walk itself memory-safe?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43634583011
--===============2241572966179256876==--
