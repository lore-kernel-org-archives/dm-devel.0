Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794443969;
	b=KkbS7ksX8gfW9V9RZ4jS98qfg/JC6wh5LoumE7Id175BTXT3F9zhfOxnHMbeqjnYfa3T
	 sYQEhrLxRs1BrfDyQrkkhlYKVFIu6FlZrp1S3O4+0pGddcgt6XQnw6jW4VAgqgZ3XE0Bi
	 tFqR+BF0KnTAIlKu+nZlg9xKxfSsDor3zUgjY0y4f/TSdxLZnmtxp9zSFvxhLGv0EHJnE
	 DASSzi8zWaeKKzZFqO2y5ErJWmWf/Q5yHOrDc/fqY/FpX4P6frysj7JF1tVSpK1ILi3hZ
	 JjHtMA3UZbF7r39M+qgBKr0Dwm7hYMjSES5CyJvFrjjcTEpf55K7J8ChjPAsf7WTRUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443969;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UOjibiAmupLywhn2quKFIlI1TbUeUqTwp8V6XpFAyBY=;
	b=DVPfnyE7nAZ5ixisRvmhg7VqL0M9SAWie8sJBr7i9J+o5xg892io+e3b8f/5NUMPNfV+
	 q2KrN/QQS6tCINCDRyW1x9qoLjYh1HwjnyM/G8O8s2lVFafwQ4pA/6O0QUTU8/PRzqG2+
	 bh2RaNYWvEgpmy3akvH/CKXqPs2fdvMXapXPfjer9n9qYnRUegIuPM6VfD6fyjkkloKzH
	 hqHyMzCd9nVv8qgoQDEPglZwLtNEGVrf5wqgYmoKMqS30sKtOKKhVfVBdx13D7Hm7Ux1g
	 dqz89fpyuKP2cIIGX/JpIHsQoqCY1x7mSXAAYlG+dtqpE31n0ddn6efsi5v4u5nk0lg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GyWTAkU0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823D6606A321
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 00:39:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 823D6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GyWTAkU0
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a206f0b95bso12235e9.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 16:39:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794443968; cv=none;
        d=google.com; s=arc-20260327;
        b=SzC0vmvW8whv0nebEskoPPlWNfnLYT/pQK7xb9QgKaHlTPMql2XcvIknhEBrK+9SvI
         H45evy8gNem+hCaVvV+DgY6AVuglErRzhZXNzmnS6o06kyLnATTDGdopw7KA/7mgaEuk
         4YtalhpSo0z/6ysb0ZPTavFXX+Aoqqe937DGi5Lp9oYk0PlQ8itYCli/SuIe+NKKSjPo
         mscJjaB1PZD9ldp2J1SSno7kVOJAI62JYmkltEIF48kenFeMTlCGFj5/Wbb24Nxx/mAz
         NtJfOKU0G64Xk5beMxtzvYjE8VCoMKJ1H3fFw2hG6g370upPq23G4UfTpCakbYOdrzPA
         6dOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UOjibiAmupLywhn2quKFIlI1TbUeUqTwp8V6XpFAyBY=;
        fh=XpQY3w3zRDzLtli7AMn1ZBGOcKEad8QUSa1HhEEThWU=;
        b=D84vPPNM8Q3dwRPwrPc4b7jF3KxSO1d1mw62D6pvPnyfsUTE2oEE95UoOeB05Do1fG
         +/MG2RL2RJ3OHFGtnT5Te/TyFr5VugHRmBi4gDJgxzJFUDw5SwUUm22VkRijXze+WnMo
         m6KyI07LRnbdAybnwA0CfiyJAylTyAJiS8D3T+HFbADBkcbYk6NR3QzmkeyJfCAQvLTB
         scU8ubePxShtlFi1zIpUnIGzNO/cKi+gaJ6r7TybVwmeZeFk/S5abqtqgANQb7QwYyR3
         u4I8lGFN1j2uUJrJfpUp16cvCZSwRT+DvtFL/dxxaMmpHkpwy9eIDx2jQvHVXVowm8Zf
         03MQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794443968; x=1795048768; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UOjibiAmupLywhn2quKFIlI1TbUeUqTwp8V6XpFAyBY=;
        b=GyWTAkU0qu1wN/VEYaqYOk+nag99s0xjf74T4lettErCAqymzy+WDXWkRhXAyH6nNk
         39pBZoVGW450PtBkI8lgH0I6FAb/+yLxQYRn6p66J8f+0MDVzZWrO06nidO1S1+dAvlZ
         FxzgtvjA+1Aw7KHkfDzAnLQgT4phHia5Xa4DnoCDNZsaCPHZx7O2KYS5fpTJj2K9UPg0
         CCiMsMdEqi4oCxSrrILgcHVGlojNIB5w3Gfz8MzOF1F2wkMLULib/RXzAdswa2x6+wSB
         avcjciEw8uSxZhFVfTDcuoa7S9samAFC/CzN4Sa22M8mn9pJXj6HYgFl0Em63h6cOvFk
         EWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794443968; x=1795048768;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UOjibiAmupLywhn2quKFIlI1TbUeUqTwp8V6XpFAyBY=;
        b=tYlAFZg7Y2N+taHJU4f6D6qZCdh9XGQrPvIoSSjJvb/8W/qB6pA1D7NkC/5ZmQN1m4
         nu9qEbGVnrIYOmTu4ZHA4XrYP7fNElV1+HWUB0cM55ldaF8WxaNqVlvUL8ofW2dObkle
         KCBdG9zX5eKVxb/w+tyK5t5yCEsGM2ci7FTZzSFTz1UeRPr0bzqSFg7ZcYJmYlKbAFhY
         6LjHyj3MtrlG+JLnNShxUEV+nBwnIy515WlUlXaDKnLg5ParaMtVTrelR6doXbNu/hsI
         +tFSa9XwYqbeFjAW9XRUCFuMgMIaoyrm1u58f23qSVhkDzID+/yW9aN+CeL31HkEtb0t
         OOGw==
