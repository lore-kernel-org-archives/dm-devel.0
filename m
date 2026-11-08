Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794135430;
	b=tZAIUfN0spgqhpw7TYDdp5Fdw780DcET0OvjKErMIil6cHhxaQsE7+zEKd30raNI0cqv
	 JNmGjhnq+sRaER6czdaHZ/m4SAO3BN1NoCVxJu0whg5EACGYvmvC4blndPktZ14Pd232p
	 OXE1UTOIXxFonHwYAfqX+/9szrGWxr9IjDmaKGPEG3Op/zzNy9/nqMkSYIlwYWtu58rjA
	 ipiLLS5X0RgIh/md62b4UTViEq6zPDFXNEgcjZwByYhwmuwcXxx/v6MkXrvALzGH14fUL
	 mZU6m1wpUqo2tukrax/9oAa2gvMjVoPiBYzAqZnfg1AJFELoEW5gTyqFPsi82jHJsOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794135430;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TwD6srxjUR1mlpO3FVThd9ARdJjbCvcuXWMQlKqn3B8=;
	b=WG3+30/PhBO8ujMdOvgE3j5hPkbER73U4hFLILkcFCfVURtWZLrJM20LQ6GRqlONPYdI
	 mBAFS+H0NptRrpnDgtQvVNiPwoxi1wtg8qFDg0ZLrr9LABhp4+DOEaWKpR0ij6Z/SfPik
	 JzurcC9Ihh1nxf7h11RF5SjcvN37Qjf7SIDVlO7CIC0spL2BqIKdx3sXX4pL8fzCWbrGP
	 hRHloaWcy8rGTrWGCAnoQ44beYpkmQow4sDHJyEjlkwLtGjPiahWah6zTp6JYDuaaZgDo
	 7wOSt5pvdycjmYozYvIN03wJVhNa9LHm5WB2NtYuycV4UU+651c9rjHcm/t+LelZFRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TRiyJ6fm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 944DF606A321;
	Sun,  8 Nov 2026 10:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TRiyJ6fm
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7C02B1F0089F;
	Sun,  8 Nov 2026 10:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794135429;
	bh=TwD6srxjUR1mlpO3FVThd9ARdJjbCvcuXWMQlKqn3B8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TRiyJ6fmFAW63gdpsdwizsp8sks3nQPXCSsVNd2T20n3ecL1W08N+jUzZxESIVAWt
	 rhR2mdZ4qwRW/NMbHJFqpDNOPF9CXCkui9oI7PMmIUK4NxRCe2tt3hQpxEkFSNqnT0
	 fw0KvS+KzLx48jNlOy68g7m9gUQm5PjmAAZkx6rtXjtm9xekTzjZXWKbj5B0QbYwyG
	 JB/8XGKYPRZUhr7WB2L1DE2wA6j8fiZesr0+iLMikAA0HSFogUoI1v59TfiFrI9g6D
	 VM/ZyMozcNPiWETPtwx8BEFg9Wkle0PgGqG+r2WbGEMNej4Yxuy0+ze7IBBhmtmmqV
	 eurIf9dCG5Cjg==
Date: Sun, 8 Nov 2026 12:57:05 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, bpf@vger.kernel.org,
	dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
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
Message-ID: <avBVgZt92j3OkpOG@kernel.org>
References: <20261107195605.3929659-1-jarkko@kernel.org>
 <au-FkAtC4Gcw7Bkb@kernel.org>
 <20261107204210.GG6049@quark>
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
In-Reply-To: <20261107204210.GG6049@quark>

On Sat, Nov 07, 2026 at 12:42:10PM -0800, Eric Biggers wrote:
> On Sat, Nov 07, 2026 at 10:09:52PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 07, 2026 at 09:56:01PM +0200, Jarkko Sakkinen wrote:
> > > The keyrings subsystem is the sole user of assoc_array. It has over 1700
> > > lines of code, no test suite, and a long history of bugs, with LLMs now
> > > finding more.
> > > 
> > > This unfortunate outcome has evolved over time by large from the shortage
> > > of in-kernel callers, time bandwidth and 3rd party contributors.
> > > 
> > > What the keyrings subsystem needs is just a generic key-value store, which
> > > performs well with sparse key sets. Replace assoc_array with an
> > > rhashtable-backed keyring index and remove assoc_array from the kernel.
> > 
> > Sashiko: https://sashiko.dev/#/patchset/20261107195605.3929659-1-jarkko%40kernel.org
> > 
> > Not addressing this as only one patch changed and the change was
> > exactly:
> > 
> > diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> > index 772fa0e35f9d..6761c6801edc 100644
> > --- a/security/keys/keyring.c
> > +++ b/security/keys/keyring.c
> > @@ -12,7 +12,6 @@
> >  #include <linux/security.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/err.h>
> > -#include <linux/delay.h>
> >  #include <linux/jhash.h>
> >  #include <linux/user_namespace.h>
> >  #include <linux/nsproxy.h>
> > @@ -101,6 +100,7 @@ static const struct rhashtable_params keyring_link_params = {
> >         .min_size               = 4,
> >         .nelem_hint             = 3,
> >         .automatic_shrinking    = true,
> > +       .insecure_elasticity    = true,
> >  };
> > 
> >  static struct keyring_index *keyring_index_locked(const struct key *keyring)
> > @@ -1225,12 +1225,8 @@ int __key_link_begin(struct key *keyring,
> >                 if (ret < 0)
> >                         goto error;
> > 
> > -               do {
> > -                       ret = rhashtable_insert_fast(&links->ht, &link->node,
> > -                                                    keyring_link_params);
> > -                       if (ret == -EBUSY)
> > -                               fsleep(100);
> > -               } while (ret == -EBUSY);
> > +               ret = rhashtable_insert_fast(&links->ht, &link->node,
> > +                                            keyring_link_params);
> >                 if (ret < 0) {
> >                         key_payload_reserve(keyring,
> >                                             keyring->datalen - KEYQUOTA_LINK_BYTES);
> > 
> > So I don't think there are any real issue with the patch set, except I
> > will need to rebase the commits to the latest mainline.
> 
> It looks good to me now too, but it would be good to get a Sashiko run
> on the latest version.  Sashiko hasn't run since v3, as it failed to
> apply the series.  You should base the series on a commit in either
> mainline or linux-next, and pass the '--base' option to 'git
> format-patch' so it adds a 'base-commit' line.
> 
> (The only reason I've been able to apply it myself for review is that I
> went out of my way to find your keys-rhashtable branch in git.)
> 
> - Eric

I think know what is the problem here exactly. It's the prepending bug
fixes. Sorry, I only now realized this althouhgh it should be quite
obvious.

I updated mainline few days for the sake of v7.4-rcX PRs late this
week (I think it was Thu or Fri) but linux-next was not up to date
last time I checked.

One I'm able to send the PR containing the fixes, I'll do that and
once that is in the mainline. I'll send a new version of this patch
set.

Br, Jarkko
