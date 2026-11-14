Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794685038;
	b=pLmRd493TL3PE2pF3TtgHkgLMi/h8HfiBeR+H18X1ozQRAx22knyO7aZ2IhMfSQcyNrU
	 6c7ONzu9sCvN7amp7Nc9GMyJ5sKJj7b9iiNGasKR9SmVPWZYkIhk1FtEvGk/J9iNKaHnz
	 ZP1L62zTScyPJpg+k9GtT4w0PpIULLOuL3wi+kX4IsMUvd6YlPIT1qRuEz+Q7hxTNX7zB
	 uz1cP1Q2NLHSABNn4hoBi0isF2U44npffR1DJG4qfmLa2W5aru2QtWbzfPvQdz0wNfbi9
	 b40xAMPDdFaafJrAkXDZSGv15CuRHJCn4MxaUdn5ob4ZU2mntSdh8j5IO6qLEbEAWkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794685038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=iKqMVfHU1BuNysZ1d5XUw+mMudQRssNyWcr4sCK+jH8=;
	b=c1fJJI5fSZvMfBJWpjus7NFP64Ep4NqQHeyQnKb7+zgDG4YeEUOYbAZPKgRZLxd7vbmT
	 BLID8n7tE3Du54CcboVFILmn1TBaVqQNBUk18E9bPAh9erhDjuxenIuDa1ZKrvn1GZB19
	 T9UNPcRb+rY4jdCgMGicd6vf+1hRQX14fgpilLt+RpK/v9iBdQYEFxP82BL6OU5u+zk4E
	 23VaodTvNEpIXEYMzYNQlQm7hTFX/5HdCpS5ojcDUJ0eYA5smdLyeXo5y0QbfbFUSIAL3
	 fAORTh+ts2oTj8MKu3cJjW8knzMH6MX655NS/zxzNAs4GlC2b1kLZz/zi2ee6rVcXKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWt5sU3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id ED900606A330;
	Sat, 14 Nov 2026 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWt5sU3V
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EA5801F000C4;
	Sat, 14 Nov 2026 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794685037;
	bh=iKqMVfHU1BuNysZ1d5XUw+mMudQRssNyWcr4sCK+jH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWt5sU3Vw11O4Aj50AEJ4FXTKi65ACjyVP5/vff5wDsnSJlAAOez5K6ONxMpchwqZ
	 aS/96pBSMdXm/XoKpstt80SjeNLXVEh//pu/IQKs/QBHpuyXZvlhu/UP5nbRskJvWx
	 dUFsfyzGxqhjbSqVM/MCCwNLa6itmbnYGoCWcvd9YLAnHGkhotYF49WeVzLyoL6KBw
	 zDWuBV4YMIhOjNqDWPf9O0+KBLQ6cZAtrHUIH/ocCPoBHpFzataDfS3qL2kL1Jgg51
	 E7GYPQTlDGWjia5kcTrs1E3YBW05XExAkeFVaIeQTYNQdJ3KpPVIsd/Kmk/kzpb3f9
	 BfyTBw4tTqz9g==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	dm-devel@lists.linux.dev,
	fsverity@lists.linux.dev,
	keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Alex Shi <alexs@kernel.org>,
	Anastasia Eskova <anastasia.eskova@ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ignat Korchagin <ignat@linux.win>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Song Liu <song@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v13 3/7] s390/cert_store: Skip keys that disappeared during invalidation
Date: Sat, 14 Nov 2026 21:36:27 +0200
Message-ID: <20261114193631.731615-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114193631.731615-1-jarkko@kernel.org>
References: <20261114193631.731615-1-jarkko@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

key_lookup() can return ERR_PTR(-ENOKEY) for an unlinked key. Skip such
keys instead.

Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org # v6.6+
Fixes: 8cf57d7217c3 ("s390: add support for user-defined certificates")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/s390/kernel/cert_store.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/cert_store.c b/arch/s390/kernel/cert_store.c
index 0a10b31d68af..bec95991edae 100644
--- a/arch/s390/kernel/cert_store.c
+++ b/arch/s390/kernel/cert_store.c
@@ -331,17 +331,25 @@ static int invalidate_keyring_keys(struct key *keyring)
 		goto out;
 	}
 
+	rc = 0;
+
 	for (key_index = 0; key_index < num_keys; key_index++) {
 		current_key = key_lookup(key_array[key_index]);
+		if (IS_ERR(current_key))
+			continue;
+
 		pr_dbf_msg("Invalidating key %08x", current_key->serial);
 
 		key_invalidate(current_key);
-		key_put(current_key);
 		rc = key_unlink(keyring, current_key);
+		if (rc == -ENOENT)
+			rc = 0;
 		if (rc) {
 			pr_dbf_msg("Couldn't unlink key %08x: %d", current_key->serial, rc);
+			key_put(current_key);
 			break;
 		}
+		key_put(current_key);
 	}
 out:
 	kfree(key_array);
-- 
2.47.3