X-Forwarded-Encrypted: i=1; AL+hErGUH8B3uxDRIgh3pJM9NQ4DPnXd8SpGOYiigLCluBl8xo8LT8ZuVPJ6JniR1MLMmYnuUg3kH3O3hg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+zf3Eud0Xd0Wl/JPG+zoLHBwtHdDOqzBXn6DKYGzHyVG9YIf1n
	oHgXDkjHCYL+aHK2JIFfsTpgrLXF+LJpw0VOHGQ/eooUV1rGZGbkHbYQt4Etz23kbV3179LpqkH
	gw81GukzJstffFQlWfqq2jt/KKGFw124VxPRIifP9L7uO7gKwCKEqZpiB/4w=
X-Gm-Gg: AYBFou2JES50/7P8enWyIVr79+V6rMjk6VTZG8vyw6x3b0tc+71XTXnR3Ft7/NNH4wH
	jqwDqddZQcXd0QHpKbOe+coLuExTD9i4y6dxQ43aZexvwo3NrAM+Wc3wF28y8BzAFxc8mbEnLL8
	lqF5JTG0o+Yu0u+qno4KgzhAPbUG22w6oMaILxEjxnc/DpwKhXWNphLQrPaHsYwMgkc6sY2ivnO
	rEP7lypTp3VKODUaE0mgUVSiJE8VRqDw9m57RYvtArwgQKR6oUM9qW8KPYerPEXqXBl39y9LdpK
	z8Nj6PPcdh7pmfoduM5CiFURCHuysRmIYav43Mqt8QgV04JnN4cX8SybDVWwhX9sAAzEsfK7ydv
	RgxyeCGAIDDmDmXMKXQvGppmftWE70R7QQw==
X-Received: by 2002:a05:600c:154b:b0:4b8:b175:c5a3 with SMTP id
 5b1f17b1804b1-4bb4ff4ad0dmr239675e9.9.1794443967249; Wed, 11 Nov 2026
 16:39:27 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com>
 <27b2dc50d3bb497ea3f3f84e7e4b271c@zeshmbx08.spreadtrum.com> <5188c1e8-c08a-2a56-7e4c-1d84aba4df35@redhat.com>
