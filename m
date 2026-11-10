Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794288092;
	b=qzBevFzDbyy1ebtVTlQ9kj6M7P4czO+YMSrSI2AUhF6tKqEWrTaITK9iVf8GTUhs94W1
	 jbUz8zMFOZ9PYy6baUW0KAuF9Y7iIeWfkGimmTnvruz+T/nTIhyyfzwchXSErjRI9Lny2
	 CyLeSRdHxArG5XezDx7M6gfMsrgzAHqyGyHnD3ngTNBPirabqAhCPxerZ1CWxr8skgbNZ
	 opA/Gi1sC2GLjKh3JR4qM5hrtEbFoeQM3uEd/BsRRHnbBLNXLpPeA99LVJSGtLHnxjQTZ
	 Xrf/GQSQKRrPJqP9q5Tlq6lCR7SZ3NWfBT1Gp9TBewGtshPql6aYA1HMc3xMt5R16AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794288092;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dA6CuQNcoNv2YWC3tYXjU/L3VM00gTntyUjMmiDasUU=;
	b=PaAXQpr+PnuNm9fE6kwlGcNcfPrrIP+tRRUxD7qVYP6ZwPaW7DBLvtISOtaOM0c3APhw
	 dJfor/6QpZvOOgiVU4S6gSKVjDRtUr+rSwghg++oqPP1juwZvYJ4cbE6fuYZC97Pn7O3F
	 utRMHoMpgbeXWM6AVtX+3TJYME8U0AtiHX9qQgI9e2BlN8uuEbVQbUlJa648ZWctF/U3B
	 9PTbIiYkAxRRIbp4IlKxSexPsIK6BwDMkzfrb77g4Q/dzb39NXQ2PSwjDvhCh7iifvUX1
	 kjAcPHB0Z62fahMSN6IAMFFCaf66szSwL4gPIfFBOnckqL/6hMy9sw2e/f/6vQftzmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=klOn8EZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 127AD606A31C;
	Tue, 10 Nov 2026 05:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=klOn8EZC
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D4D791F0089F;
	Tue, 10 Nov 2026 05:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794288091;
	bh=dA6CuQNcoNv2YWC3tYXjU/L3VM00gTntyUjMmiDasUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=klOn8EZC92QIUMHe+NYT/jaRWdt++3gUiCgyfQ9dWqyu3ghmdC4vPP+XdVzUcb0e2
	 6GsWBAFQmIyCCQo6H7zMp2R9AM3JhVfuwZSgR/C9tzUNOjTtBZ8Toft4rzWDQsBn8A
	 ft3/ULyBW0qQ5M638wybS1G1VRS+TGdUmq4g23UGrWhKDHQKY02BaqbUIQU/dOo5AI
	 0D9gMyD0hNkW2f25E15YneWFnKWtnzPFXQ19woBo7wVcMKm7Ib69IMpadMyY1g0bND
	 Zjvc31/E1fXM1Fzfh0L2pLXFqp7Ag9be+xvmQ5kGaY4/GHm7qCczS9ZmeFqnXOeO+g
	 ZJu42Q6+eR2wA==
Date: Tue, 10 Nov 2026 07:21:27 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>, bpf@vger.kernel.org,
	dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
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
	Yonghong Song <yonghong.song@linux.dev>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v8 2/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <avKp1xpBZBNeCrl5@kernel.org>
References: <20261110044043.2608600-1-jarkko@kernel.org>
 <20261110044043.2608600-3-jarkko@kernel.org>
 <sashiko-outbox-206254@kernel.org>
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
In-Reply-To: <sashiko-outbox-206254@kernel.org>

On Tue, Nov 10, 2026 at 05:03:58AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Critical] keys: uninitialized return value in __key_link_begin() on
>   link replacement
> - [Critical] keys: goto jumps past __free(kfree) initialization in
>   __key_link_begin()

I'll retract using cleanup.h shenanigans i.e.

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 60309f18e3a5..04d9a98c0f31 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1185,6 +1185,7 @@ int __key_link_begin(struct key *keyring,
 		     const struct keyring_index_key *index_key,
 		     struct keyring_edit *edit)
 {
+	struct keyring_link *link = NULL;
 	struct keyring_link *replace;
 	struct keyring_index *links;
 	int ret;
@@ -1211,7 +1212,7 @@ int __key_link_begin(struct key *keyring,
 		goto out;
 	}

-	struct keyring_link *link __free(kfree) = kzalloc_obj(struct keyring_link);
+	link = kzalloc_obj(struct keyring_link);
 	if (!link) {
 		ret = -ENOMEM;
 		goto out;
@@ -1239,10 +1240,13 @@ int __key_link_begin(struct key *keyring,
 		}
 	}

-	edit->new = no_free_ptr(link);
+	edit->new = link;
 	edit->old = replace;
+	ret = 0;

 out:
+	if (ret && link)
+		kfree(link);
 	kleave(" = %d", ret);
 	return ret;
 }

I went clearly over the top with the cleanup.h macros (lessons learned).

Br, Jarkko
