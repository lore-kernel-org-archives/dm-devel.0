Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794672752;
	b=ZFcNbGGNhrcwy2cy54gQHNEZrDqIucgbriHaD4vZbenvcVoqwR1Iw/mNd7gNsDIKv9QH
	 ouuonU26psnBowZVsYcDwXBGB4mOcxOO/jLPrMY6QQ6KZjO2PPpEDU3QdaULVm9B/GLB2
	 3PGGV7VYKgEEC5YMGlAa2VOH+ItZZsRjfatY8CrI4ABmzrqE+6iVD74PSK0TeA3IHOMnJ
	 mKlisN6T086Im+EIjvgoPkfT3pBs/WxYJsAMU+oy1NKND0KDF6IAdQPnD+f2Gaw1wOpIS
	 NYJF2OLHgORxh+ffEOb6EUpBYGWRW6yKLbnA4qGRtUnCLgU/Uv1DRDIemzPSeCVFXJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794672752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0ujS7/x7bK7lIvrp7g2hVVfZfW+s7y4W0vsq7LYrxAQ=;
	b=QkqUdxWtqud5msN6kzlOQVSGlJ4X6cAoE708HbTjTeQrK92YxX6A1n3MdxAWnVDui4EL
	 P/dRgS46ayE7g+qEDq3hwZ0CdS9e3a7GnF9kEO95m69R/ofoBPC9T8Nzn02yr/MQUjFj2
	 uQY1swtKFJ88ruZ5CIK0LzGqGjYF3kF1IdkPNtXyoPcASKAyjwdptbOu+ZHzx6C68kZse
	 qKU1sk17QMA7/TybTYdGJyUa0Jfa+cJijH8gES0fOBo11gGylBPz90ZeT8ECFcodGzB8d
	 U3vQwyx0uR/1ue7PvEqNKkrWmikXMPoLShmP+2jLtFR7lf/CY7gzf7wcIesnAQTyzRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YgDjlimn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B051E606A327;
	Sat, 14 Nov 2026 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YgDjlimn
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D9A3C1F000C4;
	Sat, 14 Nov 2026 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794672752;
	bh=0ujS7/x7bK7lIvrp7g2hVVfZfW+s7y4W0vsq7LYrxAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgDjlimn5pg8vv7bNudSUfh1zLjoPClDLM6aN90EUdEZGX5ECBs7HjiQQb6emBTho
	 En+5whC9tESJL9m/p3wgum5ZAU4jZm4yFDfXCBfeJ4aTvupSNiRMnNfAqtQjZJmxnu
	 JysXlEWt9gj84MyJLa0cCxLrZKybVIM8CE6Ug7auWfk/GHuGsoU+K+x4Uo8HRyhL5T
	 gvoHxQcVyZF8i5GtF3qMweKYL+sSwDVaqV/us1CYLl4O90JHBrCcddL+bMZ1QnC74U
	 KGK/Y2nLlmXfQAaEgFlylQq5F9piE74RArhRu8CycappgMIWoLyXz5gcLJMRIY1P6v
	 E6Z28YatRkVfg==
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
Subject: [PATCH v11 3/6] s390/cert_store: Skip keys that disappeared during invalidation
Date: Sat, 14 Nov 2026 18:12:08 +0200
Message-ID: <20261114161211.376859-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114161211.376859-1-jarkko@kernel.org>
References: <20261114161211.376859-1-jarkko@kernel.org>
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

key_lookup() can return NULL for an unlinked key. Skip such keys instead.

Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org # v6.6+
Fixes: 8cf57d7217c3 ("s390: add support for user-defined certificates")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/s390/kernel/cert_store.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kernel/cert_store.c b/arch/s390/kernel/cert_store.c
index 0a10b31d68af..bc682216fa7f 100644
--- a/arch/s390/kernel/cert_store.c
+++ b/arch/s390/kernel/cert_store.c
@@ -333,6 +333,9 @@ static int invalidate_keyring_keys(struct key *keyring)
 
 	for (key_index = 0; key_index < num_keys; key_index++) {
 		current_key = key_lookup(key_array[key_index]);
+		if (!current_key)
+			continue;
+
 		pr_dbf_msg("Invalidating key %08x", current_key->serial);
 
 		key_invalidate(current_key);
-- 
2.47.3