In-Reply-To: <5188c1e8-c08a-2a56-7e4c-1d84aba4df35@redhat.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 11 Nov 2026 16:38:49 -0800
X-Gm-Features: AclHuK94XFrMcjBFTU4luoaHl-MettOSDlEWZkt9e99FC8tcOhv65Jro-agdQb4
Message-ID: <CABCJKucwN7yMAp_cgcyJaFJ=XjKPz-rZ5wc=nKe53Dk2dURVQg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] dm-verity: don't decode FEC into a dm_bufio page
 that is already in the cache
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: =?UTF-8?B?5ZGo5Lyf5rGfIChXZWlqaWFuZyBaaG91KQ==?= <weijiang.zhou@unisoc.com>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>, 
	=?UTF-8?B?6YeR57qi5a6HIChIb25neXUgSmluKQ==?= <hongyu.jin@unisoc.com>, 
	=?UTF-8?B?5ZC056Wl56aEIChYaWFuZ2x1IFd1KQ==?= <Xianglu.Wu@unisoc.com>, 
	=?UTF-8?B?5ZC05ZGo6ZWcIChKdXN0aW4gV3Up?= <Justin.Wu@unisoc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 1:08=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Hi
>
>
> On Tue, 10 Nov 2026, =E5=91=A8=E4=BC=9F=E6=B1=9F (Weijiang Zhou) wrote:
>
> > Commit 51ba14fb368e ("dm-verity: do forward error correction on metadat=
a
> > I/O errors") handles a failed hash block read by allocating the block w=
ith
> > dm_bufio_new() and decoding into it with verity_fec_decode().
> >
> > dm_bufio_new() inserts the buffer into the v->bufio cache immediately, =
with
> > no B_READING state and no read_error, i.e. indistinguishable from a
> > successfully read block that merely has not been hash-verified yet. Its
> > contents are whatever the allocator returned (all zeroes with init_on_a=
lloc),
> > and no I/O is ever submitted for it.
>
> I don't see why this should be a problem.
>
> If the device returns random data, FEC is supposed to correct it.
>
> If the device returns an I/O error and we create a buffer with random
> data, this is similar to the case where the device returned random data -
> and FEC should also correct it. It doesn't matter whether the random data
> came from the device or from uninitialized kernel memory.
>
> So, it seems to me that this patch is just papering over the problem.
>
> > FEC then reads every other block of the RS codeword and, for blocks on =
the
> > data device, calls verity_hash_for_block() on them to decide whether th=
ey
> > are erasures. That walks the hash tree through the same v->bufio. If on=
e of
> > those data blocks is covered by the hash block being recovered (or by a
> > descendant of it, when it is an upper level block), the nested
>
> This is the real problem that should be fixed. Correcting a block
> shouldn't depend on the content of the block being corrected.

It doesn't depend on it. We only look for erasures because knowing
which blocks are corrupt allows us to correct twice as many errors,
but this is completely optional. Sounds like the correct solution is
not to call verity_handle_err() on verification errors while we're
only looking up erasures, since these are not fatal errors.

> > verity_verify_level() gets the placeholder from the cache, hashes the
> > uninitialized contents, sees a mismatch, cannot recurse into FEC again
> > (fio->level !=3D 0) and calls verity_handle_err(). With restart_on_corr=
uption
> > that reboots the machine on a single transient read error, although the
> > media is intact.
> >
> > Whether this happens is purely a function of the geometry. With 4K bloc=
ks,
> > sha256 and roots=3D2, 251 of the 1786 level-0 hash blocks, all level-1 =
blocks
> > and the root block have a codeword data block underneath them, so an I/=
O
> > error on any of those reliably produces "metadata block N is corrupted"=
.
> > It was observed on Android devices where a hash read failed with -EIO w=
hile
> > UFS was already offline during reboot.

We also shouldn't try to correct I/O errors when the system is
shutting down. We already have verity_is_system_shutting_down() for
this purpose, perhaps we should use it in verity_fec_decode() too?

Sami
