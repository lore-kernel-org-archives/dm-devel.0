Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794082196;
	b=Hf5mFNE+woNxwsLbP831TXM+mKHl6GAV+wdlx8QZXMWwdGMNBDLghlaa7c3LXXJkM0dv
	 LwRz5bSrMDfMm6p7cdYJ85qincYalueiqEB8PnXWP6SZkSm8XxCU98oMBMYjyWJlHvhbY
	 Q5LXHwBgjWOlbf5U0EMSmzpsu8HdGhXkzB6teWVaaR2kZR1OX5/3QHITMNJhGjAdUFSPz
	 Ad7ukdh+X/1hh0Oo7PlSNnLLEQs2u5BfzgXy/ZZsx25HrE7XHCi6Mms4dCsz//MrUx5Ky
	 zZcykvQYcqbf1cx19zacJ/xcRKoV0DAXriEb0v4uB63DnSlPSxr68dELIiEKZksrVeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794082196;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Xk0X32457iFYN1BGU3GAQStNoc/gho7s4TDAKaTabps=;
	b=vca6Bs9QKAy3e0rIoMyFU+tW+zZA7xSkMrXg1QvkyE8LmnL4VqwB4UnBR1XywDJ4hbab
	 Gg/Wc60ugQYt3P/Em6Q9EERgdx/R6e1NWaHZMSuNoRyXXfc73Y5MFr2WjSzjvu44GYqzI
	 9I3TEJjjtMxZCK9DTQs/LOrWC/XmwMsvr3zF/zk0uO9fQx8ZCqH90Y8AprxWpKIgkwk68
	 x6UTn8yG8eOqveKRtx0DVb0kjLRTL/nnHcpLxflId5Lh1svT2cweMtk7GBZnhzxYIx2q3
	 uzt+KHSTkBTV6e2GGW20Qv4ovVcCYoMXeG9/ol/mnEJ9Wop6HTrdhdE62QofrQubn7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oJk2JMZp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 94202606A326;
	Sat,  7 Nov 2026 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oJk2JMZp
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7BEB71F0089F;
	Sat,  7 Nov 2026 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082196;
	bh=Xk0X32457iFYN1BGU3GAQStNoc/gho7s4TDAKaTabps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oJk2JMZp0MhPfM8rzByqvvNnCZjRq5/RY7VGZe+RGNUqtal6lzJMGADUx0eDfObDF
	 x2A0zR1atvNeDMgM2ktcKIboDUB9BPMreYceFMHuHIgOmqz2XqRFZpLCVf7lhmzz8G
	 WDb2lvIBtPuwpxbrOw2n2McsL+/Q8FwD/CzM/s4tZV0HYJj6ZEtsLCF+pTWqRSBmJ8
	 DQdUEMjqXJ8B+aTq5CDAwsGLoBvaGHMDxag7gChJA6W4qjNCBgKWQT60y7LFKKuQAT
	 pyd7fSUqhXm7s9byjv7mU1nBJd1UWuousgWCOyt2kj2wppSM8Mmw1UDgm9dTFCV8nt
	 DYR7iGPZp/JzA==
Date: Sat, 7 Nov 2026 22:09:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: bpf@vger.kernel.org, dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
	keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ignat Korchagin <ignat@linux.win>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	James Morris <jmorris@namei.org>, Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>, Song Liu <song@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Yanteng Si <si.yanteng@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: Re: [PATCH v6 0/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <au-FkAtC4Gcw7Bkb@kernel.org>
References: <20261107195605.3929659-1-jarkko@kernel.org>
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
In-Reply-To: <20261107195605.3929659-1-jarkko@kernel.org>

On Sat, Nov 07, 2026 at 09:56:01PM +0200, Jarkko Sakkinen wrote:
> The keyrings subsystem is the sole user of assoc_array. It has over 1700
> lines of code, no test suite, and a long history of bugs, with LLMs now
> finding more.
> 
> This unfortunate outcome has evolved over time by large from the shortage
> of in-kernel callers, time bandwidth and 3rd party contributors.
> 
> What the keyrings subsystem needs is just a generic key-value store, which
> performs well with sparse key sets. Replace assoc_array with an
> rhashtable-backed keyring index and remove assoc_array from the kernel.

Sashiko: https://sashiko.dev/#/patchset/20261107195605.3929659-1-jarkko%40kernel.org

Not addressing this as only one patch changed and the change was
exactly:

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 772fa0e35f9d..6761c6801edc 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -12,7 +12,6 @@
 #include <linux/security.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
-#include <linux/delay.h>
 #include <linux/jhash.h>
 #include <linux/user_namespace.h>
 #include <linux/nsproxy.h>
@@ -101,6 +100,7 @@ static const struct rhashtable_params keyring_link_params = {
        .min_size               = 4,
        .nelem_hint             = 3,
        .automatic_shrinking    = true,
+       .insecure_elasticity    = true,
 };

 static struct keyring_index *keyring_index_locked(const struct key *keyring)
@@ -1225,12 +1225,8 @@ int __key_link_begin(struct key *keyring,
                if (ret < 0)
                        goto error;

-               do {
-                       ret = rhashtable_insert_fast(&links->ht, &link->node,
-                                                    keyring_link_params);
-                       if (ret == -EBUSY)
-                               fsleep(100);
-               } while (ret == -EBUSY);
+               ret = rhashtable_insert_fast(&links->ht, &link->node,
+                                            keyring_link_params);
                if (ret < 0) {
                        key_payload_reserve(keyring,
                                            keyring->datalen - KEYQUOTA_LINK_BYTES);

So I don't think there are any real issue with the patch set, except I
will need to rebase the commits to the latest mainline.

Br, Jarkko
